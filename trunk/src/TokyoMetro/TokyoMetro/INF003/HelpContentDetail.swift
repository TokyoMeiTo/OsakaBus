//
//  HelpContentDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-11.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class HelpContentDetail: UIViewController {

    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    @IBOutlet weak var questionCHTitle: UILabel!
    @IBOutlet weak var questionJPTitle: UILabel!
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    // 中文求助内容
    var chTtile = ""
    // 日文求助内容
    var jpTtile = ""
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "INF003_06".localizedString()
        questionCHTitle.text = chTtile
        questionJPTitle.text = jpTtile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}