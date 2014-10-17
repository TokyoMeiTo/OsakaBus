//
//  StationDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import CoreLocation

class StationDetail: UIViewController, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellJPNmaeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weSegment: UISegmentedControl!
    @IBOutlet weak var imgCollect: UIImageView!
    
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
    // 站点statId、statSeq、lineId数组
    var statSeqArr: NSArray = NSArray.array()
    
    // 景点、购物、美食数组
    var landMarkArr: NSArray = NSArray.array()
    // 其他链接
    var selectList = ["车站时刻表", "车站结构图","车站便利设施", "车站商业设施"]
    
    // 其他链接
    var landMarkTitleList = ["INF002_11".localizedString(), "INF002_09".localizedString(), "PUBLIC_09".localizedString()]
    
    var depaTimeArr: NSMutableArray = NSMutableArray.array()
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //车站本地化名
        cellNameLabel.text = stat_id.station()
        //车站日文名
        cellJPNmaeLabel.text = cellJPName + "（" + cellJPNameKana + "）"
        //标题
        self.title = stat_id.station()
        //查询车站信息
        odbStation()
        //查询时刻表信息
//        odbTrainSchedule()
        // 获取屏幕尺寸
        size = UIScreen.mainScreen().bounds.size
        // 代码添加车站icon
        addLineView()
        // 添加首末班车时间
        addLineTime()
        // 添加站点相关信息的链接
        addStationSelect()
        // 检索该站是否已收藏
        odbCollectStation()

    }
    
    
    func odbLandMark(type: String) {
        
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        landMarkArr = mstT04Table.queryLandMarkByStatId(group_id, lmakType: type)

    }
    
    func odbLandMark() -> NSArray{
        
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        var rows = mstT04Table.queryLandMarkByStatId(group_id, lmakType: "")
        
        return rows
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        // 存储丸之内线m段车站
        var mStationArr: NSMutableArray = NSMutableArray.array()
        
        table.statId = stat_id
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            key as MstT02StationTable
            
            group_id = key.item(MSTT02_STAT_GROUP_ID) as String
            statSeqArr = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(group_id)")
        }
    }
    
    func odbTrainSchedule() {
        var table = LinT01TrainScheduleTrainTable()
        // 获取平日时的所有列车各个方向的首末班车时间
        for (var j = 0; j < statSeqArr.count; j++) {
            var startTime = ""
            var endTime = ""
            var statId = (statSeqArr[j] as MstT02StationTable).item(MSTT02_STAT_ID) as String
            table.statId = statId
            table.scheType = "1"
            table.firstTrainFlag = "1"
            var rows = table.selectAll()
            if (rows.count > 0) {
                for (var i = 0; i < rows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = rows[i] as LinT01TrainScheduleTrainTable
                    cellLine = addString(cellLine, addValue:(key.item(LINT01_TRAIN_SCHEDULE_LINE_ID) as String))
                    cellClose = addString(cellClose, addValue:(key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String).station())
                    startTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            table.reset()
            table.statId = statId
            table.scheType = "1"
            table.firstTrainFlag = "9"
            var endRows = table.selectAll()
            if (endRows.count > 0) {
                for (var i = 0; i < endRows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = endRows[i] as LinT01TrainScheduleTrainTable
                    endTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            cellJapanTime = addString(cellJapanTime, addValue: "\(startTime)/\(endTime)")

        }
        
        // 获取周末时的所有列车各个方向的首末班车时间
        for (var j = 0; j < statSeqArr.count; j++) {
            var startTime = ""
            var endTime = ""
            var statId = (statSeqArr[j] as MstT02StationTable).item(MSTT02_STAT_ID) as String
            table.statId = statId
            table.scheType = "2"
            table.firstTrainFlag = "1"
            var rows = table.selectAll()
            if (rows.count > 0) {
                for (var i = 0; i < rows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = rows[i] as LinT01TrainScheduleTrainTable
                    startTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            table.reset()
            table.statId = statId
            table.scheType = "2"
            table.firstTrainFlag = "9"
            var endRows = table.selectAll()
            if (endRows.count > 0) {
                for (var i = 0; i < endRows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = endRows[i] as LinT01TrainScheduleTrainTable
                    endTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            cellJapanWETime = addString(cellJapanWETime, addValue: "\(startTime)/\(endTime)")
            
        }
        
        // 获取节假日时的所有列车各个方向的首末班车时间
        for (var j = 0; j < statSeqArr.count; j++) {
            var startTime = ""
            var endTime = ""
            var statId = (statSeqArr[j] as MstT02StationTable).item(MSTT02_STAT_ID) as String
            table.statId = statId
            table.scheType = "3"
            table.firstTrainFlag = "1"
            var rows = table.selectAll()
            if (rows.count > 0) {
                for (var i = 0; i < rows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = rows[i] as LinT01TrainScheduleTrainTable
                    startTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            table.reset()
            table.statId = statId
            table.scheType = "3"
            table.firstTrainFlag = "9"
            var endRows = table.selectAll()
            if (endRows.count > 0) {
                for (var i = 0; i < endRows.count; i++) {
                    var key: LinT01TrainScheduleTrainTable = endRows[i] as LinT01TrainScheduleTrainTable
                    endTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
                }
            }
            
            cellJapanHolidayTime = addString(cellJapanHolidayTime, addValue: "\(startTime)/\(endTime)")
        }
    }
    
    
    
    func addString(value: String, addValue:String) -> String{
        
        if (addValue.isEmpty) {
            return value
        }
        if (value.isEmpty) {
            return addValue
        } else {
            return value + "," + addValue
        }
    }
    
    func odbCollectStation() {
        var table = UsrT03FavoriteTable()
        table.favoType = "01"
        table.statId = group_id
        var rows = table.selectAll()
        if (rows.count > 0) {
            imgCollect.image = UIImage(named: "station_collect_icon")
        } else {
            imgCollect.image = UIImage(named: "station_uncollect_icon")
        }
    }
    
    
    func collectStation() {
    
        var table = UsrT03FavoriteTable()
        
        table.favoType = "01"
        table.statId = group_id
        var rows = table.selectAll()
        if (rows.count > 0) {
            var sureBtn: UIAlertView = UIAlertView(title: "", message: "STA002_06".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_06".localizedString())
            
            sureBtn.show()
        } else {
            table.reset()
            table.favoType = "01"
            table.favoTime = NSDate().description.dateWithFormat("yyyy-MM-dd HH:mm:ss +0000", target: "yyyyMMddHHmmss")
            table.lineId = ""
            table.statId = stat_id
            table.statExitId = ""
            table.lmakId = ""
            table.ruteId = ""
            table.ext1 = ""
            table.ext2 = ""
            table.ext3 = ""
            table.ext4 = ""
            table.ext5 = ""
            if (table.insert()) {
                var sureBtn: UIAlertView = UIAlertView(title: "", message: "CMN003_21".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_06".localizedString())
                
                sureBtn.show()
                imgCollect.image = UIImage(named: "station_collect_icon")
            } else {
                var sureBtn: UIAlertView = UIAlertView(title: "", message: "CMN003_20".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_06".localizedString())
                
                sureBtn.show()
            }
        }
    }
    
    func odbTime(statId: String) {

        var table = LinT01TrainScheduleTrainTable()
        var rows = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
        
        
        for key in rows {
            key as LinT01TrainScheduleTrainTable
            var dirtStat: String = key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String
            var lineId: String = key.item(LINT01_TRAIN_SCHEDULE_LINE_ID) as String

            var timeTypeArr1 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '1' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr2 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '2' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr3 = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '3' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            
            var timeArr: NSMutableArray = NSMutableArray.array()
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr1)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr2)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr3)])
            
            println(timeArr[0])
            depaTimeArr.addObject(timeArr)
        }
    }
    
    func timeFormat(time: NSArray) -> String{
        
        if (time.count < 2){
            return ""
        }
        
        var startTime: String = ""
        var endTime: String = ""
        var strTime: String = ""
        for key in time {
            key as LinT01TrainScheduleTrainTable
            var trainFlag: String = key.item(LINT01_TRAIN_SCHEDULE_FIRST_TRAIN_FLAG) as String
            
            if (trainFlag == "1") {
                startTime = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).dateWithFormat("HHmm", target: "HH:mm")
            } else if (trainFlag == "9") {
                
                if (strTime == "") {
                    strTime = key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String
                } else {
                    var string: Int! = strTime.toInt()
                    if (string < 400) {
                        string = string + 2400
                    }
                    var string2: Int! = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).toInt()
                    if (string2 < 400) {
                        string2 = string2 + 2400
                    }
                    
                    if (string2 > string) {
                        strTime = key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String
                    }
                }
            }
        }
        endTime = strTime.dateWithFormat("HHmm", target: "HH:mm")
        return "\(startTime)/\(endTime)"
    }

    
    @IBAction func showStationExit() {
    
//        var stationExit: ExitInfo = self.storyboard?.instantiateViewControllerWithIdentifier("stationExit") as ExitInfo
//        
//        stationExit.statId = group_id
//        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem = backButton
//        
//        self.navigationController?.pushViewController(stationExit, animated: true)
        var exitInfo: ExitInfo = self.storyboard?.instantiateViewControllerWithIdentifier("ExitInfo") as ExitInfo
        
        var rowArr = odbLandMark()
        exitInfo.statId = group_id
        exitInfo.landMarkArr = rowArr
        
        self.navigationController?.pushViewController(exitInfo, animated: true)
    }
    
    
    @IBAction func addSubway() {
    
        collectStation()
    }
    
    @IBAction func showLandMarkMap() {
    
        var landMarkMap: LandMarkMapController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
        
        if (statSeqArr.count > 0) {
            var key: MstT02StationTable = statSeqArr[0] as MstT02StationTable
            var statLat: Double = ("\(key.item(MSTT02_STAT_LAT))" as NSString).doubleValue
            var statLon: Double = ("\(key.item(MSTT02_STAT_LON))" as NSString).doubleValue
            landMarkMap.landMarkLocation = CLLocation(latitude: statLat, longitude: statLon)
            landMarkMap.statId = group_id
            
            landMarkMap.title = "站点地图"
        }
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(landMarkMap, animated: true)
    }
    
    
    @IBAction func pushStationMap() {
    
        var stationMap: StationImg = self.storyboard?.instantiateViewControllerWithIdentifier("StationImg") as StationImg

        stationMap.stationMapUrl = group_id.getStationInnerMapImagePath()
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(stationMap, animated: true)
    }
    
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        if (buttonIndex == 1) {
//            var name: String = cellName
//            var description: String = cellStation
//            taskMgr.addTask(name, desc: description)
        }
    }
    
    @IBAction func setStartStation() {
    
        var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
        
        routeSearch.startStationText = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(routeSearch, animated: true)
    }
    
    @IBAction func setEndStation() {
        
        var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
        
        routeSearch.endStationText = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(routeSearch, animated: true)
    }
    
    func addLineView() {
        
        for (var i = 0; i < statSeqArr.count; i++) {
            
            var map = statSeqArr[i] as MstT02StationTable
            var lineImage: UIImageView = UIImageView()
            lineImage.frame = CGRectMake(CGFloat(20 + i * 35), 85, 30, 30)
            lineImage.image = (map.item(MSTT02_STAT_ID) as String).getStationIconImage()
            
            self.scrollView.addSubview(lineImage)
        }
        
    }

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
    
    func addLineTime() {

        for key in statSeqArr {
            key as MstT02StationTable
            
            odbTime(key.item(MSTT02_STAT_ID) as String)
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
    
    func addStationSelect() {

        var table = UITableView(frame: CGRectMake(0, CGFloat(220 + depaTimeArr.count * 35 + 15), 320, CGFloat(44 * (selectList.count + landMarkTitleList.count) + 30)), style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.scrollView.addSubview(table)
        
        scrollView.contentSize = CGSizeMake(320, table.frame.origin.y + table.frame.height)
    }
    
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
            lblTitle.text = "周边信息"
            view.addSubview(lblTitle)
            return view
        }
        
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return selectList.count
        } else {
            return landMarkTitleList.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
            case 0:
                showTime()
            case 1:
                pushStationMap()
            case 2:
                showFacility()
            case 3:
                showComercialInside()
            default:
                pushStationMap()
            }
        } else{
            showLnadMarkList(indexPath.row)
        }
    }
    
    func showLnadMarkList(index: Int) {
        var landMark: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        if (index == 0) {
            odbLandMark("景点")
            landMark.title = "INF002_11".localizedString()
        } else if (index == 1) {
            odbLandMark("美食")
            landMark.title = "INF002_09".localizedString()
        } else {
            odbLandMark("购物")
            landMark.title = "PUBLIC_09".localizedString()
        }
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        landMark.landMarks = landMarkArr as? Array<MstT04LandMarkTable>
        
        self.navigationController?.pushViewController(landMark, animated: true)

    }
    
    func showExitInfo() {
        var exitInfo: ExitInfo = self.storyboard?.instantiateViewControllerWithIdentifier("ExitInfo") as ExitInfo
        
        var rowArr = odbLandMark()
        
        exitInfo.landMarkArr = rowArr
        
        self.navigationController?.pushViewController(exitInfo, animated: true)
    }
    
    func showComercialInside() {
        var stationFacilities: StationFacilities = self.storyboard?.instantiateViewControllerWithIdentifier("StationFacilities") as StationFacilities
        stationFacilities.statId = group_id
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(stationFacilities, animated: true)
    }
    
    func showTime() {
    
        var timeDetail: TimeTable = self.storyboard?.instantiateViewControllerWithIdentifier("TimeTable") as TimeTable
        
        timeDetail.statId = stat_id
        timeDetail.lineArr = statSeqArr
        timeDetail.nameKana = cellJPNmaeLabel.text
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        self.navigationController?.pushViewController(timeDetail, animated: true)
    }
    
    func showFacility() {
    
        var facilityList: FacilityList = self.storyboard?.instantiateViewControllerWithIdentifier("FacilityList") as FacilityList
        
        facilityList.statId = group_id
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(facilityList, animated: true)
    }
    
    func showExitMap() {
        var exitMap: ExitMap = self.storyboard?.instantiateViewControllerWithIdentifier("ExitMap") as ExitMap
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(exitMap, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
