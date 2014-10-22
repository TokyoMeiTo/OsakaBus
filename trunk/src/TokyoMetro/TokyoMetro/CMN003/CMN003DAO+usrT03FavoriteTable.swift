//
//  CMN003DAO+usrT03FavoriteTable.swift
//  TokyoMetro
//
//  Created by limc on 14-10-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
extension UsrT03FavoriteTable{
    
    func addUserFavoriteRoute(routeId:String) -> NSArray? {
    
        self.ruteId = routeId
        self.favoType = "04"
        var user03insertBefore = self.selectAll()
        
        return user03insertBefore
    }
    
    func queryAllFavoriteRoute() -> NSArray? {
        var user03tableAdd = UsrT03FavoriteTable()
        user03tableAdd.favoType = "04"
        var user03Add = user03tableAdd.selectAll()
        
        return user03Add
    }

}