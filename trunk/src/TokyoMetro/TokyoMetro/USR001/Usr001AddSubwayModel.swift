//
//  Usr001AddSubwayModel.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation


class Usr001AddSubwayModel {
    
    
    // 删除收藏表中的数据
    func removeCollection(ruteRowId: String?) -> Bool {
        // 没有rowid时不让删除
        if (ruteRowId == nil || ruteRowId == "") {
            return false
        }
        
        var table = UsrT03FavoriteTable()
        table.rowid = ruteRowId!
        
        if (table.selectAll().count > 0) {
            return table.delete()
        } else {
            return false
        }
    }
    
    /**
    * 从DB查询地标信息
    */
    func selectLandMarkTable(type:Int, landMarkId: String) -> NSMutableArray{
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        var landMarks: NSMutableArray = NSMutableArray.array()
        
        var landMarkTypeStr:String = ""
        switch type{
        case 2:
            landMarkTypeStr = "景点"
        case 3:
            landMarkTypeStr = "美食"
        case 4:
            landMarkTypeStr = "购物"
        default:
            println("nothing")
        }
        if (landMarkId != "") {
            var rows = mstT04Table.excuteQuery("select *, ROWID from MSTT04_LANDMARK where LMAK_TYPE = '\(landMarkTypeStr)' and LMAK_ID in (\(landMarkId)) and IMAG_ID1 IS NOT NULL")
            
            for key in rows {
                key as MstT04LandMarkTable
                landMarks.addObject(key)
            }
        }
        
        return landMarks
    }

}