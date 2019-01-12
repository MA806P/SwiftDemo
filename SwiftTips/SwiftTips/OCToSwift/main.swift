//
//  main.swift
//  OCToSwift
//
//  Created by MA806P on 2018/12/1.
//  Copyright © 2018 myz. All rights reserved.
//

import Foundation


print("Hello, World!")


// -----------------------------

//输出格式化
/*
 在 Swift 里，我们在输出时一般使用的 print 中是支持字符串插值的，
 而字符串插值时将直接使用类型的 Streamable，Printable 或者 DebugPrintable 协议
 (按照先后次序，前面的没有实现的话则使用后面的) 中的方法返回的字符串并进行打印。
 这样就可以不借助于占位符，也不用再去记忆类型所对应的字符表示，就能很简单地输出各种类型的字符串描述了。
 
 C 的字符串格式化，在需要以一定格式输出的时候，传统的方式就显得很有用。例如打算只输出小数后两位
 
 */

let a = 3
let b = 1.23456
let c = "abc"
print("int:\(a) double:\(b) string:\(c)")
//int:3 double:1.23456 string:abc

let format = String(format: "%.2lf", b)
print("double:\(format)") //1.23

extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

let f = ".4"
print("double:\(b.format(f))") //1.2346



// -----------------------------

//调用 C 动态库
/*
 OC 是 C 的超级，可以无缝访问 C 的内容，只需要指定依赖并且导入头文件就可以了。
 Swift 不能直接使用 C 代码，之前计算某个字符串的 MD5 以前直接使用 CommonCrypto 中的 CC_MD5 就可以了，
 但是现在因为我们在 Swift 中无法直接写 #import <CommonCrypto/CommonCrypto.h> 这样的代码，
 这些动态库暂时也没有 module 化，因此快捷的方法就只有借助于通过 Objective-C 来进行调用了
 
 暂时建议尽量使用现有的经过时间考验的 C 库，一方面 Swift 还年轻，三方库的引入和依赖机制不很成熟，另外使用动态库至少可以减少APP大小
 
 */



// -----------------------------

//类族
/*
 类族就是使用一个统一的公共类来定制单一的接口，然后在表面之下对应若干个私有类进行实现的方式。
 避免公开很多子类造成混乱，典型的例子 NSNumber
 类族在 OC 中实现起来也很自然，在所谓的 初始化方法 中将 self 进行替换，根据调用的方式或者输入的类型，返回合适的私有子类对象就可以了。
 
 Swift 中有所不同，Swift 有真正的初始化方法，初始化的时候只能得到当前类的实例，并且要完成所有的配置。
 对于公共类，是不可能在初始化方法中返回其子类的信息。Swift中使用工厂方法
 
 */

/*
class Drinking {
    typealias LiquidColor = Int
    
    var color: LiquidColor {
        return 0
    }
    
    class func drinking (name: String) -> Drinking {
        var drinking: Drinking
        switch name {
        case "Coke":
            drinking = Coke()
        case "Beer":
            drinking = Beer()
        default:
            drinking = Drinking()
        }
        return drinking
    }
    
}


class Coke: Drinking {
    override var color: LiquidColor {
        return 1
    }
}

class Beer: Drinking {
    override var color: LiquidColor {
        return 2
    }
}

let coke = Drinking.drinking(name: "Coke")
print(coke.color) //1

let beer = Drinking.drinking(name: "Beer")
print(beer.color) //22

print(NSStringFromClass(type(of: coke))) //OCToSwift.Coke
print(NSStringFromClass(type(of: beer))) //OCToSwift.Beer

*/


// -----------------------------

//哈希
/*
 我需要为判等结果为相同的对象提供相同的哈希值，以保证在被用作字典的 key 是的确定性和性能。
 Swift 中对 NSObject 子类对象使用 == 时要是该子类没有实现这个操作符重载的话将回滚到 -isEqual: 方法。
 对于哈希计算，Swift 也采用了类似的策略，提供了 Hashable 的协议，实现这个协议即可为该类型提供哈希支持：
 protocol Hashable: Equatable { var hashValue: Int { get } }
 
 Swift 的原生 Dictionary 中，key 一定是要实现了的 Hashable 协议的类型。
 像 Int 或者 String 这些 Swift 基础类型，已经实现了这个协议，因此可以用来作为 key 来使用。比如 Int 的 hashValue 就是它本身：
 let num = 19
 print(num.hashValue) // 19
 
 OC 中当对 NSObject 的子类 -isEqual 进行重写的时候，一般也需要将 -hash 方法重写，以提供一个判等为真时返回同样的哈希值的方法
 “在 Swift 中，NSObject 也默认就实现了 Hashable，而且和判等的时候情况类似，
 NSObject 对象的 hashValue 属性的访问将返回其对应的 -hash 的值”
 
 “在 Objective-C 中，对于 NSObject 的子类来说，其实 NSDictionary 的安全性是通过人为来保障的。
 对于那些重写了判等但是没有重写对应的哈希方法的子类，编译器并不能给出实质性的帮助。
 而在 Swift 中，如果你使用非 NSObject 的类型和原生的 Dictionary，并试图将这个类型作为字典的 key 的话，编译器将直接抛出错误。
 从这方面来说，如果我们尽量使用 Swift 的话，安全性将得到大大增加。
 
 关于哈希值，另一个特别需要提出的是，除非我们正在开发一个哈希散列的数据结构，否则我们不应该直接依赖系统所实现的哈希值来做其他操作。
 首先哈希的定义是单向的，对于相等的对象或值，我们可以期待它们拥有相同的哈希，但是反过来并不一定成立。
 其次，某些对象的哈希值有可能随着系统环境或者时间的变化而改变。
 因此你也不应该依赖于哈希值来构建一些需要确定对象唯一性的功能，在绝大部分情况下，你将会得到错误的结果。”
 
 */




