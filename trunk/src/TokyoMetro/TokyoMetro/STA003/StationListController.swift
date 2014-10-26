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
class StationListController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    MKMapViewDelegate, GPSDelegate{

    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/

    /* SegmentedControl控件 */
    @IBOutlet weak var sgmMain: UISegmentedControl!
    /* 加载进度条ActivityIndicatorView */
    @IBOutlet weak var gaiLoading: UIActivityIndicatorView!
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    /* 地图MKMapView */
    @IBOutlet weak var mkMap: MKMapView!
    /* 地图MKMapView */
    @IBOutlet weak var tempView: UIView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/

    /* GPSHelper */
    let GPS_HELPER:GPSHelper = GPSHelper()
    /* STA003Model */
    var STA003_MODEL:STA003Model = STA003Model()
    
    /* 100 */
    let NUM_100:Int = 100
    /* 0 */
    let NUM_0:Int = 0
    /* 1 */
    let NUM_1:Int = 1
    /* 2 */
    let NUM_2:Int = 2
    /* 3 */
    let NUM_3:Int = 3
    /* 4 */
    let NUM_4:Int = 4
    /* 5 */
    let NUM_5:Int = 5
    /* 起点軽度   */
    let testLat = 35.672737
    /* 起点緯度 */
    let testLon = 139.768898
    /* 当前位置 */
    let LOCATION_STRING:String = "STA003_02".localizedString()
    /* 确定删除本条提醒？ */
    let MSG_0001:String = "STA003_03".localizedString()
    /* 通知 */
    let MSG_0002:String = "PUBLIC_08".localizedString()
    /* 确定 */
    let MSG_0003:String = "PUBLIC_06".localizedString()
    /* 取消 */
    let MSG_0004:String = "PUBLIC_07".localizedString()
    /* 重新定位 */
    let BTN_Location_TAG:Int = 120
    /* 路线颜色 */
    let LINE_COLOR = [UIColor.blueColor(),
        UIColor.yellowColor(),
        UIColor.redColor(),
        UIColor.greenColor()]

    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/

    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    /* 最近站点信息 */
    var mStations:Array<MstT02StationTableData>?
    /* 当前位置信息 */
    var mLocation:CLLocation?
    /* 线路索引 */
    var mRouteIndex:Int?
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期化变量
        // 准备数据
        initValue()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 画面内容变更
        // 设置数据
        // 加载当前位置
        loadLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controllers:AnyObject? = self.navigationController!.viewControllers
        if(controllers!.count > 1){
            var main:Main = controllers![controllers!.count - 2] as Main
            main.stationIdFromStationList = mStations![indexPath.row].statId
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(mStations != nil){
            return mStations!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "UITableViewCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if(cell == nil){
             cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }
        
        for subview in cell!.contentView.subviews{
            if(subview.isKindOfClass(UILabel) || subview.isKindOfClass(UIImageView)){
                subview.removeFromSuperview()
            }
        }
        
        var mMstT02Data:MstT02StationTableData = mStations![indexPath.row]
        var line:MstT01LineTableData = STA003_MODEL.findLineTable(mMstT02Data.lineId)
        var statNm:String = mMstT02Data.statId.station()
        
        var lblStation = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30))
        lblStation.font = UIFont.systemFontOfSize(17)
        lblStation.text = statNm
        lblStation.textAlignment = NSTextAlignment.Left
        
        var lblDetail = UILabel(frame: CGRect(x:15,y:30,width:(tableView.frame.width - 30)/2,height:25))
        lblDetail.font = UIFont.systemFontOfSize(13)
        lblDetail.adjustsFontSizeToFitWidth = true
        lblDetail.textColor = UIColor.darkGrayColor()
        lblDetail.text = mMstT02Data.statName + "(" + mMstT02Data.statNameKana + ")"
        lblDetail.textAlignment = NSTextAlignment.Left
        
        var statLat:Double = (mMstT02Data.statLat as NSString).doubleValue
        var statLon:Double = (mMstT02Data.statLon as NSString).doubleValue
        var locationStat:CLLocation = CLLocation(latitude: statLat, longitude: statLon)
        
        var lblDistance = UILabel(frame: CGRect(x:(tableView.frame.width - 30)/2,y:30,width:(tableView.frame.width - 30)/2,height:25))
        lblDistance.font = UIFont.systemFontOfSize(13)
        lblDistance.textColor = UIColor.darkGrayColor()
        lblDistance.text = STA003_MODEL.convertDistance(STA003_MODEL.calcDistance(mLocation!, statLocation: locationStat))
        lblDistance.textAlignment = NSTextAlignment.Right
        
        var imageViewLine = UIImageView(frame: CGRectMake(tableView.frame.width - 48, 18, 18, 18))
        imageViewLine.image = mMstT02Data.lineId.getLineMiniImage()
        
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell!.contentView.addSubview(lblStation)
        cell!.contentView.addSubview(lblDetail)
        cell!.contentView.addSubview(lblDistance)
        cell!.contentView.addSubview(imageViewLine)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
   
    /*******************************************************************************
    *      Implements Of GPSDelegate
    *******************************************************************************/

    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation){
        mLocation = location//CLLocation(latitude: fromLat, longitude: fromLon)
        
        // 获取最近的10个站点
        mStations = STA003_MODEL.findNearbyStations(location)
        if(mStations == nil){
            noData()
            return
        }
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 显示最近站点列表
            initList()
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 在地图上显示最近站点
            initMap()
        }else{
        }
        ActivityIndicatorController.disMiss(gaiLoading)
    }

    
    /*******************************************************************************
    *      Implements Of MKMapViewDelegate
    *******************************************************************************/

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation){
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        var pinView:MKPinAnnotationView?
        if(annotation.title == LOCATION_STRING){
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "STA003_02".localizedString())
            pinView!.pinColor = .Red
            var img = UIImage(named: "STA00302")
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
        }else{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            pinView!.pinColor = .Purple
            var img = UIImage(named: "STA00301")
            pinView!.image = img
            pinView!.canShowCallout = true
            pinView!.frame = CGRectMake((CGRectMake(0, 0, 185, 162).size.width-16)/2, 56, 30, 35)
            var rightButton: UIButton! = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            rightButton.titleForState(UIControlState.Normal)
            rightButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            // button添加tag，点击时用
            for(var i=0;i<mStations!.count;i++){
                var key = mStations![i]
                var statLat:Double? = (key.statLat as NSString).doubleValue
                var statLon:Double? = (key.statLon as NSString).doubleValue
                if(statLat! as CLLocationDegrees == annotation.coordinate.latitude && statLon! as CLLocationDegrees == annotation.coordinate.longitude){
                    rightButton.tag = NUM_100 + i
                }
            }
            pinView!.rightCalloutAccessoryView = rightButton as UIView
        }
        return pinView!
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if(view.annotation.title == LOCATION_STRING){
            return
        }
        if(mStations!.count > 0){
            var locations:Array<CLLocation> = Array<CLLocation>()
            locations.append(mLocation!)
            locations.append(CLLocation(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude))
            drawLineWithLocationArray(locations)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = LINE_COLOR[mRouteIndex!]
        
        mRouteIndex = mRouteIndex! + 1
        return renderer
    }
    
    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     * 初始化全局变量
     */
    func initValue(){
        self.navigationItem.rightBarButtonItem = nil
        tbList.hidden = true
        mkMap.hidden = true
        sgmMain.setTitle("PUBLIC_11".localizedString(), forSegmentAtIndex: 0)
        sgmMain.setTitle("STA003_06".localizedString(), forSegmentAtIndex: 1)
        sgmMain.selectedSegmentIndex = NUM_0
        sgmMain.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        // 定位按钮
        var searchButtonTemp:UIButton? = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        searchButtonTemp!.frame = CGRect(x:0,y:0,width:25,height:25)
        var imgLandMark = UIImage(named: "station_local")
        searchButtonTemp!.setBackgroundImage(imgLandMark, forState: UIControlState.Normal)
        searchButtonTemp!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButtonTemp!.tag = BTN_Location_TAG
        var searchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButtonTemp!)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    /**
     * 加载当前位置
     */
    func loadLocation(){
        ActivityIndicatorController.show(gaiLoading)
        GPS_HELPER.delegate = self
        GPS_HELPER.updateLocation()
        tempView.hidden = true
    }

    /**
     * sgmMain点击事件
     */
    func segmentChanged(sender: AnyObject){
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 显示最近站点列表
            initList()
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 在地图上显示最近站点
            initMap()
        }else{
        }
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
            if(mStations != nil && mStations!.count > 0){
                var controllers:AnyObject? = self.navigationController!.viewControllers
                if(controllers != nil && controllers!.count > 1){
                    var main:Main = controllers![controllers!.count - 2] as Main
                    main.stationIdFromStationList = mStations![sender.tag - NUM_100].statId
                }
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }
    
    /**
     * 初始化UITableView
     */
    func initList(){
        // 显示UITableView
        tbList.hidden = false
        mkMap.hidden = true
        tbList.delegate = self
        tbList.dataSource = self
        tbList.backgroundColor = UIColor(red: 239/255,
            green: 239/255,
            blue: 244/255,
            alpha: 1.0)
        if(mStations == nil){
            noData()
        }
        tbList.reloadData()
    }
    
    /**
     * 初始化MKMapView
     */
    func initMap(){
        // 显示MKMapView
        tbList.hidden = true
        mkMap.hidden = false
        mkMap.delegate = self
        // 设置地图显示类型
        mkMap.mapType = MKMapType.Standard
        mkMap.showsUserLocation = false
        
        if(mLocation == nil){
            return
        }
        
        var accuracy : CLLocationAccuracy = mLocation!.horizontalAccuracy
        var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        var coordinateOnMars: CLLocationCoordinate2D = mLocation!.coordinate
        
        coordinateOnMars.latitude = testLat
        coordinateOnMars.longitude = testLon
        
        var latitude : CDouble = coordinateOnMars.latitude
        var longitude : CDouble = coordinateOnMars.longitude
        
        var fromLocation = mLocation//CLLocation(latitude: testLat, longitude: testLon)
        
        // 显示距离最近的10个地铁站
        for key in mStations!{
            var statLat:Double? = (key.statLat as NSString).doubleValue
            var statLon:Double? = (key.statLon as NSString).doubleValue
            var statNm:AnyObject? = key.statNameExt1
            if(statLat == nil || statLon == nil || statNm == nil){
                continue
            }
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:statLat! as CLLocationDegrees, longitude:statLon! as CLLocationDegrees)
            annotation.title = statNm as String
            mkMap.addAnnotation(annotation)
            var region : MKCoordinateRegion = MKCoordinateRegionMake(annotation.coordinate, span)
            mkMap.setRegion(region, animated:true)
        }
        
        // MKMapView定位到当前位置
        var coordinateOnEarth = mLocation!.coordinate//CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
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
                //println("reverseGeocodeLocation:" + error.description)
            }
            else {
                for(var i=0;i<placeMarks!.count;i++){
                    //println("reverseGeocodeLocation:" + placeMarks![i].description)
                }
            }
        })
    }
    
    /**
     * 根据Location 画路线
     */
    func drawLineWithLocationArray(locations: Array<CLLocation>){
        mRouteIndex = 0
        var fromMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[0].coordinate, addressDictionary:  nil)
        var toMKPlace: MKPlacemark = MKPlacemark(coordinate: locations[1].coordinate, addressDictionary:  nil)
        var fromItem: MKMapItem = MKMapItem(placemark: fromMKPlace)
        var toItem: MKMapItem = MKMapItem(placemark: toMKPlace)
        findDirections(fromItem, to: toItem)
    }
    
    func findDirections(from: MKMapItem, to: MKMapItem){
        if(mkMap.overlays != nil && mkMap.overlays.count > 0){
            mkMap.removeOverlays(mkMap.overlays)
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
                    self.mkMap.addOverlay(route.polyline)
                }
            }
        }
    }

    func noData(){
        tbList.separatorColor = UIColor.clearColor()
        tbList.hidden = true
        tempView.hidden = false
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

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