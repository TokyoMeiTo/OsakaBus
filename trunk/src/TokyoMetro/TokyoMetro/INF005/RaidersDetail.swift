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
    
    var request: NSURLRequest!
    
    var progress: UIActivityIndicatorView!
    
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
        
        request = NSURLRequest(URL: urlPath)
        
        progress = UIActivityIndicatorView()
        progress.frame = CGRectMake(140, 264, 40, 40)
        
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        progress.hidesWhenStopped = true
        
        self.view.addSubview(progress)
        
        progress.startAnimating()
        
        webView.loadRequest(request)

    }

    func webViewDidFinishLoad(webView: UIWebView) {
        progress.stopAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
