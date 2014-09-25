//
//  LandMarkSerchController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LandMarkSearchController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource{
    /* 设置选项 */
    @IBOutlet weak var tbList: UITableView!
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* landMarksType */
    var landMarksType:Array<String> = ["购物中心","景点","体育馆","酒店"]
    /* landMarksRange */
    var landMarksRange:Array<String> = ["东京","千代田区","附近5000米以内","附近3000米以内","附近1000米以内","附近500米以内","附近100米以内"]
    var landMarkType:Int = 0
    var landMarkRange:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        items.addObject(["地标类型：",landMarksType])
        items.addObject(["地标范围：",landMarksRange])
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        // 删除按钮点击事件
        var searchButton:UIBarButtonItem = self.navigationItem.rightBarButtonItem!
        searchButton.target = self
        searchButton.action = "buttonAction:"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case self.navigationItem.rightBarButtonItem!:
            self.navigationController!.popViewControllerAnimated(true)
        default:
            println("nothing")
        }
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(didSelectRowAtIndexPath.section == 0){
            landMarkType = didSelectRowAtIndexPath.row
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 0)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
        }else if(didSelectRowAtIndexPath.section == 1){
            landMarkRange = didSelectRowAtIndexPath.row
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 1)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
        }
        tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
            UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
        if(indexPath.row == landMarkType && indexPath.section == 0){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else if(indexPath.row == landMarkRange && indexPath.section == 1){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //items.removeObjectAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}