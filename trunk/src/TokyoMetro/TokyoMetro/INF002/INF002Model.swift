//
//  INF002Model.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class INF002Model {
    
    func findFav(lmkId:String) -> UsrT03FavoriteTableData {
        var mUsr03Dao:UsrT03FavoriteTable = UsrT03FavoriteTable()
        mUsr03Dao.favoType = "03"
        mUsr03Dao.lmakId = lmkId
        
        var mUsrT03Data:UsrT03FavoriteTableData = UsrT03FavoriteTableData()
        return mUsrT03Data.fromDAO(mUsr03Dao.select()) as UsrT03FavoriteTableData
    }
    
    func insertFav(mUsrT03Data: UsrT03FavoriteTableData){
        mUsrT03Data.toDAO().insert()
    }
    
    func deleteFav(mUsrT03Data: UsrT03FavoriteTableData){
        var mUsr03Dao = mUsrT03Data.toDAO()
        mUsr03Dao.select()
        mUsr03Dao.delete()
    }
    
}