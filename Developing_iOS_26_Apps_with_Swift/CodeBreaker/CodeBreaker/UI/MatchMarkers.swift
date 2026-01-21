//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/12.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    let matches: [Match]
    var body: some View {
        HStack {
            VStack {
                //1只要有大于0个至少1个精确匹配就显示实心点
                matchMarker(peg: 0)
                //2上面有个实心点 第二个要大于1个至少2个精确匹配才显示实心点
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count(where: { match in match == .exact })
        let foundCount = matches.count{ $0 != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 3)
            .aspectRatio(1, contentMode: .fit)
    }
    
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}
