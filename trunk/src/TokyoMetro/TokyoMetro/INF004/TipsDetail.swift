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
    @IBOutlet weak var qContent: UITextView!
    
    var cellTitle: String = ""
    var tips_id: String = ""
    var rows: NSArray!
    var rowId: String = ""
    var map: InfT02TipsTable!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "贴士详细"
        qTitle.text = cellTitle
        
        odbTips()
        
        if (rows.count > 0) {
        
            map = rows[0] as InfT02TipsTable
            qContent.text = map.item(INFT02_TIPS_CONTENT) as? String
            rowId = map.rowid
            
            readTips()
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
    
    func readTips() {
        var table = InfT02TipsTable()
//        table.rowid = rowId

//        table.readTime = "20140929135320"
//        table.readFlag = "1"
//        table.favoTime = ""
//        table.favoFlag = "1"
        
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT02_TIPS set READ_FLAG = '1',READ_TIME = \(time) where ROWID = \(rowId)")) {
            println("更新成功")
        } else {
            println("更新失败")
        }

    }
    
    @IBAction func collectTips() {
    
        var table = InfT02TipsTable()
        
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '1',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
            println("更新成功")
        } else {
            println("更新失败")
        }
    }

}
