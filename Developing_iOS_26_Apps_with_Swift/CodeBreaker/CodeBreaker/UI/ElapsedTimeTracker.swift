//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/27.
//

import SwiftUI
import SwiftData


extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase //所处场景，前台活跃 后台
    let game: CodeBreaker
    
    var modelContextWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: ModelContext.willSave, object: modelContext)
    }
    
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
            .onReceive(modelContextWillSavePublisher) { _ in
                game.updateElapsedTime()
                print("update elapsed time to \(game.elapsedTime)")
            }
    }
}


