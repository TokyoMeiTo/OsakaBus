//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class LinT05RouteDetailTableData : CommonData {
    
    var ruteId :String = ""
    var ruteIdGroupId :String = ""
    var exchStatId :String = ""
    var exchLineId :String = ""
    var exchDestId :String = ""
    var exchType :String = ""
    var exchSeq :String = ""
    var moveTime :String = ""
    var waitTime :String = ""
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        ruteId         = dbNull(dao.item(LINT05_ROUTE_DETAIL_RUTE_ID) as? String)
        ruteIdGroupId  = dbNull(dao.item(LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID) as? String)
        exchStatId     = dbNull(dao.item(LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID) as? String)
        exchLineId     = dbNull(dao.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID) as? String)
        exchDestId     = dbNull(dao.item(LINT05_ROUTE_DETAIL_EXCH_LINE_ID) as? String)
        exchType       = dbNull(dao.item(LINT05_ROUTE_DETAIL_EXCH_TYPE) as? String)
        exchSeq	       = dbNull(dao.item(LINT05_ROUTE_DETAIL_EXCH_SEQ) as? String)
        moveTime       = dbNull(dao.item(LINT05_ROUTE_DETAIL_MOVE_TIME) as? String)
        waitTime       = dbNull(dao.item(LINT05_ROUTE_DETAIL_WAIT_TIME) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:LinT05RouteDetailTable = LinT05RouteDetailTable()
        dao.item(LINT05_ROUTE_DETAIL_RUTE_ID,value:ruteId)
        dao.item(LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID,value:ruteIdGroupId)
        dao.item(LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID,value:exchStatId)
        dao.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID,value:exchLineId)
        dao.item(LINT05_ROUTE_DETAIL_EXCH_LINE_ID,value:exchDestId)
        dao.item(LINT05_ROUTE_DETAIL_EXCH_TYPE,value:exchType)
        dao.item(LINT05_ROUTE_DETAIL_EXCH_SEQ,value:exchSeq)
        dao.item(LINT05_ROUTE_DETAIL_MOVE_TIME,value:moveTime)
        dao.item(LINT05_ROUTE_DETAIL_WAIT_TIME,value:waitTime)
        
        return dao
    }
}