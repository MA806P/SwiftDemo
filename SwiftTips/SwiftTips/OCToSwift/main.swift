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

