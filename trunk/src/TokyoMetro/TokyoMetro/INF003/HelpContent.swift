//
//  HelpContent.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-22.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class HelpContent: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var content: NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.addObject(["请问一下这个车站的厕所在什么地方？还是在车站外面？","便所はどこにありますか？"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HelpContentCell", forIndexPath: indexPath) as UITableViewCell
        
        var chString = content[indexPath.row][0] as String
        var chText = UILabel()
        chText.frame = CGRectMake(15, 8, 290, textHeight(chString))
        chText.text = chString
        chText.font = UIFont.systemFontOfSize(15)
        chText.numberOfLines = 0
        
        cell.addSubview(chText)
        
        var jpString = content[indexPath.row][1] as String
        var jpText = UILabel()
        jpText.frame = CGRectMake(15, 12 + chText.frame.height, 290, textHeight(jpString))
        jpText.text = jpString
        jpText.font = UIFont.systemFontOfSize(15)
        jpText.numberOfLines = 0
        
        cell.addSubview(jpText)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var string = content[indexPath.row][0] as NSString
        var string2 = content[indexPath.row][1] as NSString

        return CGFloat(textHeight(string) + textHeight(string2) + 20)
    }
    
    
    func textHeight(value:String) -> CGFloat {
    
        var font:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
        var maxSize = CGSizeMake(290, 2000)
        var size:CGSize = value.boundingRectWithSize(maxSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: font, context: nil).size

        return size.height
    }
    
}
