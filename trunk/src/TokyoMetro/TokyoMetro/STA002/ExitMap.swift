//
//  ExitMap.swift
//  TableViewTest
//
//  Created by caowj on 14-9-12.
//  Copyright (c) 2014年 rhinoIO. All rights reserved.
//

import UIKit


class ExitMap: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var scroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "银座线"
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 2.0
        
        scroll.zoomScale = 1.0
        
        segment.setTitle("涉谷放向", forSegmentAtIndex: 0)
        segment.setTitle("浅草放向", forSegmentAtIndex: 1)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentChnagedListener(sender: UISegmentedControl) {
    
        if (sender.selectedSegmentIndex == 0) {
        
            let img: UIImage = UIImage(named:"00000665_hanzomon_L_1.png")
            image.image = img
        } else {
            let img: UIImage = UIImage(named:"00000665_hanzomon_R_1.png")
            image.image = img
        }
        
        scroll.zoomScale = 1.0
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        
        for view in scroll.subviews {
            if (view.isKindOfClass(UIImageView)) {
            
                return view as UIView
            }
        
        }
        
        return nil
    }
    
}