//
//  DispatchWorkItem.swift
//  SwiftAppTest
//
//  Created by MA806P on 2018/12/22.
//  Copyright © 2018 myz. All rights reserved.
//

import Foundation

typealias Task = (_ cancel: Bool) -> Void

//“对于 block 的调用是同步行为。如果我们改变一下代码，将 block 放到一个 Dispatch 中去，
//让它在 doWork 返回后被调用的话，我们就需要在 block 的类型前加上 @escaping 标记来表明这个闭包是会“逃逸”出该方法的：

func delayBling(_ time: TimeInterval, task: @escaping()->()) -> Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure :(()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
   
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}


func canelBling(_ task: Task?) {
    task?(true)
}

