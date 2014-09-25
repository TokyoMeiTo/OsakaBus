//
//  Setting.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class Setting : UIViewController, UITableViewDelegate, UITableViewDataSource, OAPAsyncParserDelegate {
    
    var arrList: NSMutableArray = NSMutableArray.array()
    
    var itemsHead:Array<String> = ["选择语言：","检查版本：","关于我们："]
    
    var items1:Array<String> = ["中文简体","中文繁体", "日本語", "English"]
   
    var items2:Array<String> = ["当前版本"]
    
    var items3:Array<String> = ["版权信息"]
    
    @IBOutlet weak var tbList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
        self.arrList.addObject([itemsHead[0], items1])
        self.arrList.addObject([itemsHead[1], items2])
        self.arrList.addObject([itemsHead[2], items3])
        
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return arrList.count
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return arrList[section][0] as String
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return arrList[section][1].count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = arrList[indexPath.section][1][indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        if indexPath.section == 0 {
            for(var i=0; i < arrList[indexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
                var cellOther = tableView.cellForRowAtIndexPath(indexPath)
                if(cellOther != nil){
                    cellOther.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            return

        } else if indexPath.section == 1 {
            
            println(" check version")
        
        } else if indexPath.section == 2 {
            showAlertView("关于我们", Mgs: "上海冈三华大计算机系统有限公司", BtnTitle: "确认")
        }
     }
    
    // 检查版本
    func CheckVersion() {
        // 1.发送请求 http://itunes.apple.com/lookup?id=你的应用程序的ID
        
        var jsonparser = OAPAsyncJSONParser()
        var url:NSURL = NSURL.URLWithString("http://itunes.apple.com/lookup?id=你的应用程序的ID")
        
        var data = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingUncached, error: nil)
        var jsonStr=NSString(data:data,encoding:NSUTF8StringEncoding)
        var testJsonData=jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
        jsonparser.objToBeParse = testJsonData
        jsonparser.delegate = self
        jsonparser.asyncParse();
        
        // 2.解析json  获取最新版本号
        
        // 3.判断是否更新
    }
    
    // 接受请求后的数据
    func parseDidFinished(parser:AnyObject){
        println(parser.objParsed)
    }
    
    //
    func showAlertView(errTitle:String, Mgs:String, BtnTitle:String) {
        var eAv:UIAlertView = UIAlertView()
        eAv.title = errTitle
        eAv.message = Mgs
        eAv.addButtonWithTitle(BtnTitle)
        eAv.show()
        
    }


    


}