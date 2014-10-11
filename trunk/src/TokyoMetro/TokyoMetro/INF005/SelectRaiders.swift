//
//  SelectRaiders.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-11.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class SelectRaiders: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func onlineClick(sender: UIButton) {
        var url = ""
        if (sender.tag == 201) {
            url = "http://m.mafengwo.cn/travel-scenic-spot/mafengwo/10222.html"
        } else if (sender.tag == 202) {
            url = "http://m.ctrip.com/you/place/294"
        } else {
            url = "http://touch.go.qunar.com/300679?#"
        }
        
        
    }
    
    func outlineCli(sender: UIButton) {
        var pdfUrl = ""
        
        if (sender.tag == 201) {
            pdfUrl = "mayiwo".getStrategyPDFPath()
        } else if (sender.tag == 202) {
            pdfUrl = "xiecheng".getStrategyPDFPath()
        } else {
            pdfUrl = "qunaer".getStrategyPDFPath()
        }
    }
    
}