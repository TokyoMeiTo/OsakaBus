//
//  CMN002Model.swift
//  TokyoMetro
//
//  Created by limc on 2014/10/09.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class CMN002Model {
    
    func findStationLines(station:CMN002StationData) -> NSMutableArray{
        let mMstT02Dao:MstT02StationTable = MstT02StationTable()
        mMstT02Dao.statGroupId = station.statGroupId as NSString
        let mLineArray = mMstT02Dao.selectAll()
        
        var mlineGroup : NSMutableArray = NSMutableArray.array()
        for mlineIds in  mLineArray {
            mlineIds as MstT02StationTable
            var mLineId = mlineIds.lineId as String
            mlineGroup.addObject(mLineId)
        }

        return mlineGroup
    }
    
    func findTouchedStation(touchX:CGFloat,touchY:CGFloat) -> CMN002StationData? {
        var mCmnT03Dao:CmnT03StationGridTable = CmnT03StationGridTable()
        
        //将浮点数转换为字符串
        var xStr = (touchX * 2).description
        var yStr = (touchY * 2).description
        
        //检索数据库
        var mStationArray:NSArray? = mCmnT03Dao.findByPoint(xStr,xTo: xStr,yFrom: yStr,yTo: yStr)!
        


        //遍历结果
        for mCmnT03Row in mStationArray!{
            mCmnT03Row as CmnT03StationGridTable
            var stationId:String! = mCmnT03Row.statId as String
            if((stationId) != nil){
                var mMst02Dao = MstT02StationTable()
                mMst02Dao.statId = stationId
                var mMst02DaoRow:MstT02StationTable = mMst02Dao.select() as MstT02StationTable
                var result:CMN002StationData = CMN002StationData()
                result.statId = mMst02DaoRow.statId as String
                result.statGroupId = mMst02DaoRow.statGroupId as String
                result.statNameExt1 = mMst02DaoRow.statNameExt1 as String
                result.statName = mMst02DaoRow.statName as String
                result.statNameMetroId = mMst02DaoRow.statNameMetroId as String
//                result.statFromX = mCmnT03Row.stationGrideFromX as CGFloat
//                result.statFromY = mCmnT03Row.stationGrideFromX as CGFloat
//                result.statToX = mCmnT03Row.stationGrideFromX as CGFloat
//                result.statToY = mCmnT03Row.stationGrideFromX as CGFloat
                
                result.statFromX = mCmnT03Row.item(CMNT03_PONT_X_FROM) as CGFloat
                result.statFromY = mCmnT03Row.item(CMNT03_PONT_Y_FROM) as CGFloat
                result.statToX = mCmnT03Row.item(CMNT03_PONT_X_TO) as CGFloat
                result.statToY = mCmnT03Row.item(CMNT03_PONT_Y_TO) as CGFloat

                
                return result
            }
        }
        
        
        //找不到的情况下返回空
        return nil;
    }
}
