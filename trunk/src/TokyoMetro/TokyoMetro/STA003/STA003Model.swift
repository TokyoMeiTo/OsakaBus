//
//  STA003Model.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import CoreLocation

class STA003Model{
    
    func findNearbyStations(location: CLLocation!) -> Array<MstT02StationTableData>{
        let mMstT02Dao:MstT02StationTable = MstT02StationTable()
        
        var coordinateOnMars: CLLocationCoordinate2D = location.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
    
        var mMst02Tables:Array<MstT02StationTable> = mMstT02Dao.queryNearbyStations(lon,lat: lat) as Array<MstT02StationTable>
        
        var mMst02Datas:Array<MstT02StationTableData> = Array<MstT02StationTableData>()
        for mMst02Table in mMst02Tables{
            var mMst02Data:MstT02StationTableData = MstT02StationTableData()
            mMst02Datas.append(mMst02Data.fromDAO(mMst02Table) as MstT02StationTableData)
        }
        
        return mMst02Datas
    }
    
    func findLineTable(lineID:String!) -> MstT01LineTableData{
        var mMstT01Dao:MstT01LineTable = MstT01LineTable()
        mMstT01Dao.lineId = lineID
        
        var mMst01Data:MstT01LineTableData = MstT01LineTableData()
        return mMst01Data.fromDAO(mMstT01Dao.select()) as MstT01LineTableData
    }
    
    /**
     * 计算两点之间距离
     */
    func calcDistance(fromLocation: CLLocation, statLocation: CLLocation) -> CDouble{
        return statLocation.distanceFromLocation(fromLocation)
    }
    
    /**
     * 0.00KM
     */
    func convertDistance(distance: CDouble) -> String{
        if(distance < 1000){
            return "\(distance)" + " M"
        }
        return "\(distance / 1000)".decimal(2) + " KM"
    }
}