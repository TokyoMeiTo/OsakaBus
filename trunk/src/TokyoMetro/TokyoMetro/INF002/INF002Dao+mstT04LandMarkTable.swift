//
//  INF002Dao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/30.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension MstT04LandMarkTable {
  
    func queryLandMarks(lmkNm:String) -> NSArray {
        let QUERY_LANDMARK = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME_EXT1) AND IMAG_ID1 IS NOT NULL"

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(lmkNm);

        return self.excuteQuery( QUERY_LANDMARK, withArgumentsInArray: arr);
    }
    
    func queryLandMarksFilter(type: String?, lon:CDouble?, lat:CDouble?, distance: Int?, sataId:String?, specialWard:String?) -> NSArray {
        var queryFiter = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_NAME IS NOT NULL AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME) AND IMAG_ID1 IS NOT NULL"

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
    
    func querySubType() ->Array<String> {
        let QUERY_LANDMARK_SUBTYPE = "select * , ROWID from MSTT04_LANDMARK where LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK where LMAK_TYPE = '2' group by LMAK_SUB_TYPE)"
        var mMstT04Daos:[MstT04LandMarkTable] = self.excuteQuery(QUERY_LANDMARK_SUBTYPE) as Array<MstT04LandMarkTable>
        var mSubTypes:Array<String> = Array<String>()
        for mMstT04Dao in mMstT04Daos{
            if(mMstT04Dao.item(MSTT04_LANDMARK_LMAK_SUB_TYPE) == nil){
                continue
            }
            mSubTypes.append("\(mMstT04Dao.item(MSTT04_LANDMARK_LMAK_SUB_TYPE))")
        }
        return mSubTypes
    }
    
    func queryLandMarkStations(landMark:MstT04LandMarkTable) -> Array<MstT02StationTable> {
        let QUERY_ALL_STATION = "select * , ROWID from MSTT04_LANDMARK where LMAK_NAME IS NOT NULL AND LMAK_NAME = ?"

        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(landMark.item(MSTT04_LANDMARK_LMAK_NAME))
        
        var landMarkStats:Array<MstT04LandMarkTable>? = self.excuteQuery( QUERY_ALL_STATION, withArgumentsInArray:arr) as? Array<MstT04LandMarkTable>
        
        var stats:Array<MstT02StationTable> = Array<MstT02StationTable>()
        
        var statArr:NSMutableArray = NSMutableArray.array();
        
        for landMarkStat in landMarkStats!{
            landMarkStat as MstT04LandMarkTable
            var mstT02Table:MstT02StationTable = MstT02StationTable()
            mstT02Table.statGroupId = "\(landMarkStat.item(MSTT04_LANDMARK_STAT_ID))"
            var mMst02Tables:[MstT02StationTable] = mstT02Table.selectAll() as [MstT02StationTable]
            for key in mMst02Tables{
                if(key.lineId == nil || key.lineId == "" || key.statNameKana == nil || key.statNameKana == ""){
                    continue
                }
                stats.append(key)
            }
            break
        }
        return stats;
    }
    
    func queryLandMarksFilter(type: String?, lon:CDouble?, lat:CDouble?, distance: Int?, sataId:String?, specialWard:String?, subType:String, price:Int, miciRank:String, rank:String) -> NSArray {
        var queryFiter = "select * , ROWID from MSTT04_LANDMARK where LMAK_TYPE = ? AND LMAK_NAME IS NOT NULL AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME) AND IMAG_ID1 IS NOT NULL"
        //        AND (LMAK_LON - ?) * (LMAK_LON - ?) + (LMAK_LAT - ?)*(LMAK_LAT - ?) < ? AND STAT_ID = ? AND LMAK_WARD = ?
        
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(type!);
        
        if(lon != 0 && lat != 0 && distance != 100000){
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
        
        if(subType != "INF002_19".localizedString()){
            arr.addObject(subType);
            queryFiter = queryFiter + " AND LMAK_SUB_TYPE = ?"
        }
        
        if(price != 0){
            switch price{
            case 1:
                queryFiter = queryFiter + " AND LMAK_PRIC_MIN IS NOT NULL"
                queryFiter = queryFiter + " AND LMAK_PRIC_MIN >= 5000"
            case 2:
                queryFiter = queryFiter + " AND LMAK_PRIC_MIN IS NOT NULL"
                queryFiter = queryFiter + " AND LMAK_PRIC_MIN >= 1000"
            case 3:
                queryFiter = queryFiter + " AND LMAK_PRIC_MAX IS NOT NULL"
                queryFiter = queryFiter + " AND LMAK_PRIC_MAX < 1000"
            default:
                println("nothing")
            }
        }
        
        if(miciRank != ""){
            queryFiter = queryFiter + " AND LMAK_MICI_RANK IS NOT NULL"
            queryFiter = queryFiter + " AND LMAK_MICI_RANK = " + miciRank
        }
        
        if(rank != ""){
            var mRank:Int = (rank as NSString).integerValue
            queryFiter = queryFiter + " AND LMAK_RANK IS NOT NULL"
            queryFiter = queryFiter + " AND " + "LMAK_RANK >= " + "\(mRank - 1)" + " AND " + "LMAK_RANK < " + "\(mRank)"
        }
        
        return self.excuteQuery( queryFiter, withArgumentsInArray: arr);
    }
    
    func queryLandMarkByStatId(statId: String, lmakType: String) -> NSArray {
        var queryFiter = "select * , ROWID from MSTT04_LANDMARK where STAT_ID = ? AND LMAK_ID in (select min(LMAK_ID) from MSTT04_LANDMARK group by LMAK_NAME) AND IMAG_ID1 IS NOT NULL"
        
        var arr:NSMutableArray = NSMutableArray.array();
        arr.addObject(statId);
        if (!lmakType.isEmpty) {
            arr.addObject(lmakType);
            queryFiter = queryFiter + " AND LMAK_TYPE = ?"
        }
        
        return self.excuteQuery(queryFiter, withArgumentsInArray: arr);
    }
}
