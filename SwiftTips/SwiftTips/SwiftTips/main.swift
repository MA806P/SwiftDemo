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
//swift 支持重载操作符的特性

struct Vector2D {
    var x = 0.0
    var y = 0.0
}

let v1 = Vector2D(x: 2.0, y: 3.0)
let v2 = Vector2D(x: 2.0, y: 3.0)
let v3 = Vector2D(x: v1.x + v2.x, y: v1.y + v2.y)


func +(left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}
let v4 = v1 + v2
print("v3 = \(v3), v4 = \(v4)")
//v3 = Vector2D(x: 4.0, y: 6.0), v4 = Vector2D(x: 4.0, y: 6.0)

func +*(left: Vector2D, right: Vector2D) -> Double {
    return left.x * right.x + left.y * right.y
}
//Swift 中已经有定义了 +* ，如果我们要新加操作符的话，需要先对其进行声明，告诉编译器这个符号其实是一个操作符
precedencegroup DotProductPrecedence {
    associativity: none
    higherThan: MultiplicationPrecedence
}

infix operator +*: DotProductPrecedence


/*
 “precedencegroup
 定义了一个操作符优先级别。操作符优先级的定义和类型声明有些相似，一个操作符比需要属于某个特定的优先级。Swift 标准库中已经定义了一些常用的运算优先级组，比如加法优先级 (AdditionPrecedence) 和乘法优先级 (MultiplicationPrecedence) 等，你可以在这里(https://github.com/apple/swift-evolution/blob/master/proposals/0077-operator-precedence.md)找到完整的列表。如果没有适合你的运算符的优先级组，你就需要像我们在例子中做得这样，自己指定结合律方式和优先级顺序了。
 associativity
 定义了结合律，即如果多个同类的操作符顺序出现的计算顺序。比如常见的加法和减法都是 left，就是说多个加法同时出现时按照从左往右的顺序计算 (因为加法满足交换律，所以这个顺序无所谓，但是减法的话计算顺序就很重要了)。点乘的结果是一个 Double，不再会和其他点乘结合使用，所以这里是 none；
 higherThan
 运算的优先级，点积运算是优先于乘法运算的。除了 higherThan，也支持使用 lowerThan 来指定优先级低于某个其他组。
 infix
 表示要定义的是一个中位操作符，即前后都是输入；其他的修饰子还包括 prefix 和 postfix，不再赘述；
 
 “Swift 的操作符是不能定义在局部域中的，因为至少会希望在能在全局范围使用你的操作符，否则操作符也就失去意义了。
 另外，来自不同 module 的操作符是有可能冲突的，这对于库开发者来说是需要特别注意的地方。
 如果库中的操作符冲突的话，使用者是无法像解决类型名冲突那样通过指定库名字来进行调用的。
 因此在重载或者自定义操作符时，应当尽量将其作为其他某个方法的 "简便写法"，而避免在其中实现大量逻辑或者提供独一无二的功能。
 这样即使出现了冲突，使用者也还可以通过方法名调用的方式使用你的库。
 运算符的命名也应当尽量明了，避免歧义和可能的误解。
 因为一个不被公认的操作符是存在冲突风险和理解难度的，所以我们不应该滥用这个特性。
 在使用重载或者自定义操作符时，请先再三权衡斟酌，你或者你的用户是否真的需要”
 
 */
let result = v1 +* v2
print("result = \(result)") //13 = 2*2 + 3*3


// -----------------------------


/*
//Optional Chaining 可摆脱不必要的判断
//因为 Optional Chaining 是随时都可能提前返回 nil 的，所以使用 Optional Chaining 所得到的东西其实都是 Optional 的

class Toy {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Pet {
    var toy: Toy?
}

class Child {
    var pet: Pet?
}

var xiaoming = Child()

let toyName = xiaoming.pet?.toy?.name

extension Toy {
    func play() {
        
    }
}

let playClosure = {(child:Child) -> (Void)? in child.pet?.toy?.play()}
if let result: () = playClosure(xiaoming) {
    print("YES")
} else {
    print("NO")
}
*/


// -----------------------------

/*
 
func doWork(block: ()->()) {
    block()
}

doWork {
    print("work")
}

//“对于 block 的调用是同步行为。如果我们改变一下代码，将 block 放到一个 Dispatch 中去，
//让它在 doWork 返回后被调用的话，我们就需要在 block 的类型前加上 @escaping 标记来表明这个闭包是会“逃逸”出该方法的：
func doWorkAsync(block: @escaping ()->()) {
    DispatchQueue.main.async {
        block()
    }
}


class S {
    
    var foo = "foo"
    
    func method1() {
        doWork {
            print(foo)
        }
        foo = "bar"
    }
    
    func method2() {
        doWorkAsync {
            print(self.foo)
        }
        foo = "bar"
    }
    
    func method3() {
        doWorkAsync {
            [weak self] in
            print(self?.foo ?? "nil")
        }
        foo = "bar"
    }
}

S().method1() //foo
S().method2() //bar ?????? 为何我写的不打印
S().method3() //nil ??????

//闭包持有了 self，打印的值是 method2 最后对 foo 赋值后的内容 bar。
//如果我们不希望在闭包中持有 self，可以使用 [weak self] 的方式来表达


/*
如果你在协议或者父类中定义了一个接受 @escaping 为参数方法，
那么在实现协议和类型或者是这个父类的子类中，对应的方法也必须被声明为 @escaping，否则两个方法会被认为拥有不同的函数签名
protocol P {
    func work(b: @escaping ()->())
}

// 可以编译
class C: P {
    func work(b: @escaping () -> ()) {
        DispatchQueue.main.async {
            print("in C")
            b()
        }
    }
}
// 而这样是无法编译通过的：
//class C1: P { func work(b: () -> ()) { } }
*/

*/






// -----------------------------
/*
 //@autoclosure 和 ??
 //@autoclosure 做的事情就是把一句表达式自动地封装成一个闭包 (closure)。


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



