//
//  ConcentrationController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 2017/11/18.
//  Copyright © 2017年 MYZ. All rights reserved.
//

import UIKit

class ConcentrationController: UIViewController {

    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var emojiChoices = ["🐶", "🐱", "🦊", "🐷"]
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        } else {
            print("chose card was not in cardButtons")
        }
        
    }
    
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }

    @IBAction func pageClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
