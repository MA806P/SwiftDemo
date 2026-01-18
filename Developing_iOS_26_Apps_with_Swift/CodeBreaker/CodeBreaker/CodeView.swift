//
//  CodeView.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/15.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView : View {
    
    // MARK: Data in
    let code: Code
    
    // MARK: Data owned by me
    @Binding var selection: Int
    
    //let ancillaryView: AncillaryView //泛型，从外面传进来的任何view显示在右侧，按钮、匹配结果、空白..
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1), //设置默认值，创建时就可不传值
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection //@Binding默认会创建一个 _selection 和对应的计算方法
        self.ancillaryView = ancillaryView
    }
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.cornerRadius)
                    .background {
                        if selection == index, code.kind == .guess {
                            Selection.shape.foregroundColor(Selection.color)
                        }
                    }
                    .overlay {
                        Selection.shape.foregroundColor(code.isHidden ? Color.gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            //game.changeGuessPeg(at: index)
                            selection = index
                        }
                    }
            }
            
            //Rectangle().foregroundColor(Color.clear).aspectRatio(1, contentMode: .fit)
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    //if let matches = code.matches {  MatchMarkers(matches: matches) }
                    //else { if code.kind == .guess { guessButton } }
                    //ancillaryView
                    ancillaryView()
                }
        }
    }
    
    
}


fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = .gray(0.9)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

//#Preview {
//    CodeView()
//}
