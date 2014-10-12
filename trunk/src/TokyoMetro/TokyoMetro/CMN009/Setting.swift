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
    @IBOutlet weak var mTabSettingItem: UITableView!
    @IBOutlet weak var mBtnOfficeWebSite: UIButton!
    @IBOutlet weak var mBtnAppServer: UIButton!
    @IBOutlet weak var mBtnRelifDuty: UIButton!
    
    let BTNLINKACTION : Selector = "btnLinkAction:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrList = ["离线数据管理", "评价App", "分享给好友"]
        self.mTabSettingItem.scrollEnabled = false
        
        mBtnOfficeWebSite.addTarget(self, action: BTNLINKACTION, forControlEvents: UIControlEvents.TouchUpInside)
        mBtnAppServer.addTarget(self, action: BTNLINKACTION, forControlEvents: UIControlEvents.TouchUpInside)
        mBtnRelifDuty.addTarget(self, action: BTNLINKACTION, forControlEvents: UIControlEvents.TouchUpInside)
        
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
        var celllblItemIamge : UIImageView = cell.viewWithTag(101) as UIImageView!
        celllblItemsName.text = self.arrList.objectAtIndex(indexPath.row) as? String
        celllblItemIamge.image = getItemImage(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            var localCacheController : LocalCacheController = self.storyboard?.instantiateViewControllerWithIdentifier("localcache") as LocalCacheController
            localCacheController.classType = 1
            self.navigationController?.pushViewController(localCacheController, animated:true)
        case 1:
            webLinkAction("评价", webSite:"http://www.baidu.com")
        case 2:
            webLinkAction("分享", webSite:"http://www.google.com")
        default:
        
            var appservers : LocalCacheController = self.storyboard?.instantiateViewControllerWithIdentifier("localcache") as LocalCacheController
        self.navigationController?.pushViewController(appservers, animated:true)

        }
        
        
        
    }
    
    // 获取图片
    func getItemImage(index : Int) -> UIImage {
        
        var image = UIImage(named: "setting1.png")
        switch (index) {
            
        case 0:
            image = UIImage(named: "setting1.png")
        case 1:
            image = UIImage(named: "setting2.png")
        case 2:
            image = UIImage(named: "setting3.png")
        default:
            image = UIImage(named: "setting1.png")
        }
        return image
    }
    
    // 设定页面下角跳转
    func btnLinkAction(sender:UIButton) {
        var appservers : AppServerse = self.storyboard?.instantiateViewControllerWithIdentifier("appServerse") as AppServerse
        self.navigationController?.pushViewController(appservers, animated:true)
        switch (sender) {
            
        case self.mBtnAppServer:
            var appservers : AppServerse = self.storyboard?.instantiateViewControllerWithIdentifier("appServerse") as AppServerse
            
            self.navigationController?.pushViewController(appservers, animated:true)
        case self.mBtnOfficeWebSite:
            webLinkAction("冈三华大", webSite:"http://www.google.com")
        case self.mBtnRelifDuty:
           webLinkAction("免责声明", webSite:"http://www.google.com")
            
        default:
        case self.mBtnOfficeWebSite:
        webLinkAction("冈三华大", webSite:"http://www.google.com")
        }

    }
    
    // 跳转网页
    func webLinkAction(pageTitle:String, webSite:String) {
        var linkWebSite : LinkWebSite = self.storyboard?.instantiateViewControllerWithIdentifier("LinkWebSite") as LinkWebSite
        
        linkWebSite.linkWebTitle = pageTitle
        linkWebSite.linkWebSite = webSite
        
        self.navigationController?.pushViewController(linkWebSite, animated:true)
    }


}