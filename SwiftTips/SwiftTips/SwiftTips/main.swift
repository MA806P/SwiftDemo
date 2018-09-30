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



/*



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



