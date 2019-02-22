//
//  main.swift
//  SwiftDevelopment
//
//  Created by MA806P on 2019/1/26.
//  Copyright © 2019 myz. All rights reserved.
//

import Foundation


//import HelloTest

print("Swift 与开发环境及一些实践")

// -----------------------------

//性能考虑
/*
 “相比于 Objective-C，Swift 最大的改变就在于方法调用上的优化。在 Objective-C 中，
 所有的对于 NSObject 的方法调用在编译时会被转为 objc_msgSend 方法。
 这个方法运用 Objective-C 的运行时特性，使用派发的方式在运行时对方法进行查找。
 因为 Objective-C 的类型并不是编译时确定的，我们在代码中所写的类型不过只是向编译器的一种“建议”，不论对于怎样的方法，这种查找的代价基本都是同样的。”
 
 “Objective-C 运行时十分高效，相比于 I/O 这样的操作来说，单次的方法派发和查找并不会花费太多的时间，
 但实事求是地说，这确实也是 Objective-C 性能上可以改进的地方，这种改善在短时间内大量方法调用时会比较明显。”
 
 
 “Swift 因为使用了更安全和严格的类型，如果我们在编写代码中指明了某个实际的类型的话 (注意，需要的是实际具体的类型，而不是像 Any 这样的抽象的协议)，
 我们就可以向编译器保证在运行时该对象一定属于被声明的类型。这对编译器进行代码优化来说是非常有帮助的，
 因为有了更多更明确的类型信息，编译器就可以在类型中处理多态时建立虚函数表 (vtable)，这是一个带有索引的保存了方法所在位置的数组。
 在方法调用时，与原来动态派发和查找方法不同，现在只需要通过索引就可以直接拿到方法并进行调用了，这是实实在在的性能提升。”
 
 
 “如果遇到性能敏感和关键的代码部分，我们最好避免使用 Objective-C 和 NSObject 的子类。
 在以前我们可能会选择使用混编一些 C 或者 C++ 代码来处理这些关键部分，而现在我们多了 Swift 这个选项。
 相比起 C 或者 C++，Swift 的语言特性上要先进得多，而使用 Swift 类型和标准库进行编码和构建的难度，比起使用 C 或 C++ 来要简单太多。
 另外，即使不是性能关键部分，我们也应该尽量考虑在没有必要时减少使用 NSObject 和它的子类。
 如果没有动态特性的需求的话，保持在 Swift 基本类型中会让我们得到更多的性能提升。”
 
 
 
 */


//文档注释

/**
 A demo method
 - parameter input: An Int number
 - returns: The string represents the input number
 */
func method(input: Int) -> String {
    return String(input)
}
/*
 使用 option + 单击 可以看到 Xcode 格式化后的 Quick Help 对话框
 https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497
 手写 -parameter 或者 -returns 这样的东西是非常浪费时间的，
 Xcode 8 中自带了注释文档生成的工具，你可以在想要添加注释的方法或者属性上方使用快捷键 (默认是 Alt + Cmd + /)，
 它就能够帮助你快速并且自动地生成符合格式的文档注释模板
 
*/


// -----------------------------

// JSON 和 Codable

/*

/*
 // jsonString
 {"menu": {
    "id": "file",
    "value": "File",
    "popup": {
        "menuitem": [
            {"value": "New", "onclick": "CreateNewDoc()"},
            {"value": "Open", "onclick": "OpenDoc()"},
            {"value": "Close", "onclick": "CloseDoc()"}
        ]
    }
 }
 }
 
 
 */

 let jsonString = "{\"menu\": {\"id\": \"file\",\"value\": \"File\",\"popup\": {\"menuitem\": [ {\"value\": \"New\", \"onclick\":\"CreateNewDoc()\"},{\"value\":\"Open\", \"onclick\": \"OpenDoc()\"},{\"value\": \"Close\", \"onclick\": \"CloseDoc()\"}]}}}"

let json: Any = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8, allowLossyConversion: true)!, options: [])

// 在 Swift 4 之前处理json很麻烦，因为 Swift 对于类型的要求非常严格
if let jsonDic = json as? NSDictionary {
    if let menu = jsonDic["menu"] as? [String: Any] {
        if let popup: Any = menu["popup"] {
            if let popupDic = popup as? [String: Any] {
                if let menuitems = popupDic["menuitem"] {
                    if let menuitemArr = menuitems as? [Any] {
                        print(menuitemArr.count)
                        //...
                    }
                }
            }
        }
    }
}

