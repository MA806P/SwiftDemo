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

//Reflection 和 Mirror
/*
 反射 Reflection 是一种在运行时检测、访问或者修改类型的行为的特性。
 一般静态语言类型的结构和方法的调用都需要在编译时决定，
 能做的只是使用控制流 if switch 来决定作出怎样的的设置或是调用哪个方法。
 而反射特性可以让我们有机会的运行的时候通过某些条件实时决定调用的方法，甚至向某个类型动态的设置
 甚至加入属性及方法，是一种非常灵活强大的语言特性。
 
 Swift 中所有的类型都实现了 _Reflectable，这是一个内部协议，
 我们可以通过 _reflect 来获取任意对象的一个镜像，这个镜像对象包含类型的基本信息，
 在 Swift 2.0 之前，这是对某个类型的对象进行探索的一种方法。
 在 Swift 2.0 中，这些方法已经从公开的标准库中移除了，取而代之，我们可以使用 Mirror 类型来做类似的事情
 */

struct Perosn {
    let name: String
    let age: Int
}
let xiaoMing = Perosn(name: "XiaoMing", age: 20)
let r = Mirror(reflecting: xiaoMing)
print("xiaoMing is \(String(describing: r.displayStyle))")
print("属性个数：\(r.children.count)")
for child in r.children {
    print("属性名：\(String(describing: child.label)), 值：\(child.value)")
}

//xiaoMing is Optional(Swift.Mirror.DisplayStyle.struct)
//属性个数：2
//属性名：Optional("name"), 值：XiaoMing
//属性名：Optional("age"), 值：20

//child是一对键值的多元组
//public typealias Child = (label: String?, value: Any)
//public typealias Children = AnyCollection<Mirror.Type.Child>
//AnyForwardCollection 是遵守 CollectionType 协议的，因此我们可以简单地使用 count 来获取元素的个数，
//而对于具体的代表属性的多元组，则使用下标进行访问。

//“也可以简单地使用 dump 方法来通过获取一个对象的镜像并进行标准输出的方式将其输出出来”
dump(xiaoMing)
//    ▿ SwiftTips.Perosn
//    - name: "XiaoMing"
//    - age: 20

//我们可以在运行时通过 Mirror 了解一个 Swift 类型的实例属性信息。
//该特性最容易想到的应用的特性就是为任意 model 对象生成对应的JSON描述
//另一个常见的应用场景是类似对Swift类型的对象做像OC中KVC那样的valuForKey的取值

func valueFrom(_ object: Any, key: String) -> Any? {
    let mirror = Mirror(reflecting: object)
    for child in mirror.children {
        let (targetKey, targetMirror) = (child.label, child.value)
        if key == targetKey {
            return targetMirror
        }
    }
    return nil
}
if let name = valueFrom(xiaoMing, key: "name") as? String {
    print("通过 key 得到值：\(name)")
}
//通过 key 得到值：XiaoMing

//虽然理论上将反射特性应用在实际的 app 制作中是可行的，
//但是这一套机制设计的最初目的是用于 REPL 环境和 Playground 中进行输出的。
//所以我们最好遵守 Apple 的这一设定，只在 REPL 和 Playground 中用它来对一个对象进行深层次的探索，
//而避免将它用在 app 制作中 -- 因为你永远不知道什么时候它们就会失效或者被大幅改动。




// -----------------------------

/*
//lazy修饰符和lazy方法
//在 swift 中使用在变量属性前加 lazy 关键字方式来简单的指定延时加载
//使用lazy作为属性修饰符时，只能声明属性是变量，需要显示的指定属性类型
class ClassA {
    lazy var str: String = {
        let str = "Hello"
        print("只在首次访问输出")
        return str
    }()
}
//lazy var str: String = "Hello"

//“可以配合像 map 或是 filter 这类接受闭包并进行运行的方法一起，让整个行为变成延时进行的。
//在某些情况下这么做也对性能会有不小的帮助”
let data = 1...3
let result = data.lazy.map {
    (i: Int) -> Int in
    print("正在处理\(i)")
    return i*2
}
print("准备访问结果")
for i in result {
    print("操作后结果\(i)")
}
print("访问完毕")
//准备访问结果
//正在处理1
//操作后结果2
//正在处理2
//操作后结果4
//正在处理3
//操作后结果6
//访问完毕

//“对于那些不需要完全运行，可能提前退出的情况，使用 lazy 来进行性能优化效果会非常有效。
*/

// -----------------------------

