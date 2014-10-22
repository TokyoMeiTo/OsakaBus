//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014îN Okasan-Huada. All rights reserved.
//

import Foundation

class LinT06FareTableData : CommonData {
    
    var ruteId :String = ""
    var fareAdult :String = ""
    var fareChild :String = ""
    var fareIdAdult :String = ""
    var fareIdChild :String = ""
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        ruteId        = dbNull(dao.item(LINT06_FARE_RUTE_ID) as? String)
        fareAdult     = dbNull(dao.item(LINT06_FARE_FARE_ADULT) as? String)
        fareChild     = dbNull(dao.item(LINT06_FARE_FARE_CHILD) as? String)
        fareIdAdult   = dbNull(dao.item(LINT06_FARE_FARE_ID_ADULT) as? String)
        fareIdChild   = dbNull(dao.item(LINT06_FARE_FARE_ID_CHILD) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:LinT06FareTable = LinT06FareTable()
        dao.item(LINT06_FARE_RUTE_ID,value:ruteId)
        dao.item(LINT06_FARE_FARE_ADULT,value:fareAdult)
        dao.item(LINT06_FARE_FARE_CHILD,value:fareChild)
        dao.item(LINT06_FARE_FARE_ID_ADULT,value:fareIdAdult)
        dao.item(LINT06_FARE_FARE_ID_CHILD,value:fareIdChild)
        
        return dao
    }
}