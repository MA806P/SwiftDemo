//
//  FaceView.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/3/7.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class FaceView: UIView {

    
    var scale: CGFloat = 0.9
    
    var lineWidth: CGFloat = 5.0
    
    var color: UIColor = UIColor.blue
    
    var eyesOpen: Bool = true
    
    var mouthCurvature: Double = 0.5
    
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) * 0.5 * scale
    }
    
    
    private enum Eye {
        case left
        case right
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWith: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        path.stroke()
        
        
    }
    

}
