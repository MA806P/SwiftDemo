//
//  TestViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/3/15.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet var buttonCollect: [UIButton]! {
        didSet {
            //https://github.com/jinxiansen/JJHUD
            
            buttonCollect.forEach {
                $0.isHidden = true
            }
        }
    }
    
    func showButtonBegan() {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.buttonCollect.forEach({ $0.isHidden = !$0.isHidden })
        }, completion: nil)
        
    }
    
    @IBOutlet weak var showButton: UIButton!
    
    @IBAction func hideAndShow(_ sender: UIButton) {
        showButtonBegan()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showButtonBegan()
    }

}
