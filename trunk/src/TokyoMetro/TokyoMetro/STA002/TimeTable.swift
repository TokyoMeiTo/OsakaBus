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
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineMenuView: UIView!
    
    
    var statId: String = ""
    var lineId: String = ""
    
    var selectedIndex = 0
    // tableview的数据源
    var allTimeArr: NSMutableArray = NSMutableArray.array()
    // 方向站segment选择第一个时的数据源
    var destTimeArr1: NSMutableArray = NSMutableArray.array()
    // 方向站segment选择第二个时的数据源
    var destTimeArr2: NSMutableArray = NSMutableArray.array()
    
    var lineArr: NSArray = NSArray.array()
    
    var endStationArr: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "时刻表"
        
        lineMenuView.hidden = true
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "hideLine")
        lineMenuView.addGestureRecognizer(tapGesture)
        
        statName.text = statId.station()
        if (lineArr.count > 0) {
            lineId = (lineArr[0] as MstT02StationTable).item(MSTT02_LINE_ID) as String
            statIcon.image = lineImageNormal(lineId)
        }
        

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
        } else {
            allTimeArr = destTimeArr2
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
    
    func addLine() {
        
        for (var i = 0; i < lineArr.count; i++) {
            var key = lineArr[i] as MstT02StationTable
            var view = UIView()
            view.frame = CGRectMake(0, CGFloat(i * 50), 180, 50)
            var lineImage = UIImageView()
            lineImage.frame = CGRectMake(8, 3, 44, 44)
            lineImage.image = lineImageNormal(key.item(MSTT02_LINE_ID) as String)
            view.addSubview(lineImage)
            
            var lineName = UILabel()
            lineName.frame = CGRectMake(58, 0, 122, 50)
            lineName.text = (key.item(MSTT02_LINE_ID)  as String).line()
            lineName.textColor = UIColor.whiteColor()
            view.addSubview(lineName)
            
            view.tag = 300 + i
            var tapGesture = UITapGestureRecognizer(target: self, action: "lineSelected:")
            view.addGestureRecognizer(tapGesture)
            
            lineView.addSubview(view)
        }
        
        lineView.frame = CGRectMake(70, 200, 180, CGFloat(lineArr.count * 50))
    }
    
    func lineSelected(sender:UITapGestureRecognizer) {
        selectedIndex = sender.view!.tag - 300
        var key = lineArr[selectedIndex] as MstT02StationTable
        lineId = key.item(MSTT02_LINE_ID) as String
        setSegment()
        destTimeArr1.removeAllObjects()
        destTimeArr2.removeAllObjects()
        allTimeArr.removeAllObjects()
        odbTime()
        table.reloadData()
        
        lineMenuView.hidden = true
    }
    
    func setSegment() {
        segment.setTitle(getEndStation(0 + 2 * selectedIndex), forSegmentAtIndex: 0)
        segment.setTitle(getEndStation(1 + 2 * selectedIndex), forSegmentAtIndex: 1)
    }
    
    func getEndStation(index: Int) -> String{
        var string = ""
        if (endStationArr.count == 0){
            return string
        }
        
        if (index < endStationArr.count) {
            string = endStationArr[index]
        } else {
            string = endStationArr[endStationArr.count - 1]
        }
        
        return string
    }
    
    
    func odbTime() {
        
        if (destTimeArr1.count == 3 && destTimeArr2.count == 3) {
            return
        }
        var index = segment.selectedSegmentIndex
        var key = lineArr[selectedIndex] as MstT02StationTable
        var statId = key.item(MSTT02_STAT_ID) as String
        
        var table = LinT01TrainScheduleTrainTable()
        table.reset()
        table.statId = statId
        table.dirtStatId = getDirtStatId(lineId, type: index)
        table.scheType = "1"
        var timeTypeArr1 = table.selectAll()
        
        
        table.reset()
        table.statId = statId
        table.dirtStatId = getDirtStatId(lineId, type: index)
        table.scheType = "2"
        var timeTypeArr2 = table.selectAll()
        
        
        table.reset()
        table.statId = statId
        table.dirtStatId = getDirtStatId(lineId, type: index)
        table.scheType = "3"
        var timeTypeArr3 = table.selectAll()
        
        if (index == 0) {
            destTimeArr1.addObject(initTimeArr(timeTypeArr1))
            destTimeArr1.addObject(initTimeArr(timeTypeArr2))
            destTimeArr1.addObject(initTimeArr(timeTypeArr3))
        } else {
            destTimeArr2.addObject(initTimeArr(timeTypeArr1))
            destTimeArr2.addObject(initTimeArr(timeTypeArr2))
            destTimeArr2.addObject(initTimeArr(timeTypeArr3))
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
        timeArr.addObject(arr20)

        return timeArr
    }
    

    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (table == tableView) {
            return "时刻(东京时间)"
        } else {
            return nil
        }
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
            
            var timeText: UILabel = UILabel()
            timeText.frame = CGRectMake(0, 0, 45, cell.frame.height)
            timeText.text = "\(5+indexPath.row)"
            timeText.textAlignment = NSTextAlignment.Center
            timeText.backgroundColor = UIColor.lightGrayColor()
            
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
    
    
    func lineImageNormal(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_g.png")
        switch (lineNum) {
            
        case "28001":
            image = UIImage(named: "tablecell_lineicon_g.png")
        case "28002":
            image = UIImage(named: "tablecell_lineicon_m.png")
        case "28003":
            image = UIImage(named: "tablecell_lineicon_h.png")
        case "28004":
            image = UIImage(named: "tablecell_lineicon_t.png")
        case "28005":
            image = UIImage(named: "tablecell_lineicon_c.png")
        case "28006":
            image = UIImage(named: "tablecell_lineicon_y.png")
        case "28008":
            image = UIImage(named: "tablecell_lineicon_z.png")
        case "28009":
            image = UIImage(named: "tablecell_lineicon_n.png")
        case "28010":
            image = UIImage(named: "tablecell_lineicon_f.png")
        default:
            image = UIImage(named: "tablecell_lineicon_g.png")
        }
        
        return image
    }

    
    func getDirtStatId(lineId: String, type: Int) -> String{
        var dirtStatId = ""
        switch (lineId) {
        case "28001":
            if (type == 0) {
                dirtStatId = "2800119"
            } else {
                dirtStatId = "2800101"
            }
        case "28003":
            if (type == 0) {
                dirtStatId = "2800321"
            } else {
                dirtStatId = "2800301"
            }
        case "28004":
            if (type == 0) {
                dirtStatId = "2800423"
            } else {
                dirtStatId = "2800401"
            }
        case "28005":
            if (type == 0) {
                dirtStatId = "2800520"
            } else {
                dirtStatId = "2800501"
            }
        case "28006":
            if (type == 0) {
                dirtStatId = "2800624"
            } else {
                dirtStatId = "2800601"
            }
        case "28008":
            if (type == 0) {
                dirtStatId = "2800814"
            } else {
                dirtStatId = "2800801"
            }
        case "28009":
            if (type == 0) {
                dirtStatId = "2800919"
            } else {
                dirtStatId = "2800901"
            }
        case "28010":
            if (type == 0) {
                dirtStatId = "2801016"
            } else {
                dirtStatId = "2801001"
            }
        case "28002":
            if (type == 0) {
                dirtStatId = "2800228"
            } else if (type == 1)  {
                dirtStatId = "2800201"
            } else {
                
            }
        default:
            dirtStatId = "2800119"
        }
        
        return dirtStatId
    }
    
    func getAllDirtStatId(lineId: String, statId: String) -> [String]{
        var dirtStatIdArr = [String]()
        switch (lineId) {
        case "28001":
            if (statId == "2800119") {
                dirtStatIdArr = ["2800101"]
            } else if (statId == "2800101") {
                dirtStatIdArr = ["2800119"]
            } else {
                dirtStatIdArr = ["2800101","2800119"]
            }
        case "28003":
            if (statId == "2800321") {
                dirtStatIdArr = ["2800301"]
            } else if (statId == "2800301") {
                dirtStatIdArr = ["2800321"]
            } else {
                dirtStatIdArr = ["2800301","2800321"]
            }
        case "28004":
            if (statId == "2800423") {
                dirtStatIdArr = ["2800401"]
            } else if (statId == "2800401") {
                dirtStatIdArr = ["2800423"]
            } else {
                dirtStatIdArr = ["2800401","2800423"]
            }
        case "28005":
            if (statId == "2800520") {
                dirtStatIdArr = ["2800501"]
            } else if (statId == "2800501") {
                dirtStatIdArr = ["2800520"]
            } else {
                dirtStatIdArr = ["2800501","2800520"]
            }
        case "28006":
            if (statId == "2800624") {
                dirtStatIdArr = ["2800601"]
            } else if (statId == "2800601") {
                dirtStatIdArr = ["2800624"]
            } else {
                dirtStatIdArr = ["2800601","2800624"]
            }
        case "28008":
            if (statId == "2800814") {
                dirtStatIdArr = ["2800801"]
            } else if (statId == "2800801") {
                dirtStatIdArr = ["2800814"]
            } else {
                dirtStatIdArr = ["2800801","2800814"]
            }
        case "28009":
            if (statId == "2800919") {
                dirtStatIdArr = ["2800901"]
            } else if (statId == "2800901") {
                dirtStatIdArr = ["2800919"]
            } else {
                dirtStatIdArr = ["2800901","2800919"]
            }
        case "28010":
            if (statId == "2801016") {
                dirtStatIdArr = ["2801001"]
            } else if (statId == "2801001") {
                dirtStatIdArr = ["2801016"]
            } else {
                dirtStatIdArr = ["2801001","2801016"]
            }
        case "28002":
            if (statId == "2800228") {
                dirtStatIdArr = ["2800201"]
            } else if (statId == "2800201") {
                dirtStatIdArr = ["2800228"]
            } else if (statId == "2800201") {
                dirtStatIdArr = ["2800228"]
            } else {
                dirtStatIdArr = ["2801001","2801016"]
            }
//            if (type == 0) {
//                dirtStatId = "2800228"
//            } else if (type == 1)  {
//                dirtStatId = "2800201"
//            } else {
//                
//            }
        default:
            dirtStatIdArr = ["2800201"]
        }
        
        return dirtStatIdArr
    }

    
}