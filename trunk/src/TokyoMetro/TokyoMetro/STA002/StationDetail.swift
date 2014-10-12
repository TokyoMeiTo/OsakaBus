//
//  StationDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class StationDetail: UIViewController, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellJPNmaeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var weSegment: UISegmentedControl!
    
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
    // 其他链接
    var selectList = ["车站时刻表", "车站结构图", "车站位置图", "站内商业设施", "车站设施"]
    
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
        
//        odbTime(stat_id)

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
            statSeqArr = table.excuteQuery("select STAT_SEQ,STAT_ID,LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(group_id)")
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
    
    
    func collectStation() {
    
        var table = UsrT03FavoriteTable()
        
        table.favoType = "01"
        table.statId = group_id
        var rows = table.selectAll()
        if (rows.count > 0) {
            var sureBtn: UIAlertView = UIAlertView(title: "", message: "该站已收藏！", delegate: self, cancelButtonTitle: "确定")
            
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
                println("插入成功")
            } else {
                println("插入失败")
            }
        }
    }
    
    func odbTime(statId: String) {

        var table = LinT01TrainScheduleTrainTable()
        var rows = table.excuteQuery("select * from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
        
        var timeArr: NSMutableArray = NSMutableArray.array()
        for key in rows {
            key as LinT01TrainScheduleTrainTable
            var dirtStat: String = key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String
            var lineId: String = key.item(LINT01_TRAIN_SCHEDULE_LINE_ID) as String

            var timeTypeArr1 = table.excuteQuery("select * from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '1' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr2 = table.excuteQuery("select * from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '2' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            var timeTypeArr3 = table.excuteQuery("select *,from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and DIRT_STAT_ID = '\(dirtStat)' and SCHE_TYPE = '3' and (FIRST_TRAIN_FLAG = '1' or FIRST_TRAIN_FLAG = '9')")
            
            
            timeArr.removeAllObjects()
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr1)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr2)])
            timeArr.addObject([lineId, dirtStat, timeFormat(timeTypeArr3)])
            
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
                    var string: Int = strTime.numberOfDecimal()
                    if (string < 400) {
                        string = string + 2400
                    }
                    var string2: Int = (key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).numberOfDecimal()
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
    
        var stationExit: ExitInfo = self.storyboard?.instantiateViewControllerWithIdentifier("stationExit") as ExitInfo
        
        stationExit.statId = stat_id
        
        self.navigationController?.pushViewController(stationExit, animated: true)
    }
    
    
    @IBAction func addSubway() {
    
        collectStation()
    }
    
    
    @IBAction func cellectSubway() {
        
        var sureBtn: UIAlertView = UIAlertView(title: "", message: "你确定要收藏吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        
        sureBtn.show()
        
        
    }
    
    @IBAction func pushStationMap() {
    
        var stationMap: StationImg = self.storyboard?.instantiateViewControllerWithIdentifier("StationImg") as StationImg
        
        stationMap.stationMapUrl = "http://www.tokyometro.jp/station/\(statMetroId.lowercaseString)/yardmap/images/yardmap.gif"
        
        self.navigationController?.pushViewController(stationMap, animated: true)
    }
    
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        if (buttonIndex == 1) {
//            var name: String = cellName
//            var description: String = cellStation
//            taskMgr.addTask(name, desc: description)
        }
    }
    
    func addLineView() {
        
        for (var i = 0; i < statSeqArr.count; i++) {
            
            var map = statSeqArr[i] as MstT02StationTable
            var lineImage: UIImageView = UIImageView()
            lineImage.frame = CGRectMake(CGFloat(20 + i * 35), 85, 30, 30)
            lineImage.image = stationIcon(map.item(MSTT02_STAT_SEQ) as String)
            
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
            var array: [String] = depaTimeArr[i][0] as [String]
            var time1: UIView = UIView()
            time1.frame = CGRectMake(20, CGFloat(220 + i * 35), 280, 35)
            
            var icon: UIImageView = UIImageView()
            icon.frame = CGRectMake(0, 8.5, 18, 18)
            icon.image = lineImage(array[0])
            time1.addSubview(icon)
            
            var open1: UILabel = UILabel()
            open1.frame = CGRectMake(25, 0, 155, 35)
            open1.text = "开往\(array[1].station())："
            open1.font = UIFont.boldSystemFontOfSize(18)
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

        var table = UITableView()
        table.frame = CGRectMake(0, CGFloat(220 + depaTimeArr.count * 35 + 15), 320, CGFloat(46 * selectList.count))
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.scrollView.addSubview(table)
        
        scrollView.contentSize = CGSizeMake(320, table.frame.origin.y + CGFloat(46 * selectList.count + 30))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 245/255, green: 246/255, blue: 248/255, alpha: 1)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var image = UIImageView()
        var imageName = "station-link-" + (indexPath.row + 1).description
        image.frame = CGRectMake(15, 8, 30, 30)
        image.image = UIImage(named: imageName)
        
        cell.addSubview(image)
        
        var content = UILabel()
        content.frame = CGRectMake(55, 0, 200, 46)
        content.text = selectList[indexPath.row]
        content.font = UIFont.systemFontOfSize(20)
        
        cell.addSubview(content)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 0:
            showTime()
        case 1:
            pushStationMap()
        case 2:
            showExitMap()
        case 3:
            pushStationMap()
        case 4:
            showFacility()
        default:
            pushStationMap()
        }
    }
    
    func showTime() {
    
        var timeDetail: TimeTable = self.storyboard?.instantiateViewControllerWithIdentifier("TimeTable") as TimeTable
        
        timeDetail.statId = stat_id
        timeDetail.lineArr = statSeqArr
        timeDetail.nameKana = cellJPNmaeLabel.text
        
        var backButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        self.navigationController?.pushViewController(timeDetail, animated: true)
    }
    
    func showFacility() {
    
        var facilityList: FacilityList = self.storyboard?.instantiateViewControllerWithIdentifier("FacilityList") as FacilityList
        
        facilityList.statId = group_id
        
        self.navigationController?.pushViewController(facilityList, animated: true)
    }
    
    func showExitMap() {
        var exitMap: ExitMap = self.storyboard?.instantiateViewControllerWithIdentifier("ExitMap") as ExitMap
        
        self.navigationController?.pushViewController(exitMap, animated: true)
    }

    
    func lineImage(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_mini_c.png")
        switch (lineNum) {
            
        case "28005":
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
        case "28010":
            image = UIImage(named: "tablecell_lineicon_mini_f.png")
        case "28001":
            image = UIImage(named: "tablecell_lineicon_mini_g.png")
        case "28003":
            image = UIImage(named: "tablecell_lineicon_mini_h.png")
        case "28002":
            image = UIImage(named: "tablecell_lineicon_mini_m.png")
        case "28009":
            image = UIImage(named: "tablecell_lineicon_mini_n.png")
        case "28004":
            image = UIImage(named: "tablecell_lineicon_mini_t.png")
        case "28006":
            image = UIImage(named: "tablecell_lineicon_mini_y.png")
        case "28008":
            image = UIImage(named: "tablecell_lineicon_mini_z.png")
        default:
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
        }
        
        return image
    }
    
    func stationIcon(statSeq: String) -> UIImage {
        var image = UIImage(named: "station_icon_c-01.png")
        
        switch(statSeq) {
        case "C01":
            image = UIImage(named: "station_icon_c-01.png")
        case "C02":
            image = UIImage(named: "station_icon_c-02.png")
        case "C03":
            image = UIImage(named: "station_icon_c-03.png")
        case "C04":
            image = UIImage(named: "station_icon_c-04.png")
        case "C05":
            image = UIImage(named: "station_icon_c-05.png")
        case "C06":
            image = UIImage(named: "station_icon_c-06.png")
        case "C07":
            image = UIImage(named: "station_icon_c-07.png")
        case "C08":
            image = UIImage(named: "station_icon_c-08.png")
        case "C09":
            image = UIImage(named: "station_icon_c-09.png")
        case "C10":
            image = UIImage(named: "station_icon_c-10.png")
        case "C11":
            image = UIImage(named: "station_icon_c-11.png")
        case "C12":
            image = UIImage(named: "station_icon_c-12.png")
        case "C13":
            image = UIImage(named: "station_icon_c-13.png")
        case "C14":
            image = UIImage(named: "station_icon_c-14.png")
        case "C15":
            image = UIImage(named: "station_icon_c-15.png")
        case "C16":
            image = UIImage(named: "station_icon_c-16.png")
        case "C17":
            image = UIImage(named: "station_icon_c-17.png")
        case "C18":
            image = UIImage(named: "station_icon_c-18.png")
        case "C19":
            image = UIImage(named: "station_icon_c-19.png")
        case "C20":
            image = UIImage(named: "station_icon_c-20.png")
        case "F01":
            image = UIImage(named: "station_icon_f-01.png")
        case "F02":
            image = UIImage(named: "station_icon_f-02.png")
        case "F03":
            image = UIImage(named: "station_icon_f-03.png")
        case "F04":
            image = UIImage(named: "station_icon_f-04.png")
        case "F05":
            image = UIImage(named: "station_icon_f-05.png")
        case "F06":
            image = UIImage(named: "station_icon_f-06.png")
        case "F07":
            image = UIImage(named: "station_icon_f-07.png")
        case "F08":
            image = UIImage(named: "station_icon_f-08.png")
        case "F09":
            image = UIImage(named: "station_icon_f-09.png")
        case "F10":
            image = UIImage(named: "station_icon_f-10.png")
        case "F11":
            image = UIImage(named: "station_icon_f-11.png")
        case "F12":
            image = UIImage(named: "station_icon_f-12.png")
        case "F13":
            image = UIImage(named: "station_icon_f-13.png")
        case "F14":
            image = UIImage(named: "station_icon_f-14.png")
        case "F15":
            image = UIImage(named: "station_icon_f-15.png")
        case "F16":
            image = UIImage(named: "station_icon_f-16.png")
        case "G01":
            image = UIImage(named: "station_icon_g-01.png")
        case "G02":
            image = UIImage(named: "station_icon_g-02.png")
        case "G03":
            image = UIImage(named: "station_icon_g-03.png")
        case "G04":
            image = UIImage(named: "station_icon_g-04.png")
        case "G05":
            image = UIImage(named: "station_icon_g-05.png")
        case "G06":
            image = UIImage(named: "station_icon_g-06.png")
        case "G07":
            image = UIImage(named: "station_icon_g-07.png")
        case "G08":
            image = UIImage(named: "station_icon_g-08.png")
        case "G09":
            image = UIImage(named: "station_icon_g-09.png")
        case "G10":
            image = UIImage(named: "station_icon_g-10.png")
        case "G11":
            image = UIImage(named: "station_icon_g-11.png")
        case "G12":
            image = UIImage(named: "station_icon_g-12.png")
        case "G13":
            image = UIImage(named: "station_icon_g-13.png")
        case "G14":
            image = UIImage(named: "station_icon_g-14.png")
        case "G15":
            image = UIImage(named: "station_icon_g-15.png")
        case "G16":
            image = UIImage(named: "station_icon_g-16.png")
        case "G17":
            image = UIImage(named: "station_icon_g-17.png")
        case "G18":
            image = UIImage(named: "station_icon_g-18.png")
        case "G19":
            image = UIImage(named: "station_icon_g-19.png")
        case "H01":
            image = UIImage(named: "station_icon_h-01.png")
        case "H02":
            image = UIImage(named: "station_icon_h-02.png")
        case "H03":
            image = UIImage(named: "station_icon_h-03.png")
        case "H04":
            image = UIImage(named: "station_icon_h-04.png")
        case "H05":
            image = UIImage(named: "station_icon_h-05.png")
        case "H06":
            image = UIImage(named: "station_icon_h-06.png")
        case "H07":
            image = UIImage(named: "station_icon_h-07.png")
        case "H08":
            image = UIImage(named: "station_icon_h-08.png")
        case "H09":
            image = UIImage(named: "station_icon_h-09.png")
        case "H10":
            image = UIImage(named: "station_icon_h-10.png")
        case "H11":
            image = UIImage(named: "station_icon_h-11.png")
        case "H12":
            image = UIImage(named: "station_icon_h-12.png")
        case "H13":
            image = UIImage(named: "station_icon_h-13.png")
        case "H14":
            image = UIImage(named: "station_icon_h-14.png")
        case "H15":
            image = UIImage(named: "station_icon_h-15.png")
        case "H16":
            image = UIImage(named: "station_icon_h-16.png")
        case "H17":
            image = UIImage(named: "station_icon_h-17.png")
        case "H18":
            image = UIImage(named: "station_icon_h-18.png")
        case "H19":
            image = UIImage(named: "station_icon_h-19.png")
        case "H20":
            image = UIImage(named: "station_icon_h-20.png")
        case "H21":
            image = UIImage(named: "station_icon_h-21.png")
        case "M01":
            image = UIImage(named: "station_icon_m-01.png")
        case "M02":
            image = UIImage(named: "station_icon_m-02.png")
        case "M03":
            image = UIImage(named: "station_icon_m-03.png")
        case "M04":
            image = UIImage(named: "station_icon_m-04.png")
        case "M05":
            image = UIImage(named: "station_icon_m-05.png")
        case "M06":
            image = UIImage(named: "station_icon_m-06.png")
        case "M07":
            image = UIImage(named: "station_icon_m-07.png")
        case "M08":
            image = UIImage(named: "station_icon_m-08.png")
        case "M09":
            image = UIImage(named: "station_icon_m-09.png")
        case "M10":
            image = UIImage(named: "station_icon_m-10.png")
        case "M11":
            image = UIImage(named: "station_icon_m-11.png")
        case "M12":
            image = UIImage(named: "station_icon_m-12.png")
        case "M13":
            image = UIImage(named: "station_icon_m-13.png")
        case "M14":
            image = UIImage(named: "station_icon_m-14.png")
        case "M15":
            image = UIImage(named: "station_icon_m-15.png")
        case "M16":
            image = UIImage(named: "station_icon_m-16.png")
        case "M17":
            image = UIImage(named: "station_icon_m-17.png")
        case "M18":
            image = UIImage(named: "station_icon_m-18.png")
        case "M19":
            image = UIImage(named: "station_icon_m-19.png")
        case "M20":
            image = UIImage(named: "station_icon_m-20.png")
        case "M21":
            image = UIImage(named: "station_icon_m-21.png")
        case "M22":
            image = UIImage(named: "station_icon_m-22.png")
        case "M23":
            image = UIImage(named: "station_icon_m-23.png")
        case "M24":
            image = UIImage(named: "station_icon_m-24.png")
        case "M25":
            image = UIImage(named: "station_icon_m-25.png")
        case "m03":
            image = UIImage(named: "station_icon_mm-03.png")
        case "m04":
            image = UIImage(named: "station_icon_mm-04.png")
        case "m05":
            image = UIImage(named: "station_icon_mm-05.png")
        case "N01":
            image = UIImage(named: "station_icon_n-01.png")
        case "N02":
            image = UIImage(named: "station_icon_n-02.png")
        case "N03":
            image = UIImage(named: "station_icon_n-03.png")
        case "N04":
            image = UIImage(named: "station_icon_n-04.png")
        case "N05":
            image = UIImage(named: "station_icon_n-05.png")
        case "N06":
            image = UIImage(named: "station_icon_n-06.png")
        case "N07":
            image = UIImage(named: "station_icon_n-07.png")
        case "N08":
            image = UIImage(named: "station_icon_n-08.png")
        case "N09":
            image = UIImage(named: "station_icon_n-09.png")
        case "N10":
            image = UIImage(named: "station_icon_n-10.png")
        case "N11":
            image = UIImage(named: "station_icon_n-11.png")
        case "N12":
            image = UIImage(named: "station_icon_n-12.png")
        case "N13":
            image = UIImage(named: "station_icon_n-13.png")
        case "N14":
            image = UIImage(named: "station_icon_n-14.png")
        case "N15":
            image = UIImage(named: "station_icon_n-15.png")
        case "N16":
            image = UIImage(named: "station_icon_n-16.png")
        case "N17":
            image = UIImage(named: "station_icon_n-17.png")
        case "N18":
            image = UIImage(named: "station_icon_n-18.png")
        case "N19":
            image = UIImage(named: "station_icon_n-19.png")
        case "T01":
            image = UIImage(named: "station_icon_t-01.png")
        case "T02":
            image = UIImage(named: "station_icon_t-02.png")
        case "T03":
            image = UIImage(named: "station_icon_t-03.png")
        case "T04":
            image = UIImage(named: "station_icon_t-04.png")
        case "T05":
            image = UIImage(named: "station_icon_t-05.png")
        case "T06":
            image = UIImage(named: "station_icon_t-06.png")
        case "T07":
            image = UIImage(named: "station_icon_t-07.png")
        case "T08":
            image = UIImage(named: "station_icon_t-08.png")
        case "T09":
            image = UIImage(named: "station_icon_t-09.png")
        case "T10":
            image = UIImage(named: "station_icon_t-10.png")
        case "T11":
            image = UIImage(named: "station_icon_t-11.png")
        case "T12":
            image = UIImage(named: "station_icon_t-12.png")
        case "T13":
            image = UIImage(named: "station_icon_t-13.png")
        case "T14":
            image = UIImage(named: "station_icon_t-14.png")
        case "T15":
            image = UIImage(named: "station_icon_t-15.png")
        case "T16":
            image = UIImage(named: "station_icon_t-16.png")
        case "T17":
            image = UIImage(named: "station_icon_t-17.png")
        case "T18":
            image = UIImage(named: "station_icon_t-18.png")
        case "T19":
            image = UIImage(named: "station_icon_t-19.png")
        case "T20":
            image = UIImage(named: "station_icon_t-20.png")
        case "T21":
            image = UIImage(named: "station_icon_t-21.png")
        case "T22":
            image = UIImage(named: "station_icon_t-22.png")
        case "T23":
            image = UIImage(named: "station_icon_t-23.png")
        case "Y01":
            image = UIImage(named: "station_icon_y-01.png")
        case "Y02":
            image = UIImage(named: "station_icon_y-02.png")
        case "Y03":
            image = UIImage(named: "station_icon_y-03.png")
        case "Y04":
            image = UIImage(named: "station_icon_y-04.png")
        case "Y05":
            image = UIImage(named: "station_icon_y-05.png")
        case "Y06":
            image = UIImage(named: "station_icon_y-06.png")
        case "Y07":
            image = UIImage(named: "station_icon_y-07.png")
        case "Y08":
            image = UIImage(named: "station_icon_y-08.png")
        case "Y09":
            image = UIImage(named: "station_icon_y-09.png")
        case "Y10":
            image = UIImage(named: "station_icon_y-10.png")
        case "Y11":
            image = UIImage(named: "station_icon_y-11.png")
        case "Y12":
            image = UIImage(named: "station_icon_y-12.png")
        case "Y13":
            image = UIImage(named: "station_icon_y-13.png")
        case "Y14":
            image = UIImage(named: "station_icon_y-14.png")
        case "Y15":
            image = UIImage(named: "station_icon_y-15.png")
        case "Y16":
            image = UIImage(named: "station_icon_y-16.png")
        case "Y17":
            image = UIImage(named: "station_icon_y-17.png")
        case "Y18":
            image = UIImage(named: "station_icon_y-18.png")
        case "Y19":
            image = UIImage(named: "station_icon_y-19.png")
        case "Y20":
            image = UIImage(named: "station_icon_y-20.png")
        case "Y21":
            image = UIImage(named: "station_icon_y-21.png")
        case "Y22":
            image = UIImage(named: "station_icon_y-22.png")
        case "Y23":
            image = UIImage(named: "station_icon_y-23.png")
        case "Y24":
            image = UIImage(named: "station_icon_y-24.png")
        case "Z01":
            image = UIImage(named: "station_icon_z-01.png")
        case "Z02":
            image = UIImage(named: "station_icon_z-02.png")
        case "Z03":
            image = UIImage(named: "station_icon_z-03.png")
        case "Z04":
            image = UIImage(named: "station_icon_z-04.png")
        case "Z05":
            image = UIImage(named: "station_icon_z-05.png")
        case "Z06":
            image = UIImage(named: "station_icon_z-06.png")
        case "Z07":
            image = UIImage(named: "station_icon_z-07.png")
        case "Z08":
            image = UIImage(named: "station_icon_z-08.png")
        case "Z09":
            image = UIImage(named: "station_icon_z-09.png")
        case "Z10":
            image = UIImage(named: "station_icon_z-10.png")
        case "Z11":
            image = UIImage(named: "station_icon_z-11.png")
        case "Z12":
            image = UIImage(named: "station_icon_z-12.png")
        case "Z13":
            image = UIImage(named: "station_icon_z-13.png")
        case "Z14":
            image = UIImage(named: "station_icon_z-14.png")
            
        default:
            image = UIImage(named: "station_icon_c-01.png")
        }
        
        return image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