/*
 Swift 4 中新加入了 Codable 协议，用来处理数据的序列化和反序列化
 利用内置的 JSONEncoder 和 JSONDecoder，在对象实例和 JSON 表现之间进行转换变得非常简单
 
 只要一个类型中所有的成员都实现了 Codable ，那么这个类型也就可以自动满足 Codable 的要求。
 Swift 标准库中 String Int Double Date URL 这样的类型是默认就实现了 Codable，可以基于这些常见类型来构建更复杂的 Codable 类型
 
 如果 JSON 中的 key 和类型中的变量名不一致的话，还需要在对应类中声明 CodingKeys 枚举，并用合适的键值覆盖对应的默认值
 下面例子中 menuitem onclick 就是这种情况
*/

//处理上面的 JSON 创建一系列对应类型，并声明他们实现 Codable
struct Obj: Codable {
    let menu: Menu
    struct Menu: Codable {
        let id: String
        let value: String
        let popup: Popup
    }
}

struct Popup: Codable {
    let menuItem: [MenuItem]
    enum CodingKeys: String, CodingKey {
        case menuItem = "menuitem"
    }
}

struct MenuItem: Codable {
    let value: String
    let onClick: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case onClick = "onclick"
    }
}

let data = jsonString.data(using: .utf8)!
do {
    let obj = try JSONDecoder().decode(Obj.self, from: data)
    let value = obj.menu.popup.menuItem[0].value
    print("成功: value = \(value)")
} catch {
    print("出错啦：\(error)")
}


//NSNull
/*
 OC 中 NSDictionary NSArray 只能储存对象，对于像 JSON 中可能存在的 null 值，就只能用 NSNull 对象来表示
 在处理 JSON 时，NSNull 无法使用像 nil 那样对所有方法都相应的特性。
 因为 Objective-C 是没有强制的类型检查的，我们可以任意向一个对象发送任何消息，
 这就导致如果 JSON 对象中存在 null 时的话，对其映射为的 NSNull 直接发送消息时，app 将发生崩溃。
 
 在 OC 中，我们一般通过严密的判断来解决这个问题：
 1、在每次发送消息的时候都进行类型检查，以确保将要接收消息的对象不是 NSNull 的对象。
 2、另一种方法是添加 NSNull 的 category 让它响应各种常见的方法 如[obj integerValue] 并返回默认值
 前一种过于麻烦，后一种难免有疏漏。
 
 在 Swift 中这个问题被语言的特性彻底解决了，因为 Swift 所有强调的就是类型安全，无论怎么说都需要一层转换
 除非我们故意不去将 AnyObject 转换为我们需要的类型，否则我们绝对不会错误的向一个 NSNull 发送消息
 NSNull 会默默地被通过 Optional Binding 被转换为 nil，从而避免被执行：
 */

let jsonValue: AnyObject = NSNull() //假设 jsonValue 是从一个 JSON 中取出的 NSNull
if let str = jsonValue as? String {
    print(str.hasPrefix("a"))
} else {
    print("不能解析")
}
*/


// -----------------------------

/*
//数学和数字
/*
 Drawin 里的 math.h 定义了很多和数学相关的内容。在 Swift 中也被进行了 module 映射，因此在 Swift 中可以直接使用。
 
 除了导入了 math.h 的内容外，Swift 也在标准库中对极限情况的数字做了约定：
 Int.max  Int.min 取对应平台的 Int 的最大最小值
 Double.infinity 代表无穷，类似 1.0、0.0 代表数学意义上的无限大
 Double.nan - Not a Number 用来表示某些未被定义的或者出现了错误的运算
 */

func circlePerimeter(radius: Double) -> Double {
    return 2 * Double.pi * radius
}

func yPosition(dy: Double, angle: Double) -> Double {
    return dy * tan(angle)
}
*/

// -----------------------------

//Playground 延时运行
/*
 Playground 提供了一个顺序执行的环境，每次更改其中代码后整个文件会被重新编译，并清空原来的状态并运行。
 
 class MyClass { @objc func callMe() {print("Hi")} }
 let object = MyClass()
 Timer.scheduledTimer(timeInterval: 1, target: object, selector: #selector(MyClass.callMe), userInfo: nil, repeats: true)
 
 执行完 Timer 语句之后，整个 Playground 将停止掉，Hi 永远不会被打印出来
 
 为了使 Playground 有延时运行功能，引入扩展包 PlaygroundSupport 框架
 import PlaygroundSupport
 PlaygroundPage.current.needsIndefiniteExecution = true
 
 延时运行是有限度的，计数会停在30次，默认会在顶层代码最后一句运行后30秒的时候停止执行
 要想改变 Alt+cmd+回车，打开辅助编辑器 设定
 
 
 */

