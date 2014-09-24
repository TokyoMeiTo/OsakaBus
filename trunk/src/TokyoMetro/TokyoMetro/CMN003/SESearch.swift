//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class SESearch : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var items : NSArray!
    var localItems : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var btnExchange: UIButton!
    @IBOutlet weak var stationStart: UITextField!
    @IBOutlet weak var stationEnd: UITextField!
    @IBOutlet weak var tbView: UITableView!
    
    var focusNumber : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var strStart:NSString = "起点"
        var strEnd:NSString = "终点"
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        stationStart.becomeFirstResponder()
        
        self.items = ["银座", "大手町", "东京", "日本桥", "门前仲町" ]
       
        btnExchange.addTarget(self, action: "exchangeAction", forControlEvents: UIControlEvents.TouchUpInside)
//        btnSearchWay.addTarget(self, action: "searchWayAction", forControlEvents: UIControlEvents.TouchUpInside)
        // 点击textFile后记住焦点的位置
        stationStart.addTarget(self, action: "foucsChangeTo1", forControlEvents: UIControlEvents.AllEditingEvents)
        stationEnd.addTarget(self, action: "foucsChangeTo2", forControlEvents: UIControlEvents.AllEditingEvents)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell!
        cell.textLabel.text = self.items!.objectAtIndex(indexPath.row) as String
        return cell
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        var stationName:String = cell.textLabel.text
        if focusNumber == "1" {
            
            if !(stationName == self.stationEnd.text)  {
                self.stationStart.text = stationName
            } else {
                 errAlertView("错误信息",errMgs: "站点名相同",errBtnTitle: "确认")
            }
            
        } else if focusNumber == "2" {
            
            if !(stationName == self.stationStart.text) {
                self.stationEnd.text = stationName
            } else {
                errAlertView("错误信息",errMgs: "站点名相同",errBtnTitle: "确认")
            }
            
        }
        
        hideKeyBoard()
        
        
    }
    
    func exchangeAction(){
        
        var tempName:NSString = self.stationStart.text
        self.stationStart.text = self.stationEnd.text
        self.stationEnd.text = tempName
        
        hideKeyBoard()
        
    }
    
    func searchWayAction(){
        var nilResult:Bool
        if ( self.stationStart.text == nil || self.stationEnd.text == nil || self.stationStart.text == self.stationEnd.text) {
            
        } else {
            
            
        }
        
        
    }
    
    func foucsChangeTo1 () {
        self.focusNumber = "1"
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func errAlertView(errTitle:String, errMgs:String, errBtnTitle:String) {
        var eAv:UIAlertView = UIAlertView()
        eAv.title = errTitle
        eAv.message = errMgs
        eAv.addButtonWithTitle(errBtnTitle)
        eAv.show()
        
    }
    
    func hideKeyBoard() {
        stationEnd.resignFirstResponder()
        stationStart.resignFirstResponder()
    }
    
    func odbSample(){
        var table = MstT01LineTable()
        var rows:NSArray = table.excuteQuery("select LINE_ID from MSTT01_LINE where 1=1")
        for key in rows {
            key as MstT01LineTable
            var id:AnyObject = key.item(MSTT01_LINE_ID)
        }
    }
    
    // 放置本地数据
    func setCache() {
        
        var accoutDefault : NSUserDefaults = NSUserDefaults()
        var historyStationdate: NSMutableArray = NSMutableArray()
        if accoutDefault.objectForKey("historyStationdata") != nil {
            historyStationdate = accoutDefault.objectForKey("historyStationdata") as NSMutableArray
        }
        historyStationdate.addObject(stationStart.text)
        historyStationdate.addObject(stationEnd.text)
        accoutDefault.setObject(historyStationdate, forKey: "historyStationdata")
    }
    
    // 读取本地数据
    func readCache() {
        var accoutDefaultRead : NSUserDefaults = NSUserDefaults()
        if accoutDefaultRead.objectForKey("historyStationdata") != nil {
            var readdate : NSMutableArray = accoutDefaultRead.objectForKey("historyStationdata") as NSMutableArray
            self.localItems = readdate
        }
    }
    
    //  清空本地数据
    func clearCache() {
        var accoutDefaultClear : NSUserDefaults = NSUserDefaults()
        accoutDefaultClear.setObject("", forKey: "historyStationdata")
    }
    
}