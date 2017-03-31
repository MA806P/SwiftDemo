//
//  CassiniViewController.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/3/31.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageVC = (segue.destination.contents as? ImageViewController) {
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navcom = self as? UINavigationController {
            return navcom.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}
