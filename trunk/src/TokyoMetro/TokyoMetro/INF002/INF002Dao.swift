//
//  INF002Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/30.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class INF002Dao:MstT04LandMarkTable {
    
    let QUERY_LANDMARK = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL"
    
    let QUERY_LANDMARK_FILTER = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ?"

    let QUERY_LANDMARK_SUBTYPE = "select * from MSTT04_LANDMARK where  LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_SUB_TYPE)"
    
    func queryLandMarks(lmkNm:String) -> NSArray {
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lmkNm);

        return self.excuteQuery( QUERY_LANDMARK, withArgumentsInArray: arr);
    }
    
    func queryLandMarksFilter(lmkNm: String,lon:CDouble, lat:CDouble,distance: Int) -> NSArray {
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lmkNm);
        arr.addObject(lon);
        arr.addObject(lat);
        arr.addObject(distance);
        
        return self.excuteQuery( QUERY_LANDMARK, withArgumentsInArray: arr);
    }
    
    func querySubType() ->NSArray {
        return self.excuteQuery( QUERY_LANDMARK_SUBTYPE);
    }
}
