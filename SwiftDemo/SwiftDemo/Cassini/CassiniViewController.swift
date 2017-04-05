//
//  CassiniViewController.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/3/31.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    // for the UISplitViewControllerDelegate method below to work
    // we have to set ourself as the UISplitViewController's delegate
    // (only we can be that because ImageViewControllers come and goes from the heap)
    // we could probably get away with doing this as late as viewDidLoad
    // but it's a bit safer to do it as early as possible
    // and this is as early as possible
    // (we just came out of the storyboard and "awoke" so we know we are in our UISplitViewController by now)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
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
    
    
    // this delegate method of UISplitViewController
    // allows the delegate to do the work of collapsing the primary view controler (the master)
    // on top of the secondary view controller (the detail)
    // this happens whenever the split view wants to show the detail
    // but the master is on screen in a spot that would be covered up by the detail
    // the return value of this delegate method is a Bool
    // "true" means "yes, Mr. UISplitViewController, I did collapse that for you"
    // "false" means "sorry, Mr. UISplitViewController, I couldn't collapse so you do it for me"
    // if our secondary (detail) is an ImageViewController with a nil imageURL
    // then we will return true even though we're not actually going to do anything
    // that's because when imageURL is nil, we do NOT want the detail to collapse on top of the master
    // (that's the whole point of this)
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.imageURL == nil{
                return true
            }
        }
        return false
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