/*
 final关键字可以用在 class func var 前面进行修饰，表示不允许对该内容进行继承或者重写操作。
 一方认为，这样是有益的，可以更好的对代码进行版本控制，得到更佳的性能，代码更安全
 当开发给其他开发者使用的库时，就需要更深的考虑各种使用场景和需求
 
 不希望被继承和重写的情况：
 1、类或者方法的功能确实已经很完备了，例如字符串MD5或AES加密解密的工具类
 2、子类继承和修改是一件危险的事情，例如修改编号
 3、为了父类中某些代码一定会被执行：有时父类一些关键代码被继承重写后必须执行（状态配置 认证等）
    否则会导致运行时候的错误，一般子类重写父类方法是没办法强制子类方法一定去调用相同的父类方法
    OC可以指定 __attribute__((objc_requires_super)) 属性，让编译器在子类没有调用父类方法时
    抛出警告，为了达到类似的目的，可以使用一个 final 的方法，在其中进行一些必要的配置
 
 使用 final 的另一个重要理由是可能带来的性能改善，编译器能从 final 中获取额外的信息可以对类或方法滴啊用进行
 额外的优化处理。这个优势在实际中与OC动态派发相比也十分有限，在项目有其他方面可以优化的情况下，并不建议使用 final
 的方式来追求性能的提升。
 
 */

class Parent {
    final func method() {
        print("开始配置")
        methodImp()
        print("结束配置")
    }
    
    func methodImp() {
        print("子类必须实现这个方法")
    }
}

class Child: Parent {
    override func methodImp() {
        //..子类业务
    }
}



// -----------------------------

/*
/*
 属性观察
 可以在当前类型内监视对于属性的设定，并作出相应。willSet didSet
 属性观察的一个重要用处是作为设置值的验证。
 
 */

class MyClass {
    
    let oneYearInSecond: TimeInterval = 365 * 24 * 60 * 60
    
    var date: NSDate {
        willSet {
            let d = date
            print("will: old value = \(d), new value = \(newValue)")
        }
        
        didSet {
            if date.timeIntervalSinceNow > oneYearInSecond {
                print("设定的时间太晚了")
                date = NSDate().addingTimeInterval(oneYearInSecond)
            }
            print("did: old value = \(oldValue), new value = \(date)")
        }
    }
    
    init() {
        date = NSDate()
    }
}

let foo = MyClass()
foo.date = foo.date.addingTimeInterval(10)
//will: old value = 2018-11-14 00:05:57 +0000, new value = 2018-11-14 00:06:07 +0000
//did: old value = 2018-11-14 00:05:57 +0000, new value = 2018-11-14 00:06:07 +0000

//初始化方法对属性的设定，以及在 willAet didSet 中对属性的再次设定都不会再次触发属性观察的调用
/*
 Swift中所声明的属性包括存储属性和计算属性两种。
 存储属性会在内存中实际分配地址对属性进行存储
 计算属性不包括背后的存储，只提供set和get两种方法。
 在同一个类型中，属性观察和计算属性是不能同时共存的。
 可以通过改写set中的内容来达到willSet didSet同样的属性观察的目的。
 如果无法改动这个类，有想要通过属性观察做一些事情，就需要子类化这个类，并重写它的属性。
 重写属性不知道父类属性的具体实现，只从父类属性中继承名字和类型，因此可以对父类属性任意添加属性观察，
 而不用在意父类中到底是存储属性还是计算属性：
 */

class A {
    var number: Int {
        get {
            print("get")
            return 1
        }
        set { print("set") }
    }
}
class B: A {
    override var number: Int {
        willSet { print("will set") }
        didSet { print("did set") }
    }
}

let b = B()
b.number = 0
print("\(b.number)")
//get
//will set
//set
//did set
//get
//1

//get被调用，因为实现了didSet会用到oldValue
//这个值需要在整个set动作之前进行获取并存储待用，否则无法确保正确性
//如果不实现 didSet 的话，第一次 get 操作也将不存在

*/

// -----------------------------

/*
/*
 动态类型和多方法
 可通过 dynamicType 来获取一个对象的动态类型（运行时的实际类型，而非代码指定或编译器看到的类型）
 但是不能根据对象在动态时的类型进行合适的重载方法调用
 在Swift中可以重载同样名字的方法，而只需要保证参数类型不同：
 */
class Pet {}
class Cat: Pet {}
class Dog: Pet {}

func printPet(_ pet: Pet) {
    print("Pet")
}

func printPet(_ cat: Cat) {
    print("Cat")
}

func printPet(_ dog: Dog) {
    print("Dog")
}

printPet(Pet()) //Pet
printPet(Cat()) //Cat
printPet(Dog()) //Dog
//对于 Cat Dog 的实例，不会去调一个通用的父类 Pet 的方法，而是去寻找最合适的方法
func printThem(_ pet: Pet, _ cat: Cat) {
    printPet(pet)
    printPet(cat)
}
printThem(Dog(), Cat())// Pet Cat
// Dog() 的类型信息并没有被用来在运行时选择合适的方法，而是被忽略掉
// 并采用了编译期间决定的 Pet 的方法，因为 Swift 默认情况下是不采用动态派发的
// 因此方法的调用只能在编译时决定
// 想要绕过这个限制，需要进行通过对输入类型做判断和转换
func printThem2(_ pet: Pet, _ cat: Cat) {
    if let aCat = pet as? Cat {
        printPet(aCat)
    } else if let aDog = pet as? Dog {
        printPet(aDog)
    }
    printPet(cat)
}
printThem2(Dog(), Cat()) // Dog Cat
 
 */

