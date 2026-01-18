//
//  ContentView.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/12.
//

import SwiftUI

struct CodeBreakerView: View {
    @State private var game = CodeBreaker(pegChoices: [.brown, .gray, .black, .cyan, .yellow, .red])
    @State private var selection: Int = 0
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        if let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1)%game.masterCode.pegs.count
            }
        }.padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maxFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    
    struct GuessButton {
        static let maxFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = 0.1
    }
    
    
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