// Playground 与项目协作
//“Playground 其实是可以用在项目里的，通过配置，我们是可以做到让 Playground 使用项目中已有的代码的。”


// Playground 可视化开发
/*
 Playground 是支持直接运行 UI 代码并在集成环境中显示 UI，并允许用户进行交互的。
 将想要显示的 UIView 子类赋值给当前 PlaygroundPage 的 liveView 属性，
 并且打开 Assistant Editor (option + Shift + Command + Return)，就能看到我们创建的视图了
 
 import UIKit
 import PlaygroundSupport
 PlaygroundPage.current.liveView = label
 
 liveView，它其实接受的是任意满足 PlaygroundLiveViewable 协议的属性。
 而 PlaygroundLiveViewable 本身需要返回一个 PlaygroundLiveViewRepresentation。
 在 PlaygroundSupport 中，UIView 和 UIViewController 都实现了这个协议。
 我们不仅能够在 Playground 中显示一个单独的 view，也能够将一个 View Controller 实例赋值给 liveView，并与其进行交互
 
 
 */


// -----------------------------

//安全的资源组织方式
/*
 很多使用字符串来指定某个资源的用法，例通过项目中图片名字来生成 UIImage 对象：
 let image = UIImage(name: "my_image")
 
 这种方法存在隐患，如果资源名称发生改变，必须在代码中作出相应的改变
 在 OC 时代，我们一般通过宏定义来缓解在这个问题，通过将资源名字设置为宏定义，就可以在相对集中的地方来管理和修改。
 但这样并没有从本质上解决资源名字改变给我们带来的困扰。在 Swift 中没有宏定义，取而代之，可以灵活使用 rawValue
 为 String 的 enum 类型。通过为资源类型添加合适的 Extension 来让编译器帮助我们在资源名称修改时能在代码中做对应的改变
 
 
 enum ImageName: String { case myImage = "my_image" }
 extension UIImage {
    convenience init!(imageName: ImageName) { self.init(named: imageName.rawValue) }
 }
 使用时就可以直接用 extension 中的类型安全版本：
 let image = UIImage(imageName: .myImage)
 
 */





// -----------------------------

//代码组织和 Framework

/*
 为了 iOS 平台安全，不允许动态链接非系统的框架，在App开发中使用的第三方框架如果是以库文件的方式提供的话
 需要链接并打包进行最后的二进制可执行文件中的静态库。
 
 最初级和原始的静态库是以 .a 的二进制文件加上一些 .h 的头文件进行定义的形式提供的，
 我们除了将其添加到项目和配置链接外，还需要进行指明头文件位置等工作。
 这样造成的结果不仅是添加起来比较麻烦，而且因为头文件的路径可能在不同环境下会存在不一样的情况，
 而造成项目在换一个开发环境后就因为配置问题造成无法编译。
 
 而 Apple 自己的框架都是 .framework 为后缀的动态框架，是集成在操作系统中的
 我们使用这些框架的时候只需要在 target 配置时进行指明就可以，非常方便。
 
 因为 framework 的易用性，因此很多开发者都很喜欢类似的“即拖即用，无需配置”的体验。
 
 虽然和 Apple 的框架的后缀名一样是 .framework，使用方式也类似，
 但是这些第三方框架都是实实在在的静态库，每个 app 需要在编译的时候进行独立地链接。
 
 
 */

//HelloFace.faceSayHello()


// -----------------------------

/*

//fatalError
/*
 断言只会在 Debug 环境中有效，在 Release 编译中所有的断言都将被禁用
 在遇到确实因为输入的错误无法使用程序继续运行的时候，一般考虑以产生致命错误 fatalError 的方式来终止程序
 
 @noreturn func fatalError(
 @autoclosure message: () -> String = default,
 file: StaticString = default,
 line: UInt = default
 )
 @noreturn，这表示调用这个方法的话可以不再需要返回值，因为程序整个都将终止。这可以帮助编译器进行一些检查
 
 */

//let array = [1,2,3]
//array[4] //Fatal error: Index out of range


enum MyEnum {
    
    case Value1,Value2,Value3
}

func check(someValue: MyEnum) -> String {
    switch someValue {
    case .Value1:
        return "OK"
    case .Value2:
        return "NOT OK"
    default:
        //没有返回 string 也能编译通过
        fatalError("Should not show!")
    }
}

var checkString = check(someValue: MyEnum.Value2) //Fatal error: Should not show!
print(checkString)



//“父类定义了某个方法，但是自己并不给出具体实现，而是要求继承它的子类去实现这个方法”

