//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class InfT03RescureTableData : CommonData {
    
    var rescId:String = ""
    var rescLoca :String = ""
    var rescType :String = ""
    var rescContentCn :String = ""
    var rescContentJp :String = ""
    var readFlag :String = ""
    var readTime :String = ""
    var favoFlag :String = ""
    var favoTime :String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        rescId     = dbNull(dao.item(INFT03_RESCURE_RESC_ID) as? String)
        rescLoca  = dbNull(dao.item(INFT03_RESCURE_RESC_LOCA) as? String)
        rescType  = dbNull(dao.item(INFT03_RESCURE_RESC_TYPE) as? String)
        rescContentCn     = dbNull(dao.item(INFT03_RESCURE_RESC_CONTENT_CN) as? String)
        rescContentJp  = dbNull(dao.item(INFT03_RESCURE_RESC_CONTENT_JP) as? String)
        readFlag  = dbNull(dao.item(INFT03_RESCURE_READ_FLAG) as? String)
        readTime     = dbNull(dao.item(INFT03_RESCURE_READ_TIME) as? String)
        favoFlag  = dbNull(dao.item(INFT03_RESCURE_FAVO_FLAG) as? String)
        favoTime  = dbNull(dao.item(INFT03_RESCURE_FAVO_TIME) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:InfT03RescureTable = InfT03RescureTable()
        dao.item(INFT03_RESCURE_RESC_ID,value:rescId)
        dao.item(INFT03_RESCURE_RESC_LOCA,value:rescLoca)
        dao.item(INFT03_RESCURE_RESC_TYPE,value:rescType)
        dao.item(INFT03_RESCURE_RESC_CONTENT_CN,value:rescContentCn)
        dao.item(INFT03_RESCURE_RESC_CONTENT_JP,value:rescContentJp)
        dao.item(INFT03_RESCURE_READ_FLAG,value:readFlag)
        dao.item(INFT03_RESCURE_READ_TIME,value:readTime)
        dao.item(INFT03_RESCURE_FAVO_FLAG,value:favoFlag)
        dao.item(INFT03_RESCURE_FAVO_TIME,value:favoTime)
        
        return dao
    }
}