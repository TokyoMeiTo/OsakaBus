//
//  LandMarkMapController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class LandMarkMapController: UIViewController, MKMapViewDelegate, UIActionSheetDelegate{
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    
    /* 起点軽度   */
    var fromLat:CDouble = 35.683618//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon:CDouble = 139.766453//121.38368547 // 天地科技广场1号楼
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    var landMarkType:String = "景点"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initMap()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * 显示地图
     */
    func initMap(){
        mkMap.delegate = self
        // 设置地图显示类型
        mkMap.mapType = MKMapType.Standard
        mkMap.showsUserLocation = true
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        var statLat:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LAT))" as NSString).doubleValue
        var statLon:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LON))" as NSString).doubleValue
        
        var statLocation = CLLocation(latitude: fromLat, longitude: fromLon)
        
        // MKMapView定位到当前位置
        var coordinateOnEarth = statLocation.coordinate
        var annotation = MKPointAnnotation()
        annotation.title = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
        annotation.coordinate = coordinateOnEarth
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:false)
        
        mkMap.addAnnotation(annotation)
        mkMap.selectAnnotation(annotation, animated: true)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) ->
        MKAnnotationView!{
            if (annotation is MKUserLocation){
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            var pinView:MKPinAnnotationView?
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))")
            // 4'3'5
            var img = UIImage(named: "INF00204.png")
            landMarkType = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))" as String
            switch landMarkType{
            case "景点":
                img = UIImage(named: "INF00204.png")
            case "美食":
                img = UIImage(named: "INF00203.png")
            case "购物":
                img = UIImage(named: "INF00205.png")
            default:
                println("nothing")
            }
            pinView!.pinColor = .Red
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            
            return pinView!
    }

}