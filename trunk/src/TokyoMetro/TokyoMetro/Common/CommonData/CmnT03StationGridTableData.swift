//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CmnT03StationGridTableData : CommonData {
    
    var straId:String = ""
    var pontXFrom :String = ""
    var pontYFrom :String = ""
    var pontXTo :String = ""
    var pontYTo :String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        straId     = dbNull(dao.item(CMNT03_STAT_ID) as? String)
        pontXFrom  = dbNull(dao.item(CMNT03_PONT_X_FROM) as? String)
        pontYFrom  = dbNull(dao.item(CMNT03_PONT_Y_FROM) as? String)
        pontXTo    = dbNull(dao.item(CMNT03_PONT_X_TO) as? String)
        pontYTo    = dbNull(dao.item(CMNT03_PONT_Y_TO) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:CmnT03StationGridTable = CmnT03StationGridTable()
        dao.item(CMNT03_STAT_ID,value:straId)
        dao.item(CMNT03_PONT_X_FROM,value:pontXFrom)
        dao.item(CMNT03_PONT_Y_FROM,value:pontYFrom)
        dao.item(CMNT03_PONT_X_TO,value:pontXTo)
        dao.item(CMNT03_PONT_Y_TO,value:pontYTo)
        return dao
    }
}
