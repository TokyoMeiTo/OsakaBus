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

class LandMarkMapController: UIViewController, MKMapViewDelegate, UIActionSheetDelegate, GPSDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/

    /* GPSHelper */
    let GPS_HELPER:GPSHelper = GPSHelper()
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
    var defaultLat:CDouble = 35.683618//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var defaultLon:CDouble = 139.766453//121.38368547 // 天地科技广场1号楼

    var landMarkType:String = "1"
    
    var landMarkLocation:CLLocation?
    
    var statId:String?
    
    /* 当前位置 */
    var currentLocation:CLLocation?
    
    var mAnnotation:MKPointAnnotation?
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
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
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))\n(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))")
                landMarkType = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))"
                switch landMarkType{
                case "1":
                    img = UIImage(named: "INF00204")
                case "2":
                    img = UIImage(named: "INF00203")
                case "3":
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
                    if(!(annotation.subtitle == nil)){
                        switch (annotation.subtitle! as String) {
                        case "PUBLIC_12".localizedString():
                            img = UIImage(named: "INF00204")
                        case "PUBLIC_13".localizedString():
                            img = UIImage(named: "INF00203")
                        case "PUBLIC_14".localizedString():
                            img = UIImage(named: "INF00205")
                        default:
                            println("nothing")
                        }
                    }
                }

            }
            
            if(annotation.title == "STA003_02".localizedString()){
                img = UIImage(named: "STA00302")
            }
            
            pinView!.pinColor = .Red
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            
            return pinView!
    }

    /*******************************************************************************
    *      Implements Of GPSDelegate
    *******************************************************************************/
    
    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation){
        currentLocation = location
        
        if(!checkLocation(currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)){
            return
        }
        if(mAnnotation == nil){
            mAnnotation = MKPointAnnotation()
        }else{
            mkMap.removeAnnotation(mAnnotation!)
        }
        
        var coordinateOnEarth = currentLocation!.coordinate
            
        mAnnotation!.title = "STA003_02".localizedString()
        mAnnotation!.subtitle = ""
        
        mAnnotation!.coordinate = coordinateOnEarth
        mkMap.addAnnotation(mAnnotation!)
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:true)
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
    }
    
    /**
     * 位置定位完成
     */
    func locationUpdateError(){
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
        //mkMap.showsUserLocation = true

        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        // 查询按钮点击事件
        var searchButtonTemp:UIButton? = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        searchButtonTemp!.frame = CGRect(x:0,y:0,width:25,height:25)
        var imgLandMark = UIImage(named: "sta00303")
        searchButtonTemp!.setBackgroundImage(imgLandMark, forState: UIControlState.Normal)
        searchButtonTemp!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButtonTemp!.tag = BTN_Location_TAG
        var searchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButtonTemp!)
        self.navigationItem.rightBarButtonItem = searchButton
        
        if(landMarkLocation == nil){
            var statLat:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LAT))" as NSString).doubleValue
            var statLon:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LON))" as NSString).doubleValue
            if(checkLocation(statLat, longitude: statLon)){
                landMarkLocation = CLLocation(latitude: statLat, longitude: statLon)
            }
        }
        
        if(landMarkLocation == nil){
            landMarkLocation = CLLocation(latitude: defaultLat, longitude: defaultLon)
        }
        
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
                
                if(!checkLocation(statLat!, longitude: statLon!)){
                    continue
                }
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude:statLat! as CLLocationDegrees, longitude:statLon! as CLLocationDegrees)

                annotation.title = key.statId.station()
                println(key.statAddr)
                annotation.subtitle = key.statAddr
                mkMap.addAnnotation(annotation)
                var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
                mkMap.setRegion(region, animated:true)
            }
            
            annotation.title = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            annotation.subtitle = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
        } else if(statId != nil) {
            annotation.title = statId!.station()
            
            
            if (landMarkArr != nil) {
                for(var i=0; i < landMarkArr!.count; i++){
                    var key = landMarkArr![i] as MstT04LandMarkTable
                    var statLat:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LAT)
                    var statLon:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LON)
                    
                    if(!checkLocation((statLat as NSString).doubleValue, longitude: (statLon as NSString).doubleValue)){
                        continue
                    }
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocation(latitude: (statLat as NSString).doubleValue, longitude: (statLon as NSString).doubleValue).coordinate
                    if(!(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) == nil)){
                        annotation.title = "\(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
                        annotation.subtitle = "\(key.item(MSTT04_LANDMARK_LMAK_ADDR))"
                    }
                    
                    mkMap.addAnnotation(annotation)
                    var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
                    mkMap.setRegion(region, animated:true)
                }
            }
        }
        
        annotation.coordinate = coordinateOnEarth
        mkMap.addAnnotation(annotation)
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:true)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case BTN_Location_TAG:
            loadLocation()
        default:
            println("nothing")
        }
    }
    
    /**
     * checkLocation
     * @param latitude,longitude
     *  -> Bool
     */
    func checkLocation(latitude: Double?, longitude: Double?) -> Bool{
        return latitude != nil && longitude != nil && latitude > 0 && latitude < 90 && longitude > 0 && longitude < 180
    }
    
    /**
     * 加载当前位置
     */
    func loadLocation(){
        if(GPS_HELPER.delegate == nil){
            GPS_HELPER.delegate = self
        }
        GPS_HELPER.updateLocation()
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}