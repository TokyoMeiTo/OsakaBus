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
    
    func findNearbyStations(location: CLLocation) -> Array<MstT02StationTable>{
        
        let mMstT02Dao:MstT02StationTable = MstT02StationTable()
        var coordinateOnMars: CLLocationCoordinate2D = location.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
    
        return mMstT02Dao.queryNearbyStations(lon,lat: lat) as Array<MstT02StationTable>
    }
    
    func findLineTable(lineID:String) -> MstT01LineTable{
        var tableMstT01 = MstT01LineTable()
        tableMstT01.lineId = lineID
        return tableMstT01.select() as MstT01LineTable
    }
}