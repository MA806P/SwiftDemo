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
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
        
        
        
        
    }

    

}
