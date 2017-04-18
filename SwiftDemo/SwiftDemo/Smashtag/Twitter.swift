//
//  Twitter.swift
//  SwiftDemo
//
//  Created by 159CaiMini02 on 17/4/18.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class Twitter: NSObject {
    
    struct Tweet {
        let text: String
        let created: String
        let user: User
    }
    
    struct User {
        let description: String
        let profileImageURL: String
    }
    
    
    var text: String?
    var tweet: Tweet?
    
    
}

