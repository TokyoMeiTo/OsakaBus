//
//  TipsContentList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class TipsContentList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tipsArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
        
        tipsArr.addObject("请问想要换票、退票或者车票丢失时该怎么办？")
        tipsArr.addObject("有没有儿童票？")
        tipsArr.addObject("什么是PASMO卡？")
        tipsArr.addObject("能否介绍一下月票如何购买？")
        tipsArr.addObject("票价是如何计算的？")
        tipsArr.addObject("有哪些推荐的观光车票？")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TipsContentCell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = tipsArr[indexPath.row] as? String
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 55
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var tipsDetail: TipsDetail = self.storyboard?.instantiateViewControllerWithIdentifier("TipsDetail") as TipsDetail
        
        tipsDetail.cellTitle = tipsArr[indexPath.row] as String
        
        self.navigationController?.pushViewController(tipsDetail, animated: true)
    }

    
}
