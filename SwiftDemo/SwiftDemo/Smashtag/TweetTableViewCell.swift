//
//  TweetTableViewCell.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/4/17.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    
    private func updateUI() {
        
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        if let tweetProfileImageViewURL = tweet?.user.profileImageURL {
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                if let urlContents = try? Data(contentsOf: tweetProfileImageViewURL) {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: urlContents)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        self.tweetCreatedLabel.text = "2017.4.20"
//        self.tweetUserLabel.text = "hello"
//        
//        
//        let text1 = "zhish"
//        let text2 = "zhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitian"
//        let text3 = "zhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitianzhishiyinweizairenqunzhongduokanleniyiyanzaiyebunengwangjinirongyanmengxiangzheourannengyouyitian"
//        
//        let index = arc4random()%3
//        switch index {
//        case 0:
//            self.tweetTextLabel.text = text1
//            self.tweetProfileImageView.backgroundColor = UIColor.green
//        case 1:
//            self.tweetTextLabel.text = text2
//            self.tweetProfileImageView.backgroundColor = UIColor.blue
//        case 2:
//            self.tweetTextLabel.text = text3
//            self.tweetProfileImageView.backgroundColor = UIColor.red
//        default:
//            self.tweetTextLabel.text = text1
//            self.tweetProfileImageView.backgroundColor = UIColor.gray
//        }
//    }

    
    
}
