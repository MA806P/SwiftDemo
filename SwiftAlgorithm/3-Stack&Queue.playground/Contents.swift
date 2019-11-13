import Cocoa


// 在 Swift 中没有内设的栈和队列，很多扩展库中使用 Generic Type 来实现栈和队列。
//正规做法是用链表来实现，这样可以保证加入或删除的时间复杂度是 O(1)
//swift 中数组有很多 API 可直接使用，用来实现栈很方便

protocol Stack {
    associatedtype Elemt  // 持有的元素类型
    var isEmpty: Bool { get }
    var size: Int { get }
    var peek: Elemt? { get }
    mutating func push(_ value: Elemt)
    mutating func pop() -> Elemt?
}

struct IntStack: Stack {
    typealias Elemt = Int
    private var stack = [Elemt]()
    
    var isEmpty: Bool { return stack.isEmpty }
    var size: Int { return stack.count }
    var peek: Elemt? { return stack.last }
    
    mutating func push(_ value: Int) {
        stack.append(value)
    }
    
    mutating func pop() -> Int? {
        return stack.popLast()
    }
}

/*
var stack = IntStack()
print("stack \(stack.isEmpty) \(stack.size) \(stack.peek ?? -1) \n") //stack true 0 -1
stack.push(0)
stack.push(1)
print("stack \(stack.isEmpty) \(stack.size) \(stack.peek ?? -1) \n") //stack false 2 1
print(stack.pop() ?? -1) //Optional(1)
*/



//队列先进先出

protocol Queue {
    associatedtype Elemt  // 持有的元素类型
    var isEmpty: Bool { get }
    var size: Int { get }
    var peek: Elemt? { get }
    mutating func enqueue(_ value: Elemt)
    mutating func dequeue() -> Elemt?
}

struct IntQueue: Queue {
    typealias Elemt = Int
    private var left = [Elemt]()
    private var right = [Elemt]()
    
    var isEmpty: Bool { return left.isEmpty && right.isEmpty }
    var size: Int { return left.count + right.count }
    var peek: Elemt? { return left.isEmpty ? right.first : left.last }
    
    mutating func enqueue(_ value: Elemt) {
        right.append(value)
    }
    
    mutating func dequeue() -> Elemt? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

struct StringQueue: Queue {
    typealias Elemt = String
    private var queue = [Elemt]()
    
    var isEmpty: Bool { return queue.isEmpty }
    var size: Int { return queue.count }
    var peek: Elemt? { return queue.first }
    
    mutating func enqueue(_ value: Elemt) {
        queue.append(value)
    }
    
    mutating func dequeue() -> Elemt? {
        guard queue.count > 0 else {
            return nil
        }
        return queue.removeFirst()
    }
}

/*
var intQueue = IntQueue()
print("queue \(intQueue.isEmpty) \(intQueue.size) \(intQueue.peek ?? -1) \n") //queue true 0 -1
intQueue.enqueue(0)
intQueue.enqueue(1)
print("queue \(intQueue.isEmpty) \(intQueue.size) \(intQueue.peek ?? -1) \n") //queue false 2 0
print(intQueue.dequeue() ?? -1) //0
print(intQueue.dequeue() ?? -1) //1
print(intQueue.dequeue() ?? -1) //-1


var stringQueue = StringQueue()
print("queue \(stringQueue.isEmpty) \(stringQueue.size) \(stringQueue.peek ?? "-1") \n") //queue true 0 -1
stringQueue.enqueue("0")
stringQueue.enqueue("1")
print("queue \(stringQueue.isEmpty) \(stringQueue.size) \(stringQueue.peek ?? "-1") \n") //queue false 2 0
print(stringQueue.dequeue() ?? "-1") //0
print(stringQueue.dequeue() ?? "-1") //1
print(stringQueue.dequeue() ?? "-1") //-1
*/



// 栈和队列互相转换

// 用栈实现队列
struct MyQueue {
    private var stackA: IntStack
    private var stackB: IntStack
    
