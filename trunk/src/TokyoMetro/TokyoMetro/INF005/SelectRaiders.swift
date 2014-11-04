//
//  SelectRaiders.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-11.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class SelectRaiders: UIViewController {
    
    @IBOutlet weak var onlineBtn1: UIButton!
    @IBOutlet weak var onlineBtn2: UIButton!
    @IBOutlet weak var onlineBtn3: UIButton!
    @IBOutlet weak var outlineBtn1: UIButton!
    @IBOutlet weak var outlineBtn2: UIButton!
    @IBOutlet weak var outlineBtn3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "INF005_04".localizedString()
        
        onlineBtn1.addTarget(self, action: "onlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
        onlineBtn2.addTarget(self, action: "onlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
        onlineBtn3.addTarget(self, action: "onlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
        outlineBtn1.addTarget(self, action: "outlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
        outlineBtn2.addTarget(self, action: "outlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
        outlineBtn3.addTarget(self, action: "outlineClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func onlineClick(sender: UIButton) {
        var url = ""
        var txtTitle = ""
        if (sender.tag == 201) {
            url = "http://m.mafengwo.cn/travel-scenic-spot/mafengwo/10222.html"
            txtTitle = "INF005_01".localizedString()
        } else if (sender.tag == 202) {
            url = "http://m.ctrip.com/you/place/294"
            txtTitle = "INF005_02".localizedString()
        } else {
            url = "http://touch.go.qunar.com/300679?#"
            txtTitle = "INF005_03".localizedString()
        }
        
        var detail: RaidersDetail = self.storyboard?.instantiateViewControllerWithIdentifier("RaidersDetail") as RaidersDetail
        
        detail.url = url
        detail.isOpenPDF = false
        detail.txtTitle = txtTitle
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func outlineClick(sender: UIButton) {
        var pdfUrl = ""
        var txtTitle = ""
        if (sender.tag == 301) {
            pdfUrl = "mayiwo".getStrategyPDFPath()
            txtTitle = "INF005_01".localizedString()
        } else if (sender.tag == 302) {
            pdfUrl = "xiecheng".getStrategyPDFPath()
            txtTitle = "INF005_02".localizedString()
        } else {
            pdfUrl = "qunaer".getStrategyPDFPath()
            txtTitle = "INF005_03".localizedString()
        }
        
        var detail: RaidersDetail = self.storyboard?.instantiateViewControllerWithIdentifier("RaidersDetail") as RaidersDetail
        
        detail.url = pdfUrl
        detail.isOpenPDF = true
        detail.txtTitle = txtTitle
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
}