// -----------------------------

/*
//协议和类方法中的Self
/*
 在一些协议定义可能会看到首字母大写的 Self
 protocol IntervalType { func clamp(xxx: Self ) -> Self {} }
 接受实现该协议的自身类型，并返回一个同样的类型
 因为协议其实本身是没有自己的上下文类型信息的，不知道什么类型来实现这个协议Swift也不能在协议中第一泛型进行限制
 当希望在协议中使用的类型就是实现这个协议本身的类型的话，就需要使用 Self 进行指代
*/

protocol Copyable {
    func copy() -> Self
    //该方法要求返回一个抽象的、表示当前类型的Self
}

class MyClass: Copyable {
    var num = 1
    
    func copy() -> Self {
        let result = type(of: self).init()
        result.num = num
        return result
    }
    
    //“编译器提示我们如果想要构建一个 Self 类型的对象的话，需要有 required 关键字修饰的初始化方法，
    //这是因为 Swift 必须保证当前类和其子类都能响应这个 init 方法。
    //另一个解决的方案是在当前类类的声明前添加 final 关键字，告诉编译器我们不再会有子类来继承这个类型。
    required init() {
        
    }
}

let object = MyClass()
object.num = 100

let newObject = object.copy()
object.num = 1

print("\(object.num) -- \(newObject.num)")//1 -- 100

*/

// -----------------------------

/*
//AnyClass 元类型和 .self
/*
 swift 中能够表示“任意”这个概念的除了 Any 和 AnyObject 以外还有 AnyClass
 typealias AnyClass = AnyObject.Type 这种方式得到是一个元类型Meta
 */
class A{
    class func method() {
        print("Hello")
    }
}
let typeA: A.Type = A.self
//.self 可以用在类型后面取的类型本身，获取到可以表示该类型的值
//也可以用在实例后面取的实例本身
//AnyClass 所表达的就是任意类型本身，对于A的类型取值，可以强制让它是一个 AnyClass
let typeA2: AnyClass = A.self

typeA.method()
(typeA2 as! A.Type).method()
//为什么不是直接调用 A.method() 对于单个独立的类型来说没有必要关系它的元类型，
//元变成概念可以变得灵活强大，在编写框架性的代码时会非常方便，例如传递一些类型时，就不需要不断改动代码了

/*
class MusicViewController: UIViewController { }
class AlbumViewController: UIViewController { }
let usingVCTypes: [AnyClass] = [MusicViewController.self,
                                AlbumViewController.self]
func setupViewControllers(_ vcTypes: [AnyClass]) {
    for vcType in vcTypes {
        if vcType is UIViewController.Type {
            let vc = (vcType as! UIViewController.Type).init()
            print(vc)
        }
    }
}
setupViewControllers(usingVCTypes)
 
 Cocoa API 中我们也常遇到一个 AnyClass 的输入，这时也应该使用 .self 的方式来获取所需要的元类型
 self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
 
 .Type 表示的是某个类型的元类型，而在 Swift 中，除了 class，struct 和 enum 这三个类型外，
 我们还可以定义 protocol。对于 protocol 来说，有时候我们也会想取得协议的元类型。
 这时我们可以在某个 protocol 的名字后面使用 .Protocol 来获取，使用的方法和 .Type 是类似的。
 
 */

 */

// -----------------------------

/*
//... 和 ..<
for i in 0...3 {
    print(i)
}

//可以用来连接两个字符串
let test = "helLo"
let interval = "a"..."z"
for c in test {
    if !interval.contains(String(c)) {
        print("\(c)不是小写字母")
    }
}
//L不是小写字母

//在日常开发中，我们可能会需要确定某个字符是不是有效的 ASCII 字符，和上面的例子很相似，
//我们可以使用 \0...~ 这样的 ClosedInterval 来进行 (\0 和 ~ 分别是 ASCII 的第一个和最后一个字符)。

*/

// -----------------------------

/*

//正则表达式
struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}
/*
 先写一个接受正则表达式的字符串，以此生成 NSRegularExpression 对象。
 然后使用该对象来匹配输入字符串，并返回结果告诉调用者匹配是否成功
 */

let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"

let matcher: RegexHelper
do {
    matcher = try RegexHelper(mailPattern)
}

let maybeMailAddress = "onev@onevcat.com"

if matcher.match(maybeMailAddress) {
    print("有效的邮箱地址")
}

