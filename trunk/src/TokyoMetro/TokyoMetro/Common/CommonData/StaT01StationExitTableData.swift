//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class StaT01StationExitTableData : CommonData {
    
    var statExitId :String = ""
    var lineId :String = ""
    var statId :String = ""
    var statExitNum :String = ""
    var statExitName :String = ""
    var statExitType :String = ""
    var statExitLon :String = ""
    var statExitLat :String = ""
    var statExitFloor :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        statExitId    = dbNull(dao.item(STAT01_STAT_EXIT_ID) as? String)
        lineId        = dbNull(dao.item(STAT01_LINE_ID) as? String)
        statId        = dbNull(dao.item(STAT01_STAT_ID) as? String)
        statExitNum   = dbNull(dao.item(STAT01_STAT_EXIT_NUM) as? String)
        statExitName  = dbNull(dao.item(STAT01_STAT_EXIT_NAME) as? String)
        statExitType  = dbNull(dao.item(STAT01_STAT_EXIT_TYPE) as? String)
        statExitLon   = dbNull(dao.item(STAT01_STAT_EXIT_LON) as? String)
        statExitLat   = dbNull(dao.item(STAT01_STAT_EXIT_LAT) as? String)
        statExitFloor = dbNull(dao.item(STAT01_STAT_EXIT_FLOOR) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:StaT01StationExitTable = StaT01StationExitTable()
        dao.item(STAT01_STAT_EXIT_ID,value:statExitId)
        dao.item(STAT01_LINE_ID,value:lineId)
        dao.item(STAT01_STAT_ID,value:statId)
        dao.item(STAT01_STAT_EXIT_NUM,value:statExitNum)
        dao.item(STAT01_STAT_EXIT_NAME,value:statExitName)
        dao.item(STAT01_STAT_EXIT_TYPE,value:statExitType)
        dao.item(STAT01_STAT_EXIT_LON,value:statExitLon)
        dao.item(STAT01_STAT_EXIT_LAT,value:statExitLat)
        dao.item(STAT01_STAT_EXIT_FLOOR,value:statExitFloor)
        
        
        return dao
    }
}