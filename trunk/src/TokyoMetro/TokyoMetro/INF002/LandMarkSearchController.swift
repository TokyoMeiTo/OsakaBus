//
//  LandMarkSerchController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LandMarkSearchController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    /* 设置选项 */
    @IBOutlet weak var tbList: UITableView!
    
    /* 区域UIPickerView */
    var pickerSpecialWard: UIPickerView = UIPickerView()
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* landMarksType */
    var landMarksSubType:Array<String>?
    /* landMarksRange */
    var landMarksRange:Array<String> = ["1000米以内","500米以内","100米以内"]
    var pickerViewIsOpen = false

    var landMarkType:Int = 0
    var landMarkSpecialWard:String = "01"
    var landMarkRange:Int = 100000
    var landMarkStatId:String = "2800101"
    
    /* 起点軽度 */
    var fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var inf002Dao:INF002Dao = INF002Dao()
        var subTypeTemp:NSArray = inf002Dao.querySubType()

        loadItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        
        pickerSpecialWard.dataSource = self
        pickerSpecialWard.delegate = self
        
        // 完成按钮点击事件
        var searchButton:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
        self.navigationItem.leftBarButtonItem = searchButton
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItems(){
        items = NSMutableArray.array()
        items.addObject(["站点：",[landMarkStatId]])
        items.addObject(["区域：",[landMarkSpecialWard,""]])
        items.addObject(["距离：",landMarksRange])
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case self.navigationItem.leftBarButtonItem!:
            var controllers:AnyObject? = self.navigationController!.viewControllers
            var lastController:LandMarkListController = controllers![controllers!.count - 2] as LandMarkListController
            var inf002Dao:INF002Dao = INF002Dao()
            switch landMarkType{
            case 0:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("景点",lon: fromLon,
                    lat: fromLat, distance: landMarkRange) as? Array<MstT04LandMarkTable>
            case 1:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("美食",lon: fromLon,
                    lat: fromLat, distance: landMarkRange) as? Array<MstT04LandMarkTable>
            case 2:
                lastController.landMarks = inf002Dao.queryLandMarksFilter("购物",lon: fromLon,
                    lat: fromLat, distance: landMarkRange) as? Array<MstT04LandMarkTable>
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
        switch didSelectRowAtIndexPath.section{
        case 0:
            var searchStationList = self.storyboard!.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
            searchStationList.classType = "landMarkSearchController"
            self.navigationController!.pushViewController(searchStationList, animated:true)
            
        case 1:
            if(pickerViewIsOpen){
                pickerViewIsOpen = false
            }else{
                pickerViewIsOpen = true
            }
            var indexPath = NSIndexPath(forRow: 1, inSection: didSelectRowAtIndexPath.section)
            tbList.reloadRowsAtIndexPaths([didSelectRowAtIndexPath,indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        case 2:
            switch didSelectRowAtIndexPath.row{
            case 0:
                landMarkRange = 1000
            case 1:
                landMarkRange = 500
            case 2:
                landMarkRange = 100
            default:
                println("nothing")
            }
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 2)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                UITableViewCellAccessoryType.Checkmark
            
        default:
            println("nothing")
        }
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 1:
            if(indexPath.row == 1)
            {
                if(pickerViewIsOpen){
                    return 216
                }else{
                    return 0
                }
            }else{
                return 43
            }
        default:
            return 43
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
        for subview in cell.subviews{
            if(subview.isKindOfClass(UIPickerView)){
                subview.removeFromSuperview()
            }
        }
        
        switch indexPath.section{
        case 0:
            cell.textLabel!.text = (items[indexPath.section][1][indexPath.row] as? String)?.station()
            
        case 1:
            cell.textLabel!.text = (items[indexPath.section][1][indexPath.row] as String).specialWard()
            if(indexPath.row == 1){
                if(pickerViewIsOpen){
                    cell.addSubview(pickerSpecialWard)
                }
            }
            
        case 2:
            cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
        default:
            println("nothing")
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return "$".getDistrict()[row]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return "$".getDistrict().count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(row < 9){
            landMarkSpecialWard = "0\(row + 1)"
        }else{
            landMarkSpecialWard = "\(row + 1)"
        }
        loadItems()
        var indexPath = NSIndexPath(forRow: 0, inSection: 1)
        //tbList.reloadData()
        tbList.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
}