//正则表达式30分钟入门教程
//http://deerchao.net/tutorials/regex/regex.htm

//8个常用正则表达式
//https://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149



//实现 =~
precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

//然后就可以使用类似于其他语言的正则匹配的方法了：
if "onev@onevcat.com" =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
    print("有效的邮箱地址")
}
// 输出: 有效的邮箱地址






//模式匹配 ~=模式匹配的操作符
//func ~= <T: Equatable>(a: T, b: T) -> Bool //可以判断是否相等的类型
//func ~= <T>(lhs: _OptionalNilComparisonType, rhs: T?) -> Bool //可以与nil比较的类型
//func ~= <I: IntervalType>(pattern: I, value: I.Bound) -> Bool //一个范围输入和某个特定值

//等类型的判断
let password = "abc"
switch password {
case "abc": print("pass")
default: print("no pass")
}

//optional的判断
let num: Int? = nil
switch num {
case nil: print("nil")
default: print("\(num!)")
}

//对范围的判断
let x = 0.5
switch x {
case -1.0...1.0: print("区间内")
default: print("区间外")
}

/*
 Swift的switch就是使用了 ~= 操作符进行模式匹配，只不过是Swift隐式的完成
那样在 case 做判断的时候我们完全可以使用我们自定义的模式匹配方法来进行判断，代码可以变得简洁有条理
 只需要按照要求重载 ~= 操作符，下面通过使用正则表达式做匹配例子
*/
func ~= (pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatches(in: input, options: [], range: NSRange(location: 0, length: input.count)) > 0
}

//将字符串转换为 NSRegularExpression 的操作符
prefix operator ~/
prefix func ~/(pattern: String) -> NSRegularExpression? {
    do {
        let a = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return a
    } catch _ {
        return nil
    }
}

let contact = ("http://xxxx.com", "xxxx@xxxx.com")
let mailRegex: NSRegularExpression
let siteRegex: NSRegularExpression

mailRegex = (try ~/"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$")!
siteRegex = (try ~/"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$")!

switch contact {
case (siteRegex, mailRegex): print("同时拥有有效的网站和邮箱")
case (_, mailRegex): print("只拥有有效的邮箱")
case (siteRegex, _): print("只拥有有效的网站")
default: print("嘛都没有")
}
// 输出
// 同时拥有网站和邮箱

*/

// -----------------------------

/*
//default 参数
/*
 swift 的方法支持默认参数，可以给某个参数指定一个默认使用的值
 */

func sayHello(str1: String = "Hello", str2: String, str3: String) {
    print(str1 + str2 + str3)
}
sayHello(str2: "", str3: "World")
*/

// -----------------------------

/*
// 多类型和容器
//Array Dictionary Set 他们都是泛型的，也就是说我们在一个集合中只能放同一类型的元素
//要想把不相关的类型放到同一个容器中
let mixed: [Any] = [1, "two", 3] //Any类型可以隐式转换
let objectArray = [1 as NSObject, "Two" as NSObject, 3 as NSObject]
//转换为NSObject, 会造成部分信息的损失，我们从容器中取值时只能得到信息完全丢失后的结果，在使用时还需要进行一次类型转换。
//这其实是在无其他可选方案后的最差选择：因为使用这样的转换的话，编译器就不能再给我们提供警告信息了。
//我们可以随意地将任意对象添加进容器，也可以将容器中取出的值转换为任意类型，这是一件十分危险的事情


//如上面的例子如果我们希望的是打印出容器内的元素的 description，可能我们更倾向于将数组声明为 [CustomStringConvertible] 的：

let mixed2: [CustomStringConvertible] = [1, "two", 3]

for obj in mixed2 {
    print(obj.description)
}
//这种方法虽然也损失了一部分类型信息，但是相对于 Any 或者 AnyObject 还是改善很多，
//在对于对象中存在某种共同特性的情况下无疑是最方便的。另一种做法是使用 enum 可以带有值的特点，
//将类型信息封装到特定的 enum 中。下面的代码封装了 Int 或者 String 类型：

enum IntOrString {
    case IntValue(Int)
    case StringValue(String)
}

let mixed3 = [IntOrString.IntValue(1), IntOrString.StringValue("two"), IntOrString.IntValue(3)]
for value in mixed3 {
    switch value {
    case let .IntValue(i):
        print(i)
    case let .StringValue(s):
        print(s.capitalized)
    }
}
// 1
*/



// -----------------------------

