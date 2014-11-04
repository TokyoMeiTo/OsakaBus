//
//  USR002Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/09.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class USR002DAO:LinT01TrainScheduleTrainTable {
    
    func queryDepaTime(lineId:String, statId:String, destId:String, trainFlag:String, scheType:String) -> String {
        self.lineId = lineId
        self.statId = statId
        self.destStatId = destId
        self.firstTrainFlag = trainFlag
        self.scheType = scheType
        var mLinT01Data:LinT01TrainScheduleTrainTableData = LinT01TrainScheduleTrainTableData()
        
        return (mLinT01Data.fromDAO(self.select()) as LinT01TrainScheduleTrainTableData).depaTime
    }
}
