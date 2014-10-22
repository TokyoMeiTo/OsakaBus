//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class LinT04RouteTableData : CommonData {
    
    var ruteId :String = ""
    var startStatId :String = ""
    var startStatName :String = ""
    var termStatId :String = ""
    var termStatName :String = ""
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        ruteId     = dbNull(dao.item(LINT04_ROUTE_RUTE_ID) as? String)
        startStatId  = dbNull(dao.item(LINT04_ROUTE_START_STAT_ID) as? String)
        startStatName  = dbNull(dao.item(LINT04_ROUTE_START_STAT_NAME) as? String)
        termStatId     = dbNull(dao.item(LINT04_ROUTE_TERM_STAT_ID) as? String)
        termStatName  = dbNull(dao.item(LINT04_ROUTE_TERM_STAT_NAME) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:LinT04RouteTable = LinT04RouteTable()
        dao.item(LINT04_ROUTE_RUTE_ID,value:ruteId)
        dao.item(LINT04_ROUTE_START_STAT_ID,value:startStatId)
        dao.item(LINT04_ROUTE_START_STAT_NAME,value:startStatName)
        dao.item(LINT04_ROUTE_TERM_STAT_ID,value:termStatId)
        dao.item(LINT04_ROUTE_TERM_STAT_NAME,value:termStatName)
        
        return dao
    }
}