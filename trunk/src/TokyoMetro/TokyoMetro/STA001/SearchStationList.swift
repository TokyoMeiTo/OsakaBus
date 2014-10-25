//
//  SearchStationList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class SearchStationList: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    @IBOutlet weak var table: UITableView!
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    // 区分前一画面参数
    var classType = ""
    
    var focusNumber = ""
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    var routeSearch:RouteSearch?
    
    var stationArr: NSMutableArray = NSMutableArray.array()
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()

    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        odbStation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
 
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(stationArr.count)" + "STA001_01".localizedString()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (classType == "routeSearch") {
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            if (focusNumber == "1") {
                if(routeSearch != nil && map.item(MSTT02_STAT_GROUP_ID) != nil){
                    routeSearch!.startStationText = map.item(MSTT02_STAT_GROUP_ID) as String
                }
            } else {
                if(routeSearch != nil && map.item(MSTT02_STAT_GROUP_ID) != nil){
                    routeSearch!.endStationText = map.item(MSTT02_STAT_GROUP_ID) as String
                }
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)

        } else if (classType == "landMarkSearchController") {
            var landMarkSearchController: LandMarkSearchController? = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? LandMarkSearchController
            var mstT02StationTable: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            landMarkSearchController!.landMarkStatId = "\(mstT02StationTable.item(MSTT02_STAT_GROUP_ID))"
            self.navigationController?.popToViewController(landMarkSearchController!, animated: true)
        } else {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            detail.cellJPName = map.item(MSTT02_STAT_NAME) as String
            detail.cellJPNameKana = map.item(MSTT02_STAT_NAME_KANA) as String
            detail.stat_id = map.item(MSTT02_STAT_ID) as String
            detail.statMetroId = map.item(MSTT02_STAT_METRO_ID) as String
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController?.pushViewController(detail, animated: true)
        }
        
    }

    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArr.count
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
        lineView.frame = CGRectMake(220, 5, 70, 45)
        lineView.tag = 202
        
        var arrStation: [String] = changeLineArr[indexPath.row] as [String]
        if (arrStation != ["self"]) {
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(70 - (i+1)*18 - i * 4), 13, 18, 18)
                line.image = arrStation[i].getLineMiniImage()
                
                lineView.addSubview(line)
            }
        }
        
        cell.addSubview(lineView)
        return cell
    }
    
    /*******************************************************************************
    *      Implements Of UISearchBarDelegate
    *******************************************************************************/
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (classType == "routeSearch") {
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
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
        var proposedNewLength = searchBar.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - range.length + text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if (proposedNewLength > 20) {
            return false
        }
        
        searchStation(searchBar.text)
        table.reloadData()
        return true
        //        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    func odbStation(){
        var table = MstT02StationTable()
        
        var rows: NSArray = table.excuteQuery("select *, ROWID, count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            if(key.item(MSTT02_STAT_GROUP_ID) == nil){
                continue
            }
            
            stationArr.addObject(key)
            
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            var lineArr = Array<String>()
            for (var i = 0; i < allRows.count; i++) {
                
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                
                if(map.item(MSTT02_STAT_GROUP_ID) == nil || map.item(MSTT02_LINE_ID) == nil){
                    continue
                }
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId) {
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                }
            }

            changeLineArr.addObject(lineArr)
        }
        
    }
    
    func searchStation(name: String) {
        
        stationArr.removeAllObjects()
        changeLineArr.removeAllObjects()
        if(name.isEmpty){
            odbStation()
            return
        }
        
        var table = MstT02StationTable()
        
        var rows: NSArray = table.excuteQuery("select *, ROWID, count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' and (STAT_NAME_EXT1 like '\(name)%' or STAT_NAME_EXT2 like '\(name)%' or STAT_NAME_EXT3 like '\(name)%' or STAT_NAME_EXT4 like '\(name)%' or STAT_NAME_EXT5 like '\(name)%' or STAT_NAME like '\(name)%' or STAT_NAME_KANA like '\(name)%' or STAT_NAME_ROME like '\(name)%' like '\(name)%') group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            
            if ((key.item(MSTT02_STAT_GROUP_ID) as? String) != nil) {
                stationArr.addObject(key)
                
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var lineArr = [String]()
                for (var i = 0; i < allRows.count; i++) {
                    var map: MstT02StationTable = allRows[i] as MstT02StationTable
                    
                    if ((map.item(MSTT02_STAT_GROUP_ID) as? String) == statGroupId) {
                        lineArr.append(map.item(MSTT02_LINE_ID) as String)
                    }
                }
                
                changeLineArr.addObject(lineArr)
            }
        }
    }

    
}
