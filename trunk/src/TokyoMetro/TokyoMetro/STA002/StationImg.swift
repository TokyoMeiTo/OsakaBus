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
    
    var size: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = UIScreen.mainScreen().bounds.size
        
        scroll.frame = CGRectMake(0, 0, size.width, size.height)
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 3.0
        
        scroll.zoomScale = 2.0
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        
        for view in scrollView.subviews {
            if (view.isKindOfClass(UIImageView)) {
                return view as UIView
            }
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
