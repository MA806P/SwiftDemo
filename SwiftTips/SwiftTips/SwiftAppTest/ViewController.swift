//
//  ViewController.swift
//  SwiftAppTest
//
//  Created by MA806P on 2018/12/22.
//  Copyright © 2018 myz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MyClassDelegate {
    
    var myClass: MyClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myClass: MyClass = MyClass()
        myClass.delegate = self
        
    }
    
    func delegateMethod() {
        print("MyClassDelegate Method")
    }
    
    
    
    @IBAction func delayCallAction(_ sender: Any) {
        
        print(Date())
        
        // GCD 延时调用
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            print(Date())
            print("2 秒后输出")
        }
        
        //封装的方法
        let task = delayBling(5, task: {print("do something")})
        //取消
        canelBling(task)
    }
    
    
    
    @IBAction func delegateCallAction(_ sender: UIButton) {
        self.delegateMethod()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


protocol MyClassDelegate: class {
    func delegateMethod()
}

class MyClass {
    weak var delegate: MyClassDelegate?
}








