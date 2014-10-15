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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "求助一览"
        
        odbRescure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func odbRescure() {
    
        var table: InfT03RescureTable = InfT03RescureTable()
        
        var typeRows = table.excuteQuery("select *, ROWID, COUNT(RESC_TYPE) from INFT03_RESCURE where 1=1 group by RESC_TYPE")
        
        for key in typeRows {
            key as InfT03RescureTable
            var rescType: String! = key.item(INFT03_RESCURE_RESC_TYPE) as String
            table.rescType = rescType
            var rows = table.selectAll()
            rescArr.addObject([rescType, rows])
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rescArr[section][1].count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 30)
        view.backgroundColor = UIColor(red: 103/255, green: 188/255, blue: 228/255, alpha: 1)
        var title = UILabel()
        title.frame = CGRectMake(15, 0, 250, 30)
        title.text = rescArr[section][0] as? String
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
         return rescArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HelpContentListCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: InfT03RescureTable = rescArr[indexPath.section][1][indexPath.row] as InfT03RescureTable
        
        var view = cell.viewWithTag(201) as UIView!
        
        if (view != nil) {
            view.removeFromSuperview()
        }
        
        var rescView: UIView = UIView()
        rescView.frame = CGRectMake(15, 0, 290, cell.frame.height)
        rescView.tag = 201
        
        
        var chString = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
        var chText = UILabel()
        chText.frame = CGRectMake(0, 10, 290, textHeight(chString))
        chText.text = chString
        chText.font = UIFont.systemFontOfSize(15)
        chText.numberOfLines = 0
        
        rescView.addSubview(chText)
        
//        var jpString = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
//        var jpText = UILabel()
//        jpText.frame = CGRectMake(0, 12 + chText.frame.height, 290, textHeight(jpString))
//        jpText.text = jpString
//        jpText.font = UIFont.systemFontOfSize(15)
//        jpText.numberOfLines = 0
//        
//        rescView.addSubview(jpText)
        
        cell.addSubview(rescView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var map: InfT03RescureTable = rescArr[indexPath.section][1][indexPath.row] as InfT03RescureTable
        var cnString = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
//        var jpString = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
        
        if (textHeight(cnString) + 20 > 43) {
            return CGFloat(textHeight(cnString) + 20)
        } else {
            return 43
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var helpContentDetail: HelpContentDetail = self.storyboard?.instantiateViewControllerWithIdentifier("HelpContentDetail") as HelpContentDetail
        
        var map: InfT03RescureTable = rescArr[indexPath.section][1][indexPath.row] as InfT03RescureTable
        helpContentDetail.chTtile = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
        helpContentDetail.jpTtile = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
        self.navigationController?.pushViewController(helpContentDetail, animated: true)
    }
    
    func textHeight(value:String) -> CGFloat {
        
        var font:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
        var maxSize = CGSizeMake(290, 2000)
        var size:CGSize = value.boundingRectWithSize(maxSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: font, context: nil).size
        
        return size.height
    }
    
}
