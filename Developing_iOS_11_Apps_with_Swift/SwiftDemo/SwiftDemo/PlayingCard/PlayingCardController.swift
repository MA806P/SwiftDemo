//
//  PlayingCardController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 2018/1/3.
//  Copyright © 2018年 MYZ. All rights reserved.
//

import UIKit

class PlayingCardController: UIViewController {

    var deck = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let closeBtn = UIButton(frame: CGRect(x:20, y:20, width:40, height:40))
        closeBtn.setTitle("X", for: .normal)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(PlayingCardController.closeBtnAction), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
        
        
        
        
    }
    
    @objc func closeBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }

    

}

