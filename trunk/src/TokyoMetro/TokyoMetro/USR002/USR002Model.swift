//
//  USR002Model.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class USR002Model{

    /* 线路数量 */
    let LINE_COUNT:UInt = 9
    
    /**
     * 从DB查询到站信息
     */
    func findArrivalAlarm() -> Array<UsrT01ArrivalAlarmTable>{
        var tableUsrT01 = UsrT01ArrivalAlarmTable()
        return tableUsrT01.selectAll() as Array<UsrT01ArrivalAlarmTable>
    }
    
    /**
     * 从DB查询到站信息
     */
    func findTrainAlarmTable() -> Array<UsrT02TrainAlarmTable>{
        var tableUsrT02 = UsrT02TrainAlarmTable()
        return tableUsrT02.selectAll() as Array<UsrT02TrainAlarmTable>
    }
    
    /**
     * 从DB查询站点信息
     */
    func findStationTableOne(stationId: String) -> MstT02StationTable{
        var tableMstT02 = MstT02StationTable()
        tableMstT02.statId = stationId
        return tableMstT02.select() as MstT02StationTable
    }
    
    /**
     * 从DB查询线路
     */
    func findLinT04RouteTable(startStationId: String, toStationId: String) -> Bool{
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = "\((findStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = "\((findStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        return (tableLinT04.ruteId == nil)
    }
    
    /**
     * 从DB查询花费时间
     */
    func findLinT05RouteDetailTable(startStationId: String, toStationId: String) -> Array<LinT05RouteDetailTable>?{
        let QUERY_EXCH = "select * , ROWID from LINT05_ROUTE_DETAIL where RUTE_ID = ?"
        
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = "\((findStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = "\((findStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        var ruteId: String = "\((tableLinT04.select() as LinT04RouteTable).item(LINT04_ROUTE_RUTE_ID))"
        var costTime:Int = 0
        var tableLinT05 = LinT05RouteDetailTable()
        
        var args:NSMutableArray = NSMutableArray.array();
        args.addObject(ruteId);
        
        return tableLinT05.excuteQuery(QUERY_EXCH, withArgumentsInArray: args) as? Array<LinT05RouteDetailTable>
    }

    /**
     * 从DB删除到站提醒
     */
    func deleteAlarm(){
        var tableUsrT01 = UsrT01ArrivalAlarmTable()
        var arrivalAlarms:Array<UsrT01ArrivalAlarmTable> = tableUsrT01.selectAll() as Array<UsrT01ArrivalAlarmTable>
        for arrivalAlarm in arrivalAlarms{
            arrivalAlarm.delete()
        }
    }
    
    /**
     * 从DB查询线路信息
     */
    func findLineTable() -> Array<MstT01LineTable>{
        var tableMstT01 = MstT01LineTable()
        return tableMstT01.selectTop(LINE_COUNT) as Array<MstT01LineTable>
    }

}