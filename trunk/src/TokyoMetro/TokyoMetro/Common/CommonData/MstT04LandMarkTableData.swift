//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class MstT04LandMarkTableData : CommonData {
    
    var lmakId :String = ""
    var lmakName :String = ""
    var lmakNameKana :String = ""
    var lmakNameRome :String = ""
    var lmakNameExt1 :String = ""
    var lmakNameExt2 :String = ""
    var lmakNameExt3 :String = ""
    var lmakNameExt4 :String = ""
    var lmakNameExt5 :String = ""
    var lmakNameExt6 :String = ""
    var lmakType :String = ""
    var lmakSubType :String = ""
    var lineId :String = ""
    var statId :String = ""
    var statExitId :String = ""
    var lmakPref :String = ""
    var lmakWard :String = ""
    var lmakRank :String = ""
    var lmakMiciRank :String = ""
    var lmakAvalTime :String = ""
    var lmakTictPric :String = ""
    var lmakAddr :String = ""
    var lmakDesp :String = ""
    var olimpicFlag :String = ""
    var exitFlag1 :String = ""
    var exitFlag2 :String = ""
    var exitFlag3 :String = ""
    var exitFlag4 :String = ""
    var imagId1 :String = ""
    var imagId2 :String = ""
    var imagId3 :String = ""
    var imagId4 :String = ""
    var imagId5 :String = ""
    var lmakLon :String = ""
    var lmakLat :String = ""
    var readFlag :String = ""
    var readTime :String = ""
    var favoFlag :String = ""
    var favoTime :String = ""
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        lmakId       = dbNull(dao.item(MSTT04_LANDMARK_LMAK_ID) as? String)
        lmakName     = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME) as? String)
        lmakNameKana = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_KANA) as? String)
        lmakNameRome = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_ROME) as? String)
        lmakNameExt1 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) as? String)
        lmakNameExt2 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT2) as? String)
        lmakNameExt3 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT3) as? String)
        lmakNameExt4 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT4) as? String)
        lmakNameExt5 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT5) as? String)
        lmakNameExt6 = dbNull(dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT6) as? String)
        lmakType     = dbNull(dao.item(MSTT04_LANDMARK_LMAK_TYPE) as? String)
        lmakSubType  = dbNull(dao.item(MSTT04_LANDMARK_LMAK_SUB_TYPE) as? String)
        lineId       = dbNull(dao.item(MSTT04_LANDMARK_LINE_ID) as? String)
        statId       = dbNull(dao.item(MSTT04_LANDMARK_STAT_ID) as? String)
        statExitId   = dbNull(dao.item(MSTT04_LANDMARK_STAT_EXIT_ID) as? String)
        lmakPref     = dbNull(dao.item(MSTT04_LANDMARK_PREF) as? String)
        lmakWard     = dbNull(dao.item(MSTT04_LANDMARK_WARD) as? String)
        lmakRank     = dbNull(dao.item(MSTT04_LANDMARK_RANK) as? String)
        lmakMiciRank = dbNull(dao.item(MSTT04_LANDMARK_MICI_RANK) as? String)
        lmakAvalTime = dbNull(dao.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) as? String)
        lmakTictPric = dbNull(dao.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) as? String)
        lmakAddr     = dbNull(dao.item(MSTT04_LANDMARK_LMAK_ADDR) as? String)
        lmakDesp     = dbNull(dao.item(MSTT04_LANDMARK_LMAK_DESP) as? String)
        olimpicFlag  = dbNull(dao.item(MSTT04_LANDMARK_OLIMPIC_FLAG) as? String)
        exitFlag1    = dbNull(dao.item(MSTT04_LANDMARK_EXIT_FLAG1) as? String)
        exitFlag2    = dbNull(dao.item(MSTT04_LANDMARK_EXIT_FLAG2) as? String)
        exitFlag3    = dbNull(dao.item(MSTT04_LANDMARK_EXIT_FLAG3) as? String)
        exitFlag4    = dbNull(dao.item(MSTT04_LANDMARK_EXIT_FLAG4) as? String)
        imagId1      = dbNull(dao.item(MSTT04_LANDMARK_IMAG_ID1) as? String)
        imagId2      = dbNull(dao.item(MSTT04_LANDMARK_IMAG_ID2) as? String)
        imagId3      = dbNull(dao.item(MSTT04_LANDMARK_IMAG_ID3) as? String)
        imagId4      = dbNull(dao.item(MSTT04_LANDMARK_IMAG_ID4) as? String)
        imagId5      = dbNull(dao.item(MSTT04_LANDMARK_IMAG_ID5) as? String)
        lmakLon      = dbNull(dao.item(MSTT04_LANDMARK_LMAK_LON) as? String)
        lmakLat      = dbNull(dao.item(MSTT04_LANDMARK_LMAK_LAT) as? String)
        readFlag     = dbNull(dao.item(MSTT04_LANDMARK_READ_FLAG) as? String)
        readTime     = dbNull(dao.item(MSTT04_LANDMARK_READ_TIME) as? String)
        favoFlag     = dbNull(dao.item(MSTT04_LANDMARK_FAVO_FLAG) as? String)
        favoTime     = dbNull(dao.item(MSTT04_LANDMARK_FAVO_TIME) as? String)
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:MstT04LandMarkTable = MstT04LandMarkTable()
        dao.item(MSTT04_LANDMARK_LMAK_ID,value:lmakId)
        dao.item(MSTT04_LANDMARK_LMAK_NAME,value:lmakName)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_KANA,value:lmakNameKana)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_ROME,value:lmakNameRome)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT1,value:lmakNameExt1)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT2,value:lmakNameExt2)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT3,value:lmakNameExt3)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT4,value:lmakNameExt4)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT5,value:lmakNameExt5)
        dao.item(MSTT04_LANDMARK_LMAK_NAME_EXT6,value:lmakNameExt6)
        dao.item(MSTT04_LANDMARK_LMAK_TYPE,value:lmakType)
        dao.item(MSTT04_LANDMARK_LMAK_SUB_TYPE,value:lmakSubType)
        dao.item(MSTT04_LANDMARK_LINE_ID,value:lineId)
        dao.item(MSTT04_LANDMARK_STAT_ID,value:statId)
        dao.item(MSTT04_LANDMARK_STAT_EXIT_ID,value:statExitId)
        dao.item(MSTT04_LANDMARK_PREF,value:lmakPref)
        dao.item(MSTT04_LANDMARK_WARD,value:lmakWard)
        dao.item(MSTT04_LANDMARK_RANK,value:lmakRank)
        dao.item(MSTT04_LANDMARK_MICI_RANK,value:lmakMiciRank)
        dao.item(MSTT04_LANDMARK_LMAK_AVAL_TIME,value:lmakAvalTime)
        dao.item(MSTT04_LANDMARK_LMAK_TICL_PRIC,value:lmakTictPric)
        dao.item(MSTT04_LANDMARK_LMAK_ADDR,value:lmakAddr)
        dao.item(MSTT04_LANDMARK_LMAK_DESP,value:lmakDesp)
        dao.item(MSTT04_LANDMARK_OLIMPIC_FLAG,value:olimpicFlag)
        dao.item(MSTT04_LANDMARK_EXIT_FLAG1,value:exitFlag1)
        dao.item(MSTT04_LANDMARK_EXIT_FLAG2,value:exitFlag2)
        dao.item(MSTT04_LANDMARK_EXIT_FLAG3,value:exitFlag3)
        dao.item(MSTT04_LANDMARK_EXIT_FLAG4,value:exitFlag4)
        dao.item(MSTT04_LANDMARK_IMAG_ID1,value:imagId1)
        dao.item(MSTT04_LANDMARK_IMAG_ID2,value:imagId2)
        dao.item(MSTT04_LANDMARK_IMAG_ID3,value:imagId3)
        dao.item(MSTT04_LANDMARK_IMAG_ID4,value:imagId4)
        dao.item(MSTT04_LANDMARK_IMAG_ID5,value:imagId5)
        dao.item(MSTT04_LANDMARK_LMAK_LON,value:lmakLon)
        dao.item(MSTT04_LANDMARK_LMAK_LAT,value:lmakLat)
        dao.item(MSTT04_LANDMARK_READ_FLAG,value:readFlag)
        dao.item(MSTT04_LANDMARK_READ_TIME,value:readTime)
        dao.item(MSTT04_LANDMARK_FAVO_FLAG,value:favoFlag)
        dao.item(MSTT04_LANDMARK_FAVO_TIME,value:favoTime)
        
        return dao
    }
}