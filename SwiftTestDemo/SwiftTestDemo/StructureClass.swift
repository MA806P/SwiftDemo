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











