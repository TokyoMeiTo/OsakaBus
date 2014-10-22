//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class StaT03ComervialInsideTableData : CommonData {
    
    var comeInsiId :String = ""
    var comeInsiName :String = ""
    var comeInsiType :String = ""
    var comeInsiTag :String = ""
    var comeInsiPrice :String = ""
    var comeInsiLocaCh :String = ""
    var comeInsiLocaJp :String = ""
    var comeInsiBisiHour :String = ""
    var comeInsiImage :String = ""
    var favoFlag :String = ""
    var favoTime :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        comeInsiId        = dbNull(dao.item(STAT03_COME_INSI_ID) as? String)
        comeInsiName      = dbNull(dao.item(STAT03_COME_INSI_NAME) as? String)
        comeInsiType      = dbNull(dao.item(STAT03_COME_INSI_TYPE) as? String)
        comeInsiTag       = dbNull(dao.item(STAT03_COME_INSI_TAG) as? String)
        comeInsiPrice     = dbNull(dao.item(STAT03_COME_INSI_PRICE) as? String)
        comeInsiLocaCh    = dbNull(dao.item(STAT03_COME_INSI_LOCA_CH) as? String)
        comeInsiLocaJp    = dbNull(dao.item(STAT03_COME_INSI_LOCA_JP) as? String)
        comeInsiBisiHour  = dbNull(dao.item(STAT03_COME_INSI_BISI_HOUR) as? String)
        comeInsiImage     = dbNull(dao.item(STAT03_COME_INSI_IMAGE) as? String)
        favoFlag          = dbNull(dao.item(STAT03_FAVO_FLAG) as? String)
        favoTime          = dbNull(dao.item(STAT03_FAVO_TIME) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:StaT03ComervialInsideTable = StaT03ComervialInsideTable()
        dao.item(STAT03_COME_INSI_ID,value:comeInsiId)
        dao.item(STAT03_COME_INSI_NAME,value:comeInsiName)
        dao.item(STAT03_COME_INSI_TYPE,value:comeInsiType)
        dao.item(STAT03_COME_INSI_TAG,value:comeInsiTag)
        dao.item(STAT03_COME_INSI_PRICE,value:comeInsiPrice)
        dao.item(STAT03_COME_INSI_LOCA_CH,value:comeInsiLocaCh)
        dao.item(STAT03_COME_INSI_LOCA_JP,value:comeInsiLocaJp)
        dao.item(STAT03_COME_INSI_BISI_HOUR,value:comeInsiBisiHour)
        dao.item(STAT03_COME_INSI_IMAGE,value:comeInsiImage)
        dao.item(STAT03_FAVO_FLAG,value:favoFlag)
        dao.item(STAT03_FAVO_TIME,value:favoTime)
        
        
        return dao
    }
}