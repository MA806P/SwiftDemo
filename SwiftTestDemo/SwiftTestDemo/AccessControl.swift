//
//  AccessControl.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/9/13.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 访问控制 限制来自其他资源文件和模块的代码对你代码部分的访问。
 这个特性可以让你隐藏代码的实现细节，并且可以让你指定一个更喜欢的接口。代码可以通过这个接口被访问和使用。
 
 
 模块和资源文件
 Swift 的访问控制模型是基于模块和资源文件的概念。
 模块 是代码分发的独立单元——可以作为一个独立单元被构建和发布的 Framework 或 Application。
 模块可以被另一个模块用 Swift 的 import 关键字引用。
 在 Swift 中，Xcode 的每个构建目标（比如 app bundle 或 framework ）都被当作一个独立模块。
 如果你的团队把应用中部分代码放在一起作为一个独立的 framework ——可能用来在多个应用中包含和复用代码——然后，
 当它被一个应用引用和使用，或被另一个 framework 使用的时候，在这个 framework 中定义的每个东西都将作为独立模块的一部分。
 
 资源文件 是模块中单独的 Swift 源代码文件（实际上是应用或 framework 中的单独文件）。
 虽然在不同的源文件中定义格子的类型是常见的，但一个单独的源文件可以包含不同类型、函数等的定义。
 
 
 
 
 
 Swift 为代码中的实体提供了五种不同的 访问级别 。这些访问级别与定义实体的源文件相关联 ，也与源文件所属的模块相关联。
 
 Open 访问 和 public 访问 使实体可以在定义所在的模块的任何源文件中使用，
 也可以在引用了定义所在的模块的另一个模块中的源文件中使用。当为 framework 声明公用接口时常常使用 open 访问 或 public 访问 。
 
 Internal 访问 使实体可以在定义所在的模块的任何源文件中使用 ，但是不能在这个模块之外的任何源文件中使用。
 当定义一个应用或 framework 的内部结构时，常常使用Internal 访问 。
 
 File-private 访问 限制实体只能在它定义所在的源文件中使用。当一个特定功能片段在整个文件中使用时，
 用 file-private 访问 来隐藏它的实现细节。
 
 Private 访问 限制实体用于在同一个文件中附加声明、扩展声明。当一个特定功能片段仅仅被用在单个声明中时，
 用 Private 访问  隐藏它的实现细节。
 
 
 
 Open 访问是最高的（限制性更弱的）访问级别，而 private 访问是最低的（限制性更强的）访问级别。
 Open 访问仅仅应用于类和类的成员。它在几个方面区别于 public 访问:
 public 访问或其他更多限制访问级别修饰的类，仅可以被其定义所在模块中的类继承。
 public 访问或其他更多限制访问级别修饰的类成员，仅可以被其定义所在模块中的子类重载。
 Open 修饰的类可以被其定义所在模块或任何引用其定义所在模块的模块中的类继承。
 Open 修饰的类成员可以被其定义所在模块或任何引用该模块的模块中的子类重载。
 
 
 public class SomePublicClass {}
 internal class SomeInternalClass {}
 fileprivate class SomeFilePrivateClass {}
 private class SomePrivateClass {}
 
 public var somePublicVariable = 0
 internal let someInternalConstant = 0
 fileprivate func someFilePrivateFunction() {}
 private func somePrivateFunction() {}
 
 除非另有规定，默认访问级别为 internal。 这意味着 SomeInternalClass 和 someInternalConstant
 可以不用写显式访问级别修饰符，并且依然有访问级别 internal ：
 class SomeInternalClass {}              // 隐式 internal
 let someInternalConstant = 0            // 隐式 internal
 
 
 
 
 
 public class SomePublicClass {                  // 显式 public 类
 public var somePublicProperty = 0            // 显式 public 类成员
 var someInternalProperty = 0                 // 隐式 internal 类成员
 fileprivate func someFilePrivateMethod() {}  // 显式 file-private 类成员
 private func somePrivateMethod() {}          // 显式 private 类成员
 }
 
 class SomeInternalClass {                       // 隐式 internal 类
 var someInternalProperty = 0                 // 隐式 internal 类成员
 fileprivate func someFilePrivateMethod() {}  // 显式 file-private 类成员
 private func somePrivateMethod() {}          // 显式 private 类成员
 }
 
 fileprivate class SomeFilePrivateClass {        // 显式 file-private 类
 func someFilePrivateMethod() {}              // 隐式 file-private 类成员
 private func somePrivateMethod() {}          // 显式 private 类成员
 }
 
 private class SomePrivateClass {                // 显式 private class
 func somePrivateMethod() {}                  // 隐式 private 类成员
 }
 
 
 */




/*
 
 元组类型
 元组类型的访问权限是元组中使用的全部类型的访问级别中限制性最强的。
 
 
 */



