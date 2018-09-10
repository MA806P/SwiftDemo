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



//关联类型
/*
当定义一个协议时，有时候定义一个或多个关联类型作为协议的一部分是很有用的。
 关联类型 作为协议的一部分并为一种类型提供占位符名称。
 在实现该协议之前不会指定该关联类型的实际类型。关联类型使用 associatedtype 关键字来指定。

*/

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
/*任何符合 Container 协议的类型必须指定它存储的值的类型。
 具体来说，它必须确保只将正确类型的元素添加到容器中，并且必须明确下标返回元素的类型。
 append(_:) 方法的任何值必须与容器内元素的类型相同，并且容器的下标返回的值与容器内元素的类型相同。
 为此，Container 协议声明了一个关联类型 Item，写作 associatedtype Item。协议没有定义 Item 是什么，该信息留给任何符合要求的类型提供
 
 */
struct Stack123<Element>: Container {
    // Stack<Element> 的原始实现
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // 符合 Container 协议
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


//将约束添加到关联类型
/*
你可以将类型约束添加到协议的关联类型中，以要求符合的类型满足这些约束
*/
 
 
 
struct IntStack: Container {
    // IntStack 的原始实现
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // 符合 Container 协议
    typealias Item = Int //<------------------------------
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}




struct Stack124<Element>: Container {
    // Stack<Element> 的原始实现
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // 符合 Container 协议
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
 //在这里，类型参数 Element 作为 append(_:) 方法的 item 参数和下标的返回类型。
 //因此 Swift 可以推断出 Element 是用作这个特定容器的 Item 的合适类型。
 
 
/*
 扩展现有类型以指定关联类型
 
 你可以通过扩展现有类型来保证协议的一致性，如 添加协议与扩展的一致性 中所述。
 这需要一个带有关联类型的协议。
 
 Swift 的 Array 类型已经提供了 append（_ :) 方法，count 属性，以及带有 Int 索引的下标来检索它的元素。
 这三个功能符合 Container 协议的要求。这意味着只需声明 Array 遵循了 Container 协议，
 就可以扩展 Array 使其符合 Container 协议。你可以使用空扩展执行此操作，如 使用扩展声明遵循协议 中所述：
 
 extension Array: Container {}
 
 根据 Array 现有的 append(_:) 方法和下标，Swift 能够推断出 Item 的具体类型，
 就像上面的泛型 Stack 类型一样。定义此扩展后，你可以把任何 Array 当作 Container 使用。
 
 
 
 
 将约束添加到关联类型
 protocol Container {  associatedtype Item: Equatable
 
 
 
 
 在其关联类型的约束中使用协议
 protocol SuffixableContainer: Container {
 associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
 func suffix(_ size: Int) -> Suffix
 }
 
 */



/*
 泛型 Where 子句
 可以通过定义 泛型 where 子句 来完成此操作。泛型 where 子句使你能够要求关联类型必须符合某个协议，
 或者某些类型参数和相关类型必须相同。泛型 where 子句以 where 关键字开头，
 后跟关联类型的约束条件或类型和关联类型之间的相等关系。你需要在一个类型或函数体的起始大括号之前写一个泛型 where 子句。
 
 
 在扩展中使用泛型 Where 子句
 extension Stack where Element: Equatable {
 
 也可以编写一个通用的 where 子句，要求它们的 Item 为特定类型
 extension Container where Item == Double {
 
 
 带有泛型 Where 子句的关联类型
 associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
 
 从其他协议继承的协议，通过在协议声明中包含泛型 where 子句，可以向继承的关联类型添加约束
 protocol ComparableContainer: Container where Item: Comparable { }
 
 
 
 
 
 泛型下标
 下标也可以用泛型表示，同时也可以包含泛型 where 子句。
 可以在 下标 之后的尖括号内写一个类型占位符，在下标主体的起始大括号之前写一个泛型 where 子句
 extension Container {
 subscript<Indices: Sequence>(indices: Indices) -> [Item]
 where Indices.Iterator.Element == Int {
 var result = [Item]()
 for index in indices {
 result.append(self[index])
 }
 return result
 }
 }
 
 
 
 
 
 */







