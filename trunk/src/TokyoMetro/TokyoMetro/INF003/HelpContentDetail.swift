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
    
    var rowId: String = ""
    
    var favoFlag: String?
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "INF003_06".localizedString()
        questionCHTitle.text = chTtile
        questionJPTitle.text = jpTtile
        
        readHelpContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*******************************************************************************
    *      IBActions
    *******************************************************************************/
    
    // 收藏贴士
    @IBAction func collectHelpContent() {
        
        if (!checkTips(rowId)) {
            return
        }
        var table = InfT03RescureTable()
        
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        if (favoFlag == "1") {
            
            if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '0',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
                favoFlag == "0"
            } else {
                
            }
            
        } else {
            if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '1',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
                favoFlag == "1"
            } else {
                
            }
        }

    }
    
    func checkTips(rowid: String?) -> Bool{
        if (rowid == nil || rowid == "") {
            return false
        } else {
            var table = InfT03RescureTable()
            table.rowid = rowid!
            var rowIdArr = table.selectAll()
            if (rowIdArr.count > 0) {
                return true
            } else {
                return false
            }
        }
    }

    // 标记已阅读的贴士
    func readHelpContent() {
        var table = InfT03RescureTable()
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT03_RESCURE set READ_FLAG = '1',READ_TIME = \(time) where ROWID = \(rowId)")) {
            
        } else {
            
        }
        
    }
    
}