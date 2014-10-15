//
//  INF002Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/30.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension MstT04LandMarkTable {
//    let QUERY_STATION = "select * , ROWID from MSTT02_STATION where STAT_GROUP_ID = ?"
  
    func queryLandMarks(lmkNm:String) -> NSArray {
        let QUERY_LANDMARK = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL"

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lmkNm);

        return self.excuteQuery( QUERY_LANDMARK, withArgumentsInArray: arr);
    }
    
    func queryLandMarksFilter(type: String?, lon:CDouble?, lat:CDouble?, distance: Int?, sataId:String?, specialWard:String?) -> NSArray {
        var queryFiter = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL"
//        AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ? AND STAT_ID = ? AND LMAK_WARD = ?

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(type!);

        if(lon != 0 && lat != 0 && distance != 0){
            arr.addObject(lon!);
            arr.addObject(lat!);
            arr.addObject(distance!);
            queryFiter = queryFiter + " AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ?"
        }

        if(sataId != ""){
            arr.addObject(sataId!);
            queryFiter = queryFiter + " AND STAT_ID = ?"
        }
        
        if(specialWard != ""){
            arr.addObject(specialWard!);
            queryFiter = queryFiter + " AND LMAK_WARD = ?"
        }

        return self.excuteQuery( queryFiter, withArgumentsInArray: arr);
    }
    
    func querySubType() ->NSArray {
        let QUERY_LANDMARK_SUBTYPE = "select * from MSTT04_LANDMARK where  LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_SUB_TYPE)"

        return self.excuteQuery( QUERY_LANDMARK_SUBTYPE);
    }
    
    func queryLandMarkStations(landMark:MstT04LandMarkTable) -> Array<MstT02StationTable> {
        let QUERY_ALL_STATION = "select * , ROWID from MSTT04_LANDMARK where LMAK_NAME_EXT1 = ?"

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(landMark.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))
        
        var landMarkStats:Array<MstT04LandMarkTable>? = self.excuteQuery( QUERY_ALL_STATION, withArgumentsInArray:arr) as? Array<MstT04LandMarkTable>
        
        var stats:Array<MstT02StationTable> = Array<MstT02StationTable>()
        
        var statArr:NSMutableArray = NSMutableArray.array();
        
        for landMarkStat in landMarkStats!{
            landMarkStat as MstT04LandMarkTable
            var mstT02Table:MstT02StationTable = MstT02StationTable()
            mstT02Table.statId = "\(landMarkStat.item(MSTT04_LANDMARK_STAT_ID))"
            stats.append(mstT02Table.select() as MstT02StationTable)
        }
        return stats;
    }
    
    func queryLandMarksFilter(type: String?, lon:CDouble?, lat:CDouble?, distance: Int?, sataId:String?, specialWard:String?, subType:String, price:String, miciRank:String, rank:String) -> NSArray {
        var queryFiter = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL"
        //        AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ? AND STAT_ID = ? AND LMAK_WARD = ?
        
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(type!);
        
        if(lon != 0 && lat != 0 && distance != 0){
            arr.addObject(lon!);
            arr.addObject(lat!);
            arr.addObject(distance!);
            queryFiter = queryFiter + " AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ?"
        }
        
        if(sataId != ""){
            arr.addObject(sataId!);
            queryFiter = queryFiter + " AND STAT_ID = ?"
        }
        
        if(specialWard != ""){
            arr.addObject(specialWard!);
            queryFiter = queryFiter + " AND LMAK_WARD = ?"
        }
        
        if(subType != ""){
            arr.addObject(subType);
            queryFiter = queryFiter + " AND LMAK_SUB_TYPE = ?"
        }
        
        if(price != ""){
            arr.addObject(price);
            queryFiter = queryFiter + " AND LMAK_TICT_PRIC = ?"
        }
        
        if(miciRank != ""){
            arr.addObject(price);
            queryFiter = queryFiter + " AND LMAK_MICI_RANK = ?"
        }
        
        if(rank != ""){
            arr.addObject(price);
            queryFiter = queryFiter + " AND LMAK_RANK = ?"
        }
        
        return self.excuteQuery( queryFiter, withArgumentsInArray: arr);
    }
}
