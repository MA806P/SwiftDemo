//
//  AdvancedOperators.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/9/15.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 
 Swift 中的算术运算符默认不会溢出。溢出被捕获后是作为错误进行处理的。
 如果想使用溢出行为，请使用 Swift 的第二种算术运算符集，比如加号溢出操作符（ &+ ）。所有的溢出运算符都以 ( & ) 符开头。
 
 Swift 允许你自定义中缀、前缀、后缀，和赋值运算符，来自定义优先级和关联值。
 这些操作符可以像任意的预定义操作符一样在你的代码中使用，你甚至可以扩展已经存在的类型类支持你自定义的运算符。
 
 按位取反运算符
 let initialBits: UInt8 = 0b00001111
 let invertedBits = ~initialBits  // 等于 11110000
 
 
 let firstSixBits: UInt8 = 0b11111100
 let lastSixBits: UInt8  = 0b00111111
 let middleFourBits = firstSixBits & lastSixBits  // 等于 00111100
 
 let someBits: UInt8 = 0b10110010
 let moreBits: UInt8 = 0b01011110
 let combinedbits = someBits | moreBits  // 等于 11111110
 
 
 按位异或运算符 ，或者 按位互斥或运算符 将两个数的二进制数进行比较。
 返回一个新值，当两个操作数对应的二进制数不同时，新值对应的二进制数置为 1 ，相同时置为 0 ：
 let firstBits: UInt8 = 0b00010100
 let otherBits: UInt8 = 0b00000101
 let outputBits = firstBits ^ otherBits  // 等于 00010001
 
 
 
 按位偏移：
 let shiftBits: UInt8 = 4   // 00000100 　在二进制中
 shiftBits << 1             // 00001000
 shiftBits << 2             // 00010000
 shiftBits << 5             // 10000000
 shiftBits << 6             // 00000000
 shiftBits >> 2             // 00000001
 
 
 
 
 
 溢出运算符
 如果你向一个整型的常量或者变量中插入一个它容纳不了的数值，Swift 默认会报错，而不会允许生成一个无效的数。
 Int16 整型可以容纳从 -32768 到 32767 之间的有符号整型值。当你试图往一个 Int16 类型的常量或者变量里设置一个超出这个范围的值时，就会导致错误：
 var potentialOverflow = Int16.max
 // potentialOverflow 等于 32767，是 Int16 能容纳的最大值
 potentialOverflow += 1
 // 这行代码会导致错误
 
 当你特别期望在出现溢出情况时，能够截取有效的二进制数，你可以选择这个操作而不是抛出一个错误。
 Swift 为整型计算的溢出操作提供了三个算数 溢出运算符 可供选择。这几个运算符都是以 （&）开头：
 溢出加法运算符 (&+)
 溢出减法运算符 (&-)
 溢出乘法运算符 (&*)
 
 var unsignedOverflow = UInt8.max
 // unsignedOverflow 等于 255, 是 UInt8 能容纳的最大值
 unsignedOverflow = unsignedOverflow &+ 1
 // unsignedOverflow 现在等于 0
 
 var unsignedOverflow = UInt8.min
 // unsignedOverflow 等于 0, 是 UInt8 能容纳的最小值
 unsignedOverflow = unsignedOverflow &- 1
 // unsignedOverflow 现在等于 255
 
 var signedOverflow = Int8.min
 // signedOverflow 等于 -128,  Int8 能容纳的最小值
 signedOverflow = signedOverflow &- 1
 // signedOverflow 现在等于 127
 
 
 
 
 优先级
 
 2 + 3 % 4 * 5
 // 这个表达式等于 17
 2 + ((3 % 4) * 5) = 2 + (3 * 5) = 17
 
 
 
 
 运算符方法
 类和结构体可以提供现有运算符的自有实现。也可以称为 重载 运算符。
 
 struct Vector2D {
 var x = 0.0, y = 0.0
 }
 
 extension Vector2D {
 static func + (left: Vector2D, right: Vector2D) -> Vector2D {
 return Vector2D(x: left.x + right.x, y: left.y + right.y)
 }
 }
 
 
 前缀和后缀运算符 -b
 extension Vector2D {
 static prefix func - (vector: Vector2D) -> Vector2D {
 return Vector2D(x: -vector.x, y: -vector.y)
 }
 }
 
 复合赋值运算符 +=
 extension Vector2D {
 static func += (left: inout Vector2D, right: Vector2D) {
 left = left + right
 }
 }
 
 等价运算符  == !=
 extension Vector2D: Equatable {
 static func == (left: Vector2D, right: Vector2D) -> Bool {
 return (left.x == right.x) && (left.y == right.y)
 }
 }
 
 
 
 自定义运算符
 使用 operator 关键字在全局级别声明新运算符，并使用 prefix，infix 和 postfix 修饰符标记：
 extension Vector2D {
 static prefix func +++ (vector: inout Vector2D) -> Vector2D {
 vector += vector
 return vector
 }
 }
 
 var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
 let afterDoubling = +++toBeDoubled
 // toBeDoubled 的值为 (2.0, 8.0)
 // afterDoubling 的值也为 (2.0, 8.0)
 自定义中缀运算符均属于优先级组。优先级组指定运算符相对于其它中缀运算符的优先级
 未明确放入优先级组的自定义中缀运算符将被放入默认优先级组，其优先级高于三元条件运算符。
 
 
 
 
 以下示例定义了一个名为 +- 的新自定义中缀运算符，它属于优先级组 AdditionPrecedence：
 infix operator +-: AdditionPrecedence
 extension Vector2D {
 static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
 return Vector2D(x: left.x + right.x, y: left.y - right.y)
 }
 }
 let firstVector = Vector2D(x: 1.0, y: 2.0)
 let secondVector = Vector2D(x: 3.0, y: 4.0)
 let plusMinusVector = firstVector +- secondVector
 // plusMinusVector 是一个 Vector2D 实例，其值为 (4.0, -2.0)
 
 该运算符将两个向量的 x 值相加，并从第一个向量中减去第二个向量的 y 值。
 因为它本质上是一个「加法」运算符，所以它被添加到了与加法中缀运算符（例如 + 和 - ）相同的优先级组。
 
 
 */