// -----------------------------

/*
//判等
/*
 OC 中使用 isEqualToString 进行字符串判等。Swift 使用 ==
 OC 中 == 这个符号意思是判断两个对象是否指向同一块内存地址，更关心的是对象的内容相同，OC 中通常对 isEqual 进行重写
 否则在调用这个方法时会直接使用 == 进行判断
 
 Swift 里的 == 是一个操作符的声明
 protocol Equatable {
 func ==(lhs: Self, rhs: Self) -> Bool
 }
 实现这个协议类型需要定义适合自己类型的 == 操作符，如果认为相等 返回 true
 
 
 */

let str1 = "abc"
let str2 = "abc"
let str3 = "def"
print(str1 == str2) // true
print(str2 == str3) // false


class TodoItem {
    let uuid: String
    var title: String
    
    init(uuid: String, title: String) {
        self.uuid = uuid
        self.title = title
    }
}

extension TodoItem: Equatable {
    
}

//==的实现没有放在对应的 extension 里，而是放在全局的 scope 中，因为你应该需要在全局范围内都能使用 ==
//事实上 Swift 的操作符都是全局的
func ==(lhs: TodoItem, rhs: TodoItem) -> Bool {
    return lhs.uuid == rhs.uuid
}

/*
 对于 NSObject 子类的判等你有两种选择，要么重载 ==，要么重写 -isEqual:。
 如果你只在 Swift 中使用你的类的话，两种方式是等效的；
 但是如果你还需要在 OC 中使用这个类的话，OC 不接受操作符重载，只能使用 -isEqual:，这时你应该考虑使用第二种方式。
 
 对于原来 OC 中使用 == 进行的对象指针的判定，在 Swift 中提供的是另一个操作符 ===。在 Swift 中 === 只有一种重载：
 func ===(lhs: AnyObject?, rhs: AnyObject?) -> Bool
 它用来判断两个 AnyObject 是否是同一个引用。
 
 对于判等，和它紧密相关的一个话题就是哈希。
 重载了判等的话，我们还需要提供一个可靠的哈希算法使得判等的对象在字典中作为 key 时不会发生奇怪的事情。
 
 */

 */


// -----------------------------

// 局部 Scope
/*
 C 系语言方法内部可以任意添加成对 {} 来限定代码的作用范围。
 超过作用域后里面的临时变量就将失效，可使方法内部的命名更加容易，那些不需要的引用的回收提前进行了
 也利于方法的梳理
 
 -(void)loadView {
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
 
 {
 UILabel *titleLabel = [[UILabel alloc]
 initWithFrame:CGRectMake(150, 30, 200, 40)];
 titleLabel.textColor = [UIColor redColor];
 titleLabel.text = @"Title";
 [view addSubview:titleLabel];
 }
 
 {
 UILabel *textLabel = [[UILabel alloc]
 initWithFrame:CGRectMake(150, 80, 200, 40)];
 textLabel.textColor = [UIColor redColor];
 textLabel.text = @"Text";
 [view addSubview:textLabel];
 }
 
 self.view = view;
 }
 “推荐使用局部 scope 将它们分隔开来。比如上面的代码建议加上括号重写为以下形式，
 这样至少编译器会提醒我们一些低级错误，我们也可能更专注于每个代码块”
 

 在 Swift 直接使用大括号的写法是不支持的，这和闭包的定义产生了冲突。想类似的使用局部 scope 来分隔代码的话，
 定义一个接受 ()->() 作为函数的全局方法，然后执行
 
 func local(_ closure: ()->()) { closure() }
 可以利用尾随闭包的特性模拟局部 scope
 
 “override func loadView() {
 let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
 view.backgroundColor = .white
 
 local {
 let titleLabel = UILabel(frame: CGRect(x: 150, y: 30, width: 200, height: 40))
 titleLabel.textColor = .red
 titleLabel.text = "Title"
 view.addSubview(titleLabel)
 }
 
 local {
 let textLabel = UILabel(frame: CGRect(x: 150, y: 80, width: 200, height: 40))
 textLabel.textColor = .red
 textLabel.text = "Text"
 view.addSubview(textLabel)
 }
 
 self.view = view
 }
 
 
 Swift 2.0 中，为了处理异常，Apple 加入了 do 这个关键字来作为捕获异常的作用域。这一功能恰好为我们提供了一个完美的局部作用域
 do { let textLabel = ... }
 
 
 OC 中可使用 GNU 时候C 的声明扩展来限制局部作用域的时候同时进行复制，运用得当的话，可使代码更加紧凑和整洁。
 self.titleLabel = ({
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 20, 40)];
 label.text = @"Title";
 [view addSubview:label];
 label;
 });
 
 
 swift 中可使用匿名的闭包，写出类似的代码：
 let titleLabel: UILabel = {
 let label = UILabel(frame: CGRect(x: 150, y: 30, width: 200, height: 40))
 label.text = "Title"
 return label
 }()
 

 
 */