class MyClass {
    func methodMustBeImplementedInSubclass() {
        fatalError("这个方法必须在子类中被重写")
    }
}

class YourClass: MyClass {
    override func methodMustBeImplementedInSubclass() {
        print("子类中实现了父类中的方法")
    }
}

class OtherClass: MyClass {
    func someMethod() {
        print("someMethod")
    }
}


YourClass().methodMustBeImplementedInSubclass()

//OtherClass().methodMustBeImplementedInSubclass() //Fatal error: 这个方法必须在子类中被重写
//通过协议，可将需要实现的方法定义在协议中，遵守这个协议的类型必须实现这个方法

/*
 对于其他一切我们不希望别人随意调用，但是又不得不去实现的方法，我们都应该使用 fatalError 来避免任何可能的误会。
 比如父类标明了某个 init 方法是 required 的，但是你的子类永远不会使用这个方法来初始化时，就可以采用类似的方式，
 被广泛使用 (以及被广泛讨厌的) init(coder: NSCoder) 就是一个例子。在子类中，我们往往会写：
 required init(coder: NSCoder) {
 fatalError("NSCoding not supported")
 }
 来避免编译错误。
 */

 */
 
// -----------------------------

//断言

/*
 断言在 Cocoa 开发里一般用来检查输入参数是否满足一定条件并对其进行论断。
 对于判定输入是否满足某种条件，Swift 为我们提供了一系统 assert 方法来使用断言
 
 “func assert(
 @autoclosure condition: () -> Bool,
 @autoclosure _ message: () -> String = default,
 file: StaticString = default,
 line: UInt = default
 )”
 
 
 “断言的另一个优点是它是一个开发时的特性，只有在 Debug 编译的时候有效，而在运行时是不被编译执行的，
 因此断言并不会消耗运行时的性能。这些特点使得断言成为面向程序员的在调试开发阶段非常合适的调试判断，
 而在代码发布的时候，我们也不需要刻意去将这些断言手动清理掉”
 
 “虽然默认情况下只在 Release 的情况下断言才会被禁用，但是有时候我们可能出于某些目的希望断言在调试开发时也暂时停止工作，
 或者是在发布版本中也继续有效。我们可以通过显式地添加编译标记达到这个目的。
 在对应 target 的 Build Settings 中，我们在 Swift Compiler - Custom Flags 中的
 Other Swift Flags 中添加 -assert-config Debug 来强制启用断言，
 或者 -assert-config Release 来强制禁用断言。
 当然，除非有充足的理由，否则并不建议做这样的改动。
 如果我们需要在 Release 发布时在无法继续时将程序强行终止的话，应该选择使用 fatalError。
 
 原来在 Objective-C 中使用的断言函数 NSAssert 在 Swift 中已经被彻底移除”
 
 
 
 */

/*
var absoluteZeroInCelsius = -273.15

func convertToKelvin(_ celsius: Double) -> Double {
    assert(celsius > absoluteZeroInCelsius, "输入的摄氏温度不能低于绝对零度")
    return celsius - absoluteZeroInCelsius
}

let roomTemperature = convertToKelvin(27)
// roomTemperature = 300.15

let tooCold = convertToKelvin(-300)
// 运行时错误:
// assertion failed:
// 输入的摄氏温度不能低于绝对零度 : file {YOUR_FILE_PATH}, line {LINE_NUMBER}”
/*
 Assertion failed: 输入的摄氏温度不能低于绝对零度: file /Users/MA806P/Desktop/SwiftDemo/SwiftTips/SwiftTips/SwiftDevelopment/main.swift, line 36
 2019-02-14 12:02:30.701054+0800 SwiftDevelopment[11809:684376] Assertion failed: 输入的摄氏温度不能低于绝对零度: file /Users/MA806P/Desktop/SwiftDemo/SwiftTips/SwiftTips/SwiftDevelopment/main.swift, line 36
 */

*/


// -----------------------------

