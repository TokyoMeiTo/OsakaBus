//
//  Sta003Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/29.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension MstT02StationTable {

    func queryNearbyStations(lon:CDouble, lat:CDouble) -> NSArray {
        let QUERY_MINI_DISTANCE = "select * , ROWID from MSTT02_STATION where LINE_ID LIKE '280%%' order by (STAT_LON - ?) * (STAT_LON - ?) + (STAT_LAT - ?)*(STAT_LAT - ?) limit 0,10"

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lon);
        arr.addObject(lon);
        arr.addObject(lat);
        arr.addObject(lat);
        
        return self.excuteQuery( QUERY_MINI_DISTANCE, withArgumentsInArray:arr);
    }
}