/*
//static 和 class
//在非 class 的类型上下文中，我们统一使用 static 来描述类型作用域。这包括在 enum 和 struct 中表述类型方法和类型属性时。
//在这两个值类型中，我们可以在类型范围内声明并使用存储属性，计算属性和方法


struct PointTest {
    let x: Double
    let y: Double
    
    //存储属性
    static let zero = PointTest(x: 0, y: 0)
    
    //计算属性
    static var ones: [PointTest] {
        return [PointTest(x: 1, y: 1), PointTest(x: -1, y: 1), PointTest(x: 1, y: -1), PointTest(x: -1, y: -1)]
    }
    
    //类型方法
    static func add(p1: PointTest, p2: PointTest) -> PointTest {
        return PointTest(x: p1.x + p2.x, y: p1.y + p2.y)
    }
}

//在Swift 1.2及之后，可以在class中使用 static 来声明一个类作用域的变量
//class MyClass { static var bar: PointTest? }


//如果想在 protocol 里定义一个类型域上的方法或计算属性的话，使用static进行定义。

protocol MyProtocol {
    static func foo() -> String
}

struct MyStruct: MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}

enum MyEnum: MyProtocol {
    static func foo() -> String {
        return "MyEnum"
    }
}

class MyClass: MyProtocol {
    static func foo() -> String {
        return "MyClass"
    }
}
 */

// -----------------------------

/*
//初始化返回nil
/*
 在Swift中默认情况下初始化方法是不能写return语句来返回值的，也就是说我们没有机会初始化一个optional的值。
 
 在 Swift 1.0 及之前
 “使用工厂模式，也就是写一个类方法来生成和返回实例，或者在失败的时候返回 nil。Swift 的 NSURL 就做了这样的处理：
 class func URLWithString(URLString: String!) -> Self!
 使用的时候：
 let url = NSURL.URLWithString("ht tp://swifter。tips")
 print(url)
 // 输出 nil
 不过虽然可以用这种方式来和原来一样返回 nil，但是这也算是一种折衷。在可能的情况下，
 我们还是应该倾向于尽量减少出现 Optional 的可能性，这样更有助于代码的简化。
 
 如果你确实想使用初始化方法而不愿意用工厂函数的话，也可以考虑用一个 Optional 量来存储结果
 这样你就可以处理初始化失败了，不过相应的代价是代码复杂度的增加
 let url: NSURL? = NSURL(string: "ht tp://swifter。tips")
 // nil”
 
 “在 Swift 1.1 中 Apple 已经为我们加上了初始化方法中返回 nil 的能力。
 我们可以在 init 声明时在其后加上一个 ? 或者 ! 来表示初始化失败时可能返回 nil。”
 
 */

let url = NSURL(string: "http://..")
print(url)

extension Int {
    init?(fromString: String) {
        self = 0
        var digit = fromString.count - 1
        for c in fromString {
            var number = 0
            if let n = Int(String(c)) {
                number = n
            } else {
                switch c {
                case "一": number = 1
                case "二": number = 2
                case "三": number = 3
                case "四": number = 4
                default: return nil
                }
            }
            self = self + number * Int(pow(10, Double(digit)))
            digit = digit - 1
        }
    }
}

let number1 = Int(fromString: "1一三4四")
print(number1) // Optional(11344)

let number2 = Int(fromString: "12ab")
print(number2) // nil

//“结果都将是 Int? 类型，通过 Optional Binding，我们就能知道初始化是否成功，并安全地使用它们了
//我们在这类初始化方法中还可以对 self 进行赋值，也算是 init 方法里的特权之一
//“在新版本的 Swift 中，对于可能初始化失败的情况，我们应该始终使用可返回 nil 的初始化方法，而不是类型工厂方法。”
*/

// -----------------------------
/*
//初始化方法顺序，与OC不同Swift的初始化方法需要保证类型的所有属性都被初始化。所以初始化方法的调用顺序很有讲究。
//“在某个类的子类中，初始化方法里语句的顺序并不是随意的，我们需要保证在当前子类实例的成员初始化完成后才能调用父类的初始化方法：

class Cat {
    var name: String
    init() {
        name = "cat"
    }
}

class Tiger: Cat {
    let power: Int
    override init() {
        power = 10
        //super.init()
        //name = "tiger"
        
        // 如果我们不需要打改变 name 的话，
        // 可以不写super.init() 虽然我们没有显式地对 super.init() 进行调用
        // 不过由于这是初始化的最后了，Swift 替我们自动完成了
    }
}


/*
 Swift初始化想要达到安全的目的
 在 Objective-C 中，init 方法是非常不安全的：没有人能保证 init 只被调用一次，
 也没有人保证在初始化方法调用以后实例的各个变量都完成初始化，甚至如果在初始化里使用属性进行设置的话，
 还可能会造成各种问题，虽然 Apple 也明确说明了不应该在 init 中使用属性来访问，
 但是这并不是编译器强制的，因此还是会有很多开发者犯这样的错误。
 
 所以Swift有了超级严格的初始化方法。
 一方面，Swift 强化了 designated 初始化方法的地位。Swift 中不加修饰的 init 方法都需要在方法中
 保证所有非 Optional 的实例变量被赋值初始化，而在子类中也强制 (显式或者隐式地)
 调用 super 版本的 designated 初始化，所以无论如何走何种路径，被初始化的对象总是可以完成完整的初始化的。
*/

