//
//  StationDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import CoreLocation

class StationDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
/*******************************************************************************
* IBOutlets
*******************************************************************************/
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellJPNmaeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weSegment: UISegmentedControl!
//    @IBOutlet weak var imgCollect: UIImageView!
    @IBOutlet weak var btnCollect: UIButton!
    
/*******************************************************************************
* Global
*******************************************************************************/
    
/*******************************************************************************
* Public Properties
*******************************************************************************/
    var cellJPName:String = ""
    var cellJPNameKana:String = ""
    var cellDesc:String = ""
    // 列车线路id，用逗号隔开
    var cellLine = ""
    // 终点站，用逗号隔开
    var cellClose = ""
    // 日本平日首末班车时间，用逗号隔开
    var cellJapanTime = ""
    // 日本周末首末班车时间，用逗号隔开
    var cellJapanWETime = ""
    // 日本节假日首末班车时间，用逗号隔开
    var cellJapanHolidayTime = ""
    // 日本周末首末班车时间，用逗号隔开
    var cellStation = ""
    // 终点站数组
    var arrClose = [String]()
    // 日本首末班车时间数组
    var arrTime = [String]()
    // 屏幕尺寸
    var size: CGSize!
    // 站内结构图url中的statMetroId区分用
    var statMetroId = ""
    // 查询该条线的线路id
    var stat_id = ""
    // 收藏该条线路的group_id
    var group_id = ""
    // 传递给路线画面的landmarkid
    var ruteLandMarkId: String?
    
/*******************************************************************************
* Private Properties
*******************************************************************************/
    
    var collectRowid:String?
    
    // 站点statId、statSeq、lineId数组
    var statSeqArr: NSArray = NSArray.array()
    
    // 景点、购物、美食数组
    var landMarkArr: NSArray = NSArray.array()
    // 其他链接
    var selectList = ["STA002_02".localizedString(), "STA002_03".localizedString(),"STA002_05".localizedString(), "STA002_04".localizedString()]
    
    // 其他链接
    var landMarkTitleList = ["PUBLIC_12".localizedString(), "PUBLIC_13".localizedString(), "PUBLIC_14".localizedString()]
    
    var depaTimeArr: NSMutableArray = NSMutableArray.array()
    
    var model: Sta002StationDetailModel?
    
/*******************************************************************************
* Overrides From UIViewController
*******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = Sta002StationDetailModel()
        //车站本地化名
        cellNameLabel.text = stat_id.station()
        //车站日文名
        cellJPNmaeLabel.text = cellJPName + "（" + cellJPNameKana + "）"
        //标题
        self.title = stat_id.station()
        
        collectRowid = ""
        //查询车站信息
        odbStation()

        // 获取屏幕尺寸
        size = UIScreen.mainScreen().bounds.size
        // 代码添加车站icon
        addLineView()
        // 添加首末班车时间
        addLineTime()
        // 检索该站是否已收藏
        odbCollectStation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 添加站点相关信息的链接
        addStationSelect()
    }
    
/*******************************************************************************
*    Implements Of UITableViewDelegate
*******************************************************************************/

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        } else {
            return 30
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            return nil
        } else {
            var view = UIView(frame: CGRectMake(0, 0, 320, 30))
            view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
            var lblTitle = UILabel(frame: CGRectMake(15, 0, 305, 30))
            lblTitle.text = "STA002_18".localizedString()
            view.addSubview(lblTitle)
            return view
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
            case 0:
                showTime()
            case 1:
                showStationMap()
            case 2:
                showFacility()
            case 3:
                showComercialInside()
            default:
                showStationMap()
            }
        } else{
            showLnadMarkList(indexPath.row)
        }
    }

    
    
/*******************************************************************************
*      Implements Of UITableViewDataSource
*******************************************************************************/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 245/255, green: 246/255, blue: 248/255, alpha: 1)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.section == 0) {
            var image = UIImageView()
            var imageName = "station-link-" + (indexPath.row + 1).description
            image.frame = CGRectMake(15, 6, 30, 30)
            image.image = UIImage(named: imageName)
            
            cell.addSubview(image)
            
            var content = UILabel()
            content.frame = CGRectMake(55, 0, 200, 44)
            content.text = selectList[indexPath.row]
            content.font = UIFont.systemFontOfSize(20)
            
            cell.addSubview(content)
        } else {
            var image = UIImageView()
            var imageName = "station_link2_" + (indexPath.row + 1).description
            image.frame = CGRectMake(15, 8, 30, 30)
            image.image = UIImage(named: imageName)
            
            cell.addSubview(image)
            
            var content = UILabel()
            content.frame = CGRectMake(55, 0, 200, 44)
            content.text = landMarkTitleList[indexPath.row]
            content.font = UIFont.systemFontOfSize(20)
            
            cell.addSubview(content)
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return selectList.count
        } else {
            return landMarkTitleList.count
        }
    }
    
    
