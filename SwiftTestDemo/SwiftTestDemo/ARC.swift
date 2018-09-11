//
//  ARC.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/9/10.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 Automatic Reference Counting
 
 引用计数只适用于实例对象。结构体和枚举是值类型，不是引用类型，并且不通过引用存储和传递的。
 
 
 
 
 解决实例之间的强引用循环
 Swift 提供了两种方法解决你在使用类的属性而产生的强引用循环：弱引用（ weak ）和无主引用（ unowned ）。
 弱引用（ weak ）和无主引用（ unowned ）能确保一个实例在循环引用中引用另一个实例，
 而不用保持强引用关系。这样实例就可以相互引用且不会产生强引用循环。
 
 
 //weak
 class Person {
 let name: String
 init(name: String) { self.name = name }
 var apartment: Apartment?
 deinit { print("\(name) is being deinitialized") }
 }
 
 class Apartment {
 let unit: String
 init(unit: String) { self.unit = unit }
 weak var tenant: Person?   // <---------------
 deinit { print("Apartment \(unit) is being deinitialized") }
 }
 
 
 //unowned
 与弱引用不同的是，无主引用适用于其他实例有相同的生命周期或是更长的生命周期的场景。
 无主引用总是有值的。因而，ARC也不会将无主引用的值设置为 nil，这也意味着无主引用要被定义为非可选类型。

 只有在确保引用的实例 永远 不会释放，才能使用无主引用。
 如果你在无主引用的对象释放之后，视图访问该值，会触发运行时错误
 
 对于需要禁掉运行时安全检查的情况，Swift 也提供了不安全的无主引用--例如，出于性能考虑。
 想其他不安全操作一样，你需要负责检查代码的安全性。
 unowned(unsafe) 表示这是一个不安全的无主引用。当你试图访问已经释放了的不安全的无主引用实例时，
 程序会试图访问该实例指向的内存区域，这是一种不安全的操作。
 
 
 
 
 
 Person 和 Apartment 的例子展示了两个属性都允许设置为 nil，并会造成潜在的强引用循环。这种场景最适合用弱引用来解决。
 Customer 和 CreditCard 的例子展示了一个属性允许设置为 nil，而另一个属性不允许设置为 nil，并会造成潜在的强引用循环。这种场景最适合用无主引用来解决。
 然而，还有第三种场景，两个属性 都 必须有值，初始化之后属性都不能为 nil。在这场景下，需要一个类使用无主引用属性，另一个类使用隐式解析可选类型属性。
 
 
 
 
 闭包引起的强引用循环
 强引用循环还可能发生在将一个闭包赋值给一个实例的属性，并且这个闭包又捕获到这个实例的时候。捕获的原因可能是在闭包的内部需要访问实例的属性
 当你把一个闭包赋值给一个属性时，其实赋值的是这个闭包的引用，和之前的问题一样--都是两个强引用互相持有对方不被释放
 
 Swift 提供了一个优雅的解决方案，称之为 闭包捕获列表（closure capture list）。
 
 解决闭包引起的强引用循环
 定义闭包的时候同时定义 捕获列表 ，并作为闭包的一部分，通过这种方式可以解决闭包和实例之间的强引用循环。
 捕获列表定义了在闭包内部捕获一个或多个引用类型的规则。像解决两个实例的强引用循环一样，
 将每一个捕获类型声明为弱引用（weak）或是无主引用（unowned），而不是声明为强引用。
 至于是使用弱引用（weak）还是无主引用（unowned）取决于你代码中的不同部分之间的关系。
 
 Swift强制要求
 闭包内部使用 self 的成员，必须要写成 self.someProperty 或 self.someMethod()
 （而不是仅仅写成 someProperty 或 someMethod()）。这提醒你可能会一不小心就捕获了 self。
 
 定义捕获列表
 捕获列表中的每一项都是由 weak 或 unowned 关键字和实例的引用（如 self）
 或是由其他值初始化的变量（如delegate = self.delegate!）成组构成的。
 它们每一组都写在方括号中，组之间用逗号隔开。
 lazy var someClosure: (Int, String) -> String = {
 [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
 // closure body goes here
 }
 
 如果一个闭包没有指定的参数列表或是返回值，则可以在上下文中推断出来，此时要把捕获列表放在闭包的开始位置，其后跟着关键字 in ：
 lazy var someClosure: () -> String = {
 [unowned self, weak delegate = self.delegate!] in
 // closure body goes here
 }
 
 
 弱引用和无主引用
 当闭包和它捕获的实例始终互相持有对方的时候，将闭包的捕获定义为无主引用，那闭包和它捕获的实例总会同时释放。
 相反的，将捕获定义弱引用时，捕获的引用也许会在将来的某一时刻变成 nil。弱引用总是可选类型的，
 并且，当引用的实例释放的时候，弱引用自动变成 nil。 这就需要你在闭包内部检查它的值是否存在。
 
 
 */


class HTMLElement {
    
    let name: String
    let text: String?
    
//    lazy var asHTML: () -> String = {
//        if let text = self.text {
//            return "<\(self.name)>\(text)</\(self.name)>"
//        } else {
//            return "<\(self.name) />"
//        }
//    }
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}


//let heading = HTMLElement(name: "h1")
//let defaultText = "some default text"
//heading.asHTML = {
//    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
//}
//print(heading.asHTML())
//// "<h1>some default text</h1>"



//var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
//print(paragraph!.asHTML())
//// Prints "<p>hello, world</p>"
////置变量 paragraph 为 nil，断开它对 HTMLElement 实例的强引用，但是，HTMLElement 实例和它的闭包都不释放，这是因为强引用循环：
//paragraph = nil
////我们注意到 HTMLElement 实例的析构函数中的消息并没有打印



