import Cocoa

// 动态规划
// 对于复杂问题无法一下就能解决，需要分解为一个个简单具体的小问题，通过小问题求出最终解。多米诺骨牌
// 分析出，初始状态和状态转移方程


// 斐波那契数列，1 1 2 3 5 8 13 21 34 55 ...
// 动态转移方程  f(n) = f(n-1) + f(n-2)


func Fib(_ n: Int) -> Int {
    guard n > 0 else {
        return 0
    }
    
    if n == 1 || n == 2 {
        return 1
    }
    
    return Fib(n - 1) + Fib(n - 2)
}
print("Fib(10) = \(Fib(10))") //Fib(10) = 55


//上面的方法会重复计算
var nums = Array(repeating: -1, count: 100)
print(nums.count)
func Fib2(_ n: Int) -> Int {
    guard n > 0 || n <= 90 else {
        return 0
    }
    
    if n == 1 || n == 2 {
        return 1
    }
    
    if nums[n - 1] != -1 {
        return nums[n - 1]
    }
    
    nums[n - 1] = Fib2(n - 1) + Fib2(n - 2)
    //print(nums)
    return nums[n - 1]
}
print("Fib2(90) = \(Fib2(90))") //Fib2(90) = 2880067194370816120
//大于 93 数据太大了，数据溢出了



//动态规划需要注意的问题
//栈溢出：可把栈写成循环，所有的递归都能都可改写成循环的形式
//数据溢出：在每次计算中加入数据溢出检测，终止计算，抛出异常
