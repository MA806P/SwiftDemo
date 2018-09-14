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
 如果你组合两种不同类型的元组，一个带有 internal 访问，另一个带有 private 访问，合成的元组类型的访问级别将是 private.
 
 元组类型没有像类、结构体、枚举、和函数那样的单独的定义。元组类型的访问级别是在使用元组时自动推导出来的，它不能被显式地指定。
 
 */

/*
 
 函数类型
 函数类型的访问级别被计算为函数参数类型和返回值类型的限制性最强的访问级别。
 如果函数的计算访问级别和上下文默认的不匹配，你必须显式地指定访问级别作为函数定义的一部分。
 
 函数的返回值是由两个定义在自定义类型中的自定义类型组成的元组。其中一个定义为 internal，另一个定义为 private。
 因此，合成的元组的整体访问级别为 private（元组的组成类型的最小访问级别）。
 因为函数的返回值类型是 private，为了函数声明有效，你必须用 private 修饰符标记函数的整体访问级别：
 private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
 // 函数实现在这
 }
 
 */



/*
 
 枚举类型
 枚举中的独立成员自动使用该枚举类型的访问级别。你不能给独立的成员指明一个不同的访问级别。
 
 
 
 嵌套类型
 定义在 private 类型中的嵌套类型自动访问级别为 private 。
 定义在 file-private 类型中的嵌套类型自动访问级别为 file-private 。
 定义在 public 类型中的嵌套类型自动访问级别为 public 。
 如果你想要在 public 类型中的嵌套类型能够被外部访问，你必须要显示的声明这个嵌套类型为 public。
 
 */




/*
 
 子类化
 你可以在符合当前访问上下文中子类化任何类。子类不能拥有高于其父类的访问等级——举个例子，
 你不能写父类为 internal 类型而其子类为 public 类型的代码。
 在确定可见的访问权限上下文中，你可以重写任何类成员（方法，属性，初始化器或者下标）
 重写类成员可以使其比父类版本更加开放。
 
 
 
 常量，变量，属性和下标
 一个常量，变量或者属性的访问级别不能比其所代表的类型更高。
 举个例子，写一个代表了 private 类型的 public 属性是无效的。
 private var privateInstance = SomePrivateClass()
 
 
 
 赋值方法和取值方法
 常量，变量，属性和下标的赋值和取值方法能够自动的接收和它们访问级别一致的常量，变量，属性和下标。
 你可以设置一个比取值方法更 低 访问级别的赋值方法来进行约束属性或下标的读-写范围。
 你可以在 var 或 subscript 前加入修饰符 fileprivate(set)， private(set)， 或 internal(set) 来给其分配一个较低的访问级别
 
 注意
 该规则适用于存储和计算属性。尽管你并没有显式的对存储属性写出赋值或取值方法，
 但 Swift 仍然会为你的存储属性所存储的值隐式合成赋值和取值方法。使用 fileprivate(set)， private(set)，
 或 internal(set) 修饰符去改变这个合成赋值方法的访问级别与显式的写出计算属性的赋值方法取得的效果是完全一致的。
 
 
 struct TrackedString {
 private(set) var numberOfEdits = 0
 var value: String = "" {
 didSet {
 numberOfEdits += 1
 }
 }
 }
 通过结合 pulic 和 private(set) 访问级别修饰符，
 你可以让该结构体的 numberOfEdits 属性取值方法为公开的，而它的赋值方法是私有的。
 public private(set) var numberOfEdits = 0
 
 
 
 
 
 
 初始化器的参数访问级别类型不能比该初始化器本身拥有的访问级别更低。
 默认初始化器拥有和初始化对象类型相同的访问级别，除非该类型为 public 。
 当初始化对象类型被定义为 public 时，它的默认初始化器被认为是 internal 级别。
 如果你想要在另外一个模块中使用无参初始化器去初始化 public 类型参数，
 你必须显式的提供一个 public 类型的无参初始化器作为类型定义的一部分
 
 如果结构体类型中的任何一个存储属性为 private 类型，则该结构体类型的默认成员初始化器被认为是 private 类型
 当在另外一个模块中，如果你想要成员初始化器初始化 public 的结构体类型时，
 你必须要提供一个 public 类型的成员初始化器作为该结构体类型定义的一部分。
 
 
 
 
 协议
 如果要为协议类型分配显式访问级别，请在定义协议时执行此操作。这可以使你创建的协议只能在特定的上下文中访问。
 协议定义中每个要求的访问级别自动设置为与协议相同的访问级别。你不能将协议要求设置为与协议不同的访问级别。
 这可确保在采用该协议的任何类型上都可以看到所有协议的要求。
 
 协议继承
 如果你定义一个新的协议是从现有协议中继承而来，那么新协议的访问级别最多可以与其继承的协议相同。
 例如，你无法编写一个从 internal 协议继承过来的 public 协议。
 
 
 
 扩展
 在扩展中添加的任何类型成员都与原始类型声明中的成员具有相同的默认访问级别。
 你可以使用显示访问级别修饰符（例如 private extension ）标记扩展，
 用来给扩展中定义的成员重新设置默认的访问级别。这个新的默认值仍然可以在单个类型成员的扩展中被覆盖。
 如果你使用扩展来添加协议一致性，则无法为扩展提供显式访问级别修饰符。
 相反，协议本身的访问级别为扩展中的每个协议要求的实现提供默认的访问级别。
 
 
 
 
 扩展中的私有成员
 与类、结构体或枚举值写在同一个文件中的扩展的行为和原始类型声明的部分一样。因此，你可以：
 在原始声明中声明一个私有成员，并在同一个文件的扩展中访问它。
 在一个扩展中声明一个私有成员，并在同一个文件中的另一个扩展中访问它。
 在一个扩展中声明一个私有成员，并在同一个文件中的原始声明里访问它。
 
 
 protocol SomeProtocol { func doSomething() }
 
 struct SomeStruct { private var privateVariable = 12 }
 
 extension SomeStruct: SomeProtocol {
 func doSomething() {
 print(privateVariable)
 }
 }
 
 
 
 泛型类型
 任何泛型参数或泛型函数的访问级别是该泛型参数或函数自身访问级别的最小值，以及对其类型参数的任何类型约束的访问级别。
 
 
 
 类型别名
 为了达到访问控制的目的，你定义的任何类型别名会被看作是不同类型。
 类型别名可以拥有小于或等于其所代表类型的访问级别。
 举个例子，一个 private 的类型别名可以代表 private ， file-private ， internal ， public 或 open 类型。
 但是 public 级别的类型别名不能代表 internal ， file-private ， 或 private 类型。
 
 */


