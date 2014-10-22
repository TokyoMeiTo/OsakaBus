//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class UsrT02TrainAlarmTableData : CommonData {
    
    var traiAlamId :String = ""
    var lineId :String = ""
    var statId :String = ""
    var alamType :String = ""
    var alamTime :String = ""
    var alamFlag :String = ""
    var traiDirt :String = ""
    var beepFlag :String = ""
    var voleFlag :String = ""
    var alarmTime :String = ""
    var saveTime :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        traiAlamId   = dbNull(dao.item(USRT02_TRAIN_ALARM_TRAI_ALAM_ID) as? String)
        lineId       = dbNull(dao.item(USRT02_TRAIN_ALARM_LINE_ID) as? String)
        statId       = dbNull(dao.item(USRT02_TRAIN_ALARM_STAT_ID) as? String)
        alamType     = dbNull(dao.item(USRT02_TRAIN_ALARM_ALAM_TYPE) as? String)
        alamTime     = dbNull(dao.item(USRT02_TRAIN_ALARM_ALAM_TIME) as? String)
        alamFlag     = dbNull(dao.item(USRT02_TRAIN_ALARM_ALAM_FLAG) as? String)
        traiDirt     = dbNull(dao.item(USRT02_TRAIN_ALARM_TRAI_DIRT) as? String)
        beepFlag     = dbNull(dao.item(USRT02_TRAIN_ALARM_BEEP_FLAG) as? String)
        voleFlag     = dbNull(dao.item(USRT02_TRAIN_ALARM_VOLE_FLAG) as? String)
        alarmTime    = dbNull(dao.item(USRT02_TRAIN_ALARM_ALARM_TIME) as? String)
        saveTime     = dbNull(dao.item(USRT02_TRAIN_ALARM_SAVE_TIEM) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:UsrT02TrainAlarmTable = UsrT02TrainAlarmTable()
        dao.item(USRT02_TRAIN_ALARM_TRAI_ALAM_ID,value:traiAlamId)
        dao.item(USRT02_TRAIN_ALARM_LINE_ID,value:lineId)
        dao.item(USRT02_TRAIN_ALARM_STAT_ID,value:statId)
        dao.item(USRT02_TRAIN_ALARM_ALAM_TYPE,value:alamType)
        dao.item(USRT02_TRAIN_ALARM_ALAM_TIME,value:alamTime)
        dao.item(USRT02_TRAIN_ALARM_ALAM_FLAG,value:alamFlag)
        dao.item(USRT02_TRAIN_ALARM_TRAI_DIRT,value:traiDirt)
        dao.item(USRT02_TRAIN_ALARM_BEEP_FLAG,value:beepFlag)
        dao.item(USRT02_TRAIN_ALARM_VOLE_FLAG,value:voleFlag)
        dao.item(USRT02_TRAIN_ALARM_ALARM_TIME,value:alarmTime)
        dao.item(USRT02_TRAIN_ALARM_SAVE_TIEM,value:saveTime)
        
        
        return dao
    }
}