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

//实例方法的动态调用
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

let f = MyClass.method //let f: (MyClass) -> (Int) -> Int
// let f = { (obj: MyClass) in obj.method}
let object = MyClass()
//let result = f(object)(1)

//如果遇到有类型方法的名字冲突时，如不改动 MyClass.method 将取到的是类型方法
//“如果我们想要取实例方法的话，可以显式地加上类型声明加以区别
let f1 = MyClass.method // class func method 的版本
let f2: (Int) -> Int = MyClass.method // 和 f1 相同
let f3: (MyClass) -> (Int) -> Int = MyClass.method // func method 的柯里化版本”


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

