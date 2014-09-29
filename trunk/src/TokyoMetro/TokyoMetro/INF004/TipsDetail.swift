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
    var tips_id: String = ""
    var rows: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qTitle.text = cellTitle
        
        odbTips()
        
        if (rows.count > 0) {
        
             var map = rows[0] as InfT02TipsTable
             println(map.item(INFT02_TIPS_CONTENT))
        }
       
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbTips() {
        var table = InfT02TipsTable()
        table.tipsId = tips_id
        rows = table.selectAll()
    }
    
    
    
}
