//
//  main.swift
//  SwiftTips
//
//  Created by MA806P on 2018/9/28.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

print("Hello, World!")


// -----------------------------
/*
 @autoclosure 和 ??
 
 @autoclosure 做的事情就是把一句表达式自动地封装成一个闭包 (closure)。
 
 
 
 */


func logIfTrue(_ predicate:() -> Bool) {
    if predicate() {
        print("True")
    }
}
logIfTrue({return 2 > 1})
logIfTrue({2 > 1})
logIfTrue{2 > 1}

//“但是不管哪种方式，要么是书写起来十分麻烦，要么是表达上不太清晰”
//“于是 @autoclosure 登场了。我们可以改换方法参数，在参数名前面加上 @autoclosure 关键字：
func logIfTrue2(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("True")
    }
}
logIfTrue2(2 > 1) // 2>1 ==> ()->Bool




//在 Swift 中，有一个非常有用的操作符，可以用来快速地对 nil 进行条件判断，那就是 ??。
//这个操作符可以判断输入并在当左侧的值是非 nil 的 Optional 值时返回其 value，当左侧是 nil 时返回右侧的值
var level: Int?
var startLevel = 1
var currentLevel = level ?? startLevel
print("-- \(currentLevel)")


/*
 “?? 的定义，可以看到 ?? 有两种版本：
 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T?) -> T?
 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T”
 
 虽然表面上看 startLevel 只是一个 Int，但是其实在使用时它被自动封装成了一个 () -> Int，有了这个提示，我们不妨来猜测一下 ?? 的实现：
 func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
 switch optional {
 case .Some(let value): return value
 case .None: return defaultValue() }
 }
 
 为什么这里要使用 autoclosure，直接接受 T 作为参数并返回不行么，为何要用 () -> T 这样的形式包装一遍，岂不是画蛇添足
 如果我们直接使用 T，那么就意味着在 ?? 操作符真正取值之前，我们就必须准备好一个默认值传入到这个方法中，
 一般来说这不会有很大问题，但是如果这个默认值是通过一系列复杂计算得到的话，可能会成为浪费
 因为其实如果 optional 不是 nil 的话，我们实际上是完全没有用到这个默认值，而会直接返回 optional 解包后的值的。
 这样的开销是完全可以避免的，方法就是将默认值的计算推迟到 optional 判定为 nil 之后。
 
 就这样，我们可以巧妙地绕过条件判断和强制转换，以很优雅的写法处理对 Optional 及默认值的取值了。
 最后要提一句的是，@autoclosure 并不支持带有输入参数的写法，
 也就是说只有形如 () -> T 的参数才能使用这个特性进行简化。
 另外因为调用者往往很容易忽视 @autoclosure 这个特性，所以在写接受 @autoclosure 的方法时还请特别小心，
 如果在容易产生歧义或者误解的时候，还是使用完整的闭包写法会比较好。
 
 
 
 
 
 */






// -----------------------------
/*
/*
 多元组 Tuple
 */

//交换
func swapMe2<T>(a: inout T, b: inout T) {
    (a, b) = (b, a)
}

var a = 1
var b = 2
swapMe2(a: &a, b: &b)
print("a=\(a) b=\(b)") //a=2 b=1


/*
 “
 /*
 CGRectDivide(CGRect rect, CGRect *slice, CGRect *remainder,
 CGFloat amount, CGRectEdge edge)
 */
 CGRect rect = CGRectMake(0, 0, 100, 100);
 CGRect small;
 CGRect large;
 CGRectDivide(rect, &small, &large, 20, CGRectMinXEdge);
 上面的代码将 {0,0,100,100} 的 rect 分割为两部分，分别是 {0,0,20,100} 的 small 和 {20,0,80,100} 的 large。
 由于 C 系语言的单一返回，我们不得不通过传入指针的方式让方法来填充需要的部分，可以说使用起来既不直观，又很麻烦。”


 “在 Swift 中，这个方法摇身一变，使用了多元组的方式来同时返回被分割的部分和剩余部分”
