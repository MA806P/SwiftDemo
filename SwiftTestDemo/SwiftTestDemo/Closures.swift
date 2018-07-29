//
//  Closures.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/7/29.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


//--------------- Closures -----------------

//func backward(_ s1: String, _ s2: String) -> Bool {
//    return s1 > s2
//}
//let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
//var reNames = names.sorted(by: backward)
//print(reNames)
////
////reNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })
////reNames = names.sorted(by: { s1, s2 in return s1 > s2 })
////reNames = names.sorted(by: { s1, s2 in s1 > s2 } )
////reNames = names.sorted(by: { $0 > $1 } )
////reNames = names.sorted(by: >)


////********************
////Trailing Closures
//func someFuncThatTakesAClosure(closure: () -> Void) {
//    //func body goes here
//    print("func call")
//}
////Here's how you call this function without using a trailing closure
//someFuncThatTakesAClosure (closure: {
//    //closure's body goes here
//    print("closure")
//})
////Here's how you call this function with a trailing closure instead
//someFuncThatTakesAClosure() {
//    //trailing closure's body goes here
//    print("call func")
//}
//
////If a closure expression is provided as the function or method’s only argument
////and you provide that expression as a trailing closure,
////you do not need to write a pair of parentheses ()
////after the function or method’s name when you call the function
//someFuncThatTakesAClosure {
//
//}
//reNames = names.sorted { $0 > $1 }



////********************
////Capturing Values
//func makeIncrementer(forIncrement amount: Int) -> () -> Int {
//    var runningTotal = 0
//    func incrementer() -> Int {
//        runningTotal += amount
//        return runningTotal
//    }
//    return incrementer
//}
//
//let incrementByTen = makeIncrementer(forIncrement: 10)
//print("---\(incrementByTen())") //10
//print("---\(incrementByTen())") //20
//
//let alsoIncrementByten = incrementByTen;
//print("---\(alsoIncrementByten())") //30


//Closures Are Reference Types
//the closures these constants refer to are able to increment the runningTotal variables
//that they have captured. This is because functions and closures are reference types.

//********************
//Escaping Closures
//When you declare a function that takes a closure as one of its parameters,
//you can write @escaping before the parameter’s type to indicate that the closure is allowed to escape.

////Marking a closure with @escaping means you have to refer to self explicitly within the closure
//var completionHandlers: [() -> Void] = []
//func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
//    completionHandlers.append(completionHandler)
//}
//func someFunctionWithNonescapingClosure(closure: () -> Void) {
//    closure()
//}
//class SomeClass {
//    var x = 10
//    func doSomething() {
//        someFunctionWithEscapingClosure { self.x = 100 }
//        someFunctionWithNonescapingClosure { x = 200 }
//    }
//}
//let instance = SomeClass()
//instance.doSomething()
//print(instance.x)
//// Prints "200"
//
//completionHandlers.first?()
//print(instance.x)
//// Prints "100"


//********************
//Autoclosures
//An autoclosure is a closure that is automatically created to wrap an expression
//that’s being passed as an argument to a function.

//var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
//// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
//func serve(customer customerProvider: () -> String) {
//    print("Now serving \(customerProvider())!")
//}
//serve(customer: { customersInLine.remove(at: 0) } )
//// Prints "Now serving Chris!"
//
//
//// customersInLine is ["Ewa", "Barry", "Daniella"]
//func serve(customer customerProvider: @autoclosure () -> String) {
//    print("Now serving \(customerProvider())!")
//}
//serve(customer: customersInLine.remove(at: 0))
//// Prints "Now serving Alex!"
//
//
//// customersInLine is ["Barry", "Daniella"]
//var customerProviders: [() -> String] = []
//func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
//    customerProviders.append(customerProvider)
//}
//collectCustomerProviders(customersInLine.remove(at: 0))
//collectCustomerProviders(customersInLine.remove(at: 0))
//print("Collected \(customerProviders.count) closures.")
//// Prints "Collected 2 closures."
//for customerProvider in customerProviders {
//    print("Now serving \(customerProvider())!")
//}
//The array is declared outside the scope of the function,
//which means the closures in the array can be executed after the function returns.
//As a result, the value of the customerProvider argument must be allowed to escape the function’s scope.

