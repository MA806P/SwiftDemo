//
//  SwiftDataPreview.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/25.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: CodeBreaker.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true) //存储在内存，非硬盘
        )
        // maybe load up some sample data into container.mainContext
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
    
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}
