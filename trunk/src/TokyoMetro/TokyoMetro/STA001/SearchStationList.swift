//
//  SearchStationList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class SearchStationList: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var table: UITableView!
    
    var stationArr: NSMutableArray = NSMutableArray.array()
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()
    // 区分前一画面参数
    var classType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        odbStation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        
        var rows: NSArray = table.excuteQuery("select *,count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select * from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            
            stationArr.addObject(key)
            
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            var lineArr = [String]()
            for (var i = 0; i < allRows.count; i++) {
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId) {
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                }
            }

            changeLineArr.addObject(lineArr)
        }
        
    }
    
    func searchStation(name: String) {
        
        if(name.isEmpty){
            return;
        }
        
        var table = MstT02StationTable()
        
        var rows: NSArray = table.excuteQuery("select *, ROWID, count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' and (STAT_NAME_EXT1 like '%\(name)%' or STAT_NAME_EXT2 like '%\(name)%' or STAT_NAME_EXT3 like '%\(name)%' or STAT_NAME_EXT4 like '%\(name)%' or STAT_NAME_EXT5 like '%\(name)%' or STAT_NAME like '%\(name)%' or STAT_NAME_KANA or STAT_NAME_ROME like '%\(name)%' like '%\(name)%') group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
 
        stationArr.removeAllObjects()
        for key in rows {
            
            stationArr.addObject(key)
            
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            var lineArr = [String]()
            for (var i = 0; i < allRows.count; i++) {
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId) {
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                }
            }
            
            changeLineArr.addObject(lineArr)
        }
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchStationCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
        
        var textName = cell.viewWithTag(201) as UILabel
        textName.text = map.item(MSTT02_STAT_NAME_EXT1) as? String
        
        var textJPName = cell.viewWithTag(203) as UILabel
        textJPName.text = (map.item(MSTT02_STAT_NAME) as String) + "（" + (map.item(MSTT02_STAT_NAME_KANA) as String) + "）"
        
        var view = cell.viewWithTag(202) as UIView!
        
        if (view != nil) {
            view.removeFromSuperview()
        }
        
        var lineView = UIView()
        lineView.frame = CGRectMake(225, 5, 80, 45)
        lineView.tag = 202
        
        var arrStation: [String] = changeLineArr[indexPath.row] as [String]
        if (arrStation != ["self"]) {
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(80 - (i+1)*18 - i * 4), 13, 18, 18)
                line.image = arrStation[i].getLineMiniImage()
                
                lineView.addSubview(line)
            }
        }
        
        cell.addSubview(lineView)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArr.count
    }
    

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(stationArr.count)条检索结果"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (classType == "routeSearch") {
            var routeSearch: RouteSearch = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as RouteSearch
            
            self.navigationController?.popToViewController(routeSearch, animated: true)
        } else if (classType == "remindDetailController") {
            var remindDetailController: RemindDetailController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as RemindDetailController
            
            self.navigationController?.popToViewController(remindDetailController, animated: true)
        } else {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            detail.cellJPName = map.item(MSTT02_STAT_NAME) as String
            detail.cellJPNameKana = map.item(MSTT02_STAT_NAME_KANA) as String
            detail.stat_id = map.item(MSTT02_STAT_ID) as String
            detail.statMetroId = map.item(MSTT02_STAT_METRO_ID) as String
            
            
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchStation(searchBar.text)
        table.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchStation(searchBar.text)
        table.reloadData()
    }
    
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text.indexOf("%") > 0 || text.indexOf("?") > 0){
//            return false;
//        }else{
            searchStation(searchBar.text)
            table.reloadData()
            return true
//        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        println("开始输入")
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        println("输入结束")
        return true
    }

    
}
