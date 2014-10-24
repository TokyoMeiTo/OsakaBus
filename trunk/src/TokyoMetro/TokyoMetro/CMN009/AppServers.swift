//
//  AppServers.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-28.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class AppServerse : UIViewController {

    @IBOutlet weak var txtServer: UITextView!
    @IBOutlet weak var viewServer: UIView!
    @IBOutlet weak var txtDuty: UITextView!
    @IBOutlet weak var viewDuty: UIView!
    var pagTag : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (pagTag == 1) {
            self.title = "CMN009_01".localizedString()
            viewServer.hidden = false
            txtServer.hidden = false
            txtDuty.hidden = true
            viewDuty.hidden = true
        
        } else {
            self.title = "免责声明"
            txtServer.hidden = true
            viewServer.hidden = true
            txtDuty.hidden = false
            viewDuty.hidden = false
        
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
 