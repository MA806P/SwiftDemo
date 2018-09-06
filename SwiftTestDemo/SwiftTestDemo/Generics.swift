//
//  Generics.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/9/6.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

//泛型


//泛型函数
//

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
//var someInt = 3
//var anotherInt = 107
//swapTwoValues(&someInt, &anotherInt)
//// someInt 现在是 107, anotherInt 现在是 3
//
//var someString = "hello"
//var anotherString = "world"
//swapTwoValues(&someString, &anotherString)
//// someString 现在是 "world",  anotherString 现在是 "hello"

/*
 泛型版本的函数使用占位符类型名称（在这里叫做 T ）而不是一个真正的类型名称（比如 Int , String 或者 Double ）。
 占位类型名不需要说明 T 具体是什么类型。但是它必须确定 a 和 b 都是相同的类型 T ，无论 T 代表什么。
 每次调用 swapTwoValues(_:_:)  的时候，才会确定代替 T 的实际类型。
 
 <T> 括号告诉 Swift , T 是 swapTwoValues(_:_:)  函数定义的占位类型名。
 因为 T 是占位符，所以 Swift 不会去查找名为 T 的实际类型。
 */




//泛型类型
/*
 除了泛型函数外，Swift 可以定义你自己的 泛型类型 。
 这些自定义的类、结构体、枚举可以和 任何 类型一起使用，方式类似于 数组 和 字典
*/
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}


//扩展泛型类型
//你不需要提供类型参数列表作为扩展定义的一部分。
//原始 类型定义中的类型参数列表在扩展的主体内依旧可用，并且原始类型参数名称会被用于引用原始定义中的类型参数。
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}





//类型约束
/*
 类型约束指定参数类型必须继承自特定的类、遵循特定的协议、特定的协议组。
 例如，Swift中 字典 类型对可以用作键的类型做了类型限制。在 字典中有描述 ，字典的键的类型必须是 可哈希化的 。
 也就是说它必须提供一种方式让自己具有唯一性。字典 的键必须是能够进行哈希的以确保对应的键有对应的值。
 如果没有这种要求，字典就无法辨别对于指定的键是记性插入还是替换值的操作，也无法根据给定的键去查找对应的值。
 
 
 类型约束的写法：在类型参数名后跟上一个类或协议来进行约束，使用冒号进行分割，作为类型参数列表的一部分。
 泛型函数的类型约束语法如下（泛型类型的语法与此相同）：
 func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
 // 这里写函数体的内容
 }
 T 的类型必须是 SomeClass 的子类。
 类型约束要求 U 必须遵循 SomeProtocol 协议
 
 */

func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
/*
 Swift 标准库定义了一个 Equatable 协议，该协议规定对应任何遵循该协议的类型，进行比较的时候，
 使用 （==）判断两个值是否相等，使用（!=）判断两个值不相等。所有的 Swift 标准库都自动支持 Equatable 协议。
 任何遵循 Equatable 协议的类型都可以安全的在 findIndex(of:in:) 函数中使用，因为他保证支持判断相等运算符。
 */













