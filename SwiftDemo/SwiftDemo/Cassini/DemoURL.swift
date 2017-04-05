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

    static var NASA: Dictionary<String,URL> = {
         let NASAURLStrings = [
            "Cassini" : "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491369799466&di=862faf8a9b0d947f4e469a88d23028e2&imgtype=0&src=http%3A%2F%2Ffile06.16sucai.com%2F2016%2F0921%2Fda78bbfe5a27798a8d300f30d5ad594e.jpg",
            "Earth" : "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491369840769&di=383f36cf873b9df07265ade1845b7121&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F3%2F57c69ab296692.jpg",
            "Saturn" : "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491369921402&di=59da6d3bab5ad6f3d833427a76b4225d&imgtype=0&src=http%3A%2F%2Fimgstore.cdn.sogou.com%2Fapp%2Fa%2F100540002%2F514415.jpg"
        ]
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
