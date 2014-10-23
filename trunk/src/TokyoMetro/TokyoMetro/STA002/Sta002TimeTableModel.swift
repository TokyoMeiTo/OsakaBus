//
//  Sta002TimeTableModel.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class Sta002TimeTableModel {
    
    
    /*
    *  查询并获取时刻表数据
    */
    func odbDirtStatId(statId: String?) -> [String]{
        
        var dirtStationArr = [String]()
        if (statId == nil || statId == "") {
            return dirtStationArr
        }
        
        var table = LinT01TrainScheduleTrainTable()
        var rows = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId!)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
        
        
        for key in rows {
            key as LinT01TrainScheduleTrainTable
            dirtStationArr.append(key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String)
        }
        
        return dirtStationArr
    }
    
    func cellHeight(timeArr: NSMutableArray,index: Int) -> CGFloat {
        
        if (timeArr[index].count <= 6) {
            
            return 45
        } else if (timeArr[index].count > 6 && timeArr[index].count <= 12) {
            return 90
        } else if (timeArr[index].count > 12 && timeArr[index].count <= 18) {
            return 135
        } else if (timeArr[index].count > 18 && timeArr[index].count <= 24) {
            return 180
        } else if (timeArr[index].count > 24 && timeArr[index].count <= 30) {
            return 225
        }  else if (timeArr[index].count > 30 && timeArr[index].count <= 36) {
            return 260
        } else {
            return 45
        }
    }
    
    func initTimeArr(data: NSArray) -> NSMutableArray {
        
        var timeArr: NSMutableArray = NSMutableArray.array()
        var arr1: [String] = [String]()
        var arr2: [String] = [String]()
        var arr3: [String] = [String]()
        var arr4: [String] = [String]()
        var arr5: [String] = [String]()
        var arr6: [String] = [String]()
        var arr7: [String] = [String]()
        var arr8: [String] = [String]()
        var arr9: [String] = [String]()
        var arr10: [String] = [String]()
        var arr11: [String] = [String]()
        var arr12: [String] = [String]()
        var arr13: [String] = [String]()
        var arr14: [String] = [String]()
        var arr15: [String] = [String]()
        var arr16: [String] = [String]()
        var arr17: [String] = [String]()
        var arr18: [String] = [String]()
        var arr19: [String] = [String]()
        var arr20: [String] = [String]()
        
        
        for key in data {
            key as LinT01TrainScheduleTrainTable
            
            switch ((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).left(2)) {
            case "05":
                arr1.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "06":
                arr2.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "07":
                arr3.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "08":
                arr4.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "09":
                arr5.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "10":
                arr6.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "11":
                arr7.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "12":
                arr8.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "13":
                arr9.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "14":
                arr10.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "15":
                arr11.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "16":
                arr12.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "17":
                arr13.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "18":
                arr14.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "19":
                arr15.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "20":
                arr16.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "21":
                arr17.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "22":
                arr18.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "23":
                arr19.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "00":
                arr20.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            default:
                arr20.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            }
            
        }
        
        timeArr.addObject(arr1)
        timeArr.addObject(arr2)
        timeArr.addObject(arr3)
        timeArr.addObject(arr4)
        timeArr.addObject(arr5)
        timeArr.addObject(arr6)
        timeArr.addObject(arr7)
        timeArr.addObject(arr8)
        timeArr.addObject(arr9)
        timeArr.addObject(arr10)
        timeArr.addObject(arr11)
        timeArr.addObject(arr12)
        timeArr.addObject(arr13)
        timeArr.addObject(arr14)
        timeArr.addObject(arr15)
        timeArr.addObject(arr16)
        timeArr.addObject(arr17)
        timeArr.addObject(arr18)
        timeArr.addObject(arr19)
        if (arr20.count > 0) {
            timeArr.addObject(arr20)
        }
        
        return timeArr
    }

}