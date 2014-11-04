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
    
    let MSG_0001:String = "PUBLIC_08".localizedString()
    let MSG_0002:String = "请在设置->隐私中打开定位服务"
    let MSG_0003:String = "PUBLIC_06".localizedString()
    
    /**
     * 定位到当前位置
     */
    func updateLocation(){
        var authStatus = CLLocationManager.authorizationStatus()
        
        var GPSEnabled = false
        switch authStatus {
        case CLAuthorizationStatus.NotDetermined:
            GPSEnabled = false
            locationManager.delegate = self
            delegate!.locationUpdateError()
            //for ios 8
            if (locationManager.respondsToSelector("requestAlwaysAuthorization")){
                locationManager.requestWhenInUseAuthorization()
            }else{
                // 未打开定位服务
                alertGPSTip()
            }
        case CLAuthorizationStatus.Restricted:
            GPSEnabled = false
            delegate!.locationUpdateError()
            //for ios 8
            if (locationManager.respondsToSelector("requestAlwaysAuthorization")){
                locationManager.requestWhenInUseAuthorization()
            }else{
                // 未打开定位服务
                alertGPSTip()
            }
        case CLAuthorizationStatus.Denied:
            GPSEnabled = false
            delegate!.locationUpdateError()
            //for ios 8
            if (locationManager.respondsToSelector("requestAlwaysAuthorization")){
                locationManager.requestWhenInUseAuthorization()
            }else{
                // 未打开定位服务
                alertGPSTip()
            }
        case CLAuthorizationStatus.Authorized:
            GPSEnabled = true
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            GPSEnabled = true
        }
        if(GPSEnabled){
            if(locationManager.delegate == nil){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = 1000.0
            }
            locationManager.startUpdatingLocation()
            
            //for ios 8
            if (locationManager.respondsToSelector("requestAlwaysAuthorization")){
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func checkGPSStatus() -> Bool{
        var authStatus = CLLocationManager.authorizationStatus()
        
        var GPSEnabled = false
        switch authStatus {
        case CLAuthorizationStatus.NotDetermined:
            GPSEnabled = false
            
        case CLAuthorizationStatus.Restricted:
            GPSEnabled = false
            
        case CLAuthorizationStatus.Denied:
            GPSEnabled = false
            
        case CLAuthorizationStatus.Authorized:
            GPSEnabled = true
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            GPSEnabled = true
        }
        return GPSEnabled
    }
    
    func alertGPSTip(){
        // 未打开定位服务
        RemindDetailController.showMessage(MSG_0001,
            msg:MSG_0002,
            buttons:[MSG_0003],
            delegate: self)
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
        // 经纬度获取成功
        currentLocation = locations[locations.count - 1] as CLLocation
        
        if(checkLocation(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)){
            delegate!.locationUpdateComplete(currentLocation)
        }
        manager.stopUpdatingLocation()
    }
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error.code)
        delegate!.locationUpdateComplete(currentLocation)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    /**
     * checkLocation
     * @param latitude,longitude
     *  -> Bool
     */
    func checkLocation(latitude: Double, longitude: Double) -> Bool{
        return latitude > 0 && latitude < 90 && longitude > 0 && longitude < 180
    }

}