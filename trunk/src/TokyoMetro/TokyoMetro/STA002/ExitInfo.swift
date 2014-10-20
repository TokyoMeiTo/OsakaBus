//
//  ExitInfo.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExitInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIActionSheetDelegate {

    @IBOutlet weak var exitTable: UITableView!
    
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    
    /* 起点軽度   */
    var fromLat:CDouble = 35.683618//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon:CDouble = 139.766453//121.38368547 // 天地科技广场1号楼
    
    /* 最近站点信息 */
//    var stations:Array<MstT02StationTable>?
    /* 地标 */
//    var landMark:MstT04LandMarkTable?
    
    var landMarkArr: NSArray = NSArray.array()
    
    var landMarkType:String = "景点"
    
    var landMarkLocation:CLLocation?
    
    var rows: NSArray!
    
    var statId: String = ""
    
    var arrList: NSMutableArray = NSMutableArray.array()
    
    var locatonArr:Array<CLLocation> = Array<CLLocation>()
    
    var stationLength: String = ""
    
    var index: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "出口一览"
        odbExitInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func odbExitInfo() {
        var table = StaT01StationExitTable()
        table.statId = statId
        rows = table.selectWithOrder(STAT01_STAT_EXIT_ID, desc: true)
        
        initMap()
    }
    
    /**
    * 到DB中查找最近的站点
    */
    class func selectStationTable(fromLocation: CLLocation) -> Array<MstT02StationTable>{
        var stationsNearest:Array<MstT02StationTable> = Array<MstT02StationTable>()
        
        var dao = Sta003Dao()
        var coordinateOnMars: CLLocationCoordinate2D = fromLocation.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
        
        stationsNearest = dao.queryMiniDistance(lon,lat: lat) as Array<MstT02StationTable>
        return stationsNearest
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
        
//        if(landMarkLocation == nil){
//            var statLat:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LAT))" as NSString).doubleValue
//            var statLon:Double = ("\(landMark!.item(MSTT04_LANDMARK_LMAK_LON))" as NSString).doubleValue
//            
//            landMarkLocation = CLLocation(latitude: statLon, longitude: statLat)
//        }
        
        //var statLocation = CLLocation(latitude: fromLat, longitude: fromLon)
        
        // 获取最近的10个站点
//        stations = StationListController.selectStationTable(landMarkLocation!)
        
        
        
        // NSInvalidArgumentException 'Invalid Coordinate +139.77180400, +35.68542600'
        // MKMapView定位到当前位置
        
        var coordinateOnEarth = landMarkLocation!.coordinate
        var annotation = MKPointAnnotation()
        
//        if(landMark != nil){
            // 显示距离最近的10个地铁站
//            for(var i=0; i < rows.count; i++){
//                var key = rows[i] as StaT01StationExitTable
//                var statLat:AnyObject? = key.item(STAT01_STAT_EXIT_LAT)
//                var statLon:AnyObject? = key.item(STAT01_STAT_EXIT_LON)
//                var annotation = MKPointAnnotation()
//                annotation.coordinate = CLLocationCoordinate2D(latitude:statLon as CLLocationDegrees, longitude:statLat as CLLocationDegrees)
//                annotation.title = "\(key.item(STAT01_STAT_EXIT_ID))".stationExit()
//                mkMap.addAnnotation(annotation)
//                var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
//                mkMap.setRegion(region, animated:true)
//            }
        
        for(var i=0; i < landMarkArr.count; i++){
            var key = landMarkArr[i] as MstT04LandMarkTable
            var statLat:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LAT)
            var statLon:AnyObject? = key.item(MSTT04_LANDMARK_LMAK_LON)
            
            println("\(statLat)")
            println("\(statLon)")
            var annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude:statLat as CLLocationDegrees, longitude:statLon as CLLocationDegrees)
            annotation.coordinate = CLLocation(latitude: (statLat as NSString).doubleValue, longitude: (statLon as NSString).doubleValue).coordinate
            annotation.title = "\(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            annotation.subtitle = "\(key.item(MSTT04_LANDMARK_LMAK_TYPE))"
            mkMap.addAnnotation(annotation)
            var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
            mkMap.setRegion(region, animated:true)
        }

        
        annotation.title = "\(statId.station())"
        
        annotation.coordinate = coordinateOnEarth
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:true)
        
        mkMap.addAnnotation(annotation)
        
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
            
            // 4'3'5
            var img = UIImage(named: "INF00204.png")
            
            
            var mapTitle: String! = annotation.title
            if (mapTitle == statId.station() && annotation.subtitle != nil) {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: statId.station())
                img = UIImage(named: "STA00301.png")
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!)
                
                switch (annotation.subtitle! as String) {
                case "景点":
                    img = UIImage(named: "INF00204.png")
                case "美食":
                    img = UIImage(named: "INF00203.png")
                case "购物":
                    img = UIImage(named: "INF00205.png")
                default:
                    println("nothing")
                }

            }
            
            pinView!.pinColor = .Red
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            
            return pinView!
    }

    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ExitInfoCell", forIndexPath: indexPath) as UITableViewCell
            
        var map = rows[indexPath.row] as StaT01StationExitTable
        (cell.viewWithTag(301) as UILabel).text = map.item(STAT01_STAT_EXIT_NAME) as? String
        if (index == indexPath.row && stationLength != "") {
            (cell.viewWithTag(302) as UILabel).text = stationLength + " 米"
        } else {
            (cell.viewWithTag(302) as UILabel).text = ""
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "出口信息"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var key = rows[indexPath.row] as StaT01StationExitTable
        
//        var statLat: Double = ("\(key.item(STAT01_STAT_EXIT_LAT))" as NSString).doubleValue
//        var statLon: Double = ("\(key.item(STAT01_STAT_EXIT_LON))" as NSString).doubleValue
//        var location: CLLocation = CLLocation(latitude: statLat, longitude: statLon)
        if (locatonArr.count > 0) {
            locatonArr[0] = landMarkLocation!
            if (locatonArr.count == 2) {
                stationLength = "\(Int(calcDistance(locatonArr[0], statLocation: locatonArr[1])))"
                drawLineWithLocationArray(locatonArr)
                exitTable.reloadData()
            }
        } else {
            locatonArr.append(landMarkLocation!)
        }
        index = indexPath.row
    }
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        if(view.annotation.subtitle == nil){
            return
        }
        if(locatonArr.count > 0 && locatonArr.count < 2) {
//            var locations:Array<CLLocation> = Array<CLLocation>()
//            locations.append(location!)
            locatonArr.append(CLLocation(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude))

            stationLength = "\(Int(calcDistance(locatonArr[0], statLocation: locatonArr[1])))"
            drawLineWithLocationArray(locatonArr)
            exitTable.reloadData()
        } else if (locatonArr.count == 2) {
            locatonArr[1] = CLLocation(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude)
            
            stationLength = "\(Int(calcDistance(locatonArr[0], statLocation: locatonArr[1])))"
            drawLineWithLocationArray(locatonArr)
            exitTable.reloadData()
        }
    }
    
    /**
    * 根据Location 画路线
    */
    func drawLineWithLocationArray(locations: Array<CLLocation>){
//        routeIndex = 0
        if(mkMap == nil){
            return
        }
        var fromMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[0].coordinate, addressDictionary:  nil)
        var toMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[1].coordinate, addressDictionary:  nil)
        var fromItem: MKMapItem = MKMapItem(placemark: fromMKPlace)
        var toItem: MKMapItem = MKMapItem(placemark: toMKPlace)
        findDirections(fromItem, to: toItem)
    }
    
    func findDirections(from: MKMapItem, to: MKMapItem){
        if(self.mkMap?.overlays != nil && self.mkMap?.overlays.count > 0){
            self.mkMap?.removeOverlays(self.mkMap?.overlays)
        }
        var request = MKDirectionsRequest()
        request.setSource(from)
        request.setDestination(to)
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = true
        var directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!,error: NSError!) -> Void in
            if (error != nil) {
                println("drawLineWithLocationArray:" + error.description)
            }
            else {
                for(var i=0;i<response.routes.count;i++){
                    if(i > 4){
                        break
                    }
                    var route: MKRoute = response.routes[i] as MKRoute
                    self.mkMap?.addOverlay(route.polyline)
                }
            }
        }
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
        var renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0

        return renderer
    }
    
    /**
    * 计算两点之间距离
    */
    func calcDistance(fromLocation: CLLocation, statLocation: CLLocation) -> CDouble{
        var distance:CLLocationDistance = statLocation.distanceFromLocation(fromLocation)
        return distance
    }
    
}
