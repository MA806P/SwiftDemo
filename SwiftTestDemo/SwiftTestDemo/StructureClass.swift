//
//  StructureClass.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/8/4.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

/*
 
 类有有一些结构体没有的额外功能：
 继承让一个类可以继承另一个类的特征
 类型转换让你在运行时可以检查和解释一个类实例
 析构器让一个类的实例可以释放任何被其所分配的资源
 引用计数允许对一个类实例进行多次引用
 
 使用类的额外功能其代价就是增加了复杂性。一般来说，更推荐结构体和枚举，
 因为他们更加容易进行推断，并且适当或必要时使用类
 
 
 Swift 中所有的结构体和枚举都是值类型。这意味着在代码中你创建的任何结构体或枚举的实例
 --- 及其任何值类型的属性 --- 都会在传递时被拷贝。
 
 标准库所定义的集合例如数组，字典和字符串都进行了优化以减少拷贝时的性能开销。
 这些集合不是直接复制，而是在原始实例和所有副本之间共享内存。
 如果集合的任意一个副本被修改，则会在修改之前复制该元素。代码中这种行为看似好像立即发生。
 
 类是引用类型
 与值类型不同，赋值给变量或常量，或是传递给函数时，引用类型并不会拷贝。引用的不是副本而是已经存在的实例。
 
 
 等价于===， 等于==
 等价于意思是两个常量或变量完全引用相同的类实例。
 等于的意思是两个实例某种意义上的值相等或相同，就像类型设计者定义的那样。
 当你自定义结构体或类时，你有责任决定两个实例相等的标准
 
 引用类型实例的 Swift 常量或变量，并不直接指向内存地址，你也不需要写星号（*）来表示创建了一个引用。
 定义引用和 Swift 中的其他常量或变量一样。
 如果你需要直接与指针交互标准库提供了指针和 buffer 类型
 
*/



/*
 属性
 
 结构体是 值类型。当值类型的实例声明为常量时，其所有属性也都会被标记为常量。
 类的行为却并非如此，这是因为类是引用类型 。如果将引用类型的实例声明为常量时，你仍可以修改该实例的变量属性。
 
 
 全局常量和变量总是被延迟计算，与 延迟存储属性 类似。与延迟存储属性不同的是，全局常量和变量不需要使用 lazy 修饰符进行标记。
 局部常量和变量永远不会被延迟计算。
 
 */


/*
 方法
 
 
 */


class StructClassTest {
    
    let someResolution = Resolution()
    let someVideoMode = VideoMode()
    
    func structClassFuncTest() {
        
        //所有结构体都有一个用于初始化结构体实例的成员属性，并且是自动生成的成员构造器。
        //let vga = Resolution(width: 640, height: 480)
        //与结构体不同，类没有默认的成员构造器
        
        //copy 指向不同的地址
        //var aaa = vga
        
        
        
//        let tenEighty = VideoMode()
//        tenEighty.resolution = vga
//        tenEighty.interlaced = true
//        tenEighty.name = "1080i"
//        tenEighty.frameRate = 25.0
//
//        let alsoTenEighty = tenEighty
//        alsoTenEighty.frameRate = 30.0
//
//        print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
//        // "The frameRate property of tenEighty is now 30.0"
        
        /*
         注意 tenEighty 和 alsoTenEighty 声明的是常量而不是变量。但是仍然可以改变 tenEighty.frameRate 和 alsoTenEighty.frameRate，因为常量 tenEighty 和 alsoTenEighty 的值自身实际上没有改变
         只是在底层引用了 VideoMode 的实例。改变的是 VideoMode 的属性 frameRate ，而不是引用 VideoMode 的常量的值
         */
        
        
//        //恒等运算符，来检查两个常量或变量是否引用同一个实例
//        if tenEighty === alsoTenEighty {
//            print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
//        }
//        // Prints "tenEighty and alsoTenEighty refer to the same VideoMode instance."
        
        
        
    }
}


struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}




/*-------------------------- Properties ------------------------*/

//lazy stored properties
class DataImporter {
    /*
     DataImporter is a class to import data from an external file.
     The class is assumed to take a nontrivial amount of time to initialize.
     */
    var filename = "data.txt"
    // the DataImporter class would provide data importing functionality here
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // the DataManager class would provide data management functionality here
}







struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
//var square = Rect(origin: Point(x: 0.0, y: 0.0),
//                  size: Size(width: 10.0, height: 10.0))
//let initialSquareCenter = square.center
//square.center = Point(x: 15.0, y: 15.0)
//print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
//// "square.origin is now at (10.0, 10.0)"





