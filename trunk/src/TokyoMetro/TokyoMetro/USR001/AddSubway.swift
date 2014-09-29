//
//  AddSubway.swift
//  TableViewTest
//
//  Created by caowj on 14-9-9.
//  Copyright (c) 2014年 rhinoIO. All rights reserved.
//

import UIKit

class AddSubway: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var segment: UISegmentedControl!
    
    
    var lineArr = [[String]()]
    
    var historyArr = [String]()
    
    var stationArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lineArr = [["上海火车站","真北路"], ["上海马戏城","宜山路"],["耀华路","江苏路"]]
        historyArr = ["上野", "浅草桥", "大手町"]

        odbStation()
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            stationArr.addObject(key)
            
        }
        
    }
    
    
    @IBAction func segmentChangedLinster(sender: UISegmentedControl) {
    
        table.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segment.selectedSegmentIndex == 0) {
            
            return lineArr.count
        } else if (segment.selectedSegmentIndex == 1) {
            return stationArr.count
        } else {
        
            return historyArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 1) {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CollectCell", forIndexPath: indexPath) as UITableViewCell
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            
            var textName = cell.viewWithTag(201) as UILabel
            textName.text = map.item(MSTT02_STAT_NAME) as? String
            
            var view = cell.viewWithTag(202) as UIView!
            
//            var string: String = taskMgr.tasks[indexPath.row].description
//            var arrStation = string.componentsSeparatedByString(",")
                        
            var arrStation = ["M", "C", "Z"]
            
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(110 - (i+1)*18 - i * 5), 14, 18, 18)
                line.image = lineImage(arrStation[i])
                
                
                view.addSubview(line)
            }
            
            return cell
        } else if (segment.selectedSegmentIndex == 0) {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath) as UITableViewCell
            
            var openStation =  cell.viewWithTag(301) as UILabel
            var closeStation =  cell.viewWithTag(302) as UILabel
            
            openStation.text = "起点：" + lineArr[indexPath.row][0]
            
            closeStation.text = "终点：" + lineArr[indexPath.row][1]
            
            return cell
        } else {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as UITableViewCell
            
            var historyStation =  cell.viewWithTag(401) as UILabel
            
            historyStation.text = historyArr[indexPath.row]
            
            return cell
        }


    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (segment.selectedSegmentIndex == 1) {
            return 43
        } else if (segment.selectedSegmentIndex == 0) {
        
            return 50
        } else {
            return 43
        }
        
    }
    
   override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
   func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
//       if (table.editing) {
            return UITableViewCellEditingStyle.Delete
//        } else {
//            return UITableViewCellEditingStyle.None
//        }
    }
    
        func tableView(tableView:UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath!){
    
            if(editingStyle == UITableViewCellEditingStyle.Delete){
                
                if (segment.selectedSegmentIndex == 1) {
                    stationArr.removeObjectAtIndex(indexPath.row)
                    table.reloadData()
                } else if (segment.selectedSegmentIndex == 0) {
                    
                    lineArr.removeAtIndex(indexPath.row)
                    table.reloadData()
                } else {
                
                    historyArr.removeAtIndex(indexPath.row)
                    table.reloadData()
                }
                
    
            }
    
        }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func lineImage(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_mini_c.png")
        switch (lineNum) {
            
        case "C":
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
        case "F":
            image = UIImage(named: "tablecell_lineicon_mini_f.png")
        case "G":
            image = UIImage(named: "tablecell_lineicon_mini_g.png")
        case "H":
            image = UIImage(named: "tablecell_lineicon_mini_h.png")
        case "M":
            image = UIImage(named: "tablecell_lineicon_mini_m.png")
        case "N":
            image = UIImage(named: "tablecell_lineicon_mini_n.png")
        case "T":
            image = UIImage(named: "tablecell_lineicon_mini_t.png")
        case "Y":
            image = UIImage(named: "tablecell_lineicon_mini_y.png")
        case "Z":
            image = UIImage(named: "tablecell_lineicon_mini_z.png")
            
        default:
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
            
        }
        
        return image
    }

}