//
//  GPS.swift
//  TokyoMetroDemo
//
//  Created by zhourr_ on 2014/09/16.
//  Copyright (c) 2014年 zhourr_. All rights reserved.
//

import Foundation
import CoreLocation

protocol GPSDelegate : NSObjectProtocol{
    
    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation)
    /**
     * 位置定位完成
     */
    func locationUpdateError()
}