// -----------------------------

/*
// KeyPath 和 KVO

/*
 “KVO 的目的并不是为当前类的属性提供一个钩子方法，而是为了其他不同实例对当前的某个属性 (严格来说是 keypath)
 进行监听时使用的。其他实例可以充当一个订阅者的角色，当被监听的属性发生变化时，订阅者将得到通知。”
 “像通过监听 model 的值来自动更新 UI 的绑定这样的工作，基本都是基于 KVO 来完成的。”
 
 “在 Swift 中我们也是可以使用 KVO 的，不过 KVO 仅限于在 NSObject 的子类中，因为 KVO 是基于 KVC (Key-Value Coding)
 以及动态派发技术实现的，而这些东西都是 OC 运行时的概念。另外由于 Swift 为了效率，默认禁用了动态派发，
 因此想用 Swift 来实现 KVO，我们还需要做额外的工作，那就是将想要观测的对象标记为 dynamic 和 @objc。”
 */





class MyClass: NSObject {
    @objc dynamic var date = Date()
}

private var myContext = 0

class AnotherClass: NSObject {
    var myObject: MyClass!
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        myObject = MyClass()
        print("初始化 AnotherClass，当前日期: \(myObject.date)")
        
        observation = myObject.observe(\MyClass.date, options: [.new]) { (_, change) in
            if let newDate = change.newValue {
                print("AnotherClass 日期发生变化 \(newDate)")
            }
        }
        
        delayBling(1) { self.myObject.date = Date() }
    }
}
let obj = Class()

//初始化 MyClass，当前日期: 2018-12-29 03:09:13 +0000
//MyClass 日期发生变化 2018-12-29 03:09:17 +0000

*/


// -----------------------------

/*

//自省
/*
 向一个对象发出询问以确定是不是属于某个类，这种操作称为自省。
 OC 中
 [obj1 isKindOfClass:[ClassA class]];
 [obj2 isMemberOfClass:[ClassB class]];
 isKindOfClass: 判断 obj1 是否是 ClassA 或者其子类的实例对象；
 isMemberOfClass: 则对 obj2 做出判断，当且仅当 obj2 的类型为 ClassB 时返回为真。”
 这两个是 NSObject 的方法，在 Swift 中如是 NSObject 的子类的话，可直接使用这两个方法
 
 “首先需要明确的一点是，我们为什么需要在运行时去确定类型。因为有泛型支持，Swift 对类型的推断和记录是完备的。
 因此在绝大多数情况下，我们使用的 Swift 类型都应该是在编译期间就确定的。
 如果在你写的代码中经常需要检查和确定 AnyObject 到底是什么类的话，几乎就意味着你的代码设计出了问题”
 
*/

class ClassA: NSObject { }
class ClassB: ClassA { }

let obj1: NSObject = ClassB()
let obj2: NSObject = ClassB()

print(obj1.isKind(of: ClassA.self))    // true
print(obj2.isMember(of: ClassA.self))  // false

//对于不是 NSObject 的类，怎么确定其类型
class ClassC: NSObject { }
class ClassD: ClassC { }

let obj3: AnyObject = ClassD()
let obj4: AnyObject = ClassD()

print(obj3.isKind(of: ClassC.self))    // true
print(obj4.isMember(of: ClassC.self))  // false

//Swift 提供了一个简洁的写法，可以使用 is 来判断，is 相当于 isKindOfClass
// is 不仅可用于 class 类型上，也可以对 Swift 的其他 struct enum 类型进行判断

if (obj4 is ClassC) {
    print("is ClassC")
}

// 如果编译器能够唯一确定类型，那么 is 的判断就没有必要
//let string = "abc"
//if string is String { print("is string") } // 警告：'is' test is always true

*/

// -----------------------------


/*

//获取对象类型
/*
 “如果遵循规则的话，Swift 会是一门相当安全的语言：不会存在类型的疑惑，绝大多数的内容应该能在编译期间就唯一确定。”
object_getClass 是一个定义在 OC 的 runtime 中的方法
 
 */

let date = NSDate()
let name: AnyClass! = object_getClass(date)
print(name) //some(__NSDate)

let name2 = type(of: date)
print(name2) //__NSDate

let string = "Hello"
let name3 = type(of: string)
print(name3) //String

 */

// -----------------------------

/*
// GCD 和延时调用
/*
 Swift 中抛弃了传统的基于 C 的GCD API，采用了更为先进的书写方式。
 */

//创建目标队列
let workingQueue = DispatchQueue(label: "my_queue")

//派发到刚创建的队列中，GCD进行线程调度
workingQueue.async {
    //在 workingQueue 中异步进行
    print("working")
    Thread.sleep(forTimeInterval: 2) //模拟2s执行时间
    
    DispatchQueue.main.async {
        //返回主线程更新 UI
        print("refresh UI")
    }
}


// GCD 延时调用
let time: TimeInterval = 2.0
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
    print("2 秒后输出")
}
//这里直接程序结束了，参考 SwiftAppTest 例子。封装对象，加上可以取消的功能

*/

// -----------------------------

