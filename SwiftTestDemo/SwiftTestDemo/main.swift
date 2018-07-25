//
//  main.swift
//  SwiftTestDemo
//
//  Created by MA806P on 2018/7/11.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation


//var obj = OCObject()
//obj.startTimerRunWithGCD()

//class Person: NSObject {
//    var name: String
//    override init() {
//        self.name = "adsf";
//    }
//}






//for i in 0..<3 {
//    print(i);
//} // 0 1 2
//for i in 0...3 {
//    print(i)
//} // 0 1 2 3

//let names = [1, 2, 3, 4]
//for name in names[2...] {
//    print(name)
//} // 3 4
//for name in names[...2] {
//    print(name)
//}// 1 2 3
//for name in names[..<2] {
//    print(name)
//}// 1 2


//let range = ...5
//range.contains(7)   // false
//range.contains(4)   // true
//print( range.contains(-9) ) // true



//let http404Error = (404, "Not Found")
//let (statusCode, statusMessage) = http404Error
//print("Tuples code:\(statusCode), message:\(statusMessage).  \(http404Error.0) + \(http404Error.1)")
////let (statusCode, _) = http404Error
//let http200Status = (code: 200, description: "OK")
//print("Status: \(http200Status.code), \(http200Status.description)")

/*
 Swift’s nil isn’t the same as nil in Objective-C.
 In Objective-C, nil is a pointer to a nonexistent object.
 In Swift, nil isn’t a pointer—it’s the absence of a value of a certain type.
 Optionals of any type can be set to nil, not just object types.
 */

//var optionalVar : Int? = 200
//print("optinal var \(optionalVar ?? 404)")
//if optionalVar != nil {
//    print("i'm sure is contain a value \(optionalVar!)")
//}


//two tuples of type (String, Bool)
//can’t be compared with the < operator
//because the < operator can’t be applied to Bool values.
//print(("blue", -1) < ("purple", 1))       // OK, evaluates to true
//("blue", false) < ("purple", true)  // Error because < can't compare Boolean values


//let possibleString: String? = "An optional string."
//let forcedString: String = possibleString! // requires an exclamation mark
//let assumedString: String! = "An implicitly unwrapped optional string."
//let implicitString: String = assumedString // no need for an exclamation mark
//print("\(possibleString) = \(forcedString) \n\(assumedString) = \(implicitString)")




//--------------- Strings and Characters -----------------

//let quotation = """
//
//If you need a string that spans several lines, \
//use a multiline string literal—a sequence of characters
//   surrounded by three double quotation marks
//
//"test is test"
//
//"""
//print(quotation)


//var emptyString = ""
//if emptyString.isEmpty {
//    print("Nothing to see here")
//}
//
//for character in "Dog" {
//    print(character)
//}
//
//let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
//let catString = String(catCharacters)
//print(catString)//Cat!🐱



//let greeting = "Guten Tag!"
//greeting[greeting.startIndex] // G
//greeting[greeting.index(before: greeting.endIndex)] // !
//greeting[greeting.index(after: greeting.startIndex)] // u
//let index = greeting.index(greeting.startIndex, offsetBy: 7)
//greeting[index] // a


//var welcome = "hello"
//welcome.insert("!", at: welcome.endIndex)
//// welcome now equals "hello!"
//welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex))
//// welcome now equals "hello there!"
//
//welcome.remove(at: welcome.index(before: welcome.endIndex))
//// welcome now equals "hello there"
//
//let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
//welcome.removeSubrange(range)
//// welcome now equals "hello"
//
//let greeting = "Hello, world!"
//let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
//let beginning = greeting[..<index]
//// beginning is "Hello"
//
//// Convert the result to a String for long-term storage.
//let newString = String(beginning)




//--------------- Collection Types -----------------

//array set dictionary


//var a = Array(repeating: 1, count: 3)
//var b = Array(repeating: 2, count: 3)
////b += a;
//print(a+b) //[1, 1, 1, 2, 2, 2]
//
//var c = ["1", "2", "3", "4", "5", "6", "7"]
//c[4...6] = ["e", "f"]
//print(c) //["1", "2", "3", "4", "e", "f"]
//
//for (index, value) in c.enumerated() {
//    print("item \(index + 1) = \(value)")
//}



