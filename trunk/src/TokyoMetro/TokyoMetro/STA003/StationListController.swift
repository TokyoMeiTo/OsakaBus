//
//  LocationListController.swift
//  TokyoMetroDemo
//
//  Created by zhourr_ on 2014/09/16.
//  Copyright (c) 2014年 zhourr_. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

/**
 * 最近站点列表
 */
class StationListController: UIViewController, GPSDelegate{
    
    /* SegmentedControl控件 */
    @IBOutlet weak var sgmMain: UISegmentedControl!
    /* 加载进度条ActivityIndicatorView */
    @IBOutlet weak var gaiLoading: UIActivityIndicatorView!
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    
    /* GPSHelper */
    let GPShelper:GPSHelper = GPSHelper()
    /* TableView视图控制器 */
    let listController = ListController()
    /* MKMapView视图控制器 */
    let mapController = MapController()
    
    /* 100 */
    let NUM_100 = 100
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 2 */
    let NUM_2 = 2
    /* 3 */
    let NUM_3 = 3
    /* 4 */
    let NUM_4 = 4
    /* 5 */
    let NUM_5 = 5
    /* 起点軽度   */
    let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
    /* 当前位置 */
    let LOCATION_STRING = "STA003_02".localizedString()
    /* 确定删除本条提醒？ */
    let MSG_0001 = "STA003_03".localizedString()
    /* 通知 */
    let MSG_0002 = "PUBLIC_08".localizedString()
    /* 确定 */
    let MSG_0003 = "PUBLIC_06".localizedString()
    /* 取消 */
    let MSG_0004 = "PUBLIC_07".localizedString()
    
    /* 最近站点信息 */
    var stations:Array<MstT02StationTable>?
    /* 当前位置信息 */
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValue()
        // 加载当前位置
        loadLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * 初始化全局变量
     */
    func initValue(){
        self.navigationItem.rightBarButtonItem = nil
        tbList.hidden = true
        mkMap.hidden = true
        sgmMain.setTitle("附近站点", forSegmentAtIndex: 0)
        sgmMain.setTitle("我的位置", forSegmentAtIndex: 1)
        sgmMain.selectedSegmentIndex = NUM_0
        sgmMain.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        // 定位按钮点击事件
//        var reLocationButton:UIBarButtonItem = self.navigationItem.rightBarButtonItem!
//        reLocationButton.target = self
//        reLocationButton.action = "buttonAction:"
    }
    
    /**
     * 加载当前位置
     */
    func loadLocation(){
        ActivityIndicatorController.show(gaiLoading)
        if(GPShelper.delegate == nil){
            GPShelper.delegate = self
        }
        GPShelper.updateLocation()
    }

