//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class MstT01LineTableData : CommonData {
    
    var lineId :String = ""
    var lineMetroId :String = ""
    var lineMetroIdFull :String = ""
    var lineName :String = ""
    var lineNameKana :String = ""
    var lineNameRome :String = ""
    var lineNameExt1 :String = ""
    var lineNameExt2 :String = ""
    var lineNameExt3 :String = ""
    var lineNameExt4 :String = ""
    var lineNameExt5 :String = ""
    var lineNameExt6 :String = ""
    var lineLon :String = ""
    var lineLat :String = ""
    var linePref :String = ""
    var lineComp :String = ""
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        lineId           = dbNull(dao.item(MSTT01_LINE_ID) as? String)
        lineMetroId      = dbNull(dao.item(MSTT01_LINE_METRO_ID) as? String)
        lineMetroIdFull  = dbNull(dao.item(MSTT01_LINE_METRO_ID_FULL) as? String)
        lineName         = dbNull(dao.item(MSTT01_LINE_NAME) as? String)
        lineNameKana     = dbNull(dao.item(MSTT01_LINE_NAME_KANA) as? String)
        lineNameRome     = dbNull(dao.item(MSTT01_LINE_NAME_ROME) as? String)
        lineNameExt1     = dbNull(dao.item(MSTT01_LINE_NAME_EXT1) as? String)
        lineNameExt2     = dbNull(dao.item(MSTT01_LINE_NAME_EXT2) as? String)
        lineNameExt3     = dbNull(dao.item(MSTT01_LINE_NAME_EXT3) as? String)
        lineNameExt4     = dbNull(dao.item(MSTT01_LINE_NAME_EXT4) as? String)
        lineNameExt5     = dbNull(dao.item(MSTT01_LINE_NAME_EXT5) as? String)
        lineNameExt6     = dbNull(dao.item(MSTT01_LINE_NAME_EXT6) as? String)
        lineLon          = dbNull(dao.item(MSTT01_LINE_LON) as? String)
        lineLat          = dbNull(dao.item(MSTT01_LINE_LAT) as? String)
        linePref         = dbNull(dao.item(MSTT01_LINE_PREF) as? String)
        lineComp         = dbNull(dao.item(MSTT01_LINE_COMP) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:MstT01LineTable = MstT01LineTable()
        dao.item(MSTT01_LINE_ID,value:lineId)
        dao.item(MSTT01_LINE_METRO_ID,value:lineMetroId)
        dao.item(MSTT01_LINE_METRO_ID_FULL,value:lineMetroIdFull)
        dao.item(MSTT01_LINE_NAME,value:lineName)
        dao.item(MSTT01_LINE_NAME_KANA,value:lineNameKana)
        dao.item(MSTT01_LINE_NAME_ROME,value:lineNameRome)
        dao.item(MSTT01_LINE_NAME_EXT1,value:lineNameExt1)
        dao.item(MSTT01_LINE_NAME_EXT2,value:lineNameExt2)
        dao.item(MSTT01_LINE_NAME_EXT3,value:lineNameExt3)
        dao.item(MSTT01_LINE_NAME_EXT4,value:lineNameExt4)
        dao.item(MSTT01_LINE_NAME_EXT5,value:lineNameExt5)
        dao.item(MSTT01_LINE_NAME_EXT6,value:lineNameExt6)
        dao.item(MSTT01_LINE_LON,value:lineLon)
        dao.item(MSTT01_LINE_LAT,value:lineLat)
        dao.item(MSTT01_LINE_PREF,value:linePref)
        dao.item(MSTT01_LINE_COMP,value:lineComp)
        
        return dao
    }
}