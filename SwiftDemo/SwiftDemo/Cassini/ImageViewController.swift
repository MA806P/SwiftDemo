//
//  ImageViewController.swift
//  SwiftDemo
//
//  Created by MA806P on 2017/3/29.
//  Copyright © 2017年 myz. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    //MARK: Model
    
    var imageURL : URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    //MARK: Private Implementation
    
    private func fetchImage() {
        if let url = imageURL {
            
            // we're going to start something on another queue soon
            // so let's start a spinner going in the UI to let the user know
            // we'll stop this any time an image actually gets set
            // (we'd never want the spinner and an image appearing at the same time!)
            spinner.startAnimating()
            
            // try? Data(contentsOf:) blocks the thread it is on
            // we are currently on the main thread
            // so we must dispatch that call off to a background queue
            // we'll use one of the shared, global, concurrent background queues
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                let urlContents = try? Data(contentsOf: url)
                // now that we're back from blocking
                // are we still even interested in this url
                if let imageData = urlContents, url == self?.imageURL {
                    
                    // now we want to set the image in the UI
                    // but we are not on the main thread right now
                    // so we are not allowed to do UI
                    // no problem: just dispatch the UI stuff back to the main queue
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    //MARK: View Controller Lifecycle
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageURL = DemoURL.stanford
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    //MARK: User Interface
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }

    //使用 fileprivate 来暴露内部接口, 用 private 来进行内部实现
    /*
     在swift 3中，新增加了一个 fileprivate来显式的表明，这个元素的访问权限为文件内私有。
     过去的private对应现在的fileprivate。
     现在的private则是真正的私有，离开了这个类或者结构体的作用域外面就无法访问。
     */
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // careful here because scrollView might be nil
            scrollView?.contentSize = imageView.frame.size
            
            // now that we've set an image
            // stop any spinner that exists from spinning
            spinner?.stopAnimating()
        }
        
    }
}


//MARK: UIScrollViewDelegate
//Extension which makes ImageViewController conform to UIScrollViewDelegate
//Handles viewForZooming(in scrollView:)
//by returning the UIImageView as the view ro transform when zooming
extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
