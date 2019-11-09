import Cocoa


/*
var a = [Int]()
a.reserveCapacity(3)
a.append(2)
a.append(1)
a.append(3)

a.sort()  //[1, 2, 3]
a.sort(by: >) //[3, 2, 1]

print(a) //[3, 2, 1]
a.removeAll()
print(a) //[]

//a.reserveCapacity(3) 为数组预留空间，
//防止数组在增加或删除时反复申请内存空间或是创建新新数组。可提高性能
*/


/*
// 用数组实现栈
class Stack {
    var stack: [AnyObject]
    var isEmpty: Bool { return stack.isEmpty }
    var peek: AnyObject? { return stack.last }
    
    init() {
        stack = [AnyObject]()
    }
    
    func push(object: AnyObject) {
        stack.append(object)
    }
    
    func pop() -> AnyObject? {
        if isEmpty {
            return nil
        } else {
            return stack.removeLast()
        }
    }
}

var stack = Stack()
print(stack.isEmpty)  //true
stack.push(object: NSNumber.init(value: 1))
stack.push(object: NSNumber.init(value: 2))
print(stack.isEmpty)  //false
print(stack.pop() ?? "empty")  // 2
print(stack.pop() ?? "empty")  // 1
print(stack.pop() ?? "empty")  // empty
*/


/*
let primeNums: Set = [3, 5, 7, 11, 13]
let oddNums: Set = [1, 3, 5, 7, 9]

let s1 = primeNums.intersection(oddNums)
print(s1) //交集 [5, 7, 3]

let s2 = primeNums.union(oddNums)
print(s2) //并集 [11, 5, 9, 3, 7, 13, 1]

let s3 = oddNums.subtracting(primeNums)
print(s3) //差集 [1, 9]
*/



// 利用字典和高阶函数计算字符串每个字符出现频率
print( Dictionary("hello".map { ($0, 1) }, uniquingKeysWith: +) )
// ["h": 1, "o": 1, "e": 1, "l": 2]
