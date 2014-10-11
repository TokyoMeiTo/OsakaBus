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
    
    func queryLandMarks(lmkNm:String) -> NSArray {
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lmkNm);

        return self.excuteQuery( QUERY_LANDMARK, withArgumentsInArray: arr);
    }
}