/*
 “在 C 中有一类指针，你在头文件中无法找到具体的定义，只能拿到类型的名字，而所有的实现细节都是隐藏的。
 这类指针在 C 或 C++ 中被叫做不透明指针 (Opaque Pointer)，顾名思义，它的实现和表意对使用者来说是不透明的。”

 swift 中对应这类不透明指针的类型是 COpaquePointer 用来表示那些在 Swift 中无法进行类型描述的 C 指针，其他的用
 更准确的 UnsafePointer<T> 来存储
 
 “COpaquePointer 在 Swift 中扮演的是指针转换的中间人的角色，我们可以通过这个类型在不同指针类型间进行转换，除非有十足的把握
 知道自己在干什么，否则不要这么做。
 
 另外一种重要指针指向函数的指针，
 在 C 中的函数
 int cFunction(int (callBack)(int x, int y)) { return callBack(1, 2); }
 如果想要在 Swift 中使用这个函数
 
 let callback: @convention(c) (Int32, Int32) -> Int32 = {
 (x, y) -> Int32 in
 return x + y }
 
 let result = cFunction(callback)
 print(result) // 3”

 let result = cFunction {
 (x, y) -> Int32 in return x + y
 }
 
 
*/





// -----------------------------

/*
//UnsafePointer
/*
 Swift 是一门非常安全的语言，所有的引用或者变量的类型都是确定并且正确对应他们得实际类型的，
 应当无法进行任意的类型转换，也不能直接通过指针作出一些出格的事。有助于避免不必要的bug，迅速稳定的
 找出代码错误。在高安全的同时，也丧失了部分的灵活性。
 
 为了与 C 系帝国进行合作，Swift 定义了一套对 C 语言指针的访问和转换方法 UnsafePointer
 “对于使用 C API 时如果遇到接受内存地址作为参数，或者返回是内存地址的情况，在 Swift 里会将它们转为 UnsafePointer<Type> 的类型”
 
 “UnsafePointer，就是 Swift 中专门针对指针的转换。对于其他的 C 中基础类型，在 Swift 中对应的类型都遵循统一的命名规则：
 在前面加上一个字母 C 并将原来的第一个字母大写：比如 int，bool 和 char 的对应类型分别是 CInt，CBool 和 CChar。
 在下面的 C 方法中，我们接受一个 int 的指针，转换到 Swift 里所对应的就是一个 CInt 的 UnsafePointer 类型。
 这里原来的 C API 中已经指明了输入的 num 指针的不可变的 (const)，因此在 Swift 中我们与之对应的是 UnsafePointer 这个不可变版本。
 如果只是一个普通的可变指针的话，我们可以使用 UnsafeMutablePointer 来对应：
 C API           Swift API
 const Type *    UnsafePointer
 Type *          UnsafeMutablePointer”
 
 
 如何在指针的内容和实际的值之间进行转换
 
 */

//C 语言
//void method(const int *num) { printf("%d", *num); }
// int a = 123; method(&a);

//对应的 Swift 方法应该是：
func method(_ num: UnsafePointer<CInt>) {
    print(num.pointee)
}
var a: CInt = 123
method(&a) //123

//func CFArrayGetValueAtIndex(theArray: CFArray!, idx: CFIndex) -> UnsafePointer<Any> { }
//“CFArray 中是可以存放任意对象的，所以这里的返回是一个任意对象的指针，相当于 C 中的 void *。
//这显然不是我们想要的东西。Swift 中为我们提供了一个强制转换的方法 unsafeBitCast，
//通过下面的代码，我们可以看到应当如何使用类似这样的 API，将一个指针强制按位转成所需类型的对象：
let arr = NSArray(object: "meow")
let str = unsafeBitCast(CFArrayGetValueAtIndex(arr, 0), to: CFString.self)
// str = "meow”
//“unsafeBitCast 会将第一个参数的内容按照第二个参数的类型进行转换，而不去关心实际是不是可行，
//这也正是 UnsafePointer 的不安全所在，因为我们不必遵守类型转换的检查，而拥有了在指针层面直接操作内存的机会。”
//“Apple 将直接的指针访问冠以 Unsafe 的前缀，就是提醒我们：这些东西不安全，亲们能不用就别用了吧”




//C 指针内存管理
/*
 C 指针在 Swift 被冠名 unsafe 的另一个原因是无法对其2进行自动的内存管理，需要手动来申请释放内存
 */

class MyClass {
    var a = 1
    deinit {
        print("deinit")
    }
}

var pointer: UnsafeMutablePointer<MyClass>!
pointer = UnsafeMutablePointer<MyClass>.allocate(capacity: 1)
pointer.initialize(to: MyClass())
print(pointer.pointee.a) //1
//pointer = nil //UnsafeMutablePointer 不会自动内存管理，指向的内存没有释放回收，没有调用 deinit
pointer.deinitialize(count: 1)//释放指针指向的内存的对象以及指针自己本身
pointer = nil // deinit

//“手动处理这类指针的内存管理时，我们需要遵循的一个基本原则就是谁创建谁释放。
//deallocate 与 deinitialize 应该要和 allocate 与 initialize 成对出现”
//“如果我们是通过调用了某个方法得到的指针，那么除非文档或者负责这个方法的开发者明确告诉你应该由使用者进行释放，否则都不应该去试图管理它的内存状态：

