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
 
 
 */


