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
        

        if (user03insertRouteBefore.count == 0) {
            usrT03DaoRoute.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insertRoute = usrT03DaoRoute.insert()
            if user03insertRoute {
                return true
            }
            return false
        }
        return false
    }

    // 删除车站
    func removeUserFavorite(deleteId:String, deleteType:String) -> Bool {
        
        let usrT03DaoStatDelete:UsrT03FavoriteTable = UsrT03FavoriteTable()
        
        if (deleteType == "01") {
        usrT03DaoStatDelete.statId = deleteId
        } else if (deleteType == "04") {
            usrT03DaoStatDelete.ruteId = deleteId
        } else {
            return false
        }
        
        var user03deleteStatBefore:NSArray = usrT03DaoStatDelete.selectAll()
        if (user03deleteStatBefore.count > 0) {
            var rowId  = (user03deleteStatBefore[0] as UsrT03FavoriteTable).rowid

            return removeCollection(rowId)
        }
        return false
    }
    
    // 删除收藏表中的数据
    func removeCollection(rowId: String?) -> Bool {
        // 没有rowid时不让删除
        if (rowId == nil || rowId == "") {
            return false
        }
        
        var table = UsrT03FavoriteTable()
        table.rowid = rowId!
        
        if (table.selectAll().count > 0) {
            return table.delete()
        } else {
            return false
        }
    }
    
    
    
    // 收藏站点
    func addUserFavoriteStat(statId:String) -> Bool {
        let usrT03DaoStat:UsrT03FavoriteTable = UsrT03FavoriteTable()
        usrT03DaoStat.statId = statId
        usrT03DaoStat.favoType = "01"
        var user03insertStatBefore = usrT03DaoStat.selectAll()

        if (user03insertStatBefore.count == 0) {
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