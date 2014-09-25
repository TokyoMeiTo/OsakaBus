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
    
    var arrList: NSMutableArray = NSMutableArray.array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
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
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
    
        if (sender.selectedSegmentIndex == 0) {
        
            exitTable.hidden = false
            mapView.hidden = true
        } else {
        
            exitTable.hidden = true
            mapView.hidden = false
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrList[section][0] as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList[section][1].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ExitInfoCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = arrList[indexPath.section][1][indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
}