var x:UnsafeMutablePointer<tm>!
var t = time_t()
time(&t)
x = localtime(&t)
x = nil
//指针的内存申请也可以使用 malloc 或者 calloc 来完成，这种情况下在释放时我们需要对应使用 free 而不是 deallocate。

*/


// -----------------------------

/*

//String 还是 NSString
/*
 像 string 这样的 Swift 类型和 Foundation 的对应的类是可以无缝转换的，使用时怎么选择
 尽可能的使用原生的 string 类型。
 1、虽然有良好的互相转换的特性，但现在 Cocoa所有的API都接受和返回string类型，不必给自己凭空添加麻烦把框架返回的
 字符串做一遍转换
 2、在Swift中String是struct，相比NSString类来说更切合字符串的”不变“这一特性。配合常量赋值let，
 这种不变性在多线程编程就非常重要了。在不触及NSString特有操作和动态特性的时候使用String的方法，在性能上也有所提升。
 3、String 实现了 collection 这样的协议，因此有些 Swift 语法只有 String 才能使用
 
 使用 String 唯一一个比较麻烦的地方是 它和 Range 的配合
 
 
 */


let levels = "ABCDEF"
for i in levels {
    print(i)
}

var a = levels.contains("CD")
print(a)


//报错：Argument type 'NSRange' (aka '_NSRange') does not conform to expected type 'RangeExpression'
//let nsRange = NSMakeRange(1, 4)
//levels.replacingCharacters(in: nsRange, with: "XXXX")

let indexPositionOne = levels.index(levels.startIndex, offsetBy: 1)
let swiftRange = indexPositionOne ..< levels.index(levels.startIndex, offsetBy: 5)
let replaceString = levels.replacingCharacters(in: swiftRange, with: "XXXX")
print(replaceString) //AXXXXF

//可能更愿意和基于 Int 的 Range 一起工作，而不喜欢用麻烦的 Range<String.Index>
let nsRange = NSMakeRange(1, 4)
let nsReplaceString = (levels as NSString).replacingCharacters(in: nsRange, with: "ZZZZ")
print(nsReplaceString) // AZZZZF
 
 */

// -----------------------------


/*

//值类型和引用类型
/*
 Swift 的类型分为值类型和引用类型，值类型在传递和赋值时将进行赋值，引用类型则只会使用引用对象的一个”指向“。
 struct enum 定义的类型是值类型，使用 class 定义的为引用类型。
 Swift 中所有的内建类型都是值类型，Int String Array Dictionary 都是值类型
 
 值类型的好处，减少了堆上内存分配和回收的次数。值类型的一个特点是在传递和赋值时进行复制，
 每次复制肯定会产生额外开销，但是在 Swift 中这个消耗被控制在了最小范围内，
 在没有必要复制的时候，值类型的复制都是不会发生的。也就是说，简单的赋值，参数的传递等等普通操作，
 虽然我们可能用不同的名字来回设置和传递值类型，但是在内存上它们都是同一块内容。”
 
 将数组字典设计为值类型最大的考虑是为了线程安全，在数目较少时，非常高效
 在数目较多时 Swift 内建的值类型的容器类型在每次操作时都需要复制一遍，
 即使是存储的都是引用类型，在复制时我们还是需要存储大量的引用
 
 “在需要处理大量数据并且频繁操作 (增减) 其中元素时，选择 NSMutableArray 和 NSMutableDictionary 会更好，
 而对于容器内条目小而容器本身数目多的情况，应该使用 Swift 语言内建的 Array 和 Dictionary。”
 
 
 
 */


func test(_ arr:[Int]) {
    print(arr)
    for i in arr {
        print(i)
    }
}

var a = [1,2,3]
var b = a
test(a)
//在物理内存上都是用一个东西，而且 a 还只在栈空间上，只是发生了指针移动，完全没有堆内存的分配和释放问题，效率高
//当对值进行改变时，值复制就是必须的了
b.append(4) //b 和 a 内存地址不再相同。将其中的值类型进行复制，对于引用类型的话，只复制一份引用

class MyObject {
    var num = 0
}

var myObject = MyObject()
var arr1 = [myObject]
var arr2 = arr1

arr2.append(myObject)

myObject.num = 123
print(arr1[0].num) //123
print(arr2[0].num) //123

*/



// -----------------------------

// @autoreleasepool
/*
 swift 在内存管理上使用 ARC 的一套方法，不需要手动的调用 retain, release, autorelease 来管理引用计数
 编译器在编译时在合适的地方帮我们加入。
 autorelease 会将接收改消息的对象放到 auto release pool 中，当 autoreleasepool 收到 drain 消息时，将这些对象引用计数-1
 然后从池子中移除。
 
 “在 app 中，整个主线程其实是跑在一个自动释放池里的，并且在每个主 Runloop 结束时进行 drain 操作”
 “因为我们有时候需要确保在方法内部初始化的生成的对象在被返回后别人还能使用，而不是立即被释放掉。”
 OC 中使用 @autoreleasepool 就行了，其实 @autoreleasepool 在编译时会被展开为 NSAutoreleasePool 并附带 drain 方法的调用。
 

Swift 中我们也是能使用 autoreleasepool 的 -- 虽然语法上略有不同。
 相比于原来在 Objective-C 中的关键字，现在它变成了一个接受闭包的方法：

func autoreleasepool(code: () -> ())
利用尾随闭包的写法，很容易就能在 Swift 中加入一个类似的自动释放池了：

func loadBigData() {
    if let path = NSBundle.mainBundle()
        .pathForResource("big", ofType: "jpg") {
        
        for i in 1...10000 {
            autoreleasepool {
                let data = NSData.dataWithContentsOfFile(
                    path, options: nil, error: nil)
                
                NSThread.sleepForTimeInterval(0.5)
            }
        }
    }
}
 上面的代码是 Swift 1.0 的，NSData.dataWithContentsOfFile 仅供参考
 */

