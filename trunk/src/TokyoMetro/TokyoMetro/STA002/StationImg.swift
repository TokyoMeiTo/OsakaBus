//
//  StationMap.swift
//  TableViewTest
//
//  Created by caowj on 14-9-11.
//  Copyright (c) 2014年 rhinoIO. All rights reserved.
//

import UIKit

class StationImg: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    var progress: UIActivityIndicatorView!
    
    var size: CGSize!
    
    var stationMapUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "站内结构图"
        
        size = UIScreen.mainScreen().bounds.size
        
        scroll.frame = CGRectMake(0, 0, size.width, size.height)
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 3.0
        
        scroll.zoomScale = 1.0
        
        progress = UIActivityIndicatorView()
        progress.frame = CGRectMake(140, 264, 40, 40)
        
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        progress.hidesWhenStopped = true
        
        self.view.addSubview(progress)
        
        progress.startAnimating()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        imageView.image = addMap()
        
        scroll.addSubview(imageView)
        
        progress.stopAnimating()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        
        for view in scrollView.subviews {
            if (view.isKindOfClass(UIImageView)) {
                return view as UIView
            }
        }
        
        return nil
    }
    
    
    func addMap() -> UIImage{
 
        var image = UIImage(named: stationMapUrl)
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
