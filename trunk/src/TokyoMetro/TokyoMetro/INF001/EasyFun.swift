//
//  EasyFun.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class EasyFun : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items : NSMutableArray = NSMutableArray.array()
    let PAGE_NUMBER_ALL : Int16 = 0  // 表示显示全部
    let PAGE_NUMBER_TOUR : Int16 = 1  // 表示只显示景点
    let PAGE_NUMBER_SHOPPING : Int16 = 2  // 表示只显示购物
    let PAGE_NUMBER_EAT : Int16 = 3  // 表示只显示吃
    let PAGE_NUMBER_HOME : Int16 = 4  // 表示只显示宾馆
    var pageIdTemp : Int16 = 0
    
    @IBOutlet weak var segType: UISegmentedControl!
    @IBOutlet weak var tbEFAll: UITableView!
    
    let item3 = ["Name":"Grill&Pasta es 麻布十番", "Distance":"163", "classType":"food", "ShopWeb":"http://loco.yahoo.co.jp/place/g-6FGgNSJG4Rc/"]
    let item4 = ["Name":"Zhotels智尚酒店", "Distance":"1600", "classType":"home", "ShopWeb":"http://t.dianping.com/deal/6444889"]
    let item2 = ["Name":"中环百联购物广场", "Distance":"8405", "classType":"shopping", "ShopWeb":"http://www.blzhmall.com/"]
    let item1 = ["Name":"东京塔", "Distance":"12000", "classType":"tour", "ShopWeb":"http://days.enjoytokyo.jp/tokyokanko/osusume09.html"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbEFAll.dataSource = self
        tbEFAll.delegate = self
        
        self.segType.addTarget(self, action: "selectAction", forControlEvents: UIControlEvents.ValueChanged)
 
        self.items.addObject(item1)
        self.items.addObject(item2)
        self.items.addObject(item3)
        self.items.addObject(item4)

    }
    
    func selectAction() {
        
        if (segType.selectedSegmentIndex == 0) {
            self.pageIdTemp = PAGE_NUMBER_ALL
        } else if (segType.selectedSegmentIndex == 1) {
            
            self.pageIdTemp = PAGE_NUMBER_TOUR
        } else if (segType.selectedSegmentIndex == 2) {
            self.pageIdTemp = PAGE_NUMBER_SHOPPING
        } else if (segType.selectedSegmentIndex == 3) {
            self.pageIdTemp = PAGE_NUMBER_EAT
        } else if (segType.selectedSegmentIndex == 4) {
            self.pageIdTemp = PAGE_NUMBER_HOME
        } else {
            pageIdTemp = 0
        }

        
        if self.pageIdTemp == 0 {
            self.items.removeAllObjects()
            self.items.addObject(item1)
            self.items.addObject(item2)
            self.items.addObject(item3)
            self.items.addObject(item4)
        } else if self.pageIdTemp == 1 {
            
            self.items.removeAllObjects()
            self.items.addObject(item1)
        } else if self.pageIdTemp == 2 {
            
            self.items.removeAllObjects()
            self.items.addObject(item2)
        } else if self.pageIdTemp == 3 {
            
            self.items.removeAllObjects()
            self.items.addObject(item3)
        } else if self.pageIdTemp == 4 {
            
            self.items.removeAllObjects()
            self.items.addObject(item4)
        }
        
        
        
        tbEFAll.reloadData()
        
        

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
        let cell = tableView.dequeueReusableCellWithIdentifier("FunFindCell", forIndexPath: indexPath) as UITableViewCell!
        var shopName = cell.viewWithTag(1011) as UILabel
        var shopDistance = cell.viewWithTag(1012) as UILabel
        var tempDic:NSDictionary = items.objectAtIndex(indexPath.row) as NSDictionary
        shopName.text = tempDic["Name"] as String
        var distances = tempDic["Distance"] as String
        shopDistance.text = "相距" + distances
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        var shopdetial : ShopDetial = self.storyboard?.instantiateViewControllerWithIdentifier("ShopDetial") as ShopDetial
        
        var webSiteDic:NSDictionary = items.objectAtIndex(indexPath.row) as NSDictionary
        shopdetial.title = webSiteDic["Name"] as String
        shopdetial.webSite = webSiteDic["ShopWeb"] as String
        self.navigationController.pushViewController(shopdetial, animated:true)
 
        
    }
    
}