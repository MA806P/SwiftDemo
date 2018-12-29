//
//  ViewController.swift
//  SwiftAppTest
//
//  Created by MA806P on 2018/12/22.
//  Copyright © 2018 myz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}








