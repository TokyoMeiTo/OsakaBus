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
    var landMarksSubType:Array<String>?
    /* landMarksRange */
    var landMarksRange:Array<String> = ["东京","千代田区","附近5000米以内","附近3000米以内","附近1000米以内","附近500米以内","附近100米以内"]
    var landMarkType:Int = 0
    var landMarkSubType:Int = 0
    var landMarkRange:Int = 0
    
    /* 起点軽度 */
    var fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var inf002Dao:INF002Dao = INF002Dao()
        var subTypeTemp:NSArray = inf002Dao.querySubType()
        landMarksSubType = Array<String>()
        for subType in subTypeTemp{
            landMarksSubType!.append("\(subType.item(MSTT04_LANDMARK_LMAK_SUB_TYPE))")
        }

        items.addObject(["地标类型：",landMarksSubType!])
        items.addObject(["地标范围：",landMarksRange])
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        // 删除按钮点击事件
        var searchButton:UIBarButtonItem = self.navigationItem.rightBarButtonItem!
        searchButton.target = self
        searchButton.action = "buttonAction:"
        self.navigationItem.setHidesBackButton(true, animated: false)
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
            var controllers:AnyObject? = self.navigationController!.viewControllers
            var lastController:LandMarkListController = controllers![controllers!.count - 2] as LandMarkListController
            var inf002Dao:INF002Dao = INF002Dao()
            switch landMarkType{
            case 0:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("景点", distance: 1000, subType: "") as? Array<MstT04LandMarkTable>
            case 1:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("美食", distance: 1000, subType: "") as? Array<MstT04LandMarkTable>
            case 2:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("购物", distance: 1000, subType: "") as? Array<MstT04LandMarkTable>
            default:
                println("nothing")
            }
            
            lastController.viewDidLoad()
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