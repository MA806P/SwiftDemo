//
//  ConcentrationThemeChooseController.swift
//  SwiftDemo
//
//  Created by MA806P on 2018/1/20.
//  Copyright © 2018年 MYZ. All rights reserved.
//

import UIKit

class ConcentrationThemeChooseController: UIViewController, UISplitViewControllerDelegate {
    
    
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓",
        "Faces": "😀😆☺️😇🤣😍😎🤠😱😷",
        "Animals": "🐶🐱🦊🐷🙊🐔🦄🐝🐙🐡" ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self;
    }
    
    
    // This method is called when a split view controller is collapsing its children for a transition to a compact-width size class. Override this
    // method to perform custom adjustments to the view controller hierarchy of the target controller.  When you return from this method, you're
    // expected to have modified the `primaryViewController` so as to be suitable for display in a compact-width split view controller, potentially
    // using `secondaryViewController` to do so.  Return YES to prevent UIKit from applying its default behavior; return NO to request that UIKit
    // perform its default collapsing behavior.
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        
        //this small size iPhone, first come in show theme choose view
        //if return true, system will not push secondaryViewController onto primaryViewController
        if let cvc = secondaryViewController as? ConcentrationController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationController {
            //this is iPhone case donnot destroy before cvc and then push to last cvc the cards stay last status
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationController: ConcentrationController? {
        return splitViewController?.viewControllers.last as? ConcentrationController
    }
    
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationController: ConcentrationController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Choose Theme" {
            
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationController {
                    cvc.theme = theme
                    lastSeguedToConcentrationController = cvc
                }
            }
            
        }
    }
    
    
    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
