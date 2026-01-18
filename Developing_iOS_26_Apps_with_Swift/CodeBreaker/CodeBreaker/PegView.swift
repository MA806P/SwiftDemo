//
//  PegView.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/15.
//

import SwiftUI

struct PegView: View {
    
    // MARK: data in
    let peg: Peg
    
    let pegShape = Circle() //RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape.strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(peg)
    }
}

#Preview {
    PegView(peg: .blue).padding()
}
