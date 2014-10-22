//
//  Sta003Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/29.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class Cmn003Dao:MstT02StationTable {
    
    let QUERY_MINI_DISTANCE = "select *, ROWID, COUNT(STAT_NAME_EXT1) from MSTT02_STATION where LINE_ID LIKE '280%%' group by STAT_NAME_EXT1 order by (STAT_LON - ?) * (STAT_LON - ?) + (STAT_LAT - ?)*(STAT_LAT - ?) limit 0,10"

    func queryMiniDistance(lon:CDouble, lat:CDouble) -> NSArray {
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lon);
        arr.addObject(lon);
        arr.addObject(lat);
        arr.addObject(lat);
        
        return self.excuteQuery( QUERY_MINI_DISTANCE, withArgumentsInArray:arr);
    }

    
    func queryLineIdByGroupId(groupId:String) -> NSArray {
        self.statGroupId = groupId
        return self.selectAll()
    }

}
