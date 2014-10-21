//
//  Sta002StationDetailModel.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class Sta002StationDetailModel {

    func timeFormat(time: NSArray) -> String{
        
        if (time.count < 2){
            return ""
        }
        
        var startTime: String = ""
        var endTime: String = ""
        var strTime: String = ""
        for key in time {
            key as LinT01TrainScheduleTrainTable
            var trainFlag: String = key.item(LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG) as String
            
            if (trainFlag == "1") {
                startTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
            } else if (trainFlag == "9") {
                
                if (strTime == "") {
                    strTime = key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String
                } else {
                    var string: Int! = strTime.toInt()
                    if (string < 400) {
                        string = string + 2400
                    }
                    var string2: Int! = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).toInt()
                    if (string2 < 400) {
                        string2 = string2 + 2400
                    }
                    
                    if (string2 > string) {
                        strTime = key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String
                    }
                }
            }
        }
        endTime = strTime.dateWithFormat("HHmm", target: "HH:mm")
        return "\(startTime)/\(endTime)"
    }
    
    func odbTime(statId: String, array: NSMutableArray?) -> NSMutableArray {
        
        var table = LinT01TrainScheduleTrainTable()
        var rows = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
        
        if (array == nil) {
            return NSMutableArray.array()
        }
        var depaTimeArr: NSMutableArray = array!
        
        for key in rows {
            key as LinT01TrainScheduleTrainTable
            var dirtStat: String = key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String
            var lineId: String = key.item(LINT01_TRAIN_SCHEDULE_LINE_ID) as String
            
            var timeTypeArr1 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '1' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr2 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '2' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr3 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '3' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            
            var timeArr: NSMutableArray = NSMutableArray.array()
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr1)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr2)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr3)])
            
            depaTimeArr.addObject(timeArr)
        }
        
        return depaTimeArr
    }
    
    func collectStation(groupId: String) -> Bool {
        
        var isSuccess: Bool = false
        var table = UsrT03FavoriteTable()
        
        table.favoType = "01"
        table.statId = groupId
        var rows = table.selectAll()
        if (rows.count > 0) {
//            var sureBtn: UIAlertView = UIAlertView(title: "", message: "STA002_06".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_06".localizedString())
//            
//            sureBtn.show()
        } else {
            table.reset()
            table.favoType = "01"
            table.favoTime = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
            table.lineId = ""
            table.statId = groupId
            table.statExitId = ""
            table.lmakId = ""
            table.ruteId = ""
            table.ext1 = ""
            table.ext2 = ""
            table.ext3 = ""
            table.ext4 = ""
            table.ext5 = ""
            if (table.insert()) {
                isSuccess = true
                
            } else {
                
                isSuccess = false
            }
        }
        
        return isSuccess
    }


}