//
//  Enumerations.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/7/29.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


class EnumerationsTestObject {
    
    func enmerationsDemo() {
        
        
        
        
        
    }
    
}


//--------------- Enumerations and Structures -----------------

//enum Rank: Int {
//    case ace = 1
//    case two, three, four, five, six, seven, eight, nine, ten
//    case jack, queen, king
//    func simpleDescription() -> String {
//        switch self {
//        case .ace:
//            return "ace"
//        case .jack:
//            return "jack"
//        case .queen:
//            return "queen"
//        case .king:
//            return "king"
//        default:
//            return String(self.rawValue)
//        }
//    }
//}
//let ace = Rank.ace
//let aceRawValue = ace.rawValue
//print("\(ace), \(aceRawValue), \(ace.simpleDescription()), \(Rank(rawValue: 3) ?? Rank.king)")
////ace, 1, ace, three


//One of the most important differences between structures and classes
//is that structures are always copied when they are passed around in your code,
//but classes are passed by reference.
//struct Card {
//    var rank: Int
//    var suit: String
//    func simpleDescription() -> String {
//        return "The \(rank) of \(suit)"
//    }
//}
//let threeOfSpades = Card(rank: 1, suit: "aa")
//let threeOfSpadesDescription = threeOfSpades.simpleDescription()
//print(threeOfSpadesDescription) //The 1 of aa

