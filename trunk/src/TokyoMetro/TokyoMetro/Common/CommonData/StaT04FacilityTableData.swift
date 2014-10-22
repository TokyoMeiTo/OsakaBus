//
//  InfT01StrategyTableData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class StaT04FacilityTableData : CommonData {
    
    var faciId :String = ""
    var statId :String = ""
    var faciType :String = ""
    var faciName :String = ""
    var faciDesp :String = ""
    var faciLocl :String = ""
    var escaDirt :String = ""
    var whelCairAces :String = ""
    var babyCair :String = ""
    var babyChgnTabl :String = ""
    var toilForOstm :String = ""
    var remark :String = ""
    var whelCair :String = ""
    
    
    
    
    override func fromDAO(dao:ODBDataTable) -> CommonData
    {
        faciId        = dbNull(dao.item(STAT04_FACI_ID) as? String)
        statId        = dbNull(dao.item(STAT04_STAT_ID) as? String)
        faciType      = dbNull(dao.item(STAT04_FACI_TYPE) as? String)
        faciName      = dbNull(dao.item(STAT04_FACI_NAME) as? String)
        faciDesp      = dbNull(dao.item(STAT04_FACI_DESP) as? String)
        faciLocl      = dbNull(dao.item(STAT04_FACI_LOCL) as? String)
        escaDirt      = dbNull(dao.item(STAT04_ESCA_DIRT) as? String)
        whelCairAces  = dbNull(dao.item(STAT04_WHEL_CAIR_ACES) as? String)
        babyCair      = dbNull(dao.item(STAT04_BABY_CAIR) as? String)
        babyChgnTabl  = dbNull(dao.item(STAT04_BABY_CHGN_TABL) as? String)
        toilForOstm   = dbNull(dao.item(STAT04_TOIL_FOR_OSTM) as? String)
        remark        = dbNull(dao.item(STAT04_REMARK) as? String)
        whelCair      = dbNull(dao.item(STAT04_WHEL_CAIR) as? String)
        
        
        return super.fromDAO(dao);
    }
    
    override func toDAO() -> ODBDataTable
    {
        var dao:StaT04FacilityTable = StaT04FacilityTable()
        dao.item(STAT04_FACI_ID,value:faciId)
        dao.item(STAT04_STAT_ID,value:statId)
        dao.item(STAT04_FACI_TYPE,value:faciType)
        dao.item(STAT04_FACI_NAME,value:faciName)
        dao.item(STAT04_FACI_DESP,value:faciDesp)
        dao.item(STAT04_FACI_LOCL,value:faciLocl)
        dao.item(STAT04_ESCA_DIRT,value:escaDirt)
        dao.item(STAT04_WHEL_CAIR_ACES,value:whelCairAces)
        dao.item(STAT04_BABY_CAIR,value:babyCair)
        dao.item(STAT04_BABY_CHGN_TABL,value:babyChgnTabl)
        dao.item(STAT04_TOIL_FOR_OSTM,value:toilForOstm)
        dao.item(STAT04_REMARK,value:remark)
        dao.item(STAT04_WHEL_CAIR,value:whelCair)
        
        
        return dao
    }
}