class ClassA {
    let numA: Int
    required init(num: Int) {
        numA = num
        //可以对let的实例常量进行赋值，这是初始化方法的重要特点
        //因为Swift的init只可能被调用一次，因此可以为常量进行赋值而不会引起任何线程安全问题
    }
    
    convenience init(bigNum: Bool) {
        self.init(num: bigNum ? 10000 : 1)
    }
}

class ClassB: ClassA {
    let numB: Int
    required init(num: Int) {
        numB = num + 1
        super.init(num: num)
    }
}

/*
 与 designated 初始化方法对应的是在 init 前加上 convenience 关键字的初始化方法。
 这类方法是 Swift 初始化方法中的 “二等公民”，只作为补充和提供使用上的方便。
 所有的 convenience 初始化方法都必须调用同一个类中的 designated 初始化完成设置，
 另外 convenience 的初始化方法是不能被子类重写或者是从子类中以 super 的方式被调用的。
 */

//只要在子类中实现重写了父类convenience方法所需要的init方法的话，我们在子类中就也可以使用父类的convince初始化方法了。
//即使在 ClassB 中没有 bigNum 版本的 convenience init(bigNum: Bool)，我们仍然还是可以用这个方法来完成子类初始化：
let anObj = ClassB(bigNum: true)
// anObj.numA = 10000, anObj.numB = 10001


///初始化方法永远遵循以下两个原则：
//1.初始化路径必须保证对象完全初始化，这可以通过调用本类型的 designated 初始化方法来得到保证；
//2.子类的 designated 初始化方法必须调用父类的 designated 方法，以保证父类也完成初始化。

//对于某些我们希望子类中一定实现的 designated 初始化方法，我们可以通过添加 required 关键字进行限制，
//强制子类对这个方法重写实现。这样做的最大的好处是可以保证依赖于某个 designated 初始化方法的 convenience 一直可以被使用。
//一个现成的例子就是上面的 init(bigNum: Bool)：如果我们希望这个初始化方法对于子类一定可用，
//那么应当将 init(num: Int) 声明为必须，这样我们在子类中调用 init(bigNum: Bool) 时就始终能够找到一条完全初始化的路径了：”
//对于 convenience 的初始化方法，我们也可以加上 required 以确保子类对其进行实现。
//这在要求子类不直接使用父类中的 convenience 初始化方法时会非常有帮助。
*/



// -----------------------------

/*
//可变参函数，可接受人一多个参数的函数，如 stringWithFormat:

func sum(input: Int ...) -> Int {
    return input.reduce(0, +);
}
print(sum(input: 1,2,3)) //6
//输入的 input 在函数体内部将被作为数组 [Int] 来使用


/*
 在其他很多语言中，因为编译器和语言自身语法特性的限制，
 在使用可变参数时往往可变参数只能作为方法中的最后一个参数来使用，
 而不能先声明一个可变参数，然后再声明其他参数。这是很容易理解的，
 因为编译器将不知道输入的参数应该从哪里截断。这个限制在 Swift 中是不存在的，
 因为我们会对方法的参数进行命名，所以我们可以随意地放置可变参数的位置，而不必拘泥于最后一个参数
 
 */
func myFunc(numbers: Int ..., string: String) {
    numbers.forEach {
        for i in 0..<$0 {
            print("\(i+1): \(string)")
        }
    }
}
myFunc(numbers: 1, 2, 3, string: "hello")
//1: hello
//1: hello
//2: hello
//1: hello
//2: hello
//3: hello



/*
 限制自然是有的，比如在同一个方法中只能有一个参数是可变的，比如可变参数都必须是同一种类型的等.当我们想要同时传入多个类型的参数时就需要做一些变通。比如最开始提到的 -stringWithFormat: 方法。可变参数列表的第一个元素是等待格式化的字符串，在 Swift 中这会对应一个 String 类型，而剩下的参数应该可以是对应格式化标准的任意类型。一种解决方法是使用 Any 作为参数类型，然后对接收到的数组的首个元素进行特殊处理。不过因为 Swift 提供了使用下划线 _ 来作为参数的外部标签，来使调用时不再需要加上参数名字。我们可以利用这个特性，在声明方法时就指定第一个参数为一个字符串，然后跟一个匿名的参数列表，这样在写起来的时候就 "好像" 是所有参数都是在同一个参数列表中进行的处理，会好看很多。比如 Swift 的 NSString 格式化的声明就是这样处理的：
 
 extension NSString { convenience init(format: NSString, _ args: CVarArgType...) }
 */
