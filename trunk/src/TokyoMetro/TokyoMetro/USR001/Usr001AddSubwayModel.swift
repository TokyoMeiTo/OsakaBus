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
    
    
    func selectStatJPName(statId: String?) -> String {
        var table: MstT02StationTable = MstT02StationTable()
        if (statId == nil || statId == "") {
            return ""
        }
        table.statId = statId
        var rows = table.selectAll()
        
        if (rows.count > 0) {
            var key = rows[0] as MstT02StationTable
            return (key.item(MSTT02_STAT_NAME) as String) + "（\(key.item(MSTT02_STAT_NAME_KANA) as String)）"
        } else {
            return ""
        }
    }

}