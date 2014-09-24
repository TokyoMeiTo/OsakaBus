//
//  ShopDetial.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class ShopDetial : UIViewController
{
    
    @IBOutlet weak var webview: UIWebView!
    var items : NSArray!
    
    var webSite:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = NSURL.URLWithString(webSite)
        var request = NSURLRequest(URL: url)
        self.webview.loadRequest(request)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}