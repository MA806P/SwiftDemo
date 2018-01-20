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
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        
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
