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
        
//        addData()
        self.title = "出口一览"
        odbExitInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func odbExitInfo() {
        var table = StaT01StationExitTable()
        table.statId = statId
        rows = table.selectWithOrder(STAT01_STAT_EXIT_ID, desc: true)
        
    }

    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if (segment.selectedSegmentIndex == 0) {
//            return arrList.count
//        } else {
//            return 1
//        }
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (segment.selectedSegmentIndex == 0) {
//            return arrList[section][0] as? String
//        } else {
//            return ""
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StationExit", forIndexPath: indexPath) as UITableViewCell
            
        var map = rows[indexPath.row] as StaT01StationExitTable
            cell.textLabel!.text = map.item(STAT01_STAT_EXIT_NAME) as? String
            
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
}