    var isEmpty: Bool { return stackA.isEmpty && stackB.isEmpty }
    var size: Int { return stackA.size + stackB.size }
    var peek: Int? {
        mutating get {
            shift()
            return stackB.peek
        }
    }
    
    init() {
        stackA = IntStack()
        stackB = IntStack()
    }
    
    mutating func enqueue(_ value: Int) {
        stackA.push(value)
    }
    
    mutating func dequeue() -> Int? {
        shift()
        return stackB.pop()
    }
    
    fileprivate mutating func shift() {
        if stackB.isEmpty {
            while stackA.isEmpty == false {
                stackB.push(stackA.pop()!)
            }
        }
    }
    
}

/*
var myQueue = MyQueue()
print("myQueue \(myQueue.isEmpty) \(myQueue.size) \(myQueue.peek ?? -1) \n") //myQueue true 0 -1
myQueue.enqueue(0)
myQueue.enqueue(1)
print("myQueue \(myQueue.isEmpty) \(myQueue.size) \(myQueue.peek ?? -1) \n") //myQueue false 2 0
print(myQueue.dequeue() ?? -1) //0
myQueue.enqueue(2)
print(myQueue.dequeue() ?? -1) //1
print(myQueue.dequeue() ?? -1) //2
print(myQueue.dequeue() ?? -1) //-1
*/

//用队列实现栈。这里要注意，容易混淆，最好画个图直观感受一下
struct MyStack {
    private var queueA = IntQueue()
    private var queueB = IntQueue()
    
    var isEmpty: Bool { return queueA.isEmpty && queueB.isEmpty }
    var size: Int { return queueA.size }
    var peek: Int? {
        mutating get {
            shift()
            let tmpPeek = queueA.peek
            if tmpPeek != nil {
                queueB.enqueue(queueA.dequeue()!)
                swap()
            }
            return tmpPeek
        }
    }
    
    mutating func push(_ value: Int) {
        queueA.enqueue(value)
    }
    
    mutating func pop() -> Int? {
        shift()
        let tmpPop = queueA.dequeue()
        swap()
        return tmpPop
    }
    
    
    fileprivate mutating func shift() {
        while queueA.size > 1 {
            queueB.enqueue(queueA.dequeue()!)
        }
    }
    
    fileprivate mutating func swap() {
        (queueA, queueB) = (queueB, queueA)
    }
    
}

/*
var myStack = MyStack()
print("myStack \(myStack.isEmpty) \(myStack.size) \(myStack.peek ?? -1) \n") //myStack true 0 -1
myStack.push(0)
myStack.push(1)
print("myStack \(myStack.isEmpty) \(myStack.size) \(myStack.peek ?? -1) \n") //myStack false 2 1
print(myStack.pop() ?? -1) //1
myStack.push(2)
print(myStack.pop() ?? -1) //2
print(myStack.pop() ?? -1) //0
print(myStack.pop() ?? -1) //-1
*/




// 给出一个文件的绝对路径，将其简化。"/home/" -> "/home"  "/a/./b/../../c/" -> "/c"
//"." 代表当前路径 "/a/." == "/a";  ".." 代表上一级目录 "/a/b/.." == "/a"
//先根据/对路径进行拆分成数组，然后入栈，遇到 .. 就出栈

func simplifyPath(path: String) -> String {
    
    var pathStack = [String]()
    let paths = path.components(separatedBy: "/")
    
    for path in paths {
        guard path != "." else {
            continue
        }
        if path == ".." {
            if pathStack.count > 0 {
                pathStack.removeLast()
            }
        } else if path != "" {
            pathStack.append(path)
        }
    }
    
    let result = pathStack.reduce("") { total, dir in "\(total)/\(dir)"}
    return result.isEmpty ? "/" : result
}

let path = "/a/./b/../../c/"
print(simplifyPath(path: path)) // /c
