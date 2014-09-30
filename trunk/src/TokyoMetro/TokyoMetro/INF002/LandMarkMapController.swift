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
    let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
    
    /* 当前位置信息 */
    var location:CLLocation?
    
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
//        if(location == nil){
//            return
//        }
        mkMap.delegate = self
        // 设置地图显示类型
        mkMap.mapType = MKMapType.Standard
        mkMap.showsUserLocation = true
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        // MKMapView定位到当前位置
        var coordinateOnEarth = CLLocationCoordinate2D(latitude:fromLat, longitude:fromLon)
        var annotation = MKPointAnnotation()
        annotation.title = "日本武道馆"
        annotation.coordinate = coordinateOnEarth
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:false)
        mkMap.addAnnotation(annotation)
        mkMap.selectAnnotation(annotation, animated: true)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
    }
}