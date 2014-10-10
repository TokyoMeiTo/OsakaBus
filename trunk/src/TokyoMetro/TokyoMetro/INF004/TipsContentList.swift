//
//  TipsContentList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class TipsContentList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var tipsArr: NSMutableArray = NSMutableArray.array()
    
    var tipsType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "贴士标题"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        odbTips()
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbTips() {
        var table = InfT02TipsTable()
        if (tipsType == "1") {
            table.tipsType = "旅游相关"
        } else {
            table.tipsType = "东京地铁"
        }
        var rows = table.selectAll()
        tipsArr.removeAllObjects()
        for key in rows{
            tipsArr.addObject(key)
        }
    }
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var view = UIView()
//        view.frame = CGRectMake(0, 0, 320, 30)
//        view.backgroundColor = UIColor(red: 103, green: 188, blue: 228, alpha: 1)
//        var title = UILabel()
//        title.frame = CGRectMake(15, 0, 250, 30)
//        
//        view.addSubview(title)
//        
//        return view
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TipsContentCell", forIndexPath: indexPath) as UITableViewCell
        
        var map = tipsArr[indexPath.row] as InfT02TipsTable
        
        var textTitle = cell.viewWithTag(201) as UILabel
        textTitle.text = map.item(INFT02_TIPS_TITLE) as? String
        textTitle.numberOfLines = 2
        
        if ((map.item(INFT02_READ_FLAG) as? String) == "1") {
            textTitle.textColor = UIColor.lightGrayColor()
        } else {
            textTitle.textColor = UIColor.blackColor()
        }
        
        var imageView: UIImageView = cell.viewWithTag(202) as UIImageView
        if ((map.item(INFT02_FAVO_FLAG) as? String) == "1") {
            imageView.hidden = false
        } else {
            imageView.hidden = true
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 55
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var tipsDetail: TipsDetail = self.storyboard?.instantiateViewControllerWithIdentifier("TipsDetail") as TipsDetail
        
        var map = tipsArr[indexPath.row] as InfT02TipsTable
        
        tipsDetail.cellTitle = map.item(INFT02_TIPS_TITLE)as String
        tipsDetail.tips_id = map.item(INFT02_TIPS_ID) as String
        
        self.navigationController?.pushViewController(tipsDetail, animated: true)
    }

}