let string = NSString(format: "hello %@. date %@", "Tom", NSDate())
print(string) //hello Tom. date 2018-10-19 01:40:20 +0000

 */

// -----------------------------


/*
//typealias
//typealias是用来为已经存在的类型重新定义名字的，通过命名可以使代码变的更加清晰。

typealias Location = CGPoint
typealias Distance = Double

func distance(from location:Location, to anotherLocation: Location) -> Distance {
    let dx = Distance(location.x - anotherLocation.x)
    let dy = Distance(location.y - anotherLocation.y)
    return sqrt(dx * dx + dy * dy)
}

let origin: Location = Location(x: 0, y: 0)
let point: Location = Location(x: 1, y: 1)

let d: Distance = distance(from: origin, to: point)
print(d) //1.4142135623731

//typealias 是单一的，也就是说你必须指定将某个特定的类型通过 typealias 赋值为新名字，而不能将整个泛型类型进行重命名。

class PersonClass<T> {  }
//错误代码 typealias Worker = PersonClass

//如果我们在别名中也引入泛型，是可以进行对应的：
// This is OK
typealias Worker<T> = PersonClass<T>
//当泛型类型的确定性得到保证后，别名也是可以使用的
typealias WorkId = String
typealias Worker2 = PersonClass<WorkId>


//某个类型同时实现多个协议的组合时。我们可以使用 & 符号连接几个协议，
//然后给它们一个新的更符合上下文的名字，来增强代码可读性：
protocol Cat {  }
protocol Dog {  }
typealias Pat = Cat & Dog






//associatedtype
protocol Food { }
protocol Animal {
    func eat(_ food: Food)
}

struct Meat: Food { }
struct Grass: Food { }

struct Tiger: Animal {
    func eat(_ food: Food) {
        if let meat = food as? Meat {
            print("eat \(meat)")
        } else {
            print("Tiger can only eat meat")
        }
    }
}

let meat = Meat()
Tiger().eat(meat) //eat Meat()
let grass = Grass()
Tiger().eat(grass) //Tiger can only eat meat

//“使用 associatedtype 我们就可以在 Animal 协议中添加一个限定，让 Tiger 来指定食物的具体类型”
protocol Animal2 {
    associatedtype F: Food
    func eat2(_ food: F)
}

struct Tiger2: Animal2 {
    //typealias F = Meat
    func eat2(_ food: Meat) {
        print("eat meat")
    }
}
//“在 Tiger 通过 typealias 具体指定 F 为 Meat 之前，Animal 协议中并不关心 F 的具体类型，
//只需要满足协议的类型中的 F 和 eat 参数一致即可。可以避免在 Tiger 的 eat 中进行判定和转换。
struct Sheep: Animal2 {
    func eat2(_ food: Grass) {
        print("eat grass")
    }
}

//“不过在添加 associatedtype 后，Animal 协议就不能被当作独立的类型使用了”
/*
 错误代码
func isDangerousTest(animal: Animal) -> Bool {
    if animal is Tiger { return true } else { return false }
}
 */
//“因为 Swift 需要在编译时确定所有类型，这里因为 Animal 包含了一个不确定的类型，所以随着 Animal 本身类型的变化，
//其中的 F 将无法确定 (试想一下如果在这个函数内部调用 eat 的情形，你将无法指定 eat 参数的类型)。
//在一个协议加入了像是 associatedtype 或者 Self 的约束后，它将只能被用为泛型约束，而不能作为独立类型的占位使用，
//也失去了动态派发的特性。也就是说，这种情况下，我们需要将函数改写为泛型：

func isDangerous<T: Animal>(animal: T) -> Bool {
    if animal is Tiger {
        return true
    } else {
        return false
    }
}

//isDangerous(animal: Tiger()) //true
//isDangerous(animal: Sheep()) //false

 */

// -----------------------------

/*
//命名空间
/*
 在 Swift 中，由于可以使用命名空间了，即使是名字相同的类型，只要是来自不同的命名空间的话，都是可以和平共处的。
 和 C# 这样的显式在文件中指定命名空间的做法不同，Swift 的命名空间是基于 module 而不是在代码中显式地指明，
 每个 module 代表了 Swift 中的一个命名空间。也就是说，同一个 target 里的类型名称还是不能相同的。
 在我们进行 app 开发时，默认添加到 app 的主 target 的内容都是处于同一个命名空间中的，
 我们可以通过创建 Cocoa (Touch) Framework 的 target 的方法来新建一个 module，
 这样我们就可以在两个不同的 target 中添加同样名字的类型了：

 // MyFramework.swift
 // 这个文件存在于 MyFramework.framework 中
 public class MyClass { public class func hello() { print("hello from framework") } }
 
 // MyApp.swift
 // 这个文件存在于 app 的主 target 中
 class MyClass { class func hello() { print("hello from app") } }
 
 //在使用时，如果出现可能冲突的时候，我们需要在类型名称前面加上 module 的名字 (也就是 target 的名字)：
 MyClass.hello()
 // hello from app
 
 MyFramework.MyClass.hello()
 // hello from framework”
 
 */


