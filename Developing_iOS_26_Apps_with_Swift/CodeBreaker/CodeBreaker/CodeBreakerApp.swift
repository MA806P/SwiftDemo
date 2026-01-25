//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/18.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
