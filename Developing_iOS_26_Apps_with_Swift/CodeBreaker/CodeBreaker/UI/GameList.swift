//
//  GameList.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/22.
//

import SwiftUI

struct GameList: View {
    
    @Binding var selection: CodeBreaker?
    @State private var games: [CodeBreaker] = []
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                //NavigationLink{CodeBreakerView(game:game)}label:{GameSummary(game: game)}
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu { //mac app 右键菜单按钮，iPhone app 长按菜单
                    deleteButton(for: game)
                }
                //NavigationLink(value: game.masterCode.pegs) {Text("cheat")}
            }
            .onDelete { offset in
                games.remove(atOffsets: offset)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
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
            Button("Add Game", systemImage: "plus") {
                gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
            }
            .onChange(of: gameToEdit) {
                showGameEditor = gameToEdit != nil
            }
            .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil}) {
                gameEditor
            }
            EditButton()
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            GameEditor(game: gameToEdit) {
                games.insert(gameToEdit, at: 0)
            }
        }
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            games.removeAll { $0 == game }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .purple, .gray]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .brown, .indigo, .cyan]))
            selection = games.first
        }
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


#Preview {
    
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
