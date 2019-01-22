//
//  MyClassExtension.swift
//  OCToSwift
//
//  Created by MA806P on 2019/1/22.
//  Copyright © 2019 myz. All rights reserved.
//

import Foundation

//“key 的类型在这里声明为了 Void?，并且通过 & 操作符取地址并作为 UnsafePointer<Void> 类型被传入。
//这在 Swift 与 C 协作和指针操作时是一种很常见的用法”
private var key: Void?


extension MyClass {
    var title: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
