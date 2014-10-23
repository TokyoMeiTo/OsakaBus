//
//  CMN003Model.swift
//  TokyoMetro
//
//  Created by limc on 14-10-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CMN003Model {
    
    // 收藏路线
    func addUserFavoriteRoute(routeId:String) -> Bool {
        let usrT03DaoRoute:UsrT03FavoriteTable = UsrT03FavoriteTable()
        usrT03DaoRoute.ruteId = routeId
        usrT03DaoRoute.favoType = "04"
        var user03insertRouteBefore = usrT03DaoRoute.selectAll()
        
        var checkInsert : NSMutableArray = NSMutableArray.array()
        for user03checkRouteInsertValue in user03insertRouteBefore {
            user03checkRouteInsertValue  as UsrT03FavoriteTable
            var mst03ResultLineId:AnyObject = user03checkRouteInsertValue.item(USRT03_RUTE_ID)
            checkInsert.addObject(mst03ResultLineId)
        }
        if (checkInsert.count == 0) {
            usrT03DaoRoute.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insertRoute = usrT03DaoRoute.insert()
            if user03insertRoute {
                return true
            }
            return false
        }
        return false
    }
    
    // 收藏站点
    func addUserFavoriteStat(statId:String) -> Bool {
        let usrT03DaoStat:UsrT03FavoriteTable = UsrT03FavoriteTable()
        usrT03DaoStat.statId = statId
        usrT03DaoStat.favoType = "01"
        var user03insertStatBefore = usrT03DaoStat.selectAll()
        
        var checkInsert : NSMutableArray = NSMutableArray.array()
        for user03checkStatInsertValue in user03insertStatBefore {
            user03checkStatInsertValue  as UsrT03FavoriteTable
            var mst03ResultstatId:AnyObject = user03checkStatInsertValue.item(USRT03_RUTE_ID)
            checkInsert.addObject(mst03ResultstatId)
        }
        if (checkInsert.count == 0) {
            usrT03DaoStat.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insertStat = usrT03DaoStat.insert()
            if user03insertStat {
                return true
            }
            return false
        }
        return false
    }
    
    // 根据statId查询该站点详情
    func getStationDetialById(StationID:String) -> MstT02StationTable{
        var mst02table = MstT02StationTable()
        mst02table.statId = StationID
        var mMst02StationArr:MstT02StationTable = mst02table.select() as MstT02StationTable
        return mMst02StationArr
    }

}