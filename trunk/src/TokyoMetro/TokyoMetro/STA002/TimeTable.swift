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
    
//    var timeArr: NSMutableArray = NSMutableArray.array()
    
    var statId: String = ""
    var lineId: String = ""
    var allTimeArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "时刻表"
        
        statName.text = statId.station()
        statIcon.image = lineImageNormal(lineId)

        odbTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func weekendSegmentChnaged() {
        table.reloadData()
    }
    
    @IBAction func segmentChnaged() {
        table.reloadData()
    }
    
    func odbTime() {
    
        var table = LinT01TrainScheduleTrainTable()
        table.statId = "2800803"
        table.scheType = "1"
        var timeTypeArr1 = table.selectAll()
        allTimeArr.addObject(initTimeArr(timeTypeArr1))
        
        table.reset()
        table.statId = "2800803"
        table.scheType = "2"
        var timeTypeArr2 = table.selectAll()
        allTimeArr.addObject(initTimeArr(timeTypeArr2))
        
        table.reset()
        table.statId = "2800803"
        table.scheType = "3"
        var timeTypeArr3 = table.selectAll()
        allTimeArr.addObject(initTimeArr(timeTypeArr3))
        
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
        return "时刻(东京时间)"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (weekendSegment.selectedSegmentIndex == 0) {
            return cellHeight(allTimeArr[0] as NSMutableArray, index: indexPath.row)
        } else if (weekendSegment.selectedSegmentIndex == 1) {
            return cellHeight(allTimeArr[1] as NSMutableArray, index: indexPath.row)
        } else {
            return cellHeight(allTimeArr[2] as NSMutableArray, index: indexPath.row)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (weekendSegment.selectedSegmentIndex == 0) {
            return (allTimeArr[0] as NSMutableArray).count
        } else if (weekendSegment.selectedSegmentIndex == 1) {
            return (allTimeArr[1] as NSMutableArray).count
        } else {
            return (allTimeArr[2] as NSMutableArray).count
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

    
}