/*
 
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



enum LoginError: Error {
    case UserNotFound, UserPasswordNotMatch
}

let users = ["aaa":"111"]


func login(user: String, password: String) throws {
    if !users.keys.contains(user) {
        throw LoginError.UserNotFound
    }
    
    if users[user] != password {
        throw LoginError.UserPasswordNotMatch
    }
    
    print("Login successfully")
}

// ErrorType 可以非常明确地指出问题所在，调用时 catch 语句实质上是在进行模式匹配:

do {
    try login(user: "aaa", password: "111")
} catch LoginError.UserNotFound {
    print("UserNotFound")
} catch LoginError.UserPasswordNotMatch {
    print("UserPasswordNotMatch")
}

//相比于 Java C# 的方式（把可能抛出异常的代码放在try里，Swift则是放在do中，并在只可能发生异常的语句前加try）
//Swift的可以更清楚知道是哪一个调用可能抛出异常，而不必逐句查阅文档。
//当然并非完美，最大的问题是类型安全，不借助文档 无法从代码中直接得知所抛出的异常的类型。
//光看方法定义，我们并不知 LoginError 会抛出，理想中的异常 API：“func login(user: String, password: String) throws LoginError


/*
 对于非同步的 API，抛出异常时不可用的，这类一般涉及到网络或者耗时操作，产生错误的可能性要高很多，开发者无法忽视这样的错误
 func dataTask(with: completionHandler: (Data?, URLResponse?, Error?) -> Void)
 开发中往往不会直接使用，而会选择进行一些封装，以求更方便调用和维护
 */
/*
enum Result {
    case Success(String)
    case Error(NSError)
}

func doSomethingParam(param: String) -> Result {
    
    let success = false
    
    if success {
        return Result.Success("成功完成")
    } else {
        let error = NSError(domain: "error domain", code: 1, userInfo: nil)
        return Result.Error(error)
    }
}

let result = doSomethingParam(param: "path")

switch result {
case let .Success(ok):
    let serverResponse = ok
case let .Error(error):
    let serverResponse = error.description
}
 
 
 可以在 enum 中指定泛型，可使结果统一化：
 enum Result<T> {
 case Success(T)
 case Error(NSError)
 }
 “只需要在返回结果时指明 T 的类型，就可以使用同样的 Result 枚举来代表不同的返回结果了。
 这么做可以减少代码复杂度和可能的状态，同时不是优雅地解决了类型安全的问题”

 
 
 
 “try 可以接 ! 表示强制执行，这代表你确定知道这次调用不会抛出异常。如果在调用中出现了异常的话，你的程序将会崩溃，
 这和我们在对 Optional 值用 ! 进行强制解包时的行为是一致的。
 另外，我们也可以在 try 后面加上 ? 来进行尝试性的运行。try? 会返回一个 Optional 值：如果运行成功，没有抛出错误的话，
 它会包含这条语句的返回值，否则将为 nil。和其他返回 Optional 的方法类似，
 一个典型的 try? 的应用场景是和 if let 这样的语句搭配使用，不过如果你用了 try? 的话，就意味着你无视了错误的具体类型：”

 
 
 
*/


enum E: Error {
    case Negative
}

func methodThrowsWhenPassingNegative(number: Int) throws -> Int {
    if number < 0 {
        throw E.Negative
    }
    return number
}

if let num = try? methodThrowsWhenPassingNegative(number: 100) {
    print(type(of: num))
} else {
    print("failed")
}
// Int

//在一个可以 throw 的方法里，永远不应该返回一个 Optional 的值。因为结合 try？使用的话，这个 Optional 返回值
// 将被再次包装一层 Optional 这种值非常容易产生错误 这样：throws -> Int?

/*
 “rethrows 和 throws 做的事情并没有太多不同，它们都是标记了一个方法应该抛出错误。
 但是 rethrows 一般用在参数中含有可以 throws 的方法的高阶函数中，来表示它既可以接受普通函数，
 也可以接受一个能 throw 的函数作为参数。也就是像是下面这样的方法，我们可以在外层用 rethrows 进行标注：
  */
func methodThrows(num: Int) throws {
    if num < 0 {
        print("Throwing!")
        throw E.Negative
    }
    print("Executed!")
}

func methodRethrows(num: Int, f: (Int) throws -> ()) rethrows {
    try f(num)
}

do {
    try methodRethrows(num: 1, f: methodThrows)
} catch _ {
    
}
//Executed!


/*
 “我们简单地把 rethrows 改为 throws，这段代码依然能正确运行。
 但是 throws 和 rethrows 还是有所区别的。简单理解的话你可以将 rethrows 看做是 throws 的“子类”，rethrows
 的方法可以用来重载那些被标为 throws 的方法或者参数，或者用来满足被标为 throws 的协议，但是反过来不行。
 如果你拿不准要怎么使用的话，就先记住你在要 throws 另一个 throws 时，应该将前者改为 rethrows
 这样在不失灵活性的同时保证了代码的可读性和准确性。
 标准库中很常用的 map，reduce 等函数式特点鲜明的函数都采用了 rethrows 的方式来拓展适用范围。”
 
 */

*/



// -----------------------------

//print 和 debugPrint
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