//另一种策略是使用类型嵌套的方法来指定访问的范围。常见做法是将名字重复的类型定义到不同的 struct 中，以此避免冲突。
//这样在不使用多个 module 的情况下也能取得隔离同样名字的类型的效果：
struct MyClassContainer1 {
    class MyClass {
        class func hello() {
            print("hello from MyClassContainer1")
        }
    }
}

struct MyClassContainer2 {
    class MyClass {
        class func hello() {
            print("hello from MyClassContainer2")
        }
    }
}
MyClassContainer1.MyClass.hello()
MyClassContainer2.MyClass.hello()

*/

// -----------------------------
/*
 方法嵌套
 “我们可以将方法当作变量或者参数来使用了。更进一步地，我们甚至可以在一个方法中定义新的方法，
 这给代码结构层次和访问级别的控制带来了新的选择。
 
 “我们可以在方法中定义其他方法，也就是说让方法嵌套起来。
 
 */




// -----------------------------

/*
//下标
//想要一下取出数组中几个元素
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set {
            for (index, i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

var array = [0, 1, 2, 3, 4, 5]
var result = array[[0, 2, 4]]
print(result) //[0, 2, 4]
array[[0, 2, 4]] = [-1, -2, -3]
print(array) //[-1, 1, -2, 3, -3, 5]
*/

// -----------------------------

/*
//字面量表达，“像特定的数字，字符串或者是布尔值这样，能够直截了当地指出自己的类型并为变量进行赋值的值”
let array = [1,2,3]
let dictionary = ["key1":"value1", "key2":"value2"]

/*
 那些实现了字面量表达协议的类型，在提供字面量赋值的时候，
 就可以简单地按照协议方法中定义的规则“无缝对应”地通过赋值的方式将值表达为对应类型。
 这些协议包括了各个原生的字面量，在实际开发中我们经常可能用到的有：
 “ExpressibleByArrayLiteral
 ExpressibleByBooleanLiteral
 ExpressibleByDictionaryLiteral
 ExpressibleByFloatLiteral
 ExpressibleByNilLiteral
 ExpressibleByIntegerLiteral
 ExpressibleByStringLiteral”
 
 所有的字面量表达协议都定义了一个 typealias 和对应的 init 方法。拿 ExpressibleByBooleanLiteral 举个例子：
 protocol ExpressibleByBooleanLiteral {
 typealias BooleanLiteralType
 /// Create an instance initialized to `value`.
 init(booleanLiteral value: BooleanLiteralType) }
 
 */
 //在我们需要自己实现一个字面量表达的时候，可以简单地只实现定义的 init 方法就行了。
//举个不太有实际意义的例子，比如我们想实现一个自己的 Bool 类型，可以这么做：
enum MyBool: Int {
    case myTrue, myFalse
}

extension MyBool: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .myTrue : .myFalse
    }
}
let myTrue: MyBool = true
let myFalse: MyBool = false
print(myTrue.rawValue)   // 0
print(myFalse.rawValue)  // 1

//字面量表达是一个很强大的特性，使用得当的话对缩短代码和清晰表意都很有帮助；
//但是这同时又是一个比较隐蔽的特性：因为你的代码并没有显式的赋值或者初始化，所以可能会给人造成迷惑

*/

// -----------------------------

/*
//func 的参数修饰

/*
 func incrementor(variable: Int) -> Int {
    variable += 1
    print(variable)
    return variable
 }
 编译错误
 Left side of mutating operator isn't mutable: 'variable' is a 'let' constant
 因为 Swift 其实是一门讨厌变化的语言。所有有可能的地方，都被默认认为是不可变的，也就是用 let 进行声明的
 这样不仅可以确保安全，也能在编译器的性能优化上更有作为。
 在方法的参数上也是如此，我们不写修饰符的话，默认情况下所有参数都是 let 的

*/
func incrementor(variable: Int) -> Int {
    var num = variable
    num += 1
    return num
}

func incrementor2(variable: inout Int) {
    variable += 1
}
var luckyNumber = 7
incrementor2(variable: &luckyNumber)
print(luckyNumber) //8

//对于值类型来说，inout 相当于在函数内部创建了一个新的值，然后在函数返回时将这个值赋给 & 修饰的变量，这与引用类型的行为是不同的



func makeIncrementor(addNumber: Int) -> (inout Int) -> () {
    func incrementore3(variable: inout Int) -> () {
        variable += addNumber
    }
    return incrementore3
}
let addTwo = makeIncrementor(addNumber: 2)
var num = 8
addTwo(&num)
print(num) //10

*/
// -----------------------------

/*
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

 */

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



