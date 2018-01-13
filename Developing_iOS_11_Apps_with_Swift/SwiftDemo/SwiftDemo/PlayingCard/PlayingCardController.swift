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
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right];
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
            
        }
        
    }
    
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
        
    }
    
    @objc func nextCard() {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        
//        for _ in 1...10 {
//            if let card = deck.draw() {
//                print("\(card)")
//            }
//        }
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
}