/*******************************************************************************
*      IBActions
*******************************************************************************/
    
    /*
    *  出口信息画面跳转
    */
    @IBAction func showStationExit() {
        
        var exitInfo: ExitInfo = self.storyboard?.instantiateViewControllerWithIdentifier("ExitInfo") as ExitInfo
        
        var rowArr = model!.odbLandMark(group_id)
        exitInfo.statId = group_id
        exitInfo.landMarkArr = rowArr
        if (statSeqArr.count > 0) {
            var key: MstT02StationTable = statSeqArr[0] as MstT02StationTable
            var statLat: Double = ("\(key.item(MSTT02_STAT_LAT))" as NSString).doubleValue
            var statLon: Double = ("\(key.item(MSTT02_STAT_LON))" as NSString).doubleValue
            exitInfo.landMarkLocation = CLLocation(latitude: statLat, longitude: statLon)
        }
        
        self.navigationController?.pushViewController(exitInfo, animated: true)
    }
    
    /*
    *  收藏按钮点击功能（添加、删除）
    */
    @IBAction func addSubway() {
        
        if (btnCollect.tag == 401) {
            if (collectRowid != "") {
                if (model!.removeStation(collectRowid!)){
                    btnCollect.setBackgroundImage(UIImage(named: "station_collect"), forState: UIControlState.Normal)
                    btnCollect.tag = 400
                }
            }
        } else {
            if (model!.collectStation(group_id)) {

                odbCollectStation()
            } else {

            }
        }
    }
    
    /*
    *  周边地图跳转
    */
    @IBAction func showLandMarkMap() {
        
        var landMarkMap: LandMarkMapController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
        
        if (statSeqArr.count > 0) {
            var key: MstT02StationTable = statSeqArr[0] as MstT02StationTable
            var statLat: Double = ("\(key.item(MSTT02_STAT_LAT))" as NSString).doubleValue
            var statLon: Double = ("\(key.item(MSTT02_STAT_LON))" as NSString).doubleValue
            landMarkMap.landMarkLocation = CLLocation(latitude: statLat, longitude: statLon)
            landMarkMap.statId = group_id
            
            landMarkMap.landMarkArr = model!.odbLandMark(group_id)
            
            landMarkMap.title = "STA002_16".localizedString()
        }
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(landMarkMap, animated: true)
    }
    
    /*
    *  设置起点
    */
    @IBAction func setStartStation() {
        
        var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
        
        routeSearch.startStationText = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(routeSearch, animated: true)
    }
    
    /*
    *  设置终点
    */
    @IBAction func setEndStation() {
        
        var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
        
        routeSearch.endStationText = group_id
        
        if (ruteLandMarkId != nil) {
            routeSearch.endStationLandMarkId = ruteLandMarkId!
        }
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(routeSearch, animated: true)
    }
    
    /*
    *  平日、周末、假日segment切换
    */
    @IBAction func weekendSegmentChanged(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            
            for (var i = 0; i < depaTimeArr.count; i++) {
                var array: [String] = depaTimeArr[i][0] as [String]
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = array[2]
            }
        } else if (sender.selectedSegmentIndex == 1) {
            
            for (var i = 0; i < depaTimeArr.count; i++) {
                var array: [String] = depaTimeArr[i][1] as [String]
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = array[2]
            }
        } else {
            for (var i = 0; i < depaTimeArr.count; i++) {
                var array: [String] = depaTimeArr[i][2] as [String]
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = array[2]
            }
        }
    }
    
    
