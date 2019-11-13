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
//print( Dictionary("hello".map { ($0, 1) }, uniquingKeysWith: +) )
// ["h": 1, "o": 1, "e": 1, "l": 2]




//给定一个整数数组 和 一个目标值，找出数组中和为目标值的那两个整数，并返回数组下标
func twoSumExist(_ nums: [Int], _ target: Int) -> Bool {
    var set = Set<Int>()
    for num in nums {
        if set.contains(target - num) {
            return true
        }
        set.insert(num)
    }
    return false
}


func twoSumIndex(_ nums: [Int], _ target: Int) -> [Int] {
    var dict = [Int: Int]()
    for (i, num) in nums.enumerated() {
        if let index = dict[target - num] {
            return [index, i]
        } else {
            dict[num] = i
        }
    }
    fatalError()
}

let array = [1,3,4,5,6,7,8,9]
twoSumExist(array, 10) //true
twoSumIndex(array, 12) //[3, 5]




// 给出一个字符串，按照单词顺序进行反转。the sky is blue => blue is sky the
fileprivate func _swap<T>(_ chars: inout [T], _ p: Int, _ q: Int) {
    (chars[p], chars[q]) = (chars[q], chars[p])
}

fileprivate func _reverse<T>(_ chars: inout [T], _ start: Int, _ end: Int) {
    var start = start, end = end
    while start < end {
        _swap(&chars, start, end)
        start += 1
        end -= 1
    }
}

func reversWords(_ s: String?) -> String? {
    guard let s = s else {
        return nil
    }
    
    var chars = Array(s), start = 0
    _reverse(&chars, 0, chars.count - 1)
    
    for i in 0 ..< chars.count {
        if i == chars.count - 1 || chars[i + 1] == " " {
            _reverse(&chars, start, i)
            start = i + 2
        }
    }
    
    return String(chars)
}

var str = "the sky"
var chars = Array(str)
 _reverse(&chars, 0, chars.count - 1) //y k s    e h t

reversWords("the sky is blue") //"blue is sky the"


