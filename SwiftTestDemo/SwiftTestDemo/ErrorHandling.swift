//
//  ErrorHandling.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/8/23.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


/*
 Swift 中，错误是遵循 Error 协议的值。Error 是一个空协议，表明遵循该协议的类型可以用于错误处理。
 
 */


class ErrorHandlingTest {
    
    func errorTest() {
        
        let vendingMachine = VendingMachine()
        vendingMachine.coinsDeposited = 8
        do {
            try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
            print("Success! Yum.")
        } catch VendingMachineError.invalidSelection {
            print("Invalid Selection.")
        } catch VendingMachineError.outOfStock {
            print("Out of Stock.")
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
        } catch {
            print("Unexpected error: \(error).")
        }
        // "Insufficient funds. Please insert an additional 2 coins."
        
    }
    
    
    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels", ]
    
    func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
        let snackName = favoriteSnacks[person] ?? "Candy Bar"
        try vendingMachine.vend(itemNamed: snackName)
    }
    
    
}

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}
//通过抛出错误表示发生了意外情况，导致正常的执行流程不能继续执行下去。可以使用 throw 语句抛出错误。
//当抛出错误时，它周围的代码必须负责处理错误。
//throw VendingMachineError.insufficientFunds(coinsNeeded: 5)



//在 Swift 中有四种处理错误的方式。
//可以将错误从函数传递给调用该函数的代码
//可以使用 do-catch 语句处理错误
//可以通过可选值处理错误
//可以通过断言保证错误不会发生


/*
 当函数抛出错误时，它会改变程序的流程，因此快速定位问题显得尤为重要。
 在调用可能引发错误的函数、方法或初始化程序的代码之前，使用 try 关键字，
 或者使用它的变体 try? 或 try!，在您的代码中定位错误的位置。
 
 
 在 Swift 中使用 try、catch 和 throw 关键字进行错误处理的语法和其他语言的异常处理差不多。
 不同于 Objective-C 等语言的异常处理，Swift 中的错误处理不会展开调用堆栈，
 因为这个过程的计算成本很高。因此，throw 语句的性能特性和 return 语句的性能特性相差无几。
 
 为了让函数、方法或者初始化程序可以抛出错误，您需要在函数声明的参数后面添写 throws 关键字。
 标有 throws 的函数称为抛出函数。
 func canThrowErrors() throws -> String
 抛出函数将函数中的错误传递给调用该函数的代码。
 
 
 */

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}





/*
 通过可选值处理错误
 可以使用 try? 将错误转换为可选值来处理错误。 如果在执行 try? 表达式时抛出错误，表达式的值将为 nil
 
 func someThrowingFunction() throws -> Int { // ... }
 let x = try? someThrowingFunction()
 let y: Int?
 do { y = try someThrowingFunction()
 } catch { y = nil }
 
 */


/*
 当代码执行到即将离开当前代码块之前，可以使用 defer 语句来执行一组语句。
 无论是因为错误而离开 --- 抑或是因为诸如 return 或 break 等语句而离开，
 defer 语句都可以让你执行一些必要的清理。例如，你可以使用 defer 语句来关闭文件描述符或释放手动分配的内存。
 defer 语句会推迟执行，直到退出当前作用域。
 
 func processFile(filename: String) throws {
 if exists(filename) {
 let file = open(filename)
 
 defer { close(file) }
 
 while let line = try file.readline() {
 // Work with the file.
 }
 // 在此关闭（文件），位于语句的末端。
 }
 }
 defer 语句来确保 open(_:) 函数有相应的 close(_:) 函数调用。
 
 */
