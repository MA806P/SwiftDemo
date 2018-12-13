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

