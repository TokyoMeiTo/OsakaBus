//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class LinT01TrainScheduleTrainTableData : CommonData {
    
    var lineId:String = ""
    var statId :String = ""
    var dirtStatId :String = ""
    var destStatId :String = ""
    var rescContentJp :String = ""
    var scheType :String = ""
    var depaTime :String = ""
    var tranType :String = ""
    var firstTrainFlag :String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        lineId     = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_LINE_ID) as? String)
        statId  = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_STAT_ID) as? String)
        dirtStatId  = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as? String)
        destStatId     = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_DEST_STAT_ID) as? String)
        scheType  = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_SCHE_TYPE) as? String)
        depaTime  = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as? String)
        tranType     = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_TRAN_TYPE) as? String)
        firstTrainFlag  = dbNull(dao.item(LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:LinT01TrainScheduleTrainTable = LinT01TrainScheduleTrainTable()
        dao.item(LINT01_TRAIN_SCHEDULE_LINE_ID,value:lineId)
        dao.item(LINT01_TRAIN_SCHEDULE_STAT_ID,value:statId)
        dao.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID,value:dirtStatId)
        dao.item(LINT01_TRAIN_SCHEDULE_DEST_STAT_ID,value:destStatId)
        dao.item(LINT01_TRAIN_SCHEDULE_SCHE_TYPE,value:scheType)
        dao.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME,value:depaTime)
        dao.item(LINT01_TRAIN_SCHEDULE_TRAN_TYPE,value:tranType)
        dao.item(LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG,value:firstTrainFlag)
        
        return dao
    }
}