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



//让扩展添加协议遵循
/*
 可以通过扩展这个已存在的类型并让它遵循并实现一个新的协议。扩展可以为已存在的类型添加新属性，方法和下标
 */
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
//extension Dice: TextRepresentable {
//    var textualDescription: String {
//        return "A \(sides)-sided dice"
//    }
//}






//有条件地遵循协议
/*
 泛型类型可能只能在特定条件下满足协议的要求，例如类的泛型参数遵循一个协议。
 你可以通过在扩展类型时列出条件约束，让泛型类型有条件的遵循一个协议。
 通过编写一个泛型 where 分句，在遵循的协议名称后面写上约束条件。
 */
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
//let myDice = [d6, d12]
//print(myDice.textualDescription)
//// "[A 6-sided dice, A 12-sided dice]"





//通过扩展申明采纳协议
/*
如果一个类型已经满足遵循一个协议的所有要求，但它没有申明遵循了这个协议，你可以通过一个空的扩展遵循该协议
*/
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}




//协议可以用作诸如数组或字典之类的集合类型的元素类型
//let things: [TextRepresentable] = [game, d12, simonTheHamster]
//for thing in things { print(thing.textualDescription) }




//协议可以 继承 一个或多个协议，并且可以在其继承的协议的基础上添加更多的要求。
//协议继承的语法类似于类继承的语法，但是协议继承支持同时继承多个协议，并用逗号隔开：
//protocol InheritingProtocol: SomeProtocol, AnotherProtocol { }




//类专属协议
//你可以通过将 AnyObject 协议添加到协议的继承列表，来将协议限定为仅类类型（而不是结构体或枚举）可用。
//protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol { }
//SomeClassOnlyProtocol 只能被类类型遵循。 如果尝试编写遵循 SomeClassOnlyProtocol 协议的结构体或枚举，会出现编译时错误。





//协议组合
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person34: Named, Aged {
    var name: String
    var age: Int
}
//func wishHappyBirthday(to celebrator: Named & Aged) {
//    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
//}
//let birthdayPerson = Person34(name: "Malcolm", age: 21)
//wishHappyBirthday(to: birthdayPerson)
//// "Happy birthday, Malcolm, you're 21!"

//wishHappyBirthday 参数的类型是 Named & Aged，这意味着「任何同时遵循 Named 和 Aged 协议的类型。」
//只要遵循这两个协议，将具体什么类型传递给函数并不重要。





//协议遵循的检查
/*
 可以使用 类型转换 中描述的 is 和 as 运算符来检查协议遵循，和转换成特定协议。
 如果实例遵循协议，则 is 运算符返回 true，如果不遵循则返回 false。
 向下转换运算符的 as? 返回协议类型的可选值，如果实例不遵循该协议，则该值为 nil。
 向下转换运算符的 as! 强制向下转换为协议类型，如果向下转换不成功则触发运行时错误。
*/


//可选协议要求
/*
你可以为协议定义 可选要求，这些要求不强制遵循类型的实现。可选要求以 optional 修饰符为前缀，作为协议定义的一部分。
 可选要求允许你的代码与 Objective-C 交互。协议和可选要求都必须用 @objc 属性标记。
 请注意，@objc 协议只能由继承自 Objective-C 类或其他 @objc 类的类遵循。结构体或枚举不能遵循它们。
 
 考虑到遵循协议的类型可能未实现要求，你应该使用可选链来调用可选协议要求。
 你通过在调用方法名称后面写一个问号来检查可选方法的实现，例如 someOptionalMethod?(someArgument)。
*/
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}
//counter.count = -4
//counter.dataSource = TowardsZeroSource()
//for _ in 1...5 {
//    counter.increment()
//    print(counter.count)
//}
//// -3
//// -2
//// -1
//// 0
//// 0



//协议扩展
/*
通过协议扩展，我们可以向符合协议的类型提供方法、构造器、下标和计算属性的实现。
 这允许你基于协议本身来实现行为，而无需再让每个遵循协议的类型都重复实现，或是使用全局函数。
 
 可以通过扩展 RandomNumberGenerator 协议来实现 randomBool() 方法，该方法使用 random() 的结果来返回一个随机的 Bool 值：
 extension RandomNumberGenerator {
    func randomBool() -> Bool { return random() > 0.5 }
 }
 
 let generator = LinearCongruentialGenerator()
 print("Here's a random number: \(generator.random())")
 // 打印 "Here's a random number: 0.3746499199817101"
 print("And here's a random Boolean: \(generator.randomBool())")
 // 打印 "And here's a random Boolean: true"
 
*/


//提供默认实现
/*
 可以使用协议扩展来为任何方法或计算属性提供默认实现。
 如果一个符合的类型本身就实现了协议中要求的方法或属性，那么这个实现会代替协议扩展中的实现。
 
 extension PrettyTextRepresentable  {
    var prettyTextualDescription: String { return textualDescription }
 }
 
 */




//为协议扩展添加条件约束
//当我们定义一个协议扩展时，我们可以通过where关键字在被扩展的协议名称后指定一个任意类型在遵循协议前必须满足的约束条件。
//可以在Collection协议的扩展中指定集合中的所有元素必须先遵循Equatable这个协议。
//通过Equatable这个基础协议，我们便可以使用==或者!=操作符来检查任意两个元素是否相等。
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
//allEqual()这个方法只有当集合中的所有元素都相等时才会返回true




