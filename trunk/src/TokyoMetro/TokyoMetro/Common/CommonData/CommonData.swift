//
//  CommonData.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CommonData {
    
    let EMPTY_STRING:String = ""
    
    var rowid:String = ""
    
    func fromDAO(dao:ODBDataTable) -> CommonData
    {
        rowid = dbNull(dao.item(ODB_TABLE_ROWID) as? String)
        return self;
    }
    
    func fromDAOs(daos:NSArray) -> Array<CommonData>
    {
        var result:Array<CommonData> = Array<CommonData>()
        for row in daos {
            result.append(fromDAO(row as ODBDataTable))
        }
        return result
    }
    
    func toDAO() -> ODBDataTable
    {
        var dao:ODBDataTable = ODBDataTable()
        dao.item(ODB_TABLE_ROWID,value: rowid)
        
        return dao
    }
    
    func dbNull(text:String?)->String
    {
        if(text == nil)
        {
            return EMPTY_STRING
        }
        else
        {
            return text!
        }
    }
    
    func textToBool(text:String?) -> Bool
    {
        if self.dbNull(text) == "0" || self.dbNull(text) == EMPTY_STRING
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func textToDouble(text:String?) -> Double
    {
        return (self.dbNull(text).numberic() as NSString).doubleValue
    }
    
}
