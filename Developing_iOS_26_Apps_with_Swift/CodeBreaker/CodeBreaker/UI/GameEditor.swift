//
//  GameEditor.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/22.
//

import SwiftUI

struct GameEditor: View {
    
    @Bindable var game: CodeBreaker
    
    @Environment(\.dismiss) var dismiss
    let onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .autocapitalization(.words) //自动首字母大写
                        .autocorrectionDisabled(true) //是否禁止自动纠错
                        .onSubmit {
                            done()
                        }
                }
                Section("Peg") {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Canncel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        done()
                    }
                }
            }
        }
    }
    
    func done() {
        onChoose()
        dismiss()
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Preview", pegChoices: [.red, .yellow])
    GameEditor(game: game) {
        print("game name changed to \(game.name)")
        print("game pegs changed to \(game.pegChoices)")
    }
//        .onChange(of: game.name) {
//            print("game name changed to \(game.name)")
//        }
//        .onChange(of: game.pegChoices) {
//            print("game pegs changed to \(game.pegChoices)")
//        }
}
