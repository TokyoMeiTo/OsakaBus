//
//  INF002FavDao.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class INF002FavDao:UsrT03FavoriteTable {
    
    func queryFav(lmkId:String) -> UsrT03FavoriteTable {
        self.lmakId = lmkId
        var lmkFav:UsrT03FavoriteTable? = self.select() as? UsrT03FavoriteTable
        return lmkFav!;
    }
    
    func insertFav(tableUsrT03: UsrT03FavoriteTable){
        tableUsrT03.insert()
    }
    
    func deleteFav(tableUsrT03: UsrT03FavoriteTable){
        tableUsrT03.delete()
    }
}
