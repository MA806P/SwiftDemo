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
            Button("Restart") {
                withAnimation(.restart) {
                    game.restart()
                    selection = 0
                }
            }
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
            PegChooser(choices: game.pegChoices, onChoose: changePegAction)
        }.padding()
    }
    
    
    func changePegAction(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1)%game.masterCode.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(Animation.guess) {
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

extension Animation {
    static let codeBreaker = Animation.easeInOut(duration: 3)
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
