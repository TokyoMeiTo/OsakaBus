//
//  TipsDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class TipsDetail: UIViewController {

    
    @IBOutlet weak var qTitle: UILabel!
    
    var cellTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qTitle.text = cellTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
