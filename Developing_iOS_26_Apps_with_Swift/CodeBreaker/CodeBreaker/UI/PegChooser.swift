//
//  PegChoose.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/15.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data in
    let choices: [Peg]
    
    // MARK: Data out founction
    var onChoose: ((Peg) -> Void)?
    
    // 数据传递只传该UI需要的数据，事件处理传递出去不需要UI考虑
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

//#Preview {
//    PegChooser()
//}
