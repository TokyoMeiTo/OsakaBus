//
//  CmnT03StationGridTable+CMN002.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/09.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension CmnT03StationGridTable {
    func findByPoint(xFrom:String,xTo:String,yFrom:String,yTo:String) -> NSArray?{
        let sqlStr:String = "select * , ROWID from CMNT03_STATION_GRID where PONT_X_FROM < ? and PONT_X_TO > ? and PONT_Y_FROM < ? and PONT_Y_TO > ? limit 0,1"
        
        let argsArr:NSMutableArray = NSMutableArray.array()
        
        argsArr.addObject(xFrom)
        argsArr.addObject(xTo)
        argsArr.addObject(yFrom)
        argsArr.addObject(yTo)
        
        return self.excuteQuery(sqlStr, withArgumentsInArray:argsArr);
    }
    
    func findPointByStatId(StationId:String) -> NSArray?{
        let sqlStr:String = "select * , ROWID from CMNT03_STATION_GRID where STAT_ID = '\(StationId)' "
        
        let argsArr:NSMutableArray = NSMutableArray.array()
        
        argsArr.addObject(StationId)
        
        return self.excuteQuery(sqlStr, withArgumentsInArray:argsArr);
    }
}