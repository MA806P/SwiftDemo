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
    
    let pegShape = Diamond() //Circle() //RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        pegShape
            //.overlay { if peg == Code.missingPeg { pegShape.strokeBorder(Color.gray) } }
        
        /*
        GeometryReader { geometry in
            let rect = geometry.frame(in: .local)
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.closeSubpath()
            }
        }*/
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(Color(hex: peg) ?? .clear)
    }
}

#Preview {
    PegView(peg: Color.blue.hex).padding()
}
