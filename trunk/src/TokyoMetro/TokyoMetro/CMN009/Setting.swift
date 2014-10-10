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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrList = ["离线数据管理", "评价App", "分享给好友"]
        self.mTabSettingItem.scrollEnabled = false
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

        // TODO
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

    



    


}