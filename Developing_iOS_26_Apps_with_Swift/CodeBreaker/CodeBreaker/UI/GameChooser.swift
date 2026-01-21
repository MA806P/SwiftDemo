//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/21.
//

import SwiftUI

struct GameChooser: View {
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(games, id: \.pegChoices) { game in
            VStack(alignment: .leading) {
                Text(game.name).font(.title)
                PegChooser(choices: game.pegChoices)
                    .frame(maxHeight: 50)
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
            //.listRowSeparator(.hidden)
            //.listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.indigo)).padding(10)
        }
        //.listStyle(.plain)
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .purple, .gray]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .brown, .indigo, .cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
