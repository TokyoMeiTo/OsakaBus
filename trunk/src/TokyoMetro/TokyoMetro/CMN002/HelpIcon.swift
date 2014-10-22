//
//  File.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-10-16.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class HelpIcon : UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CMN002_01".localizedString()
        
        scrollView.zoomScale = 1.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        
        for view in scrollView.subviews {
            if (view.isKindOfClass(UIImageView)) {
                return view as UIView
            }
        }
        
        return nil
    }
    
}