//var d : Set = ["x", "z", "y"]
//for i in d.sorted() {
//    print(i)
//} // x y z



//var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
//for (airportCode, airportName) in airports {
//    print("\(airportCode): \(airportName)")
//}
//let airportCodes = [String](airports.keys)
//print(airportCodes)
//let airportNames = [String](airports.values)
//print(airportNames)




//--------------- Control Flow -----------------

//let base = 3
//let power = 10
//var answer = 1
//for _ in 1...power {
//    answer *= base
//}

//let minuteInterval = 5
//for tickMark in stride(from: 0, to: 60, by: minuteInterval) {
//    // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55)
//    print(tickMark)
//}


//let c: Character = "h"
//switch c {
//case "a":
//    print("a")
//case "b":
//    print("b")
//case "c":
//    print("c")
//case "d","e","f":
//    print("def")
//case "g"..<"l":
//    print("g..<l")
//default:
//    print("NO")
//}
/*
 the entire switch statement finishes its execution as soon as the first matching switch case is completed, without requiring an explicit break statement.
 */


//let somePoint = (6, 1)
//switch somePoint {
//case (0,0):
//    print("origin")
//case (_, 0):
//    print("x-axis")
//case (0, _):
//    print("y-axis")
//case (-2...2, -2...2):
//    print("inside the box")
//
//case (let x, 1):
//    print(" x value of \(x)")
//case (1, let y):
//    print(" y value of \(y)")
//case let (x, y):
//    print("somewhere else at (\(x), \(y))")
////default:
////    print("outside")
//
//}


//let a = (1, 1)
//switch a {
//case let(x,y) where x == y:
//    print("x==y")
//case let(x,y) where x == -y:
//    print("x==-y")
//case let(x,y):
//    print("x=\(x), y=\(y)")
//}



//gameLoop: while square != finalSquare {
//    diceRoll += 1
//    if diceRoll == 7 { diceRoll = 1 }
//    switch square + diceRoll {
//    case finalSquare:
//        // diceRoll will move us to the final square, so the game is over
//        break gameLoop
//    case let newSquare where newSquare > finalSquare:
//        // diceRoll will move us beyond the final square, so roll again
//        continue gameLoop
//    default:
//        // this is a valid move, so find out its effect
//        square += diceRoll
//        square += board[square]
//    }
//}
//print("Game over!")


/*A guard statement, like an if statement, executes statements depending on the Boolean value of an expression. You use a guard statement to require that a condition must be true in order for the code after the guard statement to be executed. Unlike an if statement, a guard statement always has an else clause—the code inside the else clause is executed if the condition is not true.*/
//func greet(person: [String: String]) {
//    guard let name = person["name"] else {
//        return
//    }
//    print("Hello \(name)!")
//    guard let location = person["location"] else {
//        print("I hope the weather is nice near you.")
//        return
//    }
//    print("I hope the weather is nice in \(location).")
//}
//greet(person: ["name": "John"])
//// Prints "Hello John!"
//// Prints "I hope the weather is nice near you."
//greet(person: ["name": "Jane", "location": "Cupertino"])
//// Prints "Hello Jane!"
//// Prints "I hope the weather is nice in Cupertino."
//greet(person: ["a":"b"])


//Checking API Availability
//if #available(iOS 10, macOS 10.12, *) {}


//--------------- Functions and Closures -----------------

//func greet(_ person: String, day: String) -> String {
//    return "hello \(person) , today is \(day)"
//}
//greet("123", day: "1")


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



//--------------- Closures -----------------

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reNames = names.sorted(by: backward)
print(reNames)

reNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })
reNames = names.sorted(by: { s1, s2 in return s1 > s2 })
reNames = names.sorted(by: { s1, s2 in s1 > s2 } )
reNames = names.sorted(by: { $0 > $1 } )
reNames = names.sorted(by: >)

//--------------- Objects and Classes -----------------

