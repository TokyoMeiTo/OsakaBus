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
    
    
    var historyArr = [String]()
    
    var stationArr: NSMutableArray = NSMutableArray.array()
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()
    // 站点日文名与假名
    var statJPNameArr: NSMutableArray = NSMutableArray.array()
    // 收藏的路径
    var ruteArr: NSMutableArray = NSMutableArray.array()
    
    var detailArr: NSMutableArray = NSMutableArray.array()
    
    var ruteRowIdArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        odbRoute()
        odbStation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func odbStation(){
        var table = UsrT03FavoriteTable()
        var stationTable = MstT02StationTable()
        
        table.favoType = "01"
        var rows: NSArray = table.selectAll()
        
        var allRows: NSArray = stationTable.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            
            key as UsrT03FavoriteTable
            stationArr.addObject(key)
            
            // 取各站的lineId
            var statGroupId = key.item(USRT03_STAT_ID) as String
            var lineArr = [String]()
            var statJPName = ""
            var array: [String] = [String]()
            for (var i = 0; i < allRows.count; i++) {
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId || (map.item(MSTT02_STAT_ID) as String) == statGroupId) {
                    
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                    if (statJPName == "") {
                        statJPName = (map.item(MSTT02_STAT_NAME) as String) + "（" + (map.item(MSTT02_STAT_NAME_KANA) as String) + "）"
                        array.append(map.item(MSTT02_STAT_NAME) as String)
                        array.append(map.item(MSTT02_STAT_NAME_KANA) as String)
                    }
                }
            }
            
            detailArr.addObject(array)
            statJPNameArr.addObject(statJPName)
            changeLineArr.addObject(lineArr)
        }
        
    }
    
    
    func odbRoute() {
        var table = UsrT03FavoriteTable()
        var routeTable = LinT04RouteTable()
        
        table.favoType = "04"
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            key as UsrT03FavoriteTable
            
            var ruteId = key.item(USRT03_RUTE_ID) as String
            routeTable.ruteId = ruteId
            var ruteRows = routeTable.selectAll()
            if (ruteRows.count > 0) {
                ruteArr.addObject(ruteRows[0])
                ruteRowIdArr.addObject(key.rowid)
            }
        }

    }
    
    
    func removeSubway(index: Int) -> Bool {
        var table = UsrT03FavoriteTable()
        var map: UsrT03FavoriteTable = stationArr[index] as UsrT03FavoriteTable
        table.rowid = map.rowid
        
        return table.delete()
    }
    
    func removeRute(index: Int) -> Bool {
        var table = UsrT03FavoriteTable()
//        var map: UsrT03FavoriteTable = ruteArr[index] as UsrT03FavoriteTable
        table.rowid = ruteRowIdArr[index] as String
        
        return table.delete()
    }
    
    
    @IBAction func segmentChangedLinster(sender: UISegmentedControl) {
    
        table.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (segment.selectedSegmentIndex == 0) {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: UsrT03FavoriteTable = stationArr[indexPath.row] as UsrT03FavoriteTable
            detail.cellJPName = detailArr[indexPath.row][0] as String
            detail.cellJPNameKana = detailArr[indexPath.row][1] as String
            detail.stat_id = map.item(USRT03_STAT_ID) as String
            
            self.navigationController?.pushViewController(detail, animated: true)
        } else if (segment.selectedSegmentIndex == 1) {
            var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
            
            var key = ruteArr[indexPath.row] as LinT04RouteTable
            routeSearch.startStationText = key.item(LINT04_ROUTE_START_STAT_ID) as String
            routeSearch.endStationText = key.item(LINT04_ROUTE_TERM_STAT_ID) as String
            self.navigationController?.pushViewController(routeSearch, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segment.selectedSegmentIndex == 0) {
            return stationArr.count
        } else if (segment.selectedSegmentIndex == 1) {
            return ruteArr.count
        } else {
        
            return historyArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 0) {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CollectCell", forIndexPath: indexPath) as UITableViewCell
            
            var map: UsrT03FavoriteTable = stationArr[indexPath.row] as UsrT03FavoriteTable
            
            var textName = cell.viewWithTag(201) as UILabel
            textName.text = (map.item(USRT03_STAT_ID) as String).station()
            
            var textJPName = cell.viewWithTag(203) as UILabel
            textJPName.text = statJPNameArr[indexPath.row] as? String
            
            var view = cell.viewWithTag(202) as UIView!
            
            if (view != nil) {
                view.removeFromSuperview()
            }
            
            var lineView = UIView()
            lineView.frame = CGRectMake(185, 5, 105, 45)
            lineView.tag = 202
            
            var arrStation: [String] = changeLineArr[indexPath.row] as [String]

            for (var i = 0; i < arrStation.count; i++) {
                 var line: UIImageView = UIImageView()
                 line.frame = CGRectMake(CGFloat(105 - (i+1)*18 - i * 4), 14, 18, 18)
                 line.image = arrStation[i].getLineMiniImage()
                    
                 lineView.addSubview(line)
            }
            
            cell.addSubview(lineView)
            
            return cell
        } else if (segment.selectedSegmentIndex == 1) {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath) as UITableViewCell
            
            var key = ruteArr[indexPath.row] as LinT04RouteTable
            
            var openStation =  cell.viewWithTag(301) as UILabel
            var closeStation =  cell.viewWithTag(302) as UILabel
            
            openStation.text = "起点：" + (key.item(LINT04_ROUTE_START_STAT_ID) as String).station()
            
            closeStation.text = "终点：" + (key.item(LINT04_ROUTE_TERM_STAT_ID) as String).station()
            
            return cell
        } else {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as UITableViewCell
            
            var historyStation =  cell.viewWithTag(401) as UILabel
            
            historyStation.text = historyArr[indexPath.row]
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (segment.selectedSegmentIndex == 0) {
            return 55
        } else if (segment.selectedSegmentIndex == 1) {
            return 55
        } else {
            return 43
        }
        
    }
    
   override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
   func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
         return UITableViewCellEditingStyle.Delete
    }
    
        func tableView(tableView:UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath!){
    
            if(editingStyle == UITableViewCellEditingStyle.Delete){
                
                if (segment.selectedSegmentIndex == 0) {
                    
                    if (removeSubway(indexPath.row)) {
                        stationArr.removeObjectAtIndex(indexPath.row)
                        table.reloadData()
                    }
                } else if (segment.selectedSegmentIndex == 1) {
                    if (removeRute(indexPath.row)) {
                        ruteArr.removeObjectAtIndex(indexPath.row)
                        ruteRowIdArr.removeObjectAtIndex(indexPath.row)
                        table.reloadData()
                    }
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }

}