//Read-Only Computed Properties
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
//let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
//print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
//// Prints "the volume of fourByFiveByTwo is 40.0"




//Property Observers
class SetpCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}



//Type Property Syntax
/*
 在 Swift 中，类型属性是写在类型定义的花括号内，作为类型定义的一部分，
 并且每个类型属性都明确地显示它支持的类型。
 */
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    //可以使用 static 关键字定义类型属性。
    //对于类类型的计算类型属性，可以使用 class 关键字来允许子类覆盖超类的实现
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
    
    //类型属性是基于 类型 来进行检索和设置，而不是基于该类型的实例
    func test() {
        print("\(SomeStructure.storedTypeProperty)  \(SomeClass.overrideableComputedTypeProperty)")
    }
}
class ChildOfSomeClass: SomeClass {
    //Cannot override static var
    //static override var computedTypeProperty :Int { return 200 }
    static override var overrideableComputedTypeProperty: Int {
        return 200
    }
}
//print("\(ChildOfSomeClass.overrideableComputedTypeProperty)") //200



struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // 将新音频电平值限制在阈值之内
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // 将此存储为新的目前最大的电平值
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}
//第一个检查中，即使 didSet 观察器将 currentLevel 设置为不同的值，也不会导致再次调用观察器。




/*---------------------------- Methods ------------------------*/

//Instance methods
//Type methods


//结构体和枚举是 值类型 。默认情况下，无法在其实例方法中修改值类型的属性。
//如果需要在特定方法中修改结构体或枚举的属性，可以选择将这个方法 异变 。
//然后，该方法就可以异变（即更改）其属性，并且当方法结束时，它所做的任何更改都将写回原始的结构体中。
//该方法还可以为隐式的 self 属性分配一个全新的实例，并且该新实例将在方法结束时替换现有实例。
//你可以通过在方法的 func 关键字前放置 mutating 关键字来选择开启此行为
struct Point123 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
//var somePoint = Point123(x: 1.0, y: 1.0)
//somePoint.moveBy(x: 2.0, y: 3.0)
//print("The point is now at (\(somePoint.x), \(somePoint.y))")
//// Prints "The point is now at (3.0, 4.0)"
//你不能在常量结构体类型上调用异变方法，因为它的属性不能更改，即使它们是变量属性
//let somePoint = Point123(x: 1.0, y: 1.0)


//在可变方法中给 self 赋值
struct Point456 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point456(x: x + deltaX, y: y + deltaY)
    }
}



//Type methods
//可以直接在类型本身上定义方法
//为了明确一个方法是类型方法，你可以在这个方法的 func 关键词前加上 static 关键词。
//在类中，也可以使用 class 关键词来声明一个类型方法。与 static 关键词不同的是，
//用 class 关键词声明的类型方法允许它的子类重写其父类对类型方法的实现。
class SomeClass123 {
    class func someTypeMethod() {
        // type method implementation goes here
    }
}
//SomeClass123.someTypeMethod()

//在一个方法的函数体中，隐性属性 self 指代其类型本身，而非指代类型的实例

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
//因为调用 advance(to:) 方法时我们有时候可能会需要忽略返回值，所以这个函数用 @ discardableResult 特性标记。






/*---------------------------- Subscripts ------------------------*/

/*
 使用下标, 让你可以通过在实例名称后面的方括号中写入一个或多个值来查询类的实例。
 它们的语法类似于实例方法和计算属性语法。使用 subscript 关键字定义下标，并且和实例方法类似，
 可以指定一个或多个输入参数和返回类型。与实例方法不同，下标可以是读写或只读。
 和计算属性类似, 读写是由 getter 和 setter 方法实现的：
 
 subscript(index: Int) -> Int {
 get { // return an appropriate subscript value here }
 set(newValue) { // perform a suitable setting action here }
 }
 */

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
//let threeTimesTable = TimesTable(multiplier: 3)
//print("six times three is \(threeTimesTable[6])")
// Prints "six times three is 18"


// The Dictionary type uses an optional subscript type to model the fact
//that not every key will have a value, and to give a way to
//delete a value for a key by assigning a nil value for that key.





//一个矩阵，rows多少行，colums多少列，grid是一个一维叔祖保存矩阵里的值
//设置下标，方便取值或设置值
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
//var matrix = Matrix(rows: 2, columns: 2)
//matrix[0, 1] = 1.5
//matrix[1, 0] = 3.2






/*---------------------------- Inheritance ------------------------*/

//重写从父类继承的特性，你需要在定义重写时添加 override 前缀。
//这表明你打算重写一个特性并且没有使用错误的匹配定义。
//意外的重写会导致不可预料的行为，且任何没有使用 override 关键词修饰的重写声明在编译代码时会被标记为错误。