// -----------------------------

/*

//内存管理 weak 和 unowned
//Swift 是自动管理内存的，遵循自动引用计数 ARC


/*
 1、循环引用
 防止循环引用，不希望互相持有, weak 向编译器说明不希望持有
 除了 weak 还有 unowned。类比 OC unowned 更像是 unsafe_unretained
 unowned 设置后即使他引用的内容已经被释放了，他仍会保持对被已经释放了的对象的一个无效引用，他不能是 Optional 值
 也不会指向 nil，当调用这个引用的方法时，程序崩溃。weak 则友好一点，在引用的内容被释放后，会自动变为nil，因此标记为 weak 的变量
 一定需要是 Optional 值。
 “Apple 给我们的建议是如果能够确定在访问时不会已被释放的话，尽量使用 unowned，如果存在被释放的可能，那就选择用 weak
 “日常工作中一般使用弱引用的最常见的场景有两个：
 设置 delegate 时
 在 self 属性存储为闭包时，其中拥有对 self 引用时”
 
 
 闭包和循环引用
 “闭包中对任何其他元素的引用都是会被闭包自动持有的。如果我们在闭包中写了 self 这样的东西的话，那我们其实也就在闭包内持有了当前的对象。
 如果当前的实例直接或者间接地对这个闭包又有引用的话，就形成了一个 self -> 闭包 -> self 的循环引用”
 
 
 
 
*/

class A: NSObject {
    let b: B
    
    override init() {
        b = B()
        super.init()
        b.a = self
    }
    
    deinit {
        print("A deinit")
    }
}

class B: NSObject {
    
    weak var a: A? = nil
    
    deinit {
        print("B deinit")
    }
}

var obj: A? = A()
obj = nil //内存没有释放



//闭包
class Person {
    let name: String
    lazy var printName: ()->() = {
        //如可以确定在整个过程中self不会被释放，weak 可以改为 unowned 就不需要 strongSelf 的判断
        [weak self] in
        if let strongSelf = self {
            print("The name is \(strongSelf.name)")
        }
        
        //如果需要标注的元素有多个
        // { [unowned self, weak someObject] (number: Int) -> Bool in .. return true}
    }
    
    init(personName: String) {
        name = personName
    }
    
    deinit {
        print("Person deinit \(self.name)")
    }
}

var xiaoMing : Person? = Person(personName: "XiaoMing")
xiaoMing!.printName() //The name is XiaoMing
xiaoMing = nil //Person deinit XiaoMing

 */

// -----------------------------

/*
//可扩展协议和协议扩展
/*
 OC 中 protocol @optional 修饰的方法，并非必须要实现
 原生的 Swift protocol 里没有可选项，所有定义的方法都是必须实现的，要想实现需要将协议本身可选方法都定义为 OC 的
 “使用 @objc 修饰的 protocol 就只能被 class 实现了，
 对于 struct 和 enum 类型，我们是无法令它们所实现的协议中含有可选方法或者属性的”
 
 “在 Swift 2.0 中，可使用 protocol extension。
 我们可以在声明一个 protocol 之后再用 extension 的方式给出部分方法默认的实现。这样这些方法在实际的类中就是可选实现的了”
 
 
 */

@objc protocol OptionalProtocol {
    @objc optional func optionalMethod()
    func protocolMethod()
    @objc optional func anotherOptionalMethod()
}



protocol NormalProtocol {
    func optionalNormalProtocolMethod()
    func necessaryNormalProtocolMethod()
}

extension NormalProtocol {
    func optionalNormalProtocolMethod() {
        print("optionalNormalProtocolMethod")
    }
}

//报错：Non-class type 'MyStruct' cannot conform to class protocol 'OptionalProtocol'
//struct MyStruct: OptionalProtocol {}

class MyClass: OptionalProtocol, NormalProtocol {
    func necessaryNormalProtocolMethod() {
        print("MyClass optionalNormalProtocolMethod")
    }
    
    func protocolMethod() {
        print("MyClass protocolMethod")
    }
    
    
}

let myClass = MyClass()
myClass.optionalNormalProtocolMethod() //optionalNormalProtocolMethod

 */

// -----------------------------

