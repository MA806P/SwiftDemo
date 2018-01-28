# SwiftDemo

Example of Stanford Engineering courses: Developing Apps for iOS, CS193P


# Learning notes
### [The Swift Programming Language (Swift 4.0)](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html#//apple_ref/doc/uid/TP40014097)

#### Simple Values
Use let to make a constant and var to make a variable. 

There’s an even simpler way to include values in strings: Write the value in parentheses, and write a backslash (\) before the parentheses. For example:
```
let apples = 3
let appleSummary = "I have \(apples) apples."
```

Create arrays and dictionaries using brackets ([]), and access their elements by writing the index or key in brackets. A comma is allowed after the last element.
```
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"
 
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
```


To create an empty array or dictionary, use the initializer syntax.
```
let emptyArray = [String]()
let emptyDictionary = [String: Float]()
```


If type information can be inferred, you can write an empty array as [] and an empty dictionary as [:]—for example, when you set a new value for a variable or pass an argument to a function.
```
shoppingList = []
occupations = [:]
```


#### Control Flow

Use if and switch to make conditionals, and use for-in, while, and repeat-while to make loops. 

Another way to handle optional values is to provide a default value using the ?? operator. If the optional value is missing, the default value is used instead.
let informalGreeting = "Hi \(nickName ?? fullName)"


Switches support any kind of data and a wide variety of comparison operations—they aren’t limited to integers and tests for equality.

Use if and switch to make conditionals, and use for-in, while, and repeat-while to make loops. 
```
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)
```
```
var total = 0
for i in 0..<4 {
    total += i
}
print(total)

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)
```
Use ..< to make a range that omits its upper value, and use ... to make a range that includes both values.




#### Functions and Closures

Use func to declare a function. Call a function by following its name with a list of arguments in parentheses. Use -> to separate the parameter names and types from the function’s return type.

By default, functions use their parameter names as labels for their arguments. Write a custom argument label before the parameter name, or write _ to use no argument label.
```
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")
```


Functions can be nested. Nested functions have access to variables that were declared in the outer function. You can use nested functions to organize the code in a function that is long or complex.
```
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()
```

Functions are a first-class type. This means that a function can return another function as its value.
```
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)
```

A function can take another function as one of its arguments.

 You can write a closure without a name by surrounding code with braces ({}). Use in to separate the arguments and return type from the body.
```
numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})
```

You have several options for writing closures more concisely. 
```
let mappedNumbers = numbers.map({ number in 3 * number })
let sortedNumbers = numbers.sorted { $0 > $1 }
```



#### Objects and Classes

 An initializer to set up the class when an instance is created. Use init to create one.
 Every property needs a value assigned—either in its declaration or in the initializer.

 Use deinit to create a deinitializer if you need to perform some cleanup before the object is deallocated.
 
 Subclasses include their superclass name after their class name, separated by a colon.
 
 Methods on a subclass that override the superclass’s implementation are marked with override—overriding a method by accident, without  override, is detected by the compiler as an error. The compiler also detects methods with override that don’t actually override any     method in the superclass.
 
 In addition to simple properties that are stored, properties can have a getter and a setter.

 
 #### Enumerations and Structures
 
 Use enum to create an enumeration. Like classes and all other named types, enumerations can have methods associated with them.
 
 
 
 
 
 
 


