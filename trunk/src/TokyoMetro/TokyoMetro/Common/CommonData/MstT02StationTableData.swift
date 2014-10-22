//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class MstT02StationTableData : CommonData {
    
    var statId :String = ""
    var statGroupId :String = ""
    var lineId :String = ""
    var statSeq :String = ""
    var statNameMetroId :String = ""
    var statNameMetroIdFull :String = ""
    var statNameExt1 :String = ""
    var statNameExt2 :String = ""
    var statNameExt3 :String = ""
    var statNameExt4 :String = ""
    var statNameExt5 :String = ""
    var statNameExt6 :String = ""
    var statName :String = ""
    var statNameKana :String = ""
    var statNameRome :String = ""
    var statLon :String = ""
    var statLat :String = ""
    var statPref :String = ""
    var statAddr :String = ""
    var statDesp :String = ""


    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        statId                = dbNull(dao.item(MSTT02_STAT_ID) as? String)
        statGroupId           = dbNull(dao.item(MSTT02_STAT_GROUP_ID) as? String)
        lineId                = dbNull(dao.item(MSTT02_LINE_ID) as? String)
        statSeq               = dbNull(dao.item(MSTT02_STAT_SEQ) as? String)
        statNameMetroId       = dbNull(dao.item(MSTT02_STAT_METRO_ID) as? String)
        statNameMetroIdFull   = dbNull(dao.item(MSTT02_STAT_METRO_ID_FULL) as? String)
        statNameExt1          = dbNull(dao.item(MSTT02_STAT_NAME_EXT1) as? String)
        statNameExt2          = dbNull(dao.item(MSTT02_STAT_NAME_EXT2) as? String)
        statNameExt3          = dbNull(dao.item(MSTT02_STAT_NAME_EXT3) as? String)
        statNameExt4          = dbNull(dao.item(MSTT02_STAT_NAME_EXT4) as? String)
        statNameExt5          = dbNull(dao.item(MSTT02_STAT_NAME_EXT5) as? String)
        statNameExt6          = dbNull(dao.item(MSTT02_STAT_NAME_EXT6) as? String)
        statName              = dbNull(dao.item(MSTT02_STAT_NAME) as? String)
        statNameKana          = dbNull(dao.item(MSTT02_STAT_NAME_KANA) as? String)
        statNameRome          = dbNull(dao.item(MSTT02_STAT_NAME_ROME) as? String)
        statLon               = dbNull(dao.item(MSTT02_STAT_LON) as? String)
        statLat               = dbNull(dao.item(MSTT02_STAT_LAT) as? String)
        statPref              = dbNull(dao.item(MSTT02_STAT_PREF) as? String)
        statAddr              = dbNull(dao.item(MSTT02_STAT_ADDR) as? String)
        statDesp              = dbNull(dao.item(MSTT02_STAT_DESP) as? String)

        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:MstT02StationTable = MstT02StationTable()
        dao.item(MSTT02_STAT_ID,value:statId)
        dao.item(MSTT02_STAT_GROUP_ID,value:statGroupId)
        dao.item(MSTT02_LINE_ID,value:lineId)
        dao.item(MSTT02_STAT_SEQ,value:statSeq)
        dao.item(MSTT02_STAT_METRO_ID,value:statNameMetroId)
        dao.item(MSTT02_STAT_METRO_ID_FULL,value:statNameMetroIdFull)
        dao.item(MSTT02_STAT_NAME_EXT1,value:statNameExt1)
        dao.item(MSTT02_STAT_NAME_EXT2,value:statNameExt2)
        dao.item(MSTT02_STAT_NAME_EXT3,value:statNameExt3)
        dao.item(MSTT02_STAT_NAME_EXT4,value:statNameExt4)
        dao.item(MSTT02_STAT_NAME_EXT5,value:statNameExt5)
        dao.item(MSTT02_STAT_NAME_EXT6,value:statNameExt6)
        dao.item(MSTT02_STAT_NAME,value:statName)
        dao.item(MSTT02_STAT_NAME_KANA,value:statNameKana)
        dao.item(MSTT02_STAT_NAME_ROME,value:statNameRome)
        dao.item(MSTT02_STAT_LON,value:statLon)
        dao.item(MSTT02_STAT_LAT,value:statLat)
        dao.item(MSTT02_STAT_PREF,value:statPref)
        dao.item(MSTT02_STAT_ADDR,value:statAddr)
        dao.item(MSTT02_STAT_DESP,value:statDesp)

        return dao
    }
}