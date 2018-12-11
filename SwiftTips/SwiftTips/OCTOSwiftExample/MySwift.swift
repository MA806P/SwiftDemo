//
//  MySwift.swift
//  OCTOSwiftExample
//
//  Created by MA806P on 2018/12/11.
//  Copyright © 2018 myz. All rights reserved.
//

import Foundation


class MySwiftClass: NSObject {
    func greeting(name: String) {
        print("Hello, \(name)")
    }
}

@objc(MySwiftOtherClass)
class 我的类: NSObject {
    @objc(greeting:)
    func 打招呼(名字: String) {
        print("你好，\(名字)")
    }
}

