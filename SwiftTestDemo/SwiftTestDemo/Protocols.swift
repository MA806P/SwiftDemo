//
//  Protocols.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/8/31.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 protocol SomeProtocol { }
 
 struct SomeStructure: FirstProtocol, AnotherProtocol { }
 
 父类名称需要写在协议名之前
 class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol { }
 */




//属性
//协议可以要求遵循协议的类型提供特定名称和实例属性或类型属性。
//协议只指定属性的名称和类型，而不指定属性为储存属性或计算属性。
/*
 协议属性通常会以 var 关键字来声明变量属性。
 在类型声明后加上 { get set } 来表示属性是可读可写的，用 { get } 来表示可读属性。
 
 定义类型属性要求时，始终使用 static 关键字作为前缀。
 */
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    static var someTypeProperty: Int { get set }
}



/*
 FullyNamed 协议要求遵循协议的类型提供一个全名
 Person 的每个实例都有一个名为 fullName 的存储属性，它的类型为 String。
 这符合 FullyNamed 协议的单一要求，意味着 Person 已正确遵循该协议
 */
protocol FullyNamed {
    var fullName: String { get }
}
struct Person12: FullyNamed {
    var fullName: String
}
//let john = Person(fullName: "John Appleseed")
// john.fullName 是 "John Appleseed"







//方法
//协议可能需要通过遵循类型来实现特定的实例方法和类型方法。
protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
//let generator = LinearCongruentialGenerator()
//print("Here's a random number: \(generator.random())")
//// 打印 "Here's a random number: 0.3746499199817101"
//print("And another one: \(generator.random())")
//// 打印 "And another one: 0.729023776863283"



/*
 有时需要有一个方法来修改（或 异变）它所属的实例。例如，对值类型（即结构体和枚举）的方法，
 将 mutating 关键字放在方法 func 关键字之前，
 以指示允许该方法修改它所属的实例以及该实例的任何属性。
 
 如果将协议实例方法要求标记为 mutating，则在为类编写该方法的实现时，
 不需要写 mutating 关键字。mutating 关键字仅由结构体和枚举使用。
 */
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
//var lightSwitch = OnOffSwitch.off
//lightSwitch.toggle()
//// lightSwitch 现在是 .on


//协议可能要求通过遵循类型来实现特定的构造器。
protocol SomeProtocol11 {
    init(someParameter: Int)
}
class SomeClass11: SomeProtocol11 {
    //你可以通过实现指定构造器或便利构造器来使遵循协议的类满足协议的构造器要求。
    //在这两种情况下，你必须使用 required 修饰符标记构造器实现：
    required init(someParameter: Int) {
        // 下面是构造器的实现
    }
    //使用 required 修饰符可确保你在遵循协议类的所有子类上提供构造器要求的
    //显式或继承实现，以便它们也符合协议。
}
//你并不需要在使用 final 修饰符标记的类上使用 required 修饰符来标记协议构造器的实现，
//因为这样的类是不能进行子类化。


protocol SomeProtocol12 {
    init()
}

class SomeSuperClass12 {
    init() {
        // 下面是构造器的实现
    }
}

class SomeSubClass12: SomeSuperClass12, SomeProtocol12 {
    // 添加「required」修饰符是因为遵循了 SomeProtocol 协议;
    //添加「override」修饰符是因为该类继承自 SomeSuperClass
    required override init() {
        // 下面是构造器的实现
    }
}











//将协议作为类型
/*
 创建的任何协议都可以变为一个功能完备的类型在代码中使用
 作为函数、方法或构造器的参数类型或返回类型
 作为常量、变量或属性的类型
 作为数组、字典或其他容器的元素类型
 */
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}



/*
 委托 是一种设计模式，它使类或结构体能够将其某些职责交给（或 委托）到另一种类型的实例。
 通过定义封装委托职责的协议来实现此设计模式，从而保证遵循协议类型（称为委托）提供被委托的功能。
 委托可用于响应特定操作，或从外部源检索数据，而无需了解该源的具体类型。
 */





