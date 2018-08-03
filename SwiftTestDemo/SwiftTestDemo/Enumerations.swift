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
        
        
//        enum Rank: Int {
//            case ace = 1
//            case two, three, four, five, six, seven, eight, nine, ten
//            case jack, queen, king
//            func simpleDescription() -> String {
//                switch self {
//                case .ace:
//                    return "ace"
//                case .jack:
//                    return "jack"
//                case .queen:
//                    return "queen"
//                case .king:
//                    return "king"
//                default:
//                    return String(self.rawValue)
//                }
//            }
//        }
//        let ace = Rank.ace
//        let aceRawValue = ace.rawValue
//        print("\(ace), \(aceRawValue), \(ace.simpleDescription()), \(Rank(rawValue: 3) ?? Rank.king)")
//        //ace, 1, ace, three
        
        
    
//        enum Beverage: CaseIterable {
//            case coffee, tea, juice
//        }
//        let numberOfChoices = Beverage.allCases.count
//        print("\(numberOfChoices) beverages available")
//        // Prints "3 beverages available"
        
        
        enum Barcode {
            case upc(Int, Int, Int, Int)
            case qrCode(String)
        }
        
        var productBarcode = Barcode.upc(8, 85909, 51226, 3)
        productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
        
        switch productBarcode {
        //case .upc(let numberSystem, let manufacturer, let product, let check):
        case let .upc(numberSystem, manufacturer, product, check):
            print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
        //case .qrCode(let productCode):
        case let .qrCode(productCode):
            print("QR code: \(productCode).")
            
        }
        // Prints "QR code: ABCDEFGHIJKLMNOP."
        
        
        //Raw Values
        //Raw values can be strings, characters, or any of the integer or floating-point number types.
        //Each raw value must be unique within its enumeration declaration.
        //Raw values are not the same as associated values.
        //Raw values are set to prepopulated values when you first define the enumeration in your code
        
        //you don’t have to explicitly assign a raw value for each case. When you don’t,
        //Swift will automatically assign the values for you.
        
        enum Planet: Int {
            case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
        }
        print("\(Planet.earth.rawValue)") //3
        
        if let possiblePlanet = Planet(rawValue: 7) {
            //// possiblePlanet is of type Planet? and equals Planet.uranus
            switch possiblePlanet {
            case .uranus:
                print("uranus")
            default:
                print("nil")
            }
        }
        
        //When strings are used for raw values, the implicit value for each case is the text of that case’s name.
        enum CompassPoint: String {
            case north, south, east, west
        }
        print("\(CompassPoint.south.rawValue)")//south
        
        
        
        
        
        //Recursive Enumerations 递归
        //has another instance of the enumeration as the associated value for one or more of the enumeration cases.
        //You indicate that an enumeration case is recursive by writing indirect before it
        /*
        enum ArithmeticExpression {
            case number(Int)
            indirect case addition(ArithmeticExpression, ArithmeticExpression)
            indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
        }
        */
        indirect enum ArithmeticExpression {
            case number(Int)
            case addition(ArithmeticExpression, ArithmeticExpression)
            case multiplication(ArithmeticExpression, ArithmeticExpression)
        }
        let five = ArithmeticExpression.number(5)
        let four = ArithmeticExpression.number(4)
        let sum = ArithmeticExpression.addition(five, four)
        let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
        
        func evaluate(_ expression: ArithmeticExpression) -> Int {
            switch expression {
            case let .number(value):
                return value
            case let .addition(left, right):
                return evaluate(left) + evaluate(right)
            case let .multiplication(left, right):
                return evaluate(left) * evaluate(right)
            }
        }
        print(evaluate(product))
        //// Prints "18"
        
    }
    
}









