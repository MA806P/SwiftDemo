import UIKit

var str = "Hello, playground"


var text = """
 hello this line multiply
"""

var a = [4,1,2,6,3,5]
a.sort()  //1,2,3,4,5,6
a.sort(by: >) //6,5,4,3,2,1

let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("celery")
case let x where x.hasSuffix("pepper"):
    print("pepper")
default:
    print("nothing")
}
//pepper


class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides"
    }
}
var tmpShape = NamedShape(name: "suqare")
tmpShape.numberOfSides = 6
print("shape: \(tmpShape.simpleDescription())")
//shape: A shape with 6 sides

class Square: NamedShape {
    var sideLength: Double
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        //self.name = name //'self' used in property access 'name' before 'super.init' call
        super.init(name: name)
        numberOfSides = 4
    }
    func area() -> Double {
        return sideLength * sideLength
    }
    override func simpleDescription() -> String {
        return "square with sides of length \(sideLength)"
    }
    
    var perimeter: Double {
        get {
            return 4 * sideLength
        }
        set {
            sideLength = newValue / 4.0
        }
    }
}
let tmpSquare = Square(sideLength: 3.0, name: "test square")
tmpSquare.area() //9
tmpSquare.simpleDescription()
print("suqare side length \(tmpSquare.sideLength)") //3.0
tmpSquare.perimeter = 20
print("suqare side length \(tmpSquare.sideLength)") //5.0




