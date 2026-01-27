//
//  GameList.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/22.
//

import SwiftUI
import SwiftData

struct GameList: View {
    
    // MARK: Data in
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data shared with me
    @Binding var selection: CodeBreaker?
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker] //只读
//    @State private var showGameEditor = false
    
    // MARK: Data owned by me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch)
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                //NavigationLink{CodeBreakerView(game:game)}label:{GameSummary(game: game)}
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu { //mac app 右键菜单按钮，iPhone app 长按菜单
                    editButton(for: game)
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) { //右滑显示编辑按钮
                    editButton(for: game).tint(.accentColor)
                }
                //NavigationLink(value: game.masterCode.pegs) {Text("cheat")}
            }
            .onDelete { offsets in
                //games.remove(atOffsets: offsets)
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
            //.onMove { offsets, destination in games.move(fromOffsets: offsets, toOffset: destination) }
        }
        //.navigationDestination(for: CodeBreaker.self) { game in CodeBreakerView(game: game).navigationTitle(game.name).navigationBarTitleDisplayMode(.inline)}
        //.navigationDestination(for: [Peg].self) { pegs in PegChooser(choices: pegs)}
        .onChange(of: games) {
            if let selection, !games.contains(selection) { //如果删除当前选中的
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton()
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        //.onChange(of: gameToEdit) { showGameEditor = gameToEdit != nil }
        .sheet(isPresented: showGameEditor) {
            //(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil})
            gameEditor
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool> {
            gameToEdit != nil
        } set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        }

    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: gameToEdit) {
                
                //if let index = games.firstIndex(of: gameToEdit) {
                    //games[index] = copyOfGameToEdit //如果编辑的是已存在的替换掉
                //} else { //games.insert(gameToEdit, at: 0) }
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
                
            }
        }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            //games.removeAll { $0 == game }
            modelContext.delete(game)
        }
    }
    
    func addSampleGames() {
        
//        let fetchDescriptor = FetchDescriptor<CodeBreaker>(
//            predicate: .true , //#Predicate { game in return true }
//            sortBy: [.init(\.name)] //[SortDescriptor<CodeBreaker>.init(\.name)]
//        )
        
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let result = try? modelContext.fetchCount(fetchDescriptor), result == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .purple, .gray]))
            modelContext.insert(CodeBreaker(name: "Undersea", pegChoices: [.blue, .brown, .indigo, .cyan]))
        }
//        do {
//            let result = try modelContext.fetch(fetchDescriptor)
//            ...
//        } catch {
//            print("had a problem counting games: \(error.localizedDescription)")
//        }
        
        
//        if games.isEmpty {
//            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
//            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .purple, .gray]))
//            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .brown, .indigo, .cyan]))
//            selection = games.first
//        }
    }
    
}



/**
 
 List {
     Section("Games") {
         ForEach(games, id: \.pegChoices) { game in
             GameSummary(game: game)
         }
     }
     Section(header: Image(systemName: "face.smiling")) {
         Text("Hello")
         Text("World")
     }
 }
 
 */


#Preview(traits: .swiftData) {
    
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
