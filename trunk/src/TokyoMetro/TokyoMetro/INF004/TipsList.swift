//
//  TipsList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class TipsList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    
    var tipsArr: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "贴士类型一览"
        
        addData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addData() {
    
        tipsArr.addObject("关于车票信息")
        tipsArr.addObject("关于运行路线图")
        tipsArr.addObject("关于服务")
        tipsArr.addObject("关于运行状况")
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tipsArr.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TipsCell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel.text = tipsArr[indexPath.row] as String
        
        return cell
    }
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 43
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var contentList: TipsContentList = self.storyboard?.instantiateViewControllerWithIdentifier("TipsContentList") as TipsContentList
        
        self.navigationController?.pushViewController(contentList, animated: true)
    }
    
    
}