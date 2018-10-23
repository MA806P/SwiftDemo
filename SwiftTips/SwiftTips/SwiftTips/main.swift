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

class MyClass {
    static var bar: PointTest?
}


// -----------------------------

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



