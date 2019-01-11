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

