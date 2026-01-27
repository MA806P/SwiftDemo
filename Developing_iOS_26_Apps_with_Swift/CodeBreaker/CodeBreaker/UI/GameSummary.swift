//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/22.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var size: Size = .regular
    
    enum Size {
        case compact
        case regular
        case large
        
        var larger: Size {
            switch self {
            case .compact: .regular
            default: .large
            }
        }
        
        var smaller: Size {
            switch self {
            case .large: .regular
            default: .compact
            }
        }
    }
    
    var body: some View {
        let layout = size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))
        layout {
            Text(game.name).font(size == .compact ? .body : .title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: size == .compact ? 35 : 50)
            if size == .large {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
        
    }
}

#Preview(traits: .swiftData) {
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
