# SwiftDemo

Example of Stanford Engineering courses: Developing Apps for iOS, CS193P


# Learning notes
### [The Swift Programming Language (Swift 4)](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html#//apple_ref/doc/uid/TP40014097)

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
```
Use ..< to make a range that omits its upper value, and use ... to make a range that includes both values.

#### Functions and Closures

Use func to declare a function. Call a function by following its name with a list of arguments in parentheses. Use -> to separate the parameter names and types from the function’s return type.


#### Objects and Classes

Use class followed by the class’s name to create a class. A property declaration in a class is written the same way as a constant or variable declaration, except that it is in the context of a class. Likewise, method and function declarations are written the same way.





