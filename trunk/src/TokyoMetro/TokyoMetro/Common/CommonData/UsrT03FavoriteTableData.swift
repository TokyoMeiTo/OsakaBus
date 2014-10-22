//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class UsrT03FavoriteTableData : CommonData {
    
    var favoType :String = ""
    var favoTime :String = ""
    var lineId :String = ""
    var statId :String = ""
    var statExitId :String = ""
    var lmakId :String = ""
    var ruteId :String = ""
    var ext1 :String = ""
    var ext2 :String = ""
    var ext3 :String = ""
    var ext4 :String = ""
    var ext5 :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        favoType    = dbNull(dao.item(USRT03_FAVO_TYPE) as? String)
        favoTime    = dbNull(dao.item(USRT03_FAVO_TIME) as? String)
        lineId      = dbNull(dao.item(USRT03_LINE_ID) as? String)
        statId      = dbNull(dao.item(USRT03_STAT_ID) as? String)
        statExitId  = dbNull(dao.item(USRT03_STAT_EXIT_ID) as? String)
        lmakId      = dbNull(dao.item(USRT03_LMAK_ID) as? String)
        ruteId      = dbNull(dao.item(USRT03_RUTE_ID) as? String)
        ext1        = dbNull(dao.item(USRT03_EXI1) as? String)
        ext2        = dbNull(dao.item(USRT03_EXI2) as? String)
        ext3        = dbNull(dao.item(USRT03_EXI3) as? String)
        ext4        = dbNull(dao.item(USRT03_EXI4) as? String)
        ext5        = dbNull(dao.item(USRT03_EXI5) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:UsrT03FavoriteTable = UsrT03FavoriteTable()
        dao.item(USRT03_FAVO_TYPE,value:favoType)
        dao.item(USRT03_FAVO_TIME,value:favoTime)
        dao.item(USRT03_LINE_ID,value:lineId)
        dao.item(USRT03_STAT_ID,value:statId)
        dao.item(USRT03_STAT_EXIT_ID,value:statExitId)
        dao.item(USRT03_LMAK_ID,value:lmakId)
        dao.item(USRT03_RUTE_ID,value:ruteId)
        dao.item(USRT03_EXI1,value:ext1)
        dao.item(USRT03_EXI2,value:ext2)
        dao.item(USRT03_EXI3,value:ext3)
        dao.item(USRT03_EXI4,value:ext4)
        dao.item(USRT03_EXI5,value:ext5)
        
        
        return dao
    }
}