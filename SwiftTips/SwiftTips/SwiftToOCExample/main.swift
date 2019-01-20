//
//  main.swift
//  SwiftToOCExample
//
//  Created by MA806P on 2018/12/11.
//  Copyright © 2018 myz. All rights reserved.
//

import Foundation

print("Hello, World!")

var myObject = MyObject();
myObject.name = "zhishiyinwei"
print("my object name = \(myObject.name)")
//my object name = Optional("zhishiyinwei")


// 利用 OC 中 C 的库 CommonCrypto 的 CC_MD5 进行 MD5 加密
extension String {
    var MD5: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        if let data = data(using: .utf8) {
            data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
        
    }
}


print("swift".MD5) //818056dbd7e201243206b9c7cd88481c

// swift 自己实现 CommonCrypto 的功能 https://github.com/krzyzanowskim/CryptoSwift
//暂时建议尽量使用现有的经过时间考验的 C 库，一方面 Swift 还年轻，三方库的引入和依赖机制不很成熟，另外使用动态库至少可以减少APP大小




// swift 中使用 C
let result = test(3)
print(result) //4


/*
//不需要借助头文件和 Bridging-Header 来导入 C 函数的方法，
//那就是使用 Swift 中的一个隐藏的符号 @asmname。
//@asmname 可以通过方法名字将某个 C 函数直接映射为 Swift 中的函数

@asmname("test") func c_test(a: Int32) -> Int32

func testSwift(input: Int32) {
    let result = c_test(input)
    print(result)
}
testSwift(input: 1)
 
 “这种导入在第三方 C 方法与系统库重名导致调用发生命名冲突时，可以用来为其中之一的函数重新命名以解决问题。
 当然我们也可以利用 Module 名字 + 方法名字的方式来解决这个问题。
 
 除了作为非头文件方式的导入之外，@asmname 还承担着和 @objc 的 “重命名 Swift 中类和方法名字” 类似的任务，
 这可以将 C 中不认可的 Swift 程序元素字符重命名为 ascii 码，以便在 C 中使用。”
 
 
 @asmname 不能用
 */



