//
//  ContentView.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/12.
//

import SwiftUI

struct CodeBreakerView: View {
    
    //@Environment(\.scenePhase) var scenePhase //所处场景，前台活跃 后台
    let game: CodeBreaker
    
    //@State private var game = CodeBreaker(pegChoices: [.brown, .gray, .black, .cyan, .yellow, .red])
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    var body: some View {
        VStack {
            //Button("Restart", systemImage: "arrow.circlepath", action: restart)
            
            CodeView(code: game.masterCode)
            //{ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                    //.flexibleSystemFont() .monospaced() .lineLimit(1) }
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            
            if !game.isOver {
                PegChooser(choices: game.pegChoices, onChoose: changePegAction)
                    .transition(.pegChooser)
                    .frame(maxHeight: 80)
                    //.transition(AnyTransition.move(edge: .bottom))
            }
        }
        .trackElapsedTime(in: game)
        //.modifier(ElapsedTimeTracker(game: game))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: restart)
            }
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .monospaced().lineLimit(1)
            }
        }
        .padding()
    }
    
    
    func changePegAction(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1)%game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
            //当点击重置，且已经猜到 已猜测的先向下滑动 在向右滑出清空已猜，新的开始
            //后面改进不需要先向下滑动 直接向右滑出清空
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(Animation.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
}


extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase //所处场景，前台活跃 后台
    let game: CodeBreaker
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
    }
}

extension CodeBreaker {
    convenience init(name: String = "Code Breaker", pegChoices: [Color]) {
        self.init(name: name, pegChoices: pegChoices.map(\.hex))
    }
    
    var pegColorChoices: [Color] {
        get { pegChoices.map { Color(hex: $0) ?? .clear} }
        set { pegChoices = newValue.map(\.hex) }
    }
}


#Preview(traits: .swiftData) {
    @Previewable var game = CodeBreaker(pegChoices: [.blue, .yellow, .red])
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
