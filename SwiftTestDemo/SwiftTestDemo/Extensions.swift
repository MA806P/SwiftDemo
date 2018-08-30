//
//  Extensions.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/8/30.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

/*
 Extensions：为已存在的类、结构体、枚举或者协议类型增添了一个新的功能
 与 Objective-C 中 Categories 有所不同的是，Swift 中的 Extensions 并没有一个具体的命名
 
 Swift 中 Extensions 可以做到：
 添加计算实例属性和计算类型属性
 定义实例方法和类方法
 提供新的初始化方法
 定义下标脚本
 定义和使用新的嵌套类型
 使现有类型符合协议
 
 
 
 extension SomeType { }
 
 Extension 可以实现扩展现有类型去遵循一个或多个协议
 extension SomeType: SomeProtocol, AnotherProtocol { }
 
 */


//计算属性
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
//let oneInch = 25.4.mm
//print("One inch is \(oneInch) meters")
//// Prints "One inch is 0.0254 meters"
//let threeFeet = 3.ft
//print("Three feet is \(threeFeet) meters")
//// Prints "Three feet is 0.914399970739201 meters"



//添加一个新的初始化构造器
struct Size1 {
    var width = 0.0, height = 0.0
}
struct Point1 {
    var x = 0.0, y = 0.0
}
struct Rect1 {
    var origin = Point1()
    var size = Size1()
}

//let defaultRect = Rect()
//let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

extension Rect1 {
    init(center: Point1, size: Size1) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point1(x: originX, y: originY), size: size)
    }
}
//新的初始化器可以基于 Center 和 Size 的值去计算一个恰当的初始点，
//然后通过这个初始化器去调用 init(origin:size:) 这个自动初始化成员方法，
//这将会把新的 Origin 和 Size 保存在相对的属性中




//向已经存在的类型添加实例方法或类方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
//3.repetitions {
//    print("Hello!")
//}





//添加实例方法来实现修改变量
extension Int {
    mutating func square() {
        self = self * self
    }
}
//var someInt = 3
//someInt.square()
//// someInt = 9




//对已经存在的类型添加下标
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
//746381295[0]
//// 返回 5
//746381295[1]
//// 返回 9




//向任何已经存在的类、结构体或枚举添加新的嵌套类型
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
//针对 Int 类型的扩展 Kind，在这个扩展中，我们可以针对任意一个 Int 类型作出进一步的细分，
//比如：负数（negative），零 （zero）, 与正数 （positive）。

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
//printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
//// Prints "+ + - 0 - 0 + "