    /**
     * sgmMain点击事件
     */
    func segmentChanged(sender: AnyObject){
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 显示最近站点列表
            initList(stations!)
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 在地图上显示最近站点
            initMap(location!,stations: stations!)
        }else{
        }
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case self.navigationItem.rightBarButtonItem!:
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0001,buttons:[MSG_0003, MSG_0004], delegate: nil)
        default:
            println("nothing")
        }
    }
    
    /**
     * 初始化UITableView
     */
    func initList(stations: Array<MstT02StationTable>){
        // 显示UITableView
        tbList.hidden = false
        mkMap.hidden = true
        listController.items = stations
        listController.sender = self
        tbList.delegate = listController.self
        tbList.dataSource = listController.self
        //tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
    }
    
    /**
     * 初始化MKMapView
     */
    func initMap(location: CLLocation, stations: Array<MstT02StationTable>){
        // 显示MKMapView
        tbList.hidden = true
        mkMap.hidden = false
        mapController.MKmap = mkMap
        mapController.statListController = self
        mkMap.delegate = mapController
        // 设置地图显示类型
        mkMap.mapType = MKMapType.Standard
        mkMap.showsUserLocation = true
        
        var accuracy : CLLocationAccuracy = location.horizontalAccuracy
        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        var coordinateOnMars: CLLocationCoordinate2D = location.coordinate
        
        coordinateOnMars.latitude = fromLat
        coordinateOnMars.longitude = fromLon
        
        var latitude : CDouble = coordinateOnMars.latitude
        var longitude : CDouble = coordinateOnMars.longitude
        
        var fromLocation = location//CLLocation(latitude: fromLat, longitude: fromLon)
        
        // 初始化MKMapController变量
        mapController.gaiLoading = self.gaiLoading
        mapController.location = fromLocation
        mapController.stations = stations
        
        // 显示距离最近的10个地铁站
        for(var i=0;i<stations.count;i++){
            var key = stations[i] as MstT02StationTable
            var statLat:AnyObject? = key.item(MSTT02_STAT_LAT)
            var statLon:AnyObject? = key.item(MSTT02_STAT_LON)
            var statNm:AnyObject? = key.item(MSTT02_STAT_NAME)
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:statLat as CLLocationDegrees, longitude:statLon as CLLocationDegrees)
            annotation.title = statNm as String
            mkMap.addAnnotation(annotation)
            var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
            mkMap.setRegion(region, animated:true)
        }
        
        // MKMapView定位到当前位置
        var coordinateOnEarth = location.coordinate//CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
        var annotation = MKPointAnnotation()
        annotation.title = LOCATION_STRING
        annotation.coordinate = coordinateOnEarth
        
        mkMap.setCenterCoordinate(coordinateOnEarth, animated:false)
        mkMap.addAnnotation(annotation)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateOnEarth, span)
        mkMap.setRegion(region, animated:true)
        
        // 获取当前位置信息
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(fromLocation, completionHandler: { (placeMarks: Array!, error: NSError!) -> Void in
            if (error != nil) {
                println("reverseGeocodeLocation:" + error.description)
            }
            else {
                for(var i=0;i<placeMarks!.count;i++){
                    println("reverseGeocodeLocation:" + placeMarks![i].description)
                }
            }
        })
    }
    
    /**
     * 列表点击
     */
    func tapList(didSelectRowAtIndexPath: NSIndexPath){
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 在地图上显示最近站点
//            sgmMain.selectedSegmentIndex = NUM_1
//            initMap(locationTest!,stations: stations!)
//            var key = stations![didSelectRowAtIndexPath.row] as MstT02StationTable
//            var statLat:AnyObject? = key.item(MSTT02_STAT_LAT)
//            var statLon:AnyObject? = key.item(MSTT02_STAT_LON)
//            var statNm:AnyObject? = key.item(MSTT02_STAT_NAME)
//            var annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude:statLat as CLLocationDegrees, longitude:statLon as CLLocationDegrees)
//            annotation.title = statNm as String
//            mkMap.addAnnotation(annotation)
//            
//            mkMap.selectAnnotation(annotation, animated: true)
            var controllers:AnyObject? = self.navigationController!.viewControllers
            if(controllers!.count > 1){
                var main:Main = controllers![controllers!.count - 2] as Main
                main.stationIdFromStationList = "\(stations![didSelectRowAtIndexPath.row].item(MSTT02_STAT_ID))"
            }
            self.navigationController!.popViewControllerAnimated(true)
        }else{
        }
    }
    
    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation){
        self.location = location//CLLocation(latitude: fromLat, longitude: fromLon)
        // 获取最近的3个站点
        stations = StationListController.selectStationTable(location)
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 显示最近站点列表
            initList(stations!)
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 在地图上显示最近站点
            initMap(location,stations: stations!)
        }else{
        }
        ActivityIndicatorController.disMiss(gaiLoading)
    }
    
    /**
     * 到DB中查找最近的站点
     */
    class func selectStationTable(fromLocation: CLLocation) -> Array<MstT02StationTable>{
        var stations:Array<MstT02StationTable> = Array<MstT02StationTable>()
        
        var dao = Sta003Dao()
        var coordinateOnMars: CLLocationCoordinate2D = fromLocation.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
        
        stations = dao.queryMiniDistance(lon,lat: lat) as Array<MstT02StationTable>
        return stations
    }
    
    /**
     * 从DB查询线路信息
     */
    func selectLineTable(lineID: String) -> MstT01LineTable{
        var tableMstT01 = MstT01LineTable()
        tableMstT01.lineId = lineID
        var line:MstT01LineTable = tableMstT01.select() as MstT01LineTable
        return line
    }
    
    /**
     * 计算两点之间距离
     */
    class func calcDistance(fromLocation: CLLocation, statLocation: CLLocation) -> CDouble{
        var distance:CLLocationDistance = statLocation.distanceFromLocation(fromLocation)
        return distance
    }

    /**
     * 0.00KM
     */
    class func convertDistance(distance: CDouble) -> String{
        let DIDTANCE:String = "\(distance / 1000)"
        
        var dotIndex = DIDTANCE.indexOf(".")
        return "\(DIDTANCE.left(dotIndex + 2))" + "KM"
    }

}

