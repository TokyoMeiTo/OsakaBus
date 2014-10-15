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

        var typeRows = table.excuteQuery("select *, ROWID, COUNT(TIPS_TYPE) from INFT02_TIPS where 1=1 group by TIPS_TYPE")
        
        tipsArr = NSMutableArray.array()
        for key in typeRows {
            key as InfT02TipsTable
            var tipsType: String! = key.item(INFT02_TIPS_TYPE) as String
            table.tipsType = tipsType
            var rows = table.selectAll()
            tipsArr.addObject([tipsType, rows])
        }

    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 30)
        view.backgroundColor = UIColor(red: 103/255, green: 188/255, blue: 228/255, alpha: 1)
        var title = UILabel()
        title.frame = CGRectMake(15, 0, 250, 30)
        title.text = tipsArr[section][0] as? String
        title.textColor = UIColor.whiteColor()
        title.font = UIFont.boldSystemFontOfSize(17)
        
        view.addSubview(title)
        
        var image:UIImageView = UIImageView(frame: CGRectMake(273, 3, 32, 23))
        image.image = UIImage(named: "arrow_down")
        view.addSubview(image)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tipsArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsArr[section][1].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TipsContentCell", forIndexPath: indexPath) as UITableViewCell
        
        var map = tipsArr[indexPath.section][1][indexPath.row] as InfT02TipsTable
        
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
        
        var map = tipsArr[indexPath.section][1][indexPath.row] as InfT02TipsTable
        
        tipsDetail.cellTitle = map.item(INFT02_TIPS_TITLE)as String
        tipsDetail.tips_id = map.item(INFT02_TIPS_ID) as String
        
        self.navigationController?.pushViewController(tipsDetail, animated: true)
    }

}
