//
//  RemindDetailController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

/**
 * 编辑提醒
 */
class RemindDetailController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    /* UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    /* 站点UIPickerView */
    var pickStations: UIPickerView = UIPickerView()
    /* 上车站点UIPickerView */
    var pickFromStations: UIPickerView = UIPickerView()
    /* 站点UIPickerView */
    var pickLineStations: Array<UIPickerView> = Array<UIPickerView>()
    /* 提醒内容详细信息 */
    var arriveInfo:AnyObject?
    /* segIndex */
    var segIndex:Int?
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* lines */
    var lines:Array<MstT01LineTable> = Array<MstT01LineTable>()
    /* stations */
    var stations:Array<MstT02StationTable> = Array<MstT02StationTable>()
    /* fromStations */
    var fromStations:Array<String> = ["后乐园","本乡三丁目","银座","日本桥","东京","新宿","上野"]
    /* 提醒方式 */
    var remindsMethod:Array<String> = ["铃声","震动"]
    /* 提醒时间 */
    var remindsTime:Array<String> = ["到站前1分钟","到站前2分钟","到站前3分钟","到站前4分钟","到站前5分钟"]
    /* line */
    var line:String = "東西線"
    /* station */
    var station:String = "后乐园"
    /* fromStation */
    var fromStation:String = "后乐园"
    /* 提醒方式 */
    var remindType:Int = 0
    /* 提醒时间 */
    var remindTime:Int = 0
    /* pickerview高度 */
    var pickerViewHeight:CGFloat = 0
    /* pickerview */
    var pickerViewSection:Int = 0
    
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 100 */
    let NUM_100 = 100
    
    /* 线路数量 */
    let LINE_COUNT:UInt = 9
    /* 添加 */
    let ADD = "添加"
    /* 编辑 */
    let EDIT = "编辑"
    /* 编辑 */
    let PICKERVIEW_STRING = "pickerview"
    /* 确定删除本条提醒？ */
    let MSG_0001 = "确定删除本条提醒？"
    /* 通知 */
    let MSG_0002 = "通知"
    /* 确定 */
    let MSG_0003 = "确定"
    /* 取消 */
    let MSG_0004 = "取消"
    /* 确定添加本条提醒？ */
    let MSG_0005 = "确定添加本条提醒？"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     *
     */
    func intitValue(){
        // 查询线路
        lines = selectLineTable()
        // 查询站点
        stations = selectStationTable("28001")
        if(segIndex == NUM_0){
            editArriveStation()
        }else if(segIndex == NUM_1){
            editLastMetro()
        }
    }
    
    /**
     * 编辑到站提醒
     */
    func editArriveStation(){
        self.navigationItem.rightBarButtonItem = nil
        
        loadArriveStationItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        
        pickStations.hidden = true
        pickStations.delegate = self
        pickStations.dataSource = self
        pickLineStations.append(pickStations)
        
        pickFromStations.hidden = true
        pickFromStations.delegate = self
        pickFromStations.dataSource = self
        
        pickLineStations.append(pickFromStations)
    }
    
    /**
     * 编辑末班车提醒
     */
    func editLastMetro(){
        // 删除按钮点击事件
        var delButton:UIBarButtonItem = self.navigationItem.rightBarButtonItem
        delButton.target = self
        delButton.action = "buttonAction:"
        
        loadLastMetroItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        
        pickStations.hidden = true
        pickStations.delegate = self
        pickStations.dataSource = self
        
        pickLineStations.append(pickStations)
    }
    
    /**
     * 加载items
     */
    func loadArriveStationItems(){
        items = NSMutableArray.array()
        items.addObject(["到达站点：",[station,""]])
        items.addObject(["上车站点：",[fromStation,""]])
        items.addObject(["提醒方式：",remindsMethod])
        items.addObject(["提醒时间：",remindsTime])
    }
    
    /**
     * 加载items
     */
    func loadLastMetroItems(){
        items = NSMutableArray.array()
        items.addObject(["站点：",[station,""]])
        items.addObject(["提醒方式：",remindsMethod])
        items.addObject(["提醒时间：",remindsTime])
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case self.navigationItem.rightBarButtonItem:
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0001,buttons:[MSG_0003, MSG_0004], delegate: nil)
        default:
            println("nothing")
        }
    }

    /**
     * 改变pickview的高度
     * @param sender
     */
    func changeHeight(sender:AnyObject?,height: CGFloat){
        var viewLayer:CALayer = sender!.layer
        viewLayer.bounds.size.height = height
    }
    
    /**
     * 从DB查询线路信息
     */
    func selectLineTable() -> Array<MstT01LineTable>{
        var tableMstT01 = MstT01LineTable()
        var lines:Array<MstT01LineTable> = tableMstT01.selectTop(LINE_COUNT) as Array<MstT01LineTable>
        return lines
    }

    /**
     * 从DB查询站点信息
     */
    func selectStationTable(lineId: String) -> Array<MstT02StationTable>{
        var tableMstT02 = MstT02StationTable()
        tableMstT02.lineId = lineId
        var stations:Array<MstT02StationTable> = tableMstT02.selectAll() as Array<MstT02StationTable>
        return stations
    }
    
    /**
     * showMessage
     * @param msg
     */
    class func showMessage(title:String, msg:String, buttons:Array<String>, delegate: AnyObject?){
        var alertView = UIAlertView()
        alertView.title = title
        alertView.message = msg
        for key in buttons{
            alertView.addButtonWithTitle(key)
        }
        if(delegate != nil){
            alertView.delegate = delegate
        }
        alertView.show()
    }

    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func setTableCellHeight(didSelectRowAtIndexPath: NSIndexPath){
        if(self.pickerViewHeight != 0 && didSelectRowAtIndexPath.section != self.pickerViewSection){
            return
        }
        self.pickerViewSection = didSelectRowAtIndexPath.section
        var indexPath = NSIndexPath(forRow: didSelectRowAtIndexPath.row + 1, inSection: didSelectRowAtIndexPath.section)
        
        if(self.pickerViewHeight == 0){
            self.pickLineStations[didSelectRowAtIndexPath.section].hidden = false
            //self.pickLineStations[didSelectRowAtIndexPath.section].frame.size.height = 216
            self.pickerViewHeight = 216
            self.tbList.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }else{
            //self.pickLineStations[didSelectRowAtIndexPath.section].frame.size.height = 0
            self.pickerViewHeight = 0
            self.tbList.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.pickLineStations[didSelectRowAtIndexPath.section].hidden = true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(segIndex == NUM_0){
            if(didSelectRowAtIndexPath.section == 0 || didSelectRowAtIndexPath.section == 1){
                setTableCellHeight(didSelectRowAtIndexPath)
                return
            }
        }else if(segIndex == NUM_1){
            if(didSelectRowAtIndexPath.section == 0){
                setTableCellHeight(didSelectRowAtIndexPath)
                return
            }
        }

        if(segIndex == NUM_0){
            if(didSelectRowAtIndexPath.section == 2){
                remindType = didSelectRowAtIndexPath.row
            }else if(didSelectRowAtIndexPath.section == 3){
                remindTime = didSelectRowAtIndexPath.row
            }
        }else if(segIndex == NUM_1){
            if(didSelectRowAtIndexPath.section == 1){
                remindType = didSelectRowAtIndexPath.row
            }else if(didSelectRowAtIndexPath.section == 2){
                remindTime = didSelectRowAtIndexPath.row
            }
        }
        for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
            var indexPath = NSIndexPath(forRow: i, inSection: didSelectRowAtIndexPath.section)
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            if(cell != nil){
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath).accessoryType =
            UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if(segIndex == NUM_0){
            if((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 1){
                if(pickerViewHeight == 0 || indexPath.section != pickerViewSection){
                    return 0
                }else{
                    return pickerViewHeight
                }
            }
        }else if(segIndex == NUM_1){
            if((indexPath.section == 0) && indexPath.row == 1){
                if(pickerViewHeight == 0 || indexPath.section != pickerViewSection){
                    return 0
                }else{
                    return pickerViewHeight
                }
            }
        }
        return 43
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        if(segIndex == NUM_0){
            if(indexPath.row == remindType && indexPath.section == 2){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.row == remindTime && indexPath.section == 3){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.row == 1 && (indexPath.section == 0 || indexPath.section == 1)){
                cell.addSubview(pickLineStations[indexPath.section])
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }else if(segIndex == NUM_1){
            if(indexPath.row == remindType && indexPath.section == 1){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.row == remindTime && indexPath.section == 2){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.row == 1 && (indexPath.section == 0)){
                cell.addSubview(pickLineStations[indexPath.section])
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        cell.textLabel.text = items[indexPath.section][1][indexPath.row] as String
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
        }else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        var title = ""
        if(pickerView == pickStations){
            if(component == NUM_0){
                title = "\(lines[row].lineName)"
            }else{
                title = "\(stations[row].statName)"
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                title = "\(lines[row].lineName)"
            }else{
                title = "\(stations[row].statName)"
            }
        }
        return title
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView == pickStations){
            if(component == NUM_0){
                return lines.count
            }else{
                return stations.count
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                return lines.count
            }else{
                return stations.count
            }
        }
        return 0
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        if(pickerView == pickStations){
            if(component == NUM_0){
                line = "\(lines[row].lineName)"
                stations = selectStationTable(lines[row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                station = "\(stations[NUM_0].statName)"
            }else{
                station = "\(stations[row].statName)"
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                line = lines[row].lineName as String
                stations = selectStationTable(lines[row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                station = "\(stations[NUM_0].statName)"
            }else{
                fromStation = "\(stations[row].statName)"
            }
        }
        if(segIndex == NUM_0){
            loadArriveStationItems()
        }else if(segIndex == NUM_1){
            loadLastMetroItems()
        }
        tbList.reloadData()
    }
}