/**
 * List列表视图控制器
 */
class ListController: UITableViewController {
    /* tableview条目 */
    var items:Array<MstT02StationTable>?
    /* viewController */
    var sender:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(sender == nil){
            return
        }
        sender!.tapList(didSelectRowAtIndexPath)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        for subview in cell.subviews {
            if(subview.isKindOfClass(UIImageView) || subview.isKindOfClass(UILabel)){
                subview.removeFromSuperview()
            }
        }
        var tableMstT02 = items![indexPath.row] as MstT02StationTable
        var line:MstT01LineTable = sender!.selectLineTable("\(tableMstT02.item(MSTT02_LINE_ID))") as MstT01LineTable
        var statNm:String = "\(tableMstT02.item(MSTT02_STAT_ID))".station()
        
        var lblStation = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30))
        lblStation.font = UIFont.systemFontOfSize(17)
        lblStation.text = statNm
        lblStation.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblStation)
        
        var lblDetail = UILabel(frame: CGRect(x:15,y:30,width:tableView.frame.width - 30,height:25))
        lblDetail.font = UIFont.systemFontOfSize(13)
        lblDetail.textColor = UIColor.darkGrayColor()
        lblDetail.text = "\(tableMstT02.item(MSTT02_STAT_NAME))" + "(\(tableMstT02.item(MSTT02_STAT_NAME_KANA)))"
        lblDetail.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblDetail)
        
        // calcDistance(fromLocation: location, statLocation: CLLocation)
        var statLat:Double = ("\(tableMstT02.item(MSTT02_STAT_LAT))" as NSString).doubleValue
        var statLon:Double = ("\(tableMstT02.item(MSTT02_STAT_LON))" as NSString).doubleValue
        var locationStat:CLLocation = CLLocation(latitude: statLat, longitude: statLon)
        
        var lblDistance = UILabel(frame: CGRect(x:15,y:15,width:tableView.frame.width - 75,height:25))
        lblDistance.font = UIFont.systemFontOfSize(13)
        lblDistance.textColor = UIColor.darkGrayColor()
        sender! as StationListController
        lblDistance.text = StationListController.convertDistance(StationListController.calcDistance(sender!.location, statLocation: locationStat))
        lblDistance.textAlignment = NSTextAlignment.Right
        cell.addSubview(lblDistance)
        
        var imageViewLine = UIImageView(frame: CGRectMake(tableView.frame.width - 55, 12.5, 18, 18))
        imageViewLine.image = lineImage("\(tableMstT02.item(MSTT02_LINE_ID))")
        cell.addSubview(imageViewLine)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //items.removeObjectAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func lineImage(lineNum: String) -> UIImage {
        return lineNum.getLineImage()
    }
}

/**
 * Map地图视图控制器
 */
class MapController: UIViewController, MKMapViewDelegate, UIActionSheetDelegate{
    
    /* MKMap控件 */
    var MKmap: MKMapView?
    /* 加载进度条ActivityIndicatorView */
    var gaiLoading: UIActivityIndicatorView?
    /* 站点信息 */
    var stations:Array<MstT02StationTable>?
    /* 当前位置 */
    var location:CLLocation?
    
    var statListController:StationListController?
    
    /* 路线索引 */
    var routeIndex:Int = 0
    /* 路线颜色 */
    var lineColor = [UIColor.blueColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.greenColor()]
    
