//
//  main.swift
//  SwiftDevelopment
//
//  Created by MA806P on 2019/1/26.
//  Copyright © 2019 myz. All rights reserved.
//

import Foundation

print("Swift 与开发环境及一些实践")

// -----------------------------

//错误和异常处理
/*
 exception error
 OC 中异常往往是程序员的错误导致APP无法继续运行，无法响应某个消息、数组越界等
 NSError 相对来说代表的错误更多的是指那些“合理的”在用户使用App中可能遇到的情况，密码验证不匹配、读取文件发生问题等。
 
 作为某个可能产生错误的方法的使用者，我们用传入 NSErrorPointer 指针的方式来存储错误信息，
 然后在调用完毕后去读取内容，并确认是否发生了错误。
 
 NSError *error;
 BOOL success = [data writeToFile: path options: options error: &error];
 if(error) { // 发生了错误 }
 
 程序员往往为了省事：
 [data writeToFile: path options: options error: nil];
 
 
 在 Swift 2.0 ，Apple 为这门语言引入了异常机制。这类带有 NSError 指针作为参数的 API 都被改为了可以抛出异常的形式。
 
 open func write(toFile path: String, options writeOptionsMask: NSData.WritingOptions) throws
 我们在使用这个 API 的时候，不再像之前那样传入一个 error 指针去等待方法填充，而是变为使用 try catch 语句：
 
 do {
 try d.write(toFile: "Hello", options: [])
 } catch let error as NSError {
 print ("Error: \(error.domain)")
 }
 
 如果你不使用 try 的话，是无法调用 write(toFile:options:) 方法的，它会产生一个编译错误，这让我们无法有意无意地忽视掉这些错误。
 在上面的示例中 catch 将抛出的异常 (这里就是个 NSError) 用 let 进行了类型转换，
 这其实主要是针对 Cocoa 现有的 API 的，是对历史的一种妥协。
 
 对于我们新写的可抛出异常的 API，我们应当抛出一个实现了 Err 协议的类型，enum 就非常合适
 
 
 
 
 */


// -----------------------------

//print 和 debugPrnt
/*
 在定义和实现一个类型的时候，Swift常见做法是先定义最简单的类型结构，然后通过扩展Extension的方式来实现
 众多协议和各种各样的功能。有助于提升功能的可扩展行，OC中也有类似的 protocol+category 的形式，Swift更加简单快捷。
 
 在打印普通对象时，print只能打印出它的类型：
 对于 struct 好一些，会列举出它所有成员的名字和值
 
 “CustomDebugStringConvertible 与 CustomStringConvertible 的作用很类似
 但是仅发生在调试中使用 debugger 来进行打印的时候的输出。
 对于实现了 CustomDebugStringConvertible 协议的类型，
 我们可以在给 meeting 赋值后设置断点并在控制台使用类似 po meeting 的命令进行打印，
 控制台输出将为 CustomDebugStringConvertible 中定义的 debugDescription 返回的字符串。
 
 */

/*
class MyClass {
    var num: Int
    init() {
        num = 1
    }
}

let obj = MyClass()
print(obj) //SwiftDevelopment.MyClass


struct Meeting {
    var date: NSDate
    var place: String
    var attendeName: String
}
let meeting = Meeting(date: NSDate(timeIntervalSinceNow: 3600), place: "会议室", attendeName: "小明")
print(meeting) //Meeting(date: 2019-01-29 02:50:20 +0000, place: "会议室", attendeName: "小明")

//“CustomStringConvertible 协议，这个协议定义了将该类型实例输出时所用的字符串”

extension Meeting: CustomStringConvertible {
    var description: String {
        return "日期：\(self.date) 地点：\(self.place) 人物：\(self.attendeName)"
    }
}
print(meeting) //日期：2019-01-29 02:53:23 +0000 地点：会议室 人物：小明
*/

// -----------------------------

//随机数生成
/*
 arc4random 是一个优秀的随机数算法，并且在 Swift 中也可以使用，返回一个任意整数
 let randomRoll = Int(arc4random()) % 6 + 1
 这段代码在 iPhone5s以上没有问题，但是在 iPhone5或者以下的设备中，有时程序会崩溃
 原因是 Swift 的 Int 是和 CPU 架构有关，在32位的CPU上 iPhone5以前，实际上它是 Int32
 而在 64位 CPU iPhone5s及以后上是 Int64，arc4random 所返回的值不论在什么平台上都是 UInt32
 于是在 32 位的平台上就有一半的几率在进 Int 转换时越界，时不时的崩溃。
 相对安全的做法是是：
 func arc4random_uniform(_: UInt32) -> UInt32
 接受一个 UInt32 的数字 n 作为输入，只要我们的输入不超过 Int 的范围，就可以避免
 
 最佳实践当然是为创建一个 Range 的随机数的方法，这样我们就能在之后很容易地复用，甚至设计类似与 Randomable 这样的协议了：
 */
//let diceFaceCount: UInt32 = 6
//let randomRoll = Int(arc4random_uniform(diceFaceCount)) + 1
//print(randomRoll)


//func random(in range: Range<Int>) -> Int {
//    let count = UInt32(range.endIndex - range.startIndex)
//    return  Int(arc4random_uniform(count)) + range.startIndex
//}
//
//for _ in 0...100 {
//    let range = Range<Int>(1...6)
//    print(random(in: range))
//}



// -----------------------------

// Swift 命令行工具
/*
 Swift 的 REPL Real-Eval-Print Loop 环境可以让我们使用 Swift 进行简单的交互式编程。
 每输入一句语句就立即执行和输出。要启用 REPL 环境就要使用 Swift 的命令行工具，以 xcrun 命令的参数形式存在的。
 xcrun swift
 REPL 环境，其实质还是每次输入代码后进行编译再运行，这限制了我们不能做很复杂的事情。
 
 另一个用法是直接将一个 .swift 文件作为命令行工具的输入，这样里面的代码也会被自动地编译和执行。
 还可以在 .swift 文件最上面加上命令行工具的路径，然后将文件权限改为可执行，之后就可以直接执行这个 .swift 文件了：
 
 #!/usr/bin/env swift
 print("hello")
 // Terminal
 > chmod 755 hello.swift
 > ./hello.swift
 
 // 输出：
 hello
 
 
 Swift 命令行工具，直接脱离 Xcode环境进行编译和生成可执行的二进制文件。
 > swiftc MyClass.swift main.swift
 生成一个 main 的可执行文件，运行
 > ./main
 利用这个方法就可以用Swift写出一些命令行的程序了
 
 
 Swift命令行工具的使用案例是生成汇编级别的代码。swiftc 提供了参数来生成 asm 级别的汇编代码：
 swiftc -OO hello.swift -o hello.asm
 在结合像 Hopper 这样的工具，我们就能了解编译器具体做了什么工作。
 其他功能可使用 swift --help  swiftc --help 来查看
 
 */



