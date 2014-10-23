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
    func findArrivalAlarm() -> Array<UsrT01ArrivalAlarmTableData>{
        let mUsrT01Dao = UsrT01ArrivalAlarmTable()
        let mUsrT01Tables:[UsrT01ArrivalAlarmTable] = mUsrT01Dao.selectAll() as Array<UsrT01ArrivalAlarmTable>
        var mUsrT01Datas:Array<UsrT01ArrivalAlarmTableData> = Array<UsrT01ArrivalAlarmTableData>()
        for mUsrT01Table in mUsrT01Tables{
            var mUsrT01Data:UsrT01ArrivalAlarmTableData = UsrT01ArrivalAlarmTableData()
            mUsrT01Datas.append(mUsrT01Data.fromDAO(mUsrT01Table) as UsrT01ArrivalAlarmTableData)
        }
        return mUsrT01Datas
    }
    
    /**
     * 从DB查询首末班车信息
     */
    func findTrainAlarmTable() -> Array<UsrT02TrainAlarmTableData>{
        let mUsrT02Dao = UsrT02TrainAlarmTable()
        let mUsrT02Tables:[UsrT02TrainAlarmTable] = mUsrT02Dao.selectAll() as Array<UsrT02TrainAlarmTable>
        var mUsrT02Datas:Array<UsrT02TrainAlarmTableData> = Array<UsrT02TrainAlarmTableData>()
        for mUsrT02Table in mUsrT02Tables{
            var mUsrT02Data:UsrT02TrainAlarmTableData = UsrT02TrainAlarmTableData()
            mUsrT02Datas.append(mUsrT02Data.fromDAO(mUsrT02Table) as UsrT02TrainAlarmTableData)
        }
        
        return mUsrT02Datas
    }
    
    /**
     * 从DB查询站点信息
     */
    func findStationTableOne(stationId: String) -> MstT02StationTableData{
        var tableMstT02 = MstT02StationTable()
        tableMstT02.statId = stationId
        
        var mMst02Data:MstT02StationTableData = MstT02StationTableData()
        return mMst02Data.fromDAO(tableMstT02.select()) as MstT02StationTableData
    }
    
    /**
     * 从DB查询线路
     */
    func findLinT04RouteTable(startStationId: String, toStationId: String) -> Bool{
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = findStationTableOne(startStationId).statGroupId
        tableLinT04.termStatId = findStationTableOne(toStationId).statGroupId
        return (tableLinT04.ruteId == nil)
    }
    
    /**
     * 从DB查询花费时间
     */
    func findLinT05RouteDetailTable(startStationId: String, toStationId: String) -> Array<LinT05RouteDetailTableData>{
        let QUERY_EXCH = "select * , ROWID from LINT05_ROUTE_DETAIL where RUTE_ID = ?"
        
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = findStationTableOne(startStationId).statGroupId
        tableLinT04.termStatId = findStationTableOne(toStationId).statGroupId
        var mLinT04Data:LinT04RouteTableData = LinT04RouteTableData()
        mLinT04Data.fromDAO(tableLinT04.select())
        var ruteId: String = mLinT04Data.ruteId
        var costTime:Int = 0
        var tableLinT05 = LinT05RouteDetailTable()
        
        var args:NSMutableArray = NSMutableArray.array();
        args.addObject(ruteId);
        
        let mLinT05Tables:[LinT05RouteDetailTable] = tableLinT05.excuteQuery(QUERY_EXCH, withArgumentsInArray: args) as Array<LinT05RouteDetailTable>
        var mLinT05Datas:Array<LinT05RouteDetailTableData> = Array<LinT05RouteDetailTableData>()
        
        for mLinT05Table in mLinT05Tables{
            var mLinT05Data:LinT05RouteDetailTableData = LinT05RouteDetailTableData()
            mLinT05Datas.append(mLinT05Data.fromDAO(mLinT05Table) as LinT05RouteDetailTableData)
        }
        
        return mLinT05Datas
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
    func findLineTable() -> Array<MstT01LineTableData>{
        var mMstT01Dao:MstT01LineTable = MstT01LineTable()
        
        var mMst01Tables:[MstT01LineTable] = mMstT01Dao.selectTop(LINE_COUNT) as [MstT01LineTable]
        
        var mMst01Datas:Array<MstT01LineTableData> = Array<MstT01LineTableData>()
        for mMst01Table in mMst01Tables{
            var mMst01Data:MstT01LineTableData = MstT01LineTableData()
            mMst01Datas.append(mMst01Data.fromDAO(mMst01Table) as MstT01LineTableData)
        }
        
        return mMst01Datas
    }

    /**
     * 更新DB(到站提醒)
     */
    func updateUsrT01(mUsrT01Data:UsrT01ArrivalAlarmTableData) -> Bool{
        var mUsrT01Dao = mUsrT01Data.toDAO()
        mUsrT01Dao.rowid = mUsrT01Data.rowid
        return mUsrT01Dao.update()
    }
    
    /**
     * 更新DB(到站提醒)
     */
    func insertUsrT01(mUsrT01Data:UsrT01ArrivalAlarmTableData) -> Bool{
        return mUsrT01Data.toDAO().insert()
    }
    
    /**
     * 更新DB(首末班车提醒)
     */
    func updateUsrT02(mUsrT02Data:UsrT02TrainAlarmTableData) -> Bool{
        var mUsrT02Dao = mUsrT02Data.toDAO()
        mUsrT02Dao.rowid = mUsrT02Data.rowid
        return mUsrT02Dao.update()
    }

    /**
     * 更新DB(首末班车提醒)
     */
    func insertUsrT02(mUsrT02Data:UsrT02TrainAlarmTableData) -> Bool{
        return mUsrT02Data.toDAO().insert()
    }

    /**
     * 从DB删除末班车提醒
     */
    func deleteUsrT02(mUsrT02Data:UsrT02TrainAlarmTableData) -> Bool{
        var mUsrT02Dao = mUsrT02Data.toDAO() as UsrT02TrainAlarmTable
        mUsrT02Dao.select()
        return mUsrT02Dao.delete()
    }

}