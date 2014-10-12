//
//  LinkWebSite.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-10-10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class LinkWebSite : UIViewController {
    
    @IBOutlet weak var mWebView: UIWebView!
    
    var linkWebTitle :String = ""
    var linkWebSite :String = ""
    
    @IBOutlet weak var showServera: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = linkWebTitle
        
        let url = NSURL.URLWithString(linkWebSite)
        let request = NSURLRequest(URL:url)
        self.mWebView!.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}