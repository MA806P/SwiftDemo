//
//  MemorySafety.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/9/12.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 
 内存访问冲突
 当你有多处代码在同一时间访问同一块内存地址时，内存访问冲突就可能会出现。
 
 当你有两个访问操作放生如下情形时，就会发生访问冲突：
 至少有一个是写操作。
 它们访问的是同一块内存地址。
 它们的访问时间发生了重叠。
 
 
 
 In-Out 参数引起的访问冲突
 函数对它的所有 in-out 参数拥有长期写访问权。
 拥有长期的写访问权会造成一个问题，就是你不能一边把值作 in-out 传递一边又去访问这个原始值，
 即使作用域和访问权限是允许的--任何访问原始值都会造成冲突。比如：
 var stepSize = 1
 func increment(_ number: inout Int) {
 number += stepSize
 }
 increment(&stepSize)
 // 错误: conflicting accesses to stepSize
 
 stepSize 的读访问权和 number 的写访问权重叠了。
 number 和 stepSize 指向同一块内存地址。同一块内存的读和写访问权重叠了，因而产生了冲突。
 
 // 显性拷贝一个副本。
 var copyOfStepSize = stepSize
 increment(&copyOfStepSize)
 
 // 更新初始值
 stepSize = copyOfStepSize
 // stepSize 现在是 2
 
 
 
 func balance(_ x: inout Int, _ y: inout Int) {
 let sum = x + y
 x = sum / 2
 y = sum - x
 }
 var playerOneScore = 42
 var playerTwoScore = 30
 balance(&playerOneScore, &playerTwoScore)  // OK
 balance(&playerOneScore, &playerOneScore)
 // 错误: 访问 playerOneScore 冲突
 playerOneScore 和 playerTwoScore 作为参数传入函数时，并没有引起冲突 --- 虽然有两个写入权限恰好重叠了，
 但是它们访问的是不同的内存地址。相反，仅传 playerOneScore 作为两个参数的值引起了访问冲突，
 因为它试图在同一时间对同一内存地址执行两个写入权限。
 
 */



/*
 方法内部 self 的访问冲突
 一个结构体的 mutating 方法在其被调用期间对 self 有写访问权。
 
 
 属性访问冲突
 诸如结构体、元组、还有枚举这样的数据类型，都是由独立的值构成的，比如结构体的属性或者元组的元素
 由于这些数据类型都是值类型，改变其中任意一个值就相当于改变了其整体，
 也就是说对一个属性的读写访问需要对其整体进行读写访问。
 例如，元组元素的写访问重叠就会产生冲突
 
 
 
 */

