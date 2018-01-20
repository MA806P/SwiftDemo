//
//  ConcentrationThemeChooseController.swift
//  SwiftDemo
//
//  Created by MA806P on 2018/1/20.
//  Copyright © 2018年 MYZ. All rights reserved.
//

import UIKit

class ConcentrationThemeChooseController: UIViewController {
    
    // MARK: - Navigation
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓",
        "Faces": "😀😆☺️😇🤣😍😎🤠😱😷",
        "Animals": "🐶🐱🦊🐷🙊🐔🦄🐝🐙🐡" ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Theme Segue" {
            
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationController {
                    cvc.theme = theme
                }
            }
            
        }
        
        
    }
    

}
