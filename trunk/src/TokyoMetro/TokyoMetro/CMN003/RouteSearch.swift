//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   //  var items : NSArray!
    var allOfStationItems : NSMutableArray = NSMutableArray.array()
    var allOfStationItemsJP : NSMutableArray = NSMutableArray.array()
    var allOflineImageItems : NSMutableArray = NSMutableArray.array()
    var localItems : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var btnExchange: UIButton!
    @IBOutlet weak var stationStart: UITextField!
    @IBOutlet weak var stationEnd: UITextField!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var btnSearchRoute: UIButton!
    
    var focusNumber : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var strStart:NSString = "起点"
        var strEnd:NSString = "终点"
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        stationStart.becomeFirstResponder()
        
        loadStation()
        
       
        btnExchange.addTarget(self, action: "exchangeAction", forControlEvents: UIControlEvents.TouchUpInside)

        // 点击textFile后记住焦点的位置
        stationStart.addTarget(self, action: "foucsChangeTo1", forControlEvents: UIControlEvents.AllEditingEvents)
        stationEnd.addTarget(self, action: "foucsChangeTo2", forControlEvents: UIControlEvents.AllEditingEvents)
        
        btnSearchRoute.addTarget(self, action: "searchWayAction", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.allOfStationItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
        
        var celllblSatationName : UILabel = cell.viewWithTag(101) as UILabel!
        var celllblSatationNameJP : UILabel = cell.viewWithTag(102) as UILabel!
        
        celllblSatationName.text  = self.allOfStationItems.objectAtIndex(indexPath.row) as? String
        celllblSatationNameJP.text  = self.allOfStationItemsJP.objectAtIndex(indexPath.row) as? String
        
        var lineImageItemsRow = self.allOflineImageItems.objectAtIndex(indexPath.row) as NSArray
        for (var i = 0; i < lineImageItemsRow.count; i++) {
            var map = lineImageItemsRow[i] as MstT02StationTable
            var lineIcon: UIImageView = UIImageView()
            lineIcon.frame = CGRectMake(CGFloat(160 + i * 25), 5, 30, 30)
            lineIcon.image = lineImageNormal(map.item(MSTT02_LINE_ID) as String)
            cell.addSubview(lineIcon)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        var celllblStaionName : UILabel = cell.viewWithTag(101) as UILabel
        var stationName : String? =  celllblStaionName.text
        
      if focusNumber == "1" {
        
            if !(stationName == self.stationEnd.text)  {
                self.stationStart.text = stationName
            } else {
                 errAlertView("错误信息", errMgs: "站点名相同", errBtnTitle: "确认")
            }
            
        } else if focusNumber == "2" {
            
            if !(stationName == self.stationStart.text) {
                self.stationEnd.text = stationName
            } else {
                errAlertView("错误信息", errMgs: "站点名相同", errBtnTitle: "确认")
            }
            
        }
        hideKeyBoard()

    }
    
    // 起点和终点交换
    func exchangeAction(){
        
        var tempName:NSString = self.stationStart.text
        self.stationStart.text = self.stationEnd.text
        self.stationEnd.text = tempName
        
        hideKeyBoard()
        
    }
    
    
    func searchWayAction(){
        
       // 判断合法性
        var nilResult:Bool
        if ( self.stationStart.text == "" || self.stationEnd.text == "" || self.stationStart.text == self.stationEnd.text) {
            errAlertView("提示信息", errMgs: "请重新输入车站名", errBtnTitle: "确认")
        } else {
            var routeResult : RouteSearchResult = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearchResult") as RouteSearchResult
            routeResult.routeStart = self.stationStart.text
            routeResult.routeEnd = self.stationEnd.text
            self.navigationController?.pushViewController(routeResult, animated:true)
        }
        
        tbView.reloadData()
    }
    
    func foucsChangeTo1 () {
        self.focusNumber = "1"
        loadStation()
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"

        loadStation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 弹出错误提示框
    func errAlertView(errTitle:String, errMgs:String, errBtnTitle:String) {
        var eAv:UIAlertView = UIAlertView()
        eAv.title = errTitle
        eAv.message = errMgs
        eAv.addButtonWithTitle(errBtnTitle)
        eAv.show()
    }
    
    // 失去焦点，隐藏键盘
    func hideKeyBoard() {
        stationEnd.resignFirstResponder()
        stationStart.resignFirstResponder()
    }
    
    
    // 获取所有站的站名和图标
    func loadStation() {
        
        allOfStationItems.removeAllObjects()
        var mst02table = MstT02StationTable()
        if self.focusNumber == "1" {
            mst02table.statName = stationStart.text
        } else {
            mst02table.statName = stationEnd.text
        }
        
        var mst02Rows:NSArray = mst02table.selectLike()
        
        
        for key in mst02Rows {
            key as MstT02StationTable
            var stationNameJP:AnyObject = key.item(MSTT02_STAT_NAME)
            var stationName:AnyObject = key.item(MSTT02_STAT_NAME_EXT1)
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            
            var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
            
            self.allOflineImageItems.addObject(statSeqArr)
            self.allOfStationItemsJP.addObject(stationNameJP)
            self.allOfStationItems.addObject(stationName)
         }
        
        tbView.reloadData()
        


    }
    
    // 根据数据库中的路线id获取图片
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