//
//  TipsDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class TipsDetail: UIViewController {

    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    @IBOutlet weak var qTitle: UILabel!
    @IBOutlet weak var qContent: UITextView!
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    var cellTitle: String = ""
    var tips_id: String = ""
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    var rows: NSArray!
    var rowId: String = ""
    var map: InfT02TipsTable!
    
    var favoFlag: String = ""
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "INF004_04".localizedString()
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
    
    
    /*******************************************************************************
    *      IBActions
    *******************************************************************************/
    
    // 收藏贴士
    @IBAction func collectTips(barButton: UIBarButtonItem) {
        
        if (!checkTips(rowId)) {
            return
        }
        var table = InfT02TipsTable()
        
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        if (favoFlag == "1") {

            if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '0',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
                favoFlag == "0"
                barButton.setBackgroundImage(UIImage(named: "collect-01"), forState: UIControlState.Normal, style: UIBarButtonItemStyle.Bordered, barMetrics: UIBarMetrics.Default)
            } else {
                
            }

        } else {
            if (table.excuteUpdate("update INFT02_TIPS set FAVO_FLAG = '1',FAVO_TIME = \(time) where ROWID = \(rowId)")) {
                favoFlag == "1"
                barButton.setBackgroundImage(UIImage(named: "route_collectionlight"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
            } else {
                
            }
        }

    }

    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    func odbTips() {
        var table = InfT02TipsTable()
        table.tipsId = tips_id
        rows = table.selectAll()
    }
    
    func checkTips(rowid: String?) -> Bool{
        if (rowid == nil || rowid == "") {
            return false
        } else {
            var table = InfT02TipsTable()
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
    func readTips() {
        var table = InfT02TipsTable()
        var time:String = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
        
        if (table.excuteUpdate("update INFT02_TIPS set READ_FLAG = '1',READ_TIME = \(time) where ROWID = \(rowId)")) {
            
        } else {
            
        }

    }
    
    
}
