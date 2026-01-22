//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/22.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
        
    }
}

#Preview {
    List {
        Section("Game") {
            GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red, .blue, .yellow]))
            GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red, .blue, .yellow]))
        }
        //.listRowSeparator(.hidden)
        //.listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.indigo).padding(10))
    }
    
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red, .blue, .yellow]))
    }
    .listStyle(.plain)
}
