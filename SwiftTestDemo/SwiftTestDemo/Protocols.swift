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
/*
 
 */




