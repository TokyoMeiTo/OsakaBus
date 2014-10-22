//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class InfT01StrategyTableData : CommonData {
    
    var straId:String = ""
    var straTheme:String = ""
    var spplPeople:String = ""
    var straSeason:String = ""
    var straDescription:String = ""
    var readFlag:Bool = false
    var readTime:String = ""
    var favoFlag:Bool = false
    var favoTime:String = ""
    
    var readFlagStr:String = ""
    var favoFlagStr:String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        straId          = dbNull(dao.item(INFT01_STRA_ID) as? String)
        straTheme       = dbNull(dao.item(INFT01_STRA_THEME) as? String)
        spplPeople      = dbNull(dao.item(INFT01_SPPL_PEOPLE) as? String)
        straSeason      = dbNull(dao.item(INFT01_STRA_SEASON) as? String)
        straDescription = dbNull(dao.item(INFT01_STRA_DESCRIPTION) as? String)
        readFlag        = textToBool(dao.item(INFT01_READ_FLAG) as? String)
        readTime        = dbNull(dao.item(INFT01_READ_TIME) as? String)
        favoFlag        = textToBool(dao.item(INFT01_FAVO_FLAG) as? String)
        favoTime        = dbNull(dao.item(INFT01_FAVO_TIME) as? String)
        readFlagStr     = dbNull(dao.item(INFT01_READ_FLAG) as? String)
        favoFlagStr     = dbNull(dao.item(INFT01_FAVO_FLAG) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:InfT01StrategyTable = InfT01StrategyTable()
        dao.item(INFT01_STRA_ID,value:straId)
        dao.item(INFT01_STRA_THEME,value:straTheme)
        dao.item(INFT01_SPPL_PEOPLE,value:spplPeople)
        dao.item(INFT01_STRA_SEASON,value:straSeason)
        dao.item(INFT01_STRA_DESCRIPTION,value:straDescription)
        dao.item(INFT01_READ_FLAG,value:readFlagStr)
        dao.item(INFT01_READ_TIME,value:readTime)
        dao.item(INFT01_FAVO_FLAG,value:favoFlagStr)
        dao.item(INFT01_FAVO_TIME,value:favoTime)

        return dao
    }
}