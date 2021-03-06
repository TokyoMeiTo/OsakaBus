//
//  TimeTable.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class TimeTable: UIViewController,UITableViewDelegate,UITableViewDataSource {

/*******************************************************************************
* IBOutlets
*******************************************************************************/
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var weekendSegment: UISegmentedControl!
    @IBOutlet weak var statName: UILabel!
    @IBOutlet weak var statNameKana: UILabel!
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineMenuView: UIView!
    
    
/*******************************************************************************
* Public Properties
*******************************************************************************/
    var statId: String = ""
    var lineId: String = ""
    // 日文名与假名
    var nameKana: String?
    
/*******************************************************************************
* Private Properties
*******************************************************************************/
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
    
    var model: Sta002TimeTableModel?
    
/*******************************************************************************
* Overrides From UIViewController
*******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "STA002_02".localizedString()
        
        model = Sta002TimeTableModel()
        
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
        dirtStationArr = model!.odbDirtStatId(statId)

        setSegment()
        
        odbTime()
        
        allTimeArr = destTimeArr1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
/*******************************************************************************
*    Implements Of UITableViewDelegate
*******************************************************************************/
    
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
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (table == tableView) {
            if (weekendSegment.selectedSegmentIndex == 0) {
                return model!.cellHeight(allTimeArr[0] as NSMutableArray, index: indexPath.row)
            } else if (weekendSegment.selectedSegmentIndex == 1) {
                return model!.cellHeight(allTimeArr[1] as NSMutableArray, index: indexPath.row)
            } else {
                return model!.cellHeight(allTimeArr[2] as NSMutableArray, index: indexPath.row)
            }
        } else {
            return 50
        }
    }

/*******************************************************************************
*    Implements Of UITableViewDelegate
*******************************************************************************/
    
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

/*******************************************************************************
*      IBActions
*******************************************************************************/
    
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
    
/*******************************************************************************
*    Private Methods
*******************************************************************************/
    
//    /*
//    *  查询并获取时刻表数据
//    */
//    func odbDirtStatId() {
//        var table = LinT01TrainScheduleTrainTable()
//        var rows = table.excuteQuery("select *, ROWID from LINT01_TRAIN_SCHEDULE where 1 = 1 and STAT_ID = '\(statId)' and FIRST_TRAIN_FLAG = '1' and SCHE_TYPE = '1'")
//        
//        dirtStationArr = [String]()
//        for key in rows {
//            key as LinT01TrainScheduleTrainTable
//            dirtStationArr.append(key.item(LINT01_TRAIN_SCHEDULE_DIRT_STAT_ID) as String)
//        }
//    }
    
    /*
    *  代码画出地铁线路列表
    */
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
    
    /*
    *  地铁线路选择后重新查找数据
    */
    func lineSelected(sender:UITapGestureRecognizer) {
        selectedIndex = sender.view!.tag - 300
        var key = lineArr[selectedIndex] as MstT02StationTable
        lineId = key.item(MSTT02_LINE_ID) as String
        statId = key.item(MSTT02_STAT_ID) as String
        // 替换图标
        statIcon.image = lineId.getLineImage()
        dirtStationArr = model!.odbDirtStatId(statId)
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
    
    /*
    *  重新设置segment
    */
    func setSegment() {
        if (dirtStationArr.count > 0) {
            segment.removeAllSegments()
            for (var i = 0; i < dirtStationArr.count; i++) {
                segment.insertSegmentWithTitle(dirtStationArr[i].station() + "方向", atIndex: i, animated: false)

            }
            segment.selectedSegmentIndex = 0
        }
        
    }
    
    /*
    *  查询时刻表数据（平日、周末、假日数据）
    */
    func odbTime() {
        
        var index = segment.selectedSegmentIndex
        // 已有数据，不再进行查询
        if (index == 0) {
            if (destTimeArr1.count == 3) {
                return
            }
        } else if (index == 1) {
            if (destTimeArr1.count == 3 && destTimeArr2.count == 3) {
                return
            }
        }  else if (index == 2) {
            if (destTimeArr1.count == 3 && destTimeArr2.count == 3 && destTimeArr3.count == 3) {
                return
            }
        }
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
            destTimeArr1.addObject(model!.initTimeArr(timeTypeArr1))
            destTimeArr1.addObject(model!.initTimeArr(timeTypeArr2))
            destTimeArr1.addObject(model!.initTimeArr(timeTypeArr3))
        } else if (index == 1) {
            destTimeArr2.addObject(model!.initTimeArr(timeTypeArr1))
            destTimeArr2.addObject(model!.initTimeArr(timeTypeArr2))
            destTimeArr2.addObject(model!.initTimeArr(timeTypeArr3))
        } else {
            destTimeArr3.addObject(model!.initTimeArr(timeTypeArr1))
            destTimeArr3.addObject(model!.initTimeArr(timeTypeArr2))
            destTimeArr3.addObject(model!.initTimeArr(timeTypeArr3))
        }
        
    }
    
}