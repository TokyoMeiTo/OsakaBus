//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CmnT04ImageTableData : CommonData {
    
    var imagId:String = ""
    var imagPath :String = ""
    var imagUrl :String = ""
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        imagId     = dbNull(dao.item(CMNT04_IMAG_ID) as? String)
        imagPath  = dbNull(dao.item(CMNT04_IMAG_PATH) as? String)
        imagUrl  = dbNull(dao.item(CMNT04_IMAG_URL) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:CmnT04ImageTable = CmnT04ImageTable()
        dao.item(CMNT04_IMAG_ID,value:imagId)
        dao.item(CMNT04_IMAG_PATH,value:imagPath)
        dao.item(CMNT04_IMAG_URL,value:imagUrl)
        return dao
    }
}