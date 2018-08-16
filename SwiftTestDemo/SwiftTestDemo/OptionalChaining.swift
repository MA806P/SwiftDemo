//
//  OptionalChaining.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/8/16.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

/*
 可选链作为强制展开的代替品
 类似于在可选值之后放置感叹号（!）来强制展开它的值。
 主要的区别是，可选链在可选项为 nil 时只会调用失败，而强制展开在可选项为 nil 时会触发运行时错误。
 可选链调用的结果总是一个可选值
 
 
 
 
 
 */


class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}
////新建一个 Person 实例，由于 residence 是可选的，所以会被初始化为 nil
////如果你尝试访问此人 residence 的 numberOfRooms 属性，
////通过在 residence 后面放置一个感叹号来强制展开其值，则会触发运行时错误，因为没有值来解包
//let john = Person()
//let roomCount = john.residence!.numberOfRooms // 会触发运行时错误

////下面可选链提供了另一种访问方法
//if let roomCount = john.residence?.numberOfRooms {
//    print("John's residence has \(roomCount) room(s).")
//} else {
//    print("Unable to retrieve the number of rooms.")
//}
//// "Unable to retrieve the number of rooms."


//john.residence?.address = someAddress
//john.residence 当前的值为 nil，赋值是可选链的一部分，也就意味着 = 操作符的右操作数不会被计算






//通过可选链调用方法
//可以使用可选链来调用一个可选值的方法，以及检查调用是否成功。即使那个方法没有返回值你依然可以这样做。
//通过可选链访问下标
//可以使用可选链尝试从可选值的下标中检索和设置值，并检查该下标调用是否成功。

//var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
//testScores["Dave"]?[0] = 91
//testScores["Bev"]?[0] += 1
//testScores["Brian"]?[0] = 72 //不包含 Brian 键，调用失败 但是不会崩
////["Dave": [91, 82, 84], "Bev": [80, 94, 81]]
//当访问越界 testScores["Dave"]?[10] 会崩


//可以关联多层次的可选链，以深入到模型中更深层次的属性、方法和下标。但是，多个可选链表级别不增加返回值的可选级别。
//1、如果要检索的类型不是可选的，通过可选链，它将成为可选的。
//2、如果您要检索的类型已经是可选的，那么它将保持原状。
// if let johnsStreet = john.residence?.address?.street {


//在方法的可选返回值上进行可选链式调用
//if let buildingIdentifier = john.residence?.address?.buildingIdentifier()
//if let beginsWithThe = john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
//if beginsWithThe {


