//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/21.
//

import SwiftUI

struct GameChooser: View {
    @State private var selection: CodeBreaker? = nil
    
    //@State private var columVisibility: NavigationSplitViewVisibility = .all
    //$columVisibility
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)){
            GameList(selection: $selection)
                .navigationTitle("Code Breaker")
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    GameChooser()
}