/*
通过在子类属性中重写 getter 和 setter，可以将继承的只读属性重写为读写属性，但是，你不能将继承的读写属性重写为只读属性。
如果你重写属性的 setter 就必须同时重写属性的 getter。
 如果你不想在重写 getter 中修改继承属性的值，你可以简单地在 getter 中返回
 super.someProperty，其中 someProperty 是你想要重写的属性名称。
 
 防止重写
 你可以通过标记方法、属性或下标为 final 来防止它被重写。
 通过在方法、属性或下标前添加关键字 final （比如 final var、 final func、 final class func 和  final subscript）来完成此操作。
 */



/*---------------------------- Initialization ------------------------*/

/*
 和 Objective-C 的构造器不同，Swift 的构造器不用返回值。它们主要的作用就是确保在第一次使用前某类型的实例都能正确的初始化。
 
 
 */



//内部参数名和外部参数名
//与函数和方法的参数一样，构造参数有一个在构造器中使用的内部参数名和一个调用构造器时使用的外部参数名。
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

//let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
//let halfGray = Color(white: 0.5)

//如果在构造器中定义了外部参数名就必须使用，忽略它将会触发编译错误。
//let veryGreen = Color(0.0, 1.0, 0.0)
// 这会报编译错误 - 必须使用外部参数名


//无需外部参数名的构造参数
//如果你不想对构造参数使用外部参数名，写一个下划线（_）来代替显式外部参数名以重写其默认行为。
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
//let bodyTemperature = Celsius(37.0)
// bodyTemperature.temperatureInCelsius is 37.0




//在构造过程期间给常量赋值
//构造过程期间你可以在任何时间点给常量属性赋值，只要构造完成时设置了确定值即可。一旦常量属性被赋值，就不能再次修改。
class SurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
//let beetsQuestion = SurveyQuestion(text: "How about beets?")
//beetsQuestion.ask()
//// 打印 "How about beets?"
//beetsQuestion.response = "I also like beets. (But not with cheese.)"



//默认构造器
//Swift 为属性均有默认值和没有构造器的结构体或类提供了一个 默认构造器 。
//默认构造器创建了一个所有属性都有默认值的新实例。
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
//var item = ShoppingListItem()
//print("\(item.name) + \(item.quantity) + \(item.purchased)")
//nil + 1 + false
/*
 var quantity: Int
 如果类的属性有一个没有默认值，也没有自定义构造函数，会报错，Class has no initializers
 如果写了构造函数 init(){} 但是init里没有赋值给没有默认值的属性，
 也会报错 Return from initializer without initializing all stored properties
 */



//结构体类型的成员构造器
//如果结构体没有任何自定义构造器，那么结构体类型会自动接收一个 成员构造器。
//不同于默认构造器，即使结构体的存储属性没有默认值，它也会接收成员构造器。
struct MySize {
    var width: Float
    var height: Float
}
//var mysize = MySize(width: 1, height: 2)
//print("\(mysize.width) + \(mysize.height)") //1.0 + 2.0
//如果这样 var mysize = MySize() 创建结构体，不带参数会报错，下面
//Missing argument for parameter "width" in call



//值类型的构造器代理
//构造器可以调用其他构造器来执行实例的部分构造过程。这个过程称之为 构造器代理 ，以避免多个构造器之间的重复代码。
struct TestSize {
    var width = 0.0, height = 0.0
}
struct TestPoint {
    var x = 0.0, y = 0.0
}
struct TestRect {
    var origin = TestPoint()
    var size = TestSize()
    init() {}
    init(origin: TestPoint, size: TestSize) {
        self.origin = origin
        self.size = size
    }
    init(center: TestPoint, size: TestSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: TestPoint(x: originX, y: originY), size: size)
    }
}