//class Person {
//    var name: String
//    var otherVar: Int = 0
//
//    init(name: String) {
//        self.name = name
//    }
//
//    func greet() -> String {
//        return "a person name is \(name)"
//    }
//}
//class Child : Person {
//    var age: Int
//
//    init(age: Int, name: String) {
//        self.age = age
//        super.init(name: name)
//        otherVar = 11
//    }
//
//    override func greet() -> String {
//        return "greet from child \(name), \(age), \(otherVar)"
//    }
//}
//var pereson1 = Person(name: "Tom")
//print(pereson1.greet())
//var child = Child(age: 10, name: "coco")
//print(child.greet())




//--------------- Enumerations and Structures -----------------

//enum Rank: Int {
//    case ace = 1
//    case two, three, four, five, six, seven, eight, nine, ten
//    case jack, queen, king
//    func simpleDescription() -> String {
//        switch self {
//        case .ace:
//            return "ace"
//        case .jack:
//            return "jack"
//        case .queen:
//            return "queen"
//        case .king:
//            return "king"
//        default:
//            return String(self.rawValue)
//        }
//    }
//}
//let ace = Rank.ace
//let aceRawValue = ace.rawValue
//print("\(ace), \(aceRawValue), \(ace.simpleDescription()), \(Rank(rawValue: 3) ?? Rank.king)")
////ace, 1, ace, three


//One of the most important differences between structures and classes
//is that structures are always copied when they are passed around in your code,
//but classes are passed by reference.
//struct Card {
//    var rank: Int
//    var suit: String
//    func simpleDescription() -> String {
//        return "The \(rank) of \(suit)"
//    }
//}
//let threeOfSpades = Card(rank: 1, suit: "aa")
//let threeOfSpadesDescription = threeOfSpades.simpleDescription()
//print(threeOfSpadesDescription) //The 1 of aa




//--------------- Protocols and Extensions -----------------


//protocol ExampleProtocol {
//    var simpleDescription: String { get }
//    mutating func adjust()
//}
////Classes, enumerations, and structs can all adopt protocols.
//
//struct SimpleStructure: ExampleProtocol {
//    var simpleDescription: String = "A simple structure"
//    mutating func adjust() {
//        simpleDescription += " (adjusted)"
//    }
//}
//var b = SimpleStructure()
//b.adjust()
//let bDescription = b.simpleDescription
//print(bDescription) //A simple structure (adjusted)
//
////the use of the mutating keyword in the declaration of SimpleStructure
////to mark a method that modifies the structure.
////The declaration of SimpleClass doesn’t need any of its methods marked as mutating
////because methods on a class can always modify the class.
//
//extension Int: ExampleProtocol {
//    var simpleDescription: String {
//        return "The number \(self)"
//    }
//    mutating func adjust() {
//        self += 42
//    }
//}
//print(7.simpleDescription)
//var a = 1;
//a.adjust()
//print(a) //43





//--------------- Error Handling -----------------

//enum PrinterError: Error {
//    case outOfPaper
//    case noToner
//    case onFire
//}
//func send(job: Int, toPrinter printerName: String) throws -> String {
//    if printerName == "Never Has Toner" {
//        throw PrinterError.noToner
//    }
//    return "Job sent"
//}
//
//
//do {
//    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
//    print(printerResponse)
//} catch {
//    print(error)
//}
//
//do {
//    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
//    print(printerResponse)
//} catch PrinterError.onFire {
//    print("I'll just put this over here, with the rest of the fire.")
//} catch let printerError as PrinterError {
//    print("Printer error: \(printerError).")
//} catch {
//    print(error)
//}
//let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")




//Assertions are checked only in debug builds,
//but preconditions are checked in both debug and production builds.
//In production builds, the condition inside an assertion isn’t evaluated.
//This means you can use as many assertions as you want during your development process, without impacting performance in production.

//let age = -3
//assert(age >= 0, "A person's age can't be less than zero.")
//// This assertion fails because -3 is not >= 0.
//print("age = \(age)")
//
//if age > 10 {
//    print("You can ride the roller-coaster or the ferris wheel.")
//} else if age > 0 {
//    print("You can ride the ferris wheel.")
//} else {
//    assertionFailure("A person's age can't be less than zero.")
//}





