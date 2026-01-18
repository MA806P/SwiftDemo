//
//  FaceViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/3/6.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    private let mouthCurvature = [FacialExpression.Mouth.grin:0.5, .frown:-1.0, .smile:1.0, .neutral:0.0, .smirk:0.5]
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
        
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI()
        }
    }
    
    
    @objc func increaseHappiness() {
        expression = expression.happier
    }
    
    @objc func decreaseHappiness() {
        expression = expression.sadder
    }
    
    @objc func toggleEyes(byReactiongTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            
            let pinchRecoginzer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(byReactingTo:)))
            faceView.addGestureRecognizer(pinchRecoginzer)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactiongTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            updateUI()
        }
    }
    
    

}
