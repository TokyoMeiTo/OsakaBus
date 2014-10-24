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
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/

    let BTN_Location_TAG:Int = 120
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    
    var landMarkArr: NSArray?
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* 起点軽度   */
    var fromLat:CDouble = 35.683618//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon:CDouble = 139.766453//121.38368547 // 天地科技广场1号楼

    var landMarkType:String = "景点"
    
    var landMarkLocation:CLLocation?
    
    var statId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initMap()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************************************************************************
    *      Implements Of MKMapViewDelegate
    *******************************************************************************/

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) ->
        MKAnnotationView!{
            if (annotation is MKUserLocation){
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            var pinView:MKPinAnnotationView?
            
            // 4'3'5
            var img = UIImage(named: "INF00204")
            
            if(landMark != nil){
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))")
                landMarkType = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))"
                switch landMarkType{
                case "景点":
                    img = UIImage(named: "INF00204")
                case "美食":
                    img = UIImage(named: "INF00203")
                case "购物":
                    img = UIImage(named: "INF00205")
                default:
                    println("nothing")
                }
                if(annotation.title != "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"){
                    img = UIImage(named: "STA00301")
                }
            }else if(statId != nil){
                var mapTitle: String! = annotation.title
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: statId!.station())
                if (mapTitle == statId!.station() && annotation.subtitle != nil) {
                    
                    img = UIImage(named: "STA00301")
                } else {
                    
                    switch (annotation.subtitle! as String) {
                    case "景点":
                        img = UIImage(named: "INF00204")
                    case "美食":
                        img = UIImage(named: "INF00203")
                    case "购物":
                        img = UIImage(named: "INF00205")
                    default:
                        println("nothing")
                    }
                }

            }
            
            pinView!.pinColor = .Red
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            
            return pinView!
    }

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     * 显示地图
     */
    func initMap(){
        mkMap.delegate = self
        // 设置地图显示类型
        mkMap.mapType = MKMapType.Standard
        mkMap.showsUserLocation = true

        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        // 查询按钮点击事件
        var searchButtonTemp:UIButton? = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        searchButtonTemp!.frame = CGRect(x:0,y:0,width:25,height:25)
        var imgLandMark = UIImage(named: "station_local")
        searchButtonTemp!.setBackgroundImage(imgLandMark, forState: UIControlState.Normal)
        searchButtonTemp!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButtonTemp!.tag = BTN_Location_TAG
        var searchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButtonTemp!)
        self.navigationItem.rightBarButtonItem = searchButton
        
        if(landMarkLocation == nil){
            var statLat:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LAT))" as NSString).doubleValue
            var statLon:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LON))" as NSString).doubleValue

            landMarkLocation = CLLocation(latitude: statLon, longitude: statLat)
        }
        
        //var statLocation = CLLocation(latitude: fromLat, longitude: fromLon)
        
        var sta003_Model:STA003Model = STA003Model()
        // 获取最近的10个站点
        var stations:[MstT02StationTableData]? = sta003_Model.findNearbyStations(landMarkLocation!)
        
        // NSInvalidArgumentException 'Invalid Coordinate +139.77180400, +35.68542600'
        // MKMapView定位到当前位置
        var coordinateOnEarth = landMarkLocation!.coordinate
        var annotation = MKPointAnnotation()
        
        if(landMark != nil){
            // 显示距离最近的10个地铁站
            for key in stations!{
                var statLat:Double? = (key.statLat as NSString).doubleValue
                var statLon:Double? = (key.statLon as NSString).doubleValue
                var annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude:statLat! as CLLocationDegrees, longitude:statLon! as CLLocationDegrees)
                annotation.title = key.statId.station()
                mkMap.addAnnotation(annotation)
                var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
                mkMap.setRegion(region, animated:true)
            }
            
            annotation.title = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
        } else if(statId != nil) {
            annotation.title = statId!.station()
            
            if (landMarkArr != nil) {
                for(var i=0; i < landMarkArr!.count; i++){
                    var key = landMarkArr![i] as MstT04LandMarkTable
                    var statLat:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LAT)
                    var statLon:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LON)
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocation(latitude: (statLat as NSString).doubleValue, longitude: (statLon as NSString).doubleValue).coordinate
                    annotation.title = "\(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
                    annotation.subtitle = "\(key.item(MSTT04_LANDMARK_LMAK_TYPE))"
                    mkMap.addAnnotation(annotation)
                    var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
                    mkMap.setRegion(region, animated:true)
                }
            }
        }
        
        annotation.coordinate = coordinateOnEarth
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:true)
        
        mkMap.addAnnotation(annotation)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}