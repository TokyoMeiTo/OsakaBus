//
//  TimeTable.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class TimeTable: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var weekendSegment: UISegmentedControl!
    @IBOutlet weak var statName: UILabel!
    @IBOutlet weak var statNameKana: UILabel!
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineMenuView: UIView!
    
    
    var statId: String = ""
    var lineId: String = ""
    // 日文名与假名
    var nameKana: String?
    // 屏幕尺寸
    var mScreenSize: CGSize!
    
    var selectedIndex = 0
    // tableview的数据源
    var allTimeArr: NSMutableArray = NSMutableArray.array()
    // 方向站segment选择第一个时的数据源
    var destTimeArr1: NSMutableArray = NSMutableArray.array()
    // 方向站segment选择第二个时的数据源
    var destTimeArr2: NSMutableArray = NSMutableArray.array()
    // 方向站segment选择第三个时的数据源
    var destTimeArr3: NSMutableArray = NSMutableArray.array()
    
    var lineArr: NSArray = NSArray.array()
    
//    var endStationArr: [String] = [String]()
    
    var dirtStationArr: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "STA002_12".localizedString()
        
        // ScreenSize
        self.mScreenSize = UIScreen.mainScreen().bounds.size
        
        lineMenuView.hidden = true
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "hideLine")
        lineMenuView.addGestureRecognizer(tapGesture)
        
        statName.text = statId.station()
        statNameKana.text = nameKana
        
        if (lineArr.count > 0) {
            lineId = (lineArr[0] as MstT02StationTable).item(MSTT02_LINE_ID) as String
            statId = (lineArr[0] as MstT02StationTable).item(MSTT02_STAT_ID) as String
            statIcon.image = lineId.getLineImage()
        }
        odbDirtStatId()

        setSegment()
        
        odbTime()
        
        allTimeArr = destTimeArr1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func weekendSegmentChnaged() {
        table.reloadData()
    }
    
    @IBAction func segmentChnaged() {
        odbTime()
        if (segment.selectedSegmentIndex == 0) {
            allTimeArr = destTimeArr1
        } else if (segment.selectedSegmentIndex == 1){
            allTimeArr = destTimeArr2
        } else {
            allTimeArr = destTimeArr3
        }
        
        table.reloadData()
    }
    
    @IBAction func showLine() {
        addLine()
        lineMenuView.hidden = false
    }
    
    @IBAction func hideLine() {
        lineMenuView.hidden = true
    }
    
    func odbDirtStatId() {
        var table = LinT01TrainScheduleTrainTable()
        var rows = table.excuteQuery("select * from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
        
        dirtStationArr = [String]()
        for key in rows {
            key as LinT01TrainScheduleTrainTable
            dirtStationArr.append(key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String)
        }
    }
    
    func addLine() {
        
        for (var i = 0; i < lineArr.count; i++) {
            var key = lineArr[i] as MstT02StationTable
            var view = UIView()
            view.frame = CGRectMake(0, CGFloat(i * 60 + 5), 180, 60)
            var lineImage = UIImageView()
            lineImage.frame = CGRectMake(8, 8, 44, 44)
            lineImage.image = (key.item(MSTT02_LINE_ID) as String).getLineImage()
            view.addSubview(lineImage)
            
            var lineName = UILabel()
            lineName.frame = CGRectMake(58, 1, 122, 59)
            lineName.text = (key.item(MSTT02_LINE_ID)  as String).line()
            lineName.textColor = UIColor.whiteColor()
            view.addSubview(lineName)
            
            view.tag = 300 + i
            var tapGesture = UITapGestureRecognizer(target: self, action: "lineSelected:")
            view.addGestureRecognizer(tapGesture)

            if (i > 0) {
                var lblLine = UILabel()
                lblLine.frame = CGRectMake(0, 0, 200, 1)
                lblLine.backgroundColor = UIColor.darkGrayColor()
                view.addSubview(lblLine)
            }
            
            lineView.addSubview(view)
            
        }
        
        lineView.layer.borderColor = UIColor(red: 87/255, green: 86/255, blue: 86/255, alpha: 1).CGColor
        lineView.layer.borderWidth = 2
        lineView.layer.cornerRadius = 5
        
        var viewHeight: CGFloat = CGFloat(lineArr.count * 60 + 10)
        lineView.frame = CGRectMake(60, CGFloat((mScreenSize.height - viewHeight - 64)/2 + 64), 200, viewHeight)
    }
    
    func lineSelected(sender:UITapGestureRecognizer) {
        selectedIndex = sender.view!.tag - 300
        var key = lineArr[selectedIndex] as MstT02StationTable
        lineId = key.item(MSTT02_LINE_ID) as String
        statId = key.item(MSTT02_STAT_ID) as String
        // 替换图标
        statIcon.image = lineId.getLineImage()
        odbDirtStatId()
        setSegment()
        destTimeArr1.removeAllObjects()
        destTimeArr2.removeAllObjects()
        destTimeArr3.removeAllObjects()
        allTimeArr.removeAllObjects()
        odbTime()
        
        allTimeArr = destTimeArr1
        table.reloadData()
        
        lineMenuView.hidden = true
    }
    
    func setSegment() {
        if (dirtStationArr.count > 0) {
            segment.removeAllSegments()
            for (var i = 0; i < dirtStationArr.count; i++) {
                segment.insertSegmentWithTitle(dirtStationArr[i].station(), atIndex: i, animated: false)
//                segment.setTitle(dirtStationArr[i].station(), forSegmentAtIndex: i)
            }
            
            segment.selectedSegmentIndex = 0

        }
        
    }
    
    
    func odbTime() {
        
        if (destTimeArr1.count == 3 && destTimeArr2.count == 3 && destTimeArr3.count == 3) {
            return
        }
        var index = segment.selectedSegmentIndex
        var key = lineArr[selectedIndex] as MstT02StationTable
        var statId = key.item(MSTT02_STAT_ID) as String
        
        var table = LinT01TrainScheduleTrainTable()
        table.reset()
        table.statId = statId
        table.dirtStatId = dirtStationArr[index]
        table.scheType = "1"
        var timeTypeArr1 = table.selectAll()
        
        
        table.reset()
        table.statId = statId
        table.dirtStatId = dirtStationArr[index]
        table.scheType = "2"
        var timeTypeArr2 = table.selectAll()
        
        
        table.reset()
        table.statId = statId
        table.dirtStatId = dirtStationArr[index]
        table.scheType = "3"
        var timeTypeArr3 = table.selectAll()
        
        if (index == 0) {
            destTimeArr1.addObject(initTimeArr(timeTypeArr1))
            destTimeArr1.addObject(initTimeArr(timeTypeArr2))
            destTimeArr1.addObject(initTimeArr(timeTypeArr3))
        } else if (index == 1) {
            destTimeArr2.addObject(initTimeArr(timeTypeArr1))
            destTimeArr2.addObject(initTimeArr(timeTypeArr2))
            destTimeArr2.addObject(initTimeArr(timeTypeArr3))
        } else {
            destTimeArr3.addObject(initTimeArr(timeTypeArr1))
            destTimeArr3.addObject(initTimeArr(timeTypeArr2))
            destTimeArr3.addObject(initTimeArr(timeTypeArr3))
        }
        
        
    }
    
    func initTimeArr(data: NSArray) -> NSMutableArray {
        
        var timeArr: NSMutableArray = NSMutableArray.array()
        var arr1: [String] = [String]()
        var arr2: [String] = [String]()
        var arr3: [String] = [String]()
        var arr4: [String] = [String]()
        var arr5: [String] = [String]()
        var arr6: [String] = [String]()
        var arr7: [String] = [String]()
        var arr8: [String] = [String]()
        var arr9: [String] = [String]()
        var arr10: [String] = [String]()
        var arr11: [String] = [String]()
        var arr12: [String] = [String]()
        var arr13: [String] = [String]()
        var arr14: [String] = [String]()
        var arr15: [String] = [String]()
        var arr16: [String] = [String]()
        var arr17: [String] = [String]()
        var arr18: [String] = [String]()
        var arr19: [String] = [String]()
        var arr20: [String] = [String]()

        
        for key in data {
            key as LinT01TrainScheduleTrainTable
            
            switch ((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).left(2)) {
            case "05":
                arr1.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "06":
                arr2.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "07":
                arr3.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "08":
                arr4.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "09":
                arr5.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "10":
                arr6.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "11":
                arr7.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "12":
                arr8.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "13":
                arr9.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "14":
                arr10.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "15":
                arr11.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "16":
                arr12.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "17":
                arr13.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "18":
                arr14.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "19":
                arr15.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "20":
                arr16.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "21":
                arr17.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "22":
                arr18.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "23":
                arr19.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            case "00":
                arr20.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            default:
                arr20.append((key.item(LINT01_TRAIN_SCHEDULE_DEPA_TIME) as String).right(2))
            }
            
        }
        
        timeArr.addObject(arr1)
        timeArr.addObject(arr2)
        timeArr.addObject(arr3)
        timeArr.addObject(arr4)
        timeArr.addObject(arr5)
        timeArr.addObject(arr6)
        timeArr.addObject(arr7)
        timeArr.addObject(arr8)
        timeArr.addObject(arr9)
        timeArr.addObject(arr10)
        timeArr.addObject(arr11)
        timeArr.addObject(arr12)
        timeArr.addObject(arr13)
        timeArr.addObject(arr14)
        timeArr.addObject(arr15)
        timeArr.addObject(arr16)
        timeArr.addObject(arr17)
        timeArr.addObject(arr18)
        timeArr.addObject(arr19)
        if (arr20.count > 0) {
            timeArr.addObject(arr20)
        }
        
        return timeArr
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 25)
        view.backgroundColor = UIColor(red: 219/255, green: 121/255, blue: 158/255, alpha: 1)
        
        var lblHoure = UILabel()
        lblHoure.frame = CGRectMake(0, 0, 45, 25)
        lblHoure.textAlignment = NSTextAlignment.Center
        lblHoure.text = "STA002_13".localizedString()
        
        var lblMin = UILabel()
        lblMin.frame = CGRectMake(45, 0, 275, 25)
        lblMin.textAlignment = NSTextAlignment.Center
        lblMin.text = "STA002_14".localizedString()
        
        view.addSubview(lblHoure)
        view.addSubview(lblMin)
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (table == tableView) {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as UITableViewCell
            
            var data: NSMutableArray!
            if (weekendSegment.selectedSegmentIndex == 0) {
                data = allTimeArr[0] as NSMutableArray
            } else if (weekendSegment.selectedSegmentIndex == 1) {
                data = allTimeArr[1] as NSMutableArray
            } else {
                data = allTimeArr[2] as NSMutableArray
            }
            
            var cellView = cell.viewWithTag(401) as UIView!
            if (cellView != nil) {
                cellView.removeFromSuperview()
            }
            
            
            var view = UIView()
            view.frame = CGRectMake(0, 0, 320, cell.frame.height)
            view.tag = 401
            
            var time = "\(5+indexPath.row)"
            if (time == "24") {
                time = "00"
            }
            var timeText: UILabel = UILabel()
            timeText.frame = CGRectMake(0, 0, 45, cell.frame.height)
            timeText.text = time
            timeText.textAlignment = NSTextAlignment.Center
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor(red: 254/255, green: 251/255, blue: 251/255, alpha: 1)
                timeText.backgroundColor = UIColor(red: 253/255, green: 205/255, blue: 212/255, alpha: 1)
            } else {
                timeText.backgroundColor = UIColor(red: 243/255, green: 242/255, blue: 242/255, alpha: 1)
            }
            
            
            view.addSubview(timeText)
            
            var arr = data[indexPath.row] as [String]
            
            if (arr.count <= 6) {
                
                for (var i = 0; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            } else if (arr.count > 6 && arr.count <= 12) {
                
                for (var i = 0; i < 6; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 6; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 6)), 45, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            } else if (arr.count > 12 && arr.count <= 18) {
                
                for (var i = 0; i < 6; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 6; i < 12; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 6)), 45, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 12; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 12)), 90, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            } else if (arr.count > 18 && arr.count <= 24) {
                
                for (var i = 0; i < 6; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 6; i < 12; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 6)), 45, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 12; i < 18; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 12)), 90, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 18; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 18)), 135, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            } else if (arr.count > 24 && arr.count <= 30) {
                
                for (var i = 0; i < 6; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 6; i < 12; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 6)), 45, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 12; i < 18; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 12)), 90, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 18; i < 24; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 18)), 135, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 24; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 24)), 180, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            } else if (arr.count > 30 && arr.count <= 36) {
                
                for (var i = 0; i < 6; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 6; i < 12; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 6)), 45, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 12; i < 18; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 12)), 90, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 18; i < 24; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 18)), 135, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 24; i < 30; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 24)), 180, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
                
                for (var i = 24; i < arr.count; i++) {
                    var text: UILabel = UILabel()
                    text.frame = CGRectMake(CGFloat(45 + 45.5*(i - 30)), 225, 45.5, 45)
                    text.text = arr[i]
                    text.textAlignment = NSTextAlignment.Center
                    
                    view.addSubview(text)
                }
            }
            
            cell.addSubview(view)
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (table == tableView) {
            if (weekendSegment.selectedSegmentIndex == 0) {
                return cellHeight(allTimeArr[0] as NSMutableArray, index: indexPath.row)
            } else if (weekendSegment.selectedSegmentIndex == 1) {
                return cellHeight(allTimeArr[1] as NSMutableArray, index: indexPath.row)
            } else {
                return cellHeight(allTimeArr[2] as NSMutableArray, index: indexPath.row)
            }
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (table == tableView) {
            if (weekendSegment.selectedSegmentIndex == 0) {
                return (allTimeArr[0] as NSMutableArray).count
            } else if (weekendSegment.selectedSegmentIndex == 1) {
                return (allTimeArr[1] as NSMutableArray).count
            } else {
                return (allTimeArr[2] as NSMutableArray).count
            }
        } else {
            return 4
        }
        
    }
    
    
    func cellHeight(timeArr: NSMutableArray,index: Int) -> CGFloat {
    
        if (timeArr[index].count <= 6) {
            
            return 45
        } else if (timeArr[index].count > 6 && timeArr[index].count <= 12) {
            return 90
        } else if (timeArr[index].count > 12 && timeArr[index].count <= 18) {
            return 135
        } else if (timeArr[index].count > 18 && timeArr[index].count <= 24) {
            return 180
        } else if (timeArr[index].count > 24 && timeArr[index].count <= 30) {
            return 225
        }  else if (timeArr[index].count > 30 && timeArr[index].count <= 36) {
            return 260
        } else {
            return 45
        }
    }
    

    
}