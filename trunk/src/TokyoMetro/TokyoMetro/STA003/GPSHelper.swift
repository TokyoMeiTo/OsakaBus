//
//  GPSHelper.swift
//  TokyoMetroGPSDemo
//
//  Created by zhourr_ on 2014/09/10.
//  Copyright (c) 2014年 zhourr_. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

/**
 * GPS相关功能
 */
class GPSHelper: UIViewController, CLLocationManagerDelegate{
    /* CLLocationManager */
    var locationManager:CLLocationManager = CLLocationManager()
    /* LocationController */
    var delegate:GPSDelegate?
    /* 当前位置 */
    var currentLocation : CLLocation = CLLocation()
    
    /**
     * 定位到当前位置
     */
    func updateLocation(){
        var authStatus = CLLocationManager.authorizationStatus()
        
        var GPSEnabled = false
        switch authStatus {
        case CLAuthorizationStatus.NotDetermined:
            NSLog("GPS authorization status: NotDetermined")
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case CLAuthorizationStatus.Restricted:
            NSLog("GPS authorization status: Restricted")
            
        case CLAuthorizationStatus.Denied:
            NSLog("GPS authorization status: Denied")
            
        case CLAuthorizationStatus.Authorized:
            NSLog("GPS authorization status: Authorized")
            GPSEnabled = true
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            NSLog("GPS authorization status: AuthorizedWhenInUse")
            GPSEnabled = true
        }
        if(GPSEnabled){
            if(locationManager.delegate == nil){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 1000.0
            }
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /*
     *  locationManager:didUpdateLocations:
     *
     *  Discussion:
     *    Invoked when new locations are available.  Required for delivery of
     *    deferred locations.  If implemented, updates will
     *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
     *
     *    locations is an array of CLLocation objects in chronological order.
     */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        // 没有获取到位置信息
        if(locations.isEmpty){
            return
        }
        // 经纬度获取成功
        currentLocation = locations[locations.count - 1] as CLLocation

        delegate!.locationUpdateComplete(currentLocation)
        manager.stopUpdatingLocation()
    }
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println("STA003_01".localizedString() + error.code.description)
        delegate!.locationUpdateComplete(currentLocation)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

}