extension CGRect {
    //...
    func divided(atDistance: CGFloat, from fromEdge: CGRectEdge)
        -> (slice: CGRect, remainder: CGRect)
    //...
}
//然后使用的时候，对比之前的做法，现在就非常简单并且易于理解了：

let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let (small, large) = rect.divided(atDistance: 20, from: .minXEdge)

 */

*/




// -----------------------------
/*
// Sequence
 
/*
 “Swift 的 for...in 可以用在所有实现了 Sequence 的类型上，
 而为了实现 Sequence 你首先需要实现一个 IteratorProtocol。”
 
 */
// 先定义一个实现了 IteratorProtocol 协议的类型
// IteratorProtocol 需要指定一个 typealias Element
// 以及提供一个返回 Element? 的方法 next()

class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    
    var array: [Element]
    var currentIndex = 0
    
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        } else {
            let element = array[currentIndex]
            currentIndex -= 1
            
            return element
        }
    }
}

// 然后我们来定义 Sequence
// 和 IteratorProtocol 很类似，不过换成指定一个 typealias Iterator
// 以及提供一个返回 Iterator? 的方法 makeIterator()”
struct ReverseSequence<T>:Sequence {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    typealias  Iterator = ReverseIterator<T>
    
    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}

let arr = [0,1,2,3,4]
for i in ReverseSequence(array: arr) {
    print("Index \(i) is \(arr[i])")
}
/*
 “Index 4 is 4
 Index 3 is 3
 Index 2 is 2
 Index 1 is 1
 Index 0 is 0”
 
 for...in 这样的方法到底做了什么的话，如果我们将其展开，大概会是下面这个样子：
 var iterator = arr.makeIterator()
 while let obj = iterator.next() { print(obj) }
 
 “你可以使用像 map , filter 和 reduce 这些方法，因为 Sequence 协议扩展 (protocol extension) 已经实现了它们：
 extension Sequence {
 func map<T>(_ transform: @noescape (Self.Iterator.Element) throws -> T) rethrows -> [T]
 func filter(_ isIncluded: @noescape (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.Iterator.Element]
 func reduce<Result>(_ initialResult: Result,
 _ nextPartialResult: @noescape (partialResult: Result, Self.Iterator.Element)
 throws -> Result) rethrows -> Result”
 */





// -----------------------------
/*
 将 protocol 的方法声明为 mutating
 “Swift 的 mutating 关键字修饰方法是为了能在该方法中修改 struct 或是 enum 的变量，
 所以如果你没在协议方法里写 mutating 的话，别人如果用 struct 或者 enum 来实现这个协议的话，
 就不能在方法里改变自己的变量了。”
 
 “在使用 class 来实现带有 mutating 的方法的协议时，具体实现的前面是不需要加 mutating 修饰的，
 因为 class 可以随意更改自己的成员变量。所以说在协议里用 mutating 修饰方法，
 对于 class 的实现是完全透明，可以当作不存在的。”
 
 
 */

protocol Vehicle {
    var numberOfWhells: Int { get }
    var color: String { get set }
    
    mutating func changeColor()
}

struct MyCar: Vehicle {
    let numberOfWhells: Int = 4
    var color: String = "Red"
    
    mutating func changeColor() {
        color = "Blue"
    }
}





// -----------------------------

//Swift 里可以将方法进行柯里化 (Currying)，
//这是也就是把接受多个参数的方法进行一些变形，使其更加灵活的方法。

func addOne(num: Int) -> Int {
    return num + 1
}

func addTo(_ adder: Int) -> (Int) -> Int {
    return {
        num in
        return num + adder
    }
}
let addTwo = addTo(2)
let result = addTwo(6) //8


func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}
let greaterThan10 = greaterThan(10)
print("\(greaterThan10(13))") // true






protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction()-> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    
    func setTarget<T: AnyObject>(target: T, action: @escaping(T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
    
}


*/



