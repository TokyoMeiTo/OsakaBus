//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class UsrT01ArrivalAlarmTableData : CommonData {
    
    var arriAlamId :String = ""
    var lineFromId :String = ""
    var statFromId :String = ""
    var lineToId :String = ""
    var statToId :String = ""
    var traiDirt :String = ""
    var beepFlag :String = ""
    var voleFlag :String = ""
    var costTime :String = ""
    var alarmTime :String = ""
    var saveTime :String = ""
    var onboardTime :String = ""
    var cancelFlag :String = ""
    var cancelTime :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        arriAlamId   = dbNull(dao.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID) as? String)
        lineFromId   = dbNull(dao.item(USRT01_ARRIVAL_ALARM_LINE_FROM_ID) as? String)
        statFromId   = dbNull(dao.item(USRT01_ARRIVAL_ALARM_STAT_FROM_ID) as? String)
        lineToId     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID) as? String)
        statToId     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID) as? String)
        traiDirt     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_TRAI_DIRT) as? String)
        beepFlag     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_BEEP_FLAG) as? String)
        voleFlag     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_VOLE_FLAG) as? String)
        costTime     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_COST_TIME) as? String)
        alarmTime    = dbNull(dao.item(USRT01_ARRIVAL_ALARM_ALARM_TIME) as? String)
        saveTime     = dbNull(dao.item(USRT01_ARRIVAL_ALARM_SAVE_TIME) as? String)
        onboardTime  = dbNull(dao.item(USRT01_ARRIVAL_ALARM_ONBOARD_TIME) as? String)
        cancelFlag   = dbNull(dao.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG) as? String)
        cancelTime   = dbNull(dao.item(USRT01_ARRIVAL_ALARM_CANCEL_TIME) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:UsrT01ArrivalAlarmTable = UsrT01ArrivalAlarmTable()
        dao.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID,value:arriAlamId)
        dao.item(USRT01_ARRIVAL_ALARM_LINE_FROM_ID,value:lineFromId)
        dao.item(USRT01_ARRIVAL_ALARM_STAT_FROM_ID,value:statFromId)
        dao.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID,value:lineToId)
        dao.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID,value:statToId)
        dao.item(USRT01_ARRIVAL_ALARM_TRAI_DIRT,value:traiDirt)
        dao.item(USRT01_ARRIVAL_ALARM_BEEP_FLAG,value:beepFlag)
        dao.item(USRT01_ARRIVAL_ALARM_VOLE_FLAG,value:voleFlag)
        dao.item(USRT01_ARRIVAL_ALARM_COST_TIME,value:costTime)
        dao.item(USRT01_ARRIVAL_ALARM_ALARM_TIME,value:alarmTime)
        dao.item(USRT01_ARRIVAL_ALARM_SAVE_TIME,value:saveTime)
        dao.item(USRT01_ARRIVAL_ALARM_ONBOARD_TIME,value:onboardTime)
        dao.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG,value:cancelFlag)
        dao.item(USRT01_ARRIVAL_ALARM_CANCEL_TIME,value:cancelTime)
        
        
        return dao
    }
}