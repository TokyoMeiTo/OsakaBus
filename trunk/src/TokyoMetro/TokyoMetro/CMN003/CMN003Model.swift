//
//  CMN003Model.swift
//  TokyoMetro
//
//  Created by limc on 14-10-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CMN003Model {
    
    
    func addUserFavoriteRoute(routeId:String) -> Bool {
        let usrT03Dao:UsrT03FavoriteTable = UsrT03FavoriteTable()
        usrT03Dao.ruteId = routeId
        usrT03Dao.favoType = "04"
        var user03insertBefore = usrT03Dao.selectAll()
        
        var checkInsert : NSMutableArray = NSMutableArray.array()
        for user03checkInsertValue in user03insertBefore {
            user03checkInsertValue  as UsrT03FavoriteTable
            var mst02ResultLineId:AnyObject = user03checkInsertValue.item(USRT03_RUTE_ID)
            checkInsert.addObject(mst02ResultLineId)
        }
        if (checkInsert.count == 0) {
            usrT03Dao.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insert = usrT03Dao.insert()
            if user03insert {
                return true
            }
            return false
        }
        return false
    }

}