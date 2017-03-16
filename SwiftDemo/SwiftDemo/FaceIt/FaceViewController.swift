//
//  FaceViewController.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/3/6.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
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
    
    
    @IBOutlet weak var faceView: FaceView!
    
    

}
