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
    
    @IBOutlet weak var mlblAppName: UILabel!
    
    @IBOutlet weak var mlblAppIntroduce: UILabel!
    let BTNLINKACTION : Selector = "btnLinkAction:"
    
    var setImagArr : Array<String> = ["setting1","setting2","setting3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mlblAppName.text = "东京美途"
        mlblAppIntroduce.numberOfLines = 0
        mlblAppIntroduce.text = "东京美途是一款专门定制的APP，美途在手，畅行无忧"
        arrList = ["CMN009_02".localizedString(), "CMN009_03".localizedString(), "当前版本".localizedString()]
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
        celllblItemIamge.image = setImagArr[indexPath.row].getImage()
        
        if(indexPath.row == 2){
            var lblVersion : UILabel = UILabel(frame: CGRect(x: 250,y: 0,width: 100,height: 55))
            lblVersion.text = "1.0"
            lblVersion.textColor = UIColor.blueColor()
            lblVersion.font = UIFont.systemFontOfSize(16)
            cell.addSubview(lblVersion)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            var localCacheController : LocalCacheController = self.storyboard?.instantiateViewControllerWithIdentifier("localcache") as LocalCacheController
            localCacheController.classType = 1
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(localCacheController, animated:true)
        case 1:
            let url = NSURL.URLWithString("https://itunes.apple.com/cn/app/id928756102?mt=8")
            UIApplication.sharedApplication().openURL(url)
        case 2:
            let url = NSURL.URLWithString("https://itunes.apple.com/cn/app/id928756102?mt=8")
            UIApplication.sharedApplication().openURL(url)
        default:
        
            var appservers : LocalCacheController = self.storyboard?.instantiateViewControllerWithIdentifier("localcache") as LocalCacheController
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(appservers, animated:true)

        }

    }
    
    // 设定页面下角跳转
    func btnLinkAction(sender:UIButton) {
        switch (sender) {
        
        case self.mBtnAppServer:
            var appservers : AppServerse = self.storyboard?.instantiateViewControllerWithIdentifier("appServerse") as AppServerse
            appservers.pagTag = 1
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(appservers, animated:true)
            
        case self.mBtnOfficeWebSite:
            let url = NSURL.URLWithString("http://www.ohs-sys.com/")
            UIApplication.sharedApplication().openURL(url)

        case self.mBtnRelifDuty:
            var appservers : AppServerse = self.storyboard?.instantiateViewControllerWithIdentifier("appServerse") as AppServerse
            appservers.pagTag = 2
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(appservers, animated:true)
            
        default:
            webLinkAction("CMN009_07".localizedString(), webSite:"http://www.ohs-sys.com/")
        }

    }
    
    // 跳转网页
    func webLinkAction(pageTitle:String, webSite:String) {
        var linkWebSite : LinkWebSite = self.storyboard?.instantiateViewControllerWithIdentifier("LinkWebSite") as LinkWebSite
        
        linkWebSite.linkWebTitle = pageTitle
        linkWebSite.linkWebSite = webSite
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(linkWebSite, animated:true)
    }


}