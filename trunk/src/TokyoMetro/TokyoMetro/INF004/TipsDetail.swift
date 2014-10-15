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
    
    var favoFlag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "贴士详细"
        qTitle.text = cellTitle
        
        odbTips()
        
        if (rows.count > 0) {
        
            map = rows[0] as InfT02TipsTable
            qContent.text = map.item(INFT02_TIPS_CONTENT) as? String
            rowId = map.rowid
            favoFlag = map.item(INFT02_FAVO_FLAG) as String
            
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
    
    // 标记已阅读的贴士
    func readTips() {
        var table = InfT02TipsTable()
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT02_TIPS set READ_FLAG = '1',READ_TIME = \(time) where ROWID = \(rowId)")) {
            
        } else {
            
        }

    }
    
    // 收藏贴士
    @IBAction func collectTips() {
    
        var table = InfT02TipsTable()
        
        if (favoFlag == "1") {
            var sureBtn: UIAlertView = UIAlertView(title: "", message: "该贴士已收藏！", delegate: self, cancelButtonTitle: "确定")
            
            sureBtn.show()
            
            return
        }
        
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '1',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
            var sureBtn: UIAlertView = UIAlertView(title: "", message: "收藏成功！", delegate: self, cancelButtonTitle: "确定")
            
            sureBtn.show()
        } else {
            var sureBtn: UIAlertView = UIAlertView(title: "", message: "收藏失败！", delegate: self, cancelButtonTitle: "确定")
            
            sureBtn.show()
        }
    }

}
