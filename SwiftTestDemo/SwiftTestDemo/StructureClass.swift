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
        let vga = Resolution(width: 640, height: 480)
        //与结构体不同，类没有默认的成员构造器
        
        //copy 指向不同的地址
        //var aaa = vga
        
        
        
        let tenEighty = VideoMode()
        tenEighty.resolution = vga
        tenEighty.interlaced = true
        tenEighty.name = "1080i"
        tenEighty.frameRate = 25.0
        
        let alsoTenEighty = tenEighty
        alsoTenEighty.frameRate = 30.0
        
        print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
        // "The frameRate property of tenEighty is now 30.0"
        
        /*
         注意 tenEighty 和 alsoTenEighty 声明的是常量而不是变量。但是仍然可以改变 tenEighty.frameRate 和 alsoTenEighty.frameRate，因为常量 tenEighty 和 alsoTenEighty 的值自身实际上没有改变
         只是在底层引用了 VideoMode 的实例。改变的是 VideoMode 的属性 frameRate ，而不是引用 VideoMode 的常量的值
         */
        
        
        //恒等运算符，来检查两个常量或变量是否引用同一个实例
        if tenEighty === alsoTenEighty {
            print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
        }
        // Prints "tenEighty and alsoTenEighty refer to the same VideoMode instance."
        
        
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














