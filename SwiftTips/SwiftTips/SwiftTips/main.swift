//
//  main.swift
//  SwiftTips
//
//  Created by MA806P on 2018/9/28.
//  Copyright © 2018年 myz. All rights reserved.
//

import Foundation

print("Hello, World!")

//Swift 里可以将方法进行柯里化 (Currying)，
//这是也就是把接受多个参数的方法进行一些变形，使其更加灵活的方法。

func addOne(num: Int) -> Int {
    return num + 1
}

func addTo(_ adder: Int) -> (Int) -> Int {
    return {
        num in
        return num + adder
    }
}
let addTwo = addTo(2)
let result = addTwo(6) //8


func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}
let greaterThan10 = greaterThan(10)
print("\(greaterThan10(13))") // true






// -----------------------------

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction()-> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    
    func setTarget<T: AnyObject>(target: T, action: @escaping(T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
    
}