/*
 类的所有存储属性 --- 包括任何从父类继承而来的属性 --- 必须 在构造过程期间赋值。
 
 指定构造器和便利构造器
 指定构造器 是类的主要构造器。一个指定构造器初始化该类引入的所有属性，并调用合适的父类构造器以继续父类链上的构造过程。
 类往往只有很少的指定构造器，通常一个类只有一个指定构造器。
 每个类至少要有一个指定构造器。
 类的指定构造器和值类型的简单构造器写法相同：
 init(parameters) { }
 
 便利构造器，类的辅助构造器。你可以定义便利构造器来调用同一类中的指定构造器并为指定构造器的一些参数设置默认值。
 你也可以定义便利构造器为特殊用例类或是输入类型类创建实例。
 相比普通的构造模式，创建便利构造器会节省很多时间并将类的构造过程变得更加清晰。
 convenience init(parameters) { }
 
 
 Swift 对构造器之间的代理采用了如下三条规则：
 规则 1 指定构造器必须调用其直系父类的指定构造器。
 规则 2 便利构造器必须调用 同一 类中的其他构造器。
 规则 3 便利构造器最后必须调用指定构造器。
 
 简单的记忆方法：
 指定构造器必须 向上 代理。
 便利构造器必须 横向 代理。
 
 
 两段式构造器过程
 第一阶段，为类引入的每个存储属性赋一个初始值。
 第二阶段，在新的实例被认为可以使用前，每个类都有机会进一步定制其存储属性。
 
 两段式构造过程的使用让构造过程更安全，同时对于类层级结构中的每个类仍然给予完全的灵活性。
 两段式构造过程防止了属性在初始化前访问其值，并防止其他构造器意外给属性赋予不同的值。
 
 
 Swift 的编译器执行了四个有帮助的安全检查以确保两段式构造过程无误完成：
 安全检查 1 指定构造器必须确保其类引入的所有属性在向上代理父类构造器之前完成初始化。
 安全检查 2 指定构造器必须在继承属性赋值前向上代理父类构造器，否则，便利构造器赋予的新值将被父类构造过程的一部分重写。
 安全检查 3 便利构造器必须在 任何 属性（包括同一类中定义的属性）赋值前代理另一个构造器。否则便利构造器赋予的新值将被其所属类的指定构造器重写。
 安全检查 4 构造器在第一阶段构造过程完成前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用 self 作为一个值。
 
 
 可失败构造器
 无效的构造参数值可能会触发这种失败，或是缺失某种需要的外部资源，又或是未能满足某种条件。
 不能使用相同的参数类型或参数名定义一个可失败构造器后又定义一个非失败构造器。
 可失败构造器会创建一个关联值类型是自身构造类型的 可选 类型。在可失败构造器中编写 return nil 以表示可以在任何情况下触发失败
*/




class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
//let bicycle = Bicycle()
//print("Bicycle: \(bicycle.description)")
//// Bicycle: 2 wheel(s)
//派生类可在构造过程期间可修改变量继承属性，但不能修改常量继承属性。




//指定构造器和便利构造器
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}




//可失败构造器
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}
//let anonymousCreature = Animal(species: "")
//// anonymousCreature 的类型是 Animal?，不是 Animal
//if anonymousCreature == nil {
//    print("The anonymous creature could not be initialized")
//}
//// "The anonymous creature could not be initialized"




//枚举的可失败构造器
//可以使用可失败构造器选择基于一个或多个参数的枚举成员。如果提供的参数不符合任何一个枚举成员，则构造失败。
enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}
//let unknownUnit = TemperatureUnit(symbol: "X")
//if unknownUnit == nil {
//    print("This is not a defined temperature unit, so initialization failed.")
//}
//// "This is not a defined temperature unit, so initialization failed."


//带有原始值枚举的可失败构造器
enum TemperatureUnitTest2: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}
//let fahrenheitUnit = TemperatureUnitTest2(rawValue: "F")
//if fahrenheitUnit != nil {
//    print("This is a defined temperature unit, so initialization succeeded.")
//}
//// "This is a defined temperature unit, so initialization succeeded."
//let unknownUnit = TemperatureUnitTest2(rawValue: "X")
//if unknownUnit == nil {
//    print("This is not a defined temperature unit, so initialization failed.")
//}
//// "This is not a defined temperature unit, so initialization failed."


//构造失败的传递
//如果你代理了其他构造器而导致构造失败。整个构造过程立即失败，不再进一步执行构造代码。


//init! 可失败构造器
//可以定义一个可失败构造器，将其用于创建一个适当的隐式解包可选类型的实例。
//为了定义这个可失败构造器，在关键字 init 后面用叹号来替代问号（init!）。


//必要构造器
//在类构造器的定义前写修饰符 required 以指明该类的每个派生类必须实现此构造器。
//class SomeClass { required init() { } }
//在每个派生类实现必要构造器时也必须在构造器前面写修饰符  required，
//以指明构造器要求应用于继承链中所有派生类。重写一个必要指定构造器时无需写修饰符 override
//class SomeSubclass: SomeClass { required init() { } }



//使用闭包或函数设置默认属性值
//class SomeClass {
//    let someProperty: SomeType = {
//        // 在闭包中创建一个带有默认值的 someProperty
//        // someValue 的类型必须是 SomeType
//        return someValue
//    }()
//}






/*---------------------------- Deinitialization ------------------------*/
