    /* 当前位置 */
    let LOCATION_STRING = "STA003_02".localizedString()
    /* 站点名称 */
    let STATION_NAME_STRING = "STA003_04".localizedString()
    /* 100 */
    let NUM_100 = 100
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 2 */
    let NUM_2 = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Called after the view has been loaded.
        if(MKmap == nil){
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * 根据Location 画路线
     */
    func drawLineWithLocationArray(locations: Array<CLLocation>){
        routeIndex = 0
        if(MKmap == nil){
            return
        }
        var fromMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[0].coordinate, addressDictionary:  nil)
        var toMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[1].coordinate, addressDictionary:  nil)
        var fromItem: MKMapItem = MKMapItem(placemark: fromMKPlace)
        var toItem: MKMapItem = MKMapItem(placemark: toMKPlace)
        findDirections(fromItem, to: toItem)
    }
    
    func findDirections(from: MKMapItem, to: MKMapItem){
        if(self.MKmap?.overlays != nil && self.MKmap?.overlays.count > 0){
            self.MKmap?.removeOverlays(self.MKmap?.overlays)
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
                    self.MKmap?.addOverlay(route.polyline)
                }
            }
        }
    }
    
    /**
     * 地铁站图钉右button点击事件
     */
    func rightButtonTapped(sender: UIButton!){
        if(stations?.count > 0){
            var alertView = UIAlertView()
            alertView.title = STATION_NAME_STRING
            var statNm:String = ""
//            switch sender.tag - NUM_100{
//            case NUM_0:
//                var key = stations![NUM_0] as MstT02StationTable
//                statNm = key.item(MSTT02_STAT_NAME) as String
//            case NUM_1:
//                var key = stations![NUM_1] as MstT02StationTable
//                statNm = key.item(MSTT02_STAT_NAME) as String
//            case NUM_2:
//                var key = stations![NUM_2] as MstT02StationTable
//                statNm = key.item(MSTT02_STAT_NAME) as String
//            default:
//                println("nothing")
//            }
            var controllers:AnyObject? = statListController!.navigationController!.viewControllers
            if(controllers!.count > 1){
                var main:Main = controllers![controllers!.count - 2] as Main
                main.stationIdFromStationList = "\(stations![sender.tag - NUM_100].item(MSTT02_STAT_ID))"
            }
            statListController!.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) ->
        MKAnnotationView!{
            if (annotation is MKUserLocation){
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            var pinView:MKPinAnnotationView?
            if(annotation.title == LOCATION_STRING){
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "当前位置")
                pinView!.pinColor = .Red
                var img = UIImage(named: "STA00302.png")
                pinView!.image = img
                pinView!.canShowCallout = true
                pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
                pinView!.pinColor = .Purple
                var img = UIImage(named: "STA00301.png")
                pinView!.image = img
                pinView!.canShowCallout = true
                pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
                var rightButton: UIButton! = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
                rightButton.titleForState(UIControlState.Normal)
                rightButton.addTarget(self, action: "rightButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                // button添加tag，点击时用
                for(var i=0;i<stations?.count;i++){
                    var key = stations![i] as MstT02StationTable
                    var statLat:AnyObject? = key.item(MSTT02_STAT_LAT)
                    var statLon:AnyObject? = key.item(MSTT02_STAT_LON)
                    if(statLat as CLLocationDegrees == annotation.coordinate.latitude && statLon as CLLocationDegrees == annotation.coordinate.longitude){
                        rightButton.tag = NUM_100 + i
                    }
                }
                pinView!.rightCalloutAccessoryView = rightButton as UIView
            }
            return pinView!
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
        if(view.annotation.title == LOCATION_STRING){
            return
        }
        if(stations?.count > 0){
            var locations:Array<CLLocation> = Array<CLLocation>()
            locations.append(location!)
            locations.append(CLLocation(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude))
            drawLineWithLocationArray(locations)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
        var renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = lineColor[routeIndex]
        
        routeIndex = routeIndex + 1
        return renderer
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!){
        
    }
}

/**
 * 进度条相关
 */
class ActivityIndicatorController{
    
    class func show(gaiLoading: UIActivityIndicatorView) ->
        Bool{
            gaiLoading.hidden = true
            gaiLoading.startAnimating()
            return false
    }
    
    class func disMiss(gaiLoading: UIActivityIndicatorView) ->
        Bool{
            gaiLoading.stopAnimating()
            gaiLoading.hidden = true
            return false
    }
}