// @objc 和 dynamic
/*
 最初的 Swift 版本中，不得不考虑与 OC 的兼容，允许同一个项目中使用 Swift 和 OC 进行开发
 其实文件是处于两个不同世界中，为了能互相联通，需要添加一些桥梁。
 
 “首先通过添加 {product-module-name}-Bridging-Header.h 文件，并在其中填写想要使用的头文件名称，
 我们就可以很容易地在 Swift 中使用 Objective-C 代码了”
 
 “如果想要在 Objective-C 中使用 Swift 的类型的时候，事情就复杂一些。如果是来自外部的框架，
 那么这个框架与 Objective-C 项目肯定不是处在同一个 target 中的，我们需要对外部的 Swift module 进行导入。
 这个其实和使用 Objective-C 的原来的 Framework 是一样的，对于一个项目来说，外界框架是由 Swift 写的还是 Objective-C 写的，
 两者并没有太大区别。我们通过使用 2013 年新引入的 @import 来引入 module：
 @import MySwiftKit;
 之后就可以正常使用这个 Swift 写的框架了。”
 
 
 “如果想要在 Objective-C 里使用的是同一个项目中的 Swift 的源文件的话，可以直接导入自动生成的头文件
 {product-module-name}-Swift.h 来完成。比如项目的 target 叫做 MyApp 的话，我们就需要在 Objective-C 文件中写
 #import "MyApp-Swift.h”
 
 
 “Objective-C 和 Swift 在底层使用的是两套完全不同的机制，Cocoa 中的 Objective-C 对象是基于运行时的，
 它从骨子里遵循了 KVC (Key-Value Coding，通过类似字典的方式存储对象信息) 以及动态派发 (Dynamic Dispatch，
 在运行调用时再决定实际调用的具体实现)。而 Swift 为了追求性能，如果没有特殊需要的话，
 是不会在运行时再来决定这些的。也就是说，Swift 类型的成员或者方法在编译时就已经决定，而运行时便不再需要经过一次查找，而可以直接使用。”
 
 
 “这带来的问题是如果我们要使用 Objective-C 的代码或者特性来调用纯 Swift 的类型时候，我们会因为找不到所需要的这些运行时信息，而导致失败。
 解决起来也很简单，在 Swift 类型文件中，我们可以将需要暴露给 Objective-C 使用的任何地方 (包括类，属性和方法等) 的声明前面加上 @objc 修饰符。
 注意这个步骤只需要对那些不是继承自 NSObject 的类型进行，如果你用 Swift 写的 class 是继承自 NSObject 的话，
 Swift 会默认自动为所有的非 private 的类和成员加上 @objc。这就是说，对一个 NSObject 的子类，
 你只需要导入相应的头文件就可以在 Objective-C 里使用这个类了。”
 
 
 “@objc 修饰符的另一个作用是为 Objective-C 侧重新声明方法或者变量的名字。虽然绝大部分时候自动转换的方法名已经足够好用
 (比如会将 Swift 中类似 init(name: String) 的方法转换成 -initWithName:(NSString *)name 这样)”
 
 
 
 
 */


// -----------------------------

//UIApplicationMain
//Cocoa开发环境已经在新建一个项目时帮助我们进行很多配置，导致很多人无法说清一个App启动的流程
/*
 C系语言中程序的入口都是main函数
 int main(int argc, char * argv[]) {
    @autoreleasepool { return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); } }
 
 UIApplicationMain 根据第三个参数初始化一个 UIAppliction 或者其子类对象 传nil就是用默认的UIAppliction，然后开始接收事件
 AppDelegate 作为应用委托，用来接收与应用生命周期相关的委托方法。
 “虽然这个方法标明为返回一个 int，但是其实它并不会真正返回。它会一直存在于内存中，直到用户或者系统将其强制终止。”
 Swift 项目中在默认的 AppDelegate 只有一个 @UIApplicationMain 的标签，这个标签做的事情就是将被标注的类作为委托，
 去创建一个 UIApplication 并启动整个程序。在编译的时候，编译器将寻找这个标记的类，并自动插入像 main 函数这样的模板代码。
 
 和 C 系语言的 main.c 或者 main.m 文件一样，Swift 项目也可以有一个名为 main.swift 特殊的文件。
 在这个文件中，我们不需要定义作用域，而可以直接书写代码。这个文件中的代码将作为 main 函数来执行。
 比如我们在删除 @UIApplicationMain 后，在项目中添加一个 main.swift 文件，然后加上这样的代码：
 UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(AppDelegate))
 现在编译运行，就不会再出现错误了。
 
 我们还可以通过将第三个参数替换成自己的 UIApplication 子类，这样我们就可以轻易地做一些控制整个应用行为的事情了。
 比如将 main.swift 的内容换成：
 
 import UIKit
 
 class MyApplication: UIApplication {
 override func sendEvent(event: UIEvent!) {
 super.sendEvent(event)
 print("Event sent: \(event)");
 }
 }
 
 UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(MyApplication), NSStringFromClass(AppDelegate))
 这样每次发送事件 (比如点击按钮) 时，我们都可以监听到这个事件了。
 
 
 
*/




// -----------------------------

//编译标记
//在 OC 中在代码中插入 #pragma 来标记代码区间，方便代码定位
//在 Swift 中使用 // MARK:-
// TODO: 123
// FIXME: 455
//上面两个用来提示还未完成的工作或者需要修正的地方。

// MARK: - 123

// -----------------------------

/*
//条件编译
/*
 C系语言中，使用 #if #ifdef 编译条件分支来控制哪些代码需要编译。
 Swift 中 #if 这套编译标记还是存在的，使用的语法也和原来没有区别
 #if <condition>
 #elseif <condition>
 #else
 #endif
 condition 并不是任意的，Swift 内建了几种平台和架构的组合，来帮助我们为不同的平台编译不同的代码。
 
 */

//os(macOS) iOS tvOS watchOS Linux
//arch() arm(32位CPU真机) arm64(64位CPU真机)  i386(32为模拟器)  x86_64(64位22CPU模拟器)
//swift()  >=某个版本

