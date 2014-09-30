//
//  ExitInfo.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class ExitInfo: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var exitTable: UITableView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var rows: NSArray!
    
    var statId: String = ""
    
    var arrList: NSMutableArray = NSMutableArray.array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
        odbExitInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
    
        arrList.addObject(["1出口",["月星-环球港"]])
        arrList.addObject(["2出口",["月星-环球港"]])
        arrList.addObject(["3出口",["白玉大楼", "白玉新苑"]])
        arrList.addObject(["5出口",["银城大厦", "海棠大厦"]])
        arrList.addObject(["6出口",["月星-环球港"]])
    }
    
    func odbExitInfo() {
        var table = StaT01StationExitTable()
        table.statId = statId
        rows = table.selectWithOrder(STAT01_STAT_EXIT_ID, desc: true)
        
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
    
        if (sender.selectedSegmentIndex == 0) {
        
            exitTable.hidden = false
            mapView.hidden = true
            
            exitTable.reloadData()
        } else {
        
            exitTable.hidden = false
            mapView.hidden = true
            
            exitTable.reloadData()
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (segment.selectedSegmentIndex == 0) {
            return arrList.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (segment.selectedSegmentIndex == 0) {
            return arrList[section][0] as? String
        } else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segment.selectedSegmentIndex == 0) {
            return arrList[section][1].count
        } else {
            return rows.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 0) {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ExitInfoCell", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel!.text = arrList[indexPath.section][1][indexPath.row] as? String
            
            return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StationExit", forIndexPath: indexPath) as UITableViewCell
            
            var map = rows[indexPath.row] as StaT01StationExitTable
            cell.textLabel!.text = map.item(STAT01_STAT_EXIT_NAME) as? String
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
}
