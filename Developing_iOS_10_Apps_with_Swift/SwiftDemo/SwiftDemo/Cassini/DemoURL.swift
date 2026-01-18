//
//  URL.swift
//
//  Created by CS193p Instructor.
//  Copyright (c) 2017 Stanford University. All rights reserved.
//

import Foundation

struct DemoURL
{
    static let stanford = URL(string: "http://stanford.edu/about/images/intro_about.jpg")

    static let NASA: Dictionary<String,URL> = {
         let NASAURLStrings = [
            "Cassini" : "https://gips2.baidu.com/it/u=1674525583,3037683813&fm=3028&app=3028&f=JPEG&fmt=auto?w=1024&h=1024",
            "Earth" : "https://gips3.baidu.com/it/u=3892227616,2240763844&fm=3028&app=3028&f=JPEG&fmt=auto?w=3200&h=3200",
            "Saturn" : "https://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960"
        ]
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
