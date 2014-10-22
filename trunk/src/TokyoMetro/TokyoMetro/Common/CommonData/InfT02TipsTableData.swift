//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014îN Okasan-Huada. All rights reserved.
//

import Foundation

class InfT02TipsTableData : CommonData {
    
    var tipsId:String = ""
    var tipsType :String = ""
    var tipsSubType :String = ""
    var tipsTitle :String = ""
    var tipsContent :String = ""
    var readFlag :Bool = false
    var readTime :String = ""
    var favoFlag :Bool = false
    var favoTime :String = ""
    
    var readFlagStr:String = ""
    var favoFlagStr:String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        tipsId       = dbNull(dao.item(INFT02_TIPS_ID) as? String)
        tipsType     = dbNull(dao.item(INFT02_TIPS_TYPE) as? String)
        tipsSubType  = dbNull(dao.item(INFT02_TIPS_SUB_TYPE) as? String)
        tipsTitle    = dbNull(dao.item(INFT02_TIPS_TITLE) as? String)
        tipsContent  = dbNull(dao.item(INFT02_TIPS_CONTENT) as? String)
        readFlag     = textToBool(dao.item(INFT02_READ_FLAG) as? String)
        readTime     = dbNull(dao.item(INFT02_REAG_TIME) as? String)
        favoFlag     = textToBool(dao.item(INFT02_FAVO_FLAG) as? String)
        favoTime     = dbNull(dao.item(INFT02_FAVO_TIME) as? String)
        readFlagStr  = dbNull(dao.item(INFT02_READ_FLAG) as? String)
        favoFlagStr  = dbNull(dao.item(INFT02_FAVO_FLAG) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:InfT02TipsTable = InfT02TipsTable()
        dao.item(INFT02_TIPS_ID,value:tipsId)
        dao.item(INFT02_TIPS_TYPE,value:tipsType)
        dao.item(INFT02_TIPS_SUB_TYPE,value:tipsSubType)
        dao.item(INFT02_TIPS_TITLE,value:tipsTitle)
        dao.item(INFT02_TIPS_CONTENT,value:tipsContent)
        dao.item(INFT02_READ_FLAG,value:readFlagStr)
        dao.item(INFT02_REAG_TIME,value:readTime)
        dao.item(INFT02_FAVO_FLAG,value:favoFlagStr)
        dao.item(INFT02_FAVO_TIME,value:favoTime)
        
        return dao
    }
}