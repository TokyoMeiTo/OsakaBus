//
//  HelpContentList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class HelpContentList: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var rescArr: NSMutableArray = NSMutableArray.array()
    
    var rescType: String = "1"
    
    var titleArr = ["游览", "购物", "饮食", "住宿"]

    override func viewDidLoad() {
        super.viewDidLoad()

        if (rescType == "1") {
            self.title = "旅行求助"
        } else {
            self.title = "站内求助"
        }
        
        odbRescure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func odbRescure() {
    
        var table: InfT03RescureTable = InfT03RescureTable()
        var rows:NSArray!
        if (rescType == "1") {
            table.rescType = "游览"
            rows = table.selectLike()
            rescArr.addObject(rows)
            
            table.rescType = "购物"
            rows = table.selectLike()
            rescArr.addObject(rows)
            
            table.rescType = "饮食"
            rows = table.selectLike()
            rescArr.addObject(rows)
            
            table.rescType = "住宿"
            rows = table.selectLike()
            rescArr.addObject(rows)
            
        } else {
            table.rescType = "站内求助"
            rows = table.selectLike()
            rescArr.addObject(rows)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rescArr[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (rescType == "1") {
            return titleArr[section]
        } else {
            return "站内求助"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (rescType == "1") {
            return titleArr.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HelpContentListCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: InfT03RescureTable = rescArr[indexPath.section][indexPath.row] as InfT03RescureTable
        
        var view = cell.viewWithTag(201) as UIView!
        
        if (view != nil) {
            view.removeFromSuperview()
        }
        
        var rescView: UIView = UIView()
        rescView.frame = CGRectMake(15, 0, 290, cell.frame.height)
        rescView.tag = 201
        
        
        var chString = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
        var chText = UILabel()
        chText.frame = CGRectMake(0, 8, 290, textHeight(chString))
        chText.text = chString
        chText.font = UIFont.systemFontOfSize(15)
        chText.numberOfLines = 0
        
        rescView.addSubview(chText)
        
        var jpString = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
        var jpText = UILabel()
        jpText.frame = CGRectMake(0, 12 + chText.frame.height, 290, textHeight(jpString))
        jpText.text = jpString
        jpText.font = UIFont.systemFontOfSize(15)
        jpText.numberOfLines = 0
        
        rescView.addSubview(jpText)
        
        cell.addSubview(rescView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var map: InfT03RescureTable = rescArr[indexPath.section][indexPath.row] as InfT03RescureTable
        var cnString = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
        var jpString = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
        
        return CGFloat(textHeight(cnString) + textHeight(jpString) + 20)
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var helpContent: HelpContent = self.storyboard?.instantiateViewControllerWithIdentifier("HelpContent") as HelpContent
//        
//        
//        self.navigationController?.pushViewController(helpContent, animated: true)
//    }
    
    func textHeight(value:String) -> CGFloat {
        
        var font:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
        var maxSize = CGSizeMake(290, 2000)
        var size:CGSize = value.boundingRectWithSize(maxSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: font, context: nil).size
        
        return size.height
    }
    
}