#if os(macOS)

#else

#endif



//另一种方式是对自定义的符号进行条件编译，比如我们需要使用同一个 target 完成同一个 app 的收费版和免费版两个版本，
//并且希望在点击某个按钮时收费版本执行功能，而免费版本弹出提示的话，可以使用类似下面的方法：
 
 @IBAction func someButtonPressed(sender: AnyObject!) {
 #if FREE_VERSION
 // 弹出购买提示，导航至商店等
 #else
 // 实际功能
 #endif
 }
 //在这里我们用 FREE_VERSION 这个编译符号来代表免费版本。
//为了使之有效，我们需要在项目的编译选项中进行设置，在项目的 Build Settings 中，
//找到 Swift Compiler - Custom Flags，并在其中的 Other Swift Flags 加上 -D FREE_VERSION 就可以了。”
 
 
*/


// -----------------------------

/*
//单例
/*
 OC中公认的单列写法
 + (id)sharedManager {
 static MyManager * staticInstance = nil;
 static dispatch_once_t onceToken;
 
 dispatch_once(&onceToken, ^{
 staticInstance = [[self alloc] init];
 });
 return staticInstance;
 }

 在 Swift 3 中 Apple 移除了 dispatch_once
 Swift 中使用 let 简单的方法来保证线程安全
 在 Swift 1.2 后，可以使用类变量
 */

class MyManager {
    class var shared: MyManager {
        struct Static {
            static let shareInstance : MyManager = MyManager()
        }
        return Static.shareInstance
    }
}


/*
//由于 Swift 1.2 之前 class 不支持存储式的 property，我们想要使用一个只存在一份的属性时，
//就只能将其定义在全局的 scope 中。值得庆幸的是，在 Swift 中是有访问级别的控制的，
//我们可以在变量定义前面加上 private 关键字，使这个变量只在当前文件中可以被访问。”

private let sharedInstance = MyManager()
class MyManager {
    class shared: MyManager {
        return sharedInstance
    }
}
*/

//在 Swift 1.2 以及之后，如没有特别需求，推荐使用
class MyManager1 {
    static let shared = MyManager1()
    private init() {
        
    }
}
/*
 “这种写法不仅简洁，而且保证了单例的独一无二。在初始化类变量的时候，Apple 将会把这个初始化包装在一次 swift_once_block_invoke 中，
 以保证它的唯一性。不仅如此，对于所有的全局变量，Apple 都会在底层使用这个类似 dispatch_once 的方式来确保只以 lazy 的方式初始化一次。”
 
 “我们在这个类型中加入了一个私有的初始化方法，来覆盖默认的公开初始化方法，
 这让项目中的其他地方不能够通过 init 来生成自己的 MyManager 实例，也保证了类型单例的唯一性。
 如果你需要的是类似 default 的形式的单例 (也就是说这个类的使用者可以创建自己的实例) 的话，可以去掉这个私有的 init 方法。”
 
 */


 */
 
// -----------------------------

//实例方法的动态调用

/*
/*
 可以让我们不直接使用实例来调用这个实例上的方法，通过类型取出这个类型的实例方法的签名
 然后再通过传递实例来拿到实际需要调用的方法。
 这种方法只适用于实例方法，对于属性的 getter setter 是不能用类似的写法
 */

class MyClass {
    func method(number: Int) -> Int {
        return number + 1
    }
    
    class func method(number: Int) -> Int {
        return number + 1
    }
}

let f = MyClass.method //let f: (MyClass) -> (Int) -> Int // let f = { (obj: MyClass) in obj.method}
let object = MyClass()
//let result = f(object)(1)

//如果遇到有类型方法的名字冲突时，如不改动 MyClass.method 将取到的是类型方法
//“如果我们想要取实例方法的话，可以显式地加上类型声明加以区别
let f1 = MyClass.method // class func method 的版本
let f2: (Int) -> Int = MyClass.method // 和 f1 相同
let f3: (MyClass) -> (Int) -> Int = MyClass.method // func method 的柯里化版本”
*/



// -----------------------------

//Selector
/*
 @selector 是 OC 时代的一个关键字 可以将一个方法转换并赋值给一个 SEL 类型，类似一个动态的函数指针。
 -(void) callMeWithParam:(id)obj { }
 SEL anotherMethod = @selector(callMeWithParam:);
 // 或者也可以使用 NSSelectorFromString
 // SEL anotherMethod = NSSelectorFromString(@"callMeWithParam:");”
 
 在 Swift 中没有 @selector 了，取而代之，从 Swift 2.2 开始我们使用 #selector 来从暴露给 Objective-C 的代码中获取一个 selector。
 类似地，在 Swift 里对应原来 SEL 的类型是一个叫做 Selector 的结构体。像上面的两个例子在 Swift 中等效的写法是：
 
 @objc func callMeWithParam(obj: AnyObject!) { }
 let anotherMethod = #selector(callMeWithParam(obj:))
 
 
 “在 Swift 4 中，默认情况下所有的 Swift 方法在 Objective-C 中都是不可见的，
 所以你需要在这类方法前面加上 @objc 关键字，将这个方法暴露给 Objective-C，才能进行使用。”
 “如果想让整个类型在 Objective-C 可用，可以在类型前添加 @objcMembers。”
 
 

 */