/*******************************************************************************
*    Private Methods
*******************************************************************************/

    /*
    *  根据statid查groupid，然后根据groupid查出车站信息
    */
    func odbStation(){
        var table = MstT02StationTable()
        
        table.statId = stat_id
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            key as MstT02StationTable
            
            group_id = key.item(MSTT02_STAT_GROUP_ID) as String
            statSeqArr = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(group_id) and substr(LINE_ID,1,3)='280'")
        }
    }

    /*
    *  查询收藏表，判断该站点是否收藏并附上相应的图片
    */
    func odbCollectStation() {
        var table = UsrT03FavoriteTable()
        table.favoType = "01"
        table.statId = group_id
        var rows = table.selectAll()
        if (rows.count > 0) {
            btnCollect.setBackgroundImage(UIImage(named: "station_collect_yellow"), forState: UIControlState.Normal)
            btnCollect.tag = 401
            collectRowid = (rows[0] as UsrT03FavoriteTable).rowid
        } else {
            btnCollect.setBackgroundImage(UIImage(named: "station_collect"), forState: UIControlState.Normal)
            btnCollect.tag = 400
        }
    }

    /*
    *  代码画出该站点在所有地铁线上的站号
    */
    func addLineView() {
        
        for (var i = 0; i < statSeqArr.count; i++) {
            
            var map = statSeqArr[i] as MstT02StationTable
            var lineImage: UIImageView = UIImageView()
            lineImage.frame = CGRectMake(CGFloat(20 + i * 35), 85, 30, 30)
            lineImage.image = (map.item(MSTT02_STAT_ID) as String).getLineStatImage()
            
            self.scrollView.addSubview(lineImage)
        }
        
    }

    /*
    *  代码画出首末班车列表
    */
    func addLineTime() {

        for key in statSeqArr {
            key as MstT02StationTable
            
            depaTimeArr = model!.odbTime((key.item(MSTT02_STAT_ID) as String), array: depaTimeArr)
        }

        for (var i = 0; i < depaTimeArr.count; i++) {
            println(depaTimeArr[i][0])
            var array: [String] = depaTimeArr[i][0] as [String]
            var time1: UIView = UIView()
            time1.frame = CGRectMake(20, CGFloat(220 + i * 35), 280, 35)
            
            var icon: UIImageView = UIImageView()
            icon.frame = CGRectMake(0, 8.5, 18, 18)
            icon.image = array[0].getLineMiniImage()
            time1.addSubview(icon)
            
            var open1: UILabel = UILabel()
            open1.frame = CGRectMake(25, 0, 155, 35)
            open1.text = "STA002_10".localizedString() + "\(array[1].station())："
            open1.font = UIFont.boldSystemFontOfSize(18)
            open1.adjustsFontSizeToFitWidth = true
            time1.addSubview(open1)
            
            var open2: UILabel = UILabel()
            open2.frame = CGRectMake(180, 0, 100, 35)
            open2.text = "\(array[2])"
            open2.font = UIFont.boldSystemFontOfSize(18)
            open2.textColor = UIColor.grayColor()
            open2.tag = 300 + i
            time1.addSubview(open2)
            
            self.scrollView.addSubview(time1)
        }

    }
    
    /*
    *  代码画出车站的链接列表，并设置uiscrollview的高度
    */
    func addStationSelect() {

        var table = UITableView(frame: CGRectMake(0, CGFloat(220 + depaTimeArr.count * 35 + 15), 320, CGFloat(44 * (selectList.count + landMarkTitleList.count) + 30)), style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.scrollView.addSubview(table)
        
        scrollView.contentSize = CGSizeMake(320, table.frame.origin.y + table.frame.height)
    }
    
    /*
    *  景点、美食、购物链接跳转
    */
    func showLnadMarkList(index: Int) {
        var landMark: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        landMark.landMarkType = index
        landMark.landMarkStatId = group_id
        landMark.classType = "1"
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(landMark, animated: true)

    }
    
    /*
    *  站内商业设施跳转
    */
    func showComercialInside() {
        var stationFacilities: StationFacilities = self.storyboard?.instantiateViewControllerWithIdentifier("StationFacilities") as StationFacilities
        stationFacilities.statId = group_id
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(stationFacilities, animated: true)
    }
    
    /*
    *  时刻表跳转
    */
    func showTime() {
    
        var timeDetail: TimeTable = self.storyboard?.instantiateViewControllerWithIdentifier("TimeTable") as TimeTable
        
        timeDetail.statId = stat_id
        timeDetail.lineArr = statSeqArr
        timeDetail.nameKana = cellJPNmaeLabel.text
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        self.navigationController?.pushViewController(timeDetail, animated: true)
    }
    
    /*
    *  车站结构图跳转
    */
    func showStationMap() {
        
        var stationMap: StationImg = self.storyboard?.instantiateViewControllerWithIdentifier("StationImg") as StationImg
        
        stationMap.stationMapUrl = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(stationMap, animated: true)
    }
    
    /*
    *  车站便利设施跳转
    */
    func showFacility() {
    
        var facilityList: FacilityList = self.storyboard?.instantiateViewControllerWithIdentifier("FacilityList") as FacilityList
        
        facilityList.statId = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(facilityList, animated: true)
    }
    
    
/*******************************************************************************
*    Unused Codes
*******************************************************************************/
    
}
