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

}