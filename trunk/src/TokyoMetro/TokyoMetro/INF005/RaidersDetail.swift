//
//  RaidersDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-11.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class RaidersDetail: UIViewController,UIWebViewDelegate {
    
    var url = ""
    var isOpenPDF: Bool = false
    var txtTitle = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = txtTitle
        var urlPath: NSURL!
        if (isOpenPDF) {
            urlPath = NSURL.fileURLWithPath(url)
        } else {
            urlPath = NSURL.URLWithString(url)
        }
        var request: NSURLRequest = NSURLRequest(URL: urlPath)
        
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
