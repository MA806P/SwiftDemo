//
//  Functions.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/7/29.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

class FunctionsTest {
    
    func funcDemoTestAction() {
        
        func greet(_ person: String, day: String) -> String {
            return "hello \(person) , today is \(day)"
        }
        print("\(greet("123", day: "1"))")
        
    }
    
}




//--------------- Functions and Closures -----------------



//func makeIncrementer() -> ((Int) -> Int) {
//    func addOne(number: Int) -> Int {
//        return 1+number
//    }
//    return addOne
//}
//var increment = makeIncrementer()
//var test = increment(2)


//var numberArray = [1, 2, 3]
//numberArray.map ({ (number: Int) -> Int in
//    return number + 1
//})

////let mappedNumberArray = numberArray.map{number in 3 * number}
//let mappedNumberArray = numberArray.map{$0 * 3}
//print(mappedNumberArray) //3, 6, 9

//let sortedNumberArray = numberArray.sorted { $0 > $1 }
//print(sortedNumberArray) //3, 2, 1


//Specifying Argument Labels
//You write an argument label before the parameter name, separated by a space
//The use of argument labels can allow a function to be called in an expressive, sentence-like manner,
//while still providing a function body that is readable and clear in intent.
//func greet(person: String, from hometown: String) -> String {
//    return "Hello \(person)!  Glad you could visit from \(hometown)."
//}
//print(greet(person: "Bill", from: "Cupertino"))
//// Prints "Hello Bill!  Glad you could visit from Cupertino."


//Default Parameter Values
//func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
//    // If you omit the second argument when calling this function, then
//    // the value of parameterWithDefault is 12 inside the function body.
//}
//someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault is 6
//someFunction(parameterWithoutDefault: 4) // parameterWithDefault is 12


//Variadic Parameters
//func arithmeticMean(_ numbers: Double...) -> Double {
//    var total: Double = 0
//    for number in numbers {
//        total += number
//    }
//    return total / Double(numbers.count)
//}
//arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers
//arithmeticMean(3, 8.25, 18.75)
// returns 10.0, which is the arithmetic mean of these three numbers




////In-Out Parameters
////If you want a function to modify a parameter’s value,
////and you want those changes to persist after the function call has ended,
////define that parameter as an in-out parameter instead.
//func swapTwoInts(_ a: inout Int, _ b: inout Int) {
//    let temporaryA = a
//    a = b
//    b = temporaryA
//}
//var a = 1
//var b = 2
//swap(&a, &b)
//print("\(a), \(b)")//2, 1


////Function Types
//// () -> void
//// (Int, Int) -> Int
//func addTwoInts(_ a: Int, _ b: Int) -> Int {
//    return a + b
//}
//var mathFunction: (Int, Int) -> Int = addTwoInts
//print("Result: \(mathFunction(2, 3))")

