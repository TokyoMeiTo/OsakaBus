//
//  HelpContentList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class HelpContentList: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var tipsArr: NSMutableArray = NSMutableArray.array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
        
        tipsArr.addObject("关于到某个景点的问题")
        tipsArr.addObject("关于地铁出口的问题")
        tipsArr.addObject("关于乘出租去某地的问题")
        tipsArr.addObject("关于突发情况的问题")
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HelpContentListCell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel!.text = tipsArr[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var helpContent: HelpContent = self.storyboard?.instantiateViewControllerWithIdentifier("HelpContent") as HelpContent
        
        
        self.navigationController?.pushViewController(helpContent, animated: true)
    }
    
}
