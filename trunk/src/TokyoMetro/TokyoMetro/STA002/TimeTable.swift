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
    
    var timeArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
    
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["00", "05", "12", "18", "24", "30", "35", "41", "46", "51", "55"])
        timeArr.addObject(["00", "04", "08", "15", "22", "25", "28", "31", "35", "41", "46", "51","55", "58"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
        timeArr.addObject(["18", "32", "40", "49", "57"])
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return "时刻"
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as UITableViewCell
        
        var cellView = cell.viewWithTag(401) as UIView!
        if (cellView != nil) {
            cellView.removeFromSuperview()
        }

        
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, cellHeight(indexPath.row))
        view.tag = 401

        var timeText: UILabel = UILabel()
        timeText.frame = CGRectMake(0, 0, 45, cellHeight(indexPath.row))
        timeText.text = "\(5+indexPath.row)"
        timeText.textAlignment = NSTextAlignment.Center
        timeText.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(timeText)
        
        var arr = timeArr[indexPath.row] as [String]
        
        if (arr.count < 6) {
        
            for (var i = 0; i < arr.count; i++) {
                var text: UILabel = UILabel()
                text.frame = CGRectMake(CGFloat(45 + 45.5*i), 0, 45.5, 45)
                text.text = arr[i]
                text.textAlignment = NSTextAlignment.Center
                
                view.addSubview(text)
            }
        } else if (arr.count > 6 && arr.count < 12) {
        
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
        } else if (arr.count > 12 && arr.count < 18) {
            
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
        }
        
        cell.addSubview(view)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return cellHeight(indexPath.row)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return timeArr.count
    }
    
    
    func cellHeight(index: Int) -> CGFloat {
    
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