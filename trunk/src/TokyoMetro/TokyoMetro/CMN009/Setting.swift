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
    
    @IBOutlet weak var tbList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrList = ["版本相关", "服务条款" , "评价App", "分享给好友"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as UITableViewCell
 
        
        var celllblItemsName : UILabel = cell.viewWithTag(102) as UILabel!
        var celllblAppVersion = cell.viewWithTag(103) as UILabel
        celllblAppVersion.hidden = true
        celllblItemsName.text = self.arrList.objectAtIndex(indexPath.row) as? String
        if indexPath.row == 0 {
            celllblAppVersion.hidden = false
            celllblAppVersion.text = "1.0.1"
        }
        
        if indexPath.row == 1 {
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       // if indexPath.row ==
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

//        if indexPath.section == 0 {
//            for(var i=0; i < arrList[indexPath.section][1].count;i++){
//                var indexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
//                var cellOther = tableView.cellForRowAtIndexPath(indexPath)
//                if(cellOther != nil){
//                    cellOther!.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
//            var cell = tableView.cellForRowAtIndexPath(indexPath)
//            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
//            return
//
//        } else if indexPath.section == 1 {
//            
//            println(" check version")
//        
//        } else if indexPath.section == 2 {
//            showAlertView("关于我们", Mgs: "上海冈三华大计算机系统有限公司", BtnTitle: "确认")
//        }
//        
//        if indexPath.section == 0 {
//           
//            
//        } else if indexPath.section == 1 {
//            
//           showAlertView("检查版本", Mgs: "已经是最新版本", BtnTitle: "确认")
//            
//        } else if indexPath.section == 2 {
//            
            if indexPath.row == 0 {
                var uigoon : UIActivityIndicatorView = UIActivityIndicatorView()
                uigoon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                uigoon.frame = CGRectMake(60, 231, 200, 70)
            }
            
            if indexPath.row == 1 {
                var appServerse : AppServerse = self.storyboard?.instantiateViewControllerWithIdentifier("appServerse") as AppServerse
                self.navigationController?.pushViewController(appServerse, animated:true)
            }
            
            if indexPath.row == 2 {
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