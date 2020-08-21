//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"


let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
label.backgroundColor = .white
label.font = UIFont.systemFont(ofSize: 32)
label.textAlignment = .center
label.text = "Hello World!!!!"
PlaygroundPage.current.liveView = label




