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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        odbStation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            stationArr.addObject(key)
            
        }
        
    }
    
    func searchStation(name: String) {
    
        var table = MstT02StationTable()
        
        table.statName = name
        var rows: NSArray = table.selectLike()
        
        stationArr.removeAllObjects()
        for key in rows {
            
            stationArr.addObject(key)
            
        }
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchStationCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
        
        var textName = cell.viewWithTag(201) as UILabel
        textName.text = map.item(MSTT02_STAT_NAME) as String
        
        var view = cell.viewWithTag(202) as UIView!
        
        var arrStation = ["M", "C", "Z"]
        
        for (var i = 0; i < arrStation.count; i++) {
            var line: UIImageView = UIImageView()
            line.frame = CGRectMake(CGFloat(110 - (i+1)*18 - i * 5), 12.5, 18, 18)
            line.image = lineImage(arrStation[i])
            
            
            view.addSubview(line)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 43
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return stationArr.count
    }
    
    func tableView(tableView: UITableView!, sectionForSectionIndexTitle title: String!, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return "\(stationArr.count)条检索结果"
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar!) {
        println("关闭")
        searchBar.resignFirstResponder()
//        self.navigationController.popViewControllerAnimated(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        searchBar.resignFirstResponder()
        searchStation(searchBar.text)
        table.reloadData()
        println("点击了search按钮")
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar!) -> Bool {
        println("开始输入")
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar!) -> Bool {
        println("输入结束")
        return true
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
