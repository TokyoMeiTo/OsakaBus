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
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/

    /* 设置选项 */
    @IBOutlet weak var tbList: UITableView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
    let SAVE_BUTTON_TAG:Int = 200201
    let BTN_ALL:Int = 101
    let BTN_ALL_SPEACIAL:Int = 200202
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    var classType = ""

    var landMarkType:Int = 0
    var landMarkSpecialWard:String? = ""
    var landMarkRange:Int = 100000
    var landMarkStatId:String? = ""
    // 美食
    var landMarkSubType:String = ""
    var landMarkPrice:Int = 0
    var landMarkMiciRank:String = ""
    var landMarkRank:String = ""
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* 区域UIPickerView */
    var pickerSpecialWard: UIPickerView = UIPickerView()
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* landMarksType */
    var landMarksSubType:Array<String>?
    /* landMarksRange */
    var landMarksRange:Array<String> = ["INF002_14".localizedString(),"INF002_15".localizedString(),"INF002_16".localizedString(),"INF002_19".localizedString()]
    var pickerViewIsOpen = false
    
    var landMarkShowStatId:String = "2800101"
    var landMarkShowSpecialWard:String = "INF002_19".localizedString()
    
    /* 起点軽度 */
    var fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    var fromLon = 139.768898//121.38368547 // 天地科技广场1号楼

    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        //var inf002Dao:INF002Dao = INF002Dao()
        var subTypeTemp:NSArray = mstT04Table.querySubType()

        loadItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.reloadData()
        
        pickerSpecialWard.dataSource = self
        pickerSpecialWard.delegate = self
        
        // 完成按钮点击事件
        var saveButton:UIBarButtonItem = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.Bordered, target:self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem!.tag = SAVE_BUTTON_TAG
        
        self.title = "条件筛选"
    }
    
    override func viewWillAppear(animated: Bool) {
        loadItems()
        tbList.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        switch didSelectRowAtIndexPath.section{
        case 0:
            if(didSelectRowAtIndexPath.row == 0){
                var searchStationList = self.storyboard!.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
                searchStationList.classType = "landMarkSearchController"
                
                var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = backButton
                
                self.navigationController!.pushViewController(searchStationList, animated:true)
            }else if(didSelectRowAtIndexPath.row == 1){
                landMarkStatId = ""
                tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                    UITableViewCellAccessoryType.Checkmark
            }
        case 1:
            if(didSelectRowAtIndexPath.row == 0){
                if(pickerViewIsOpen){
                    pickerViewIsOpen = false
                }else{
                    pickerViewIsOpen = true
                }
                var indexPath = NSIndexPath(forRow: 1, inSection: didSelectRowAtIndexPath.section)
                tbList.reloadRowsAtIndexPaths([didSelectRowAtIndexPath,indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }else if(didSelectRowAtIndexPath.row == 2){
                landMarkSpecialWard = ""
                tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                    UITableViewCellAccessoryType.Checkmark
            }
            
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
        case 3:
            switch didSelectRowAtIndexPath.row{
            case 0:
                landMarkSubType = "INF002_21".localizedString()
            case 1:
                landMarkSubType = "INF002_22".localizedString()
            case 2:
                landMarkSubType = "INF002_23".localizedString()
            default:
                landMarkSubType = ""
            }
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 3)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                UITableViewCellAccessoryType.Checkmark
        case 4:
            switch didSelectRowAtIndexPath.row{
            case 0:
                landMarkPrice = 1
            case 1:
                landMarkPrice = 2
            case 2:
                landMarkPrice = 3
            default:
                landMarkPrice = 0
            }
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 4)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                UITableViewCellAccessoryType.Checkmark
        case 5:
            switch didSelectRowAtIndexPath.row{
            case 0:
                landMarkMiciRank = "1"
            case 1:
                landMarkMiciRank = "2"
            case 2:
                landMarkMiciRank = "3"
            default:
                landMarkMiciRank = ""
            }
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 5)
                var cell = tableView.cellForRowAtIndexPath(indexPath)
                if(cell != nil){
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
                UITableViewCellAccessoryType.Checkmark
        case 6:
            switch didSelectRowAtIndexPath.row{
            case 0:
                landMarkRank = "2"
            case 1:
                landMarkRank = "3"
            case 2:
                landMarkRank = "4"
            case 3:
                landMarkRank = "5"
            default:
                landMarkRank = ""
            }
            for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
                var indexPath = NSIndexPath(forRow: i, inSection: 6)
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

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 54
        }else{
            return 44
        }
    }
    
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var UIHeader:UIView = UIView()

        switch section{
        case 0:
            var imgStation = UIImage(named: "dld00106")
            var imageViewStation = UIImageView(frame: CGRectMake(15, 15, 25, 25))
            imageViewStation.image = imgStation
            UIHeader.addSubview(imageViewStation)
        case 1:
            var imgAlarm = UIImage(named: "inf00216")
            var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageViewAlarm.image = imgAlarm
            UIHeader.addSubview(imageViewAlarm)
        case 2:
            var imgAlarm = UIImage(named: "inf00215")
            var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageViewAlarm.image = imgAlarm
            UIHeader.addSubview(imageViewAlarm)
        case 3:
            var img = UIImage(named: "inf00217")
            var imageView = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageView.image = img
            UIHeader.addSubview(imageView)
        case 4:
            var img = UIImage(named: "inf00220")
            var imageView = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageView.image = img
            UIHeader.addSubview(imageView)
        case 5:
            var img = UIImage(named: "inf00218")
            var imageView = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageView.image = img
            UIHeader.addSubview(imageView)
        case 6:
            var img = UIImage(named: "inf00221")
            var imageView = UIImageView(frame: CGRectMake(15, 5, 25, 25))
            imageView.image = img
            UIHeader.addSubview(imageView)
        default:
            println("nothing")
        }
        var lblText = UILabel(frame: CGRect(x:50,y:5,width:tableView.frame.width - 100,height:25))
        if(section == 0){
            lblText.frame = CGRect(x:50,y:15,width:tableView.frame.width - 100,height:25)
        }else{
            lblText.frame = CGRect(x:50,y:5,width:tableView.frame.width - 100,height:25)
        }
        lblText.textColor = UIColor.lightGrayColor()
        lblText.font = UIFont.systemFontOfSize(15)
        lblText.text = items[section][0] as? String
        lblText.textAlignment = NSTextAlignment.Left
        UIHeader.addSubview(lblText)
        
        return UIHeader
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "LandMarkSearchCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }
        
        cell!.accessoryType = UITableViewCellAccessoryType.None
        for subview in cell!.contentView.subviews{
            if(subview.isKindOfClass(UIPickerView) || subview.isKindOfClass(UIButton)){
                subview.removeFromSuperview()
            }
        }
        
        switch indexPath.section{
        case 0:
            cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            
            if("\(items[indexPath.section][1][indexPath.row])" != "INF002_19".localizedString()){
                var btnAll:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                btnAll.frame = CGRect(x:tableView.frame.size.width - 50,y:7,width:30,height:30)
                //btnAll.setTitle("INF002_19".localizedString(), forState: UIControlState.Normal)
                btnAll.setBackgroundImage(UIImage(named: "inf00222"), forState: UIControlState.Normal)
                btnAll.tag = BTN_ALL
                
                btnAll.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell!.contentView.addSubview(btnAll)
            }
            
            if(indexPath.row == 1 && landMarkStatId == ""){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        case 1:
            cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            if(indexPath.row == 1){
                if(pickerViewIsOpen){
                    cell!.contentView.addSubview(pickerSpecialWard)
                }
            }else if(indexPath.row == 0){
                if("\(items[indexPath.section][1][indexPath.row])" != "INF002_19".localizedString()){
                    var btnAll:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                    btnAll.frame = CGRect(x:tableView.frame.size.width - 50,y:7,width:30,height:30)
                    //btnAll.setTitle("INF002_19".localizedString(), forState: UIControlState.Normal)
                    btnAll.setBackgroundImage(UIImage(named: "inf00222"), forState: UIControlState.Normal)
                    btnAll.tag = BTN_ALL_SPEACIAL
                    
                    btnAll.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell!.contentView.addSubview(btnAll)
                }
            }
            
        case 2:
            cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            if(indexPath.row == 3){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
            //        case 3:
            //            cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            //            if(indexPath.row == 0){
            //                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //            }else{
            //                cell.accessoryType = UITableViewCellAccessoryType.None
            //            }
            //        case 4:
            //            cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            //            if(indexPath.row == 0){
            //                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //            }else{
            //                cell.accessoryType = UITableViewCellAccessoryType.None
            //            }
            //        case 5:
            //            cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            //            if(indexPath.row == 0){
            //                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            //            }else{
            //                cell.accessoryType = UITableViewCellAccessoryType.None
            //            }
        case 6:
            cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            if(indexPath.row == 4){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        default:
            cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
            if(indexPath.row == 3){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell!
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

    
    /*******************************************************************************
    *      Implements Of UIPickerViewDelegate
    *******************************************************************************/

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(row < 9){
            landMarkSpecialWard = "0\(row + 1)"
            landMarkShowSpecialWard = "0\(row + 1)"
        }else{
            landMarkSpecialWard = "\(row + 1)"
            landMarkShowSpecialWard = "\(row + 1)"
        }
        loadItems()
        var indexPathSpecialWard = NSIndexPath(forRow: 0, inSection: 1)
        //tbList.reloadData()
        tbList.reloadRowsAtIndexPaths([indexPathSpecialWard], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    
    /*******************************************************************************
    *      Implements Of UIPickerViewDataSource
    *******************************************************************************/
    
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

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case SAVE_BUTTON_TAG:
            var controllers:AnyObject? = self.navigationController!.viewControllers
            var lastController:LandMarkListController = controllers![controllers!.count - 2] as LandMarkListController
            var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
            //var inf002Dao:INF002Dao = INF002Dao()
            switch landMarkType{
            case 0:
                lastController.landMarks = mstT04Table.queryLandMarksFilter("PUBLIC_12".localizedString(),lon: 0, lat: 0, distance: 0, sataId: landMarkStatId!, specialWard: landMarkSpecialWard!) as? Array<MstT04LandMarkTable>
            case 1:
                lastController.landMarks = mstT04Table.queryLandMarksFilter("INF002_08".localizedString(),lon: 0, lat: 0, distance: 0, sataId: landMarkStatId!, specialWard: landMarkSpecialWard!, subType:landMarkSubType, price:landMarkPrice, miciRank:landMarkMiciRank, rank:landMarkRank) as? Array<MstT04LandMarkTable>
            case 2:
                lastController.landMarks = mstT04Table.queryLandMarksFilter("PUBLIC_09".localizedString(),lon: 0, lat: 0, distance: 0, sataId: landMarkStatId!, specialWard: landMarkSpecialWard!) as? Array<MstT04LandMarkTable>
            default:
                println("nothing")
            }
            
            lastController.viewDidLoad()
            self.navigationController!.popViewControllerAnimated(true)
        case BTN_ALL:
            landMarkStatId = ""
            landMarkShowStatId = "INF002_19".localizedString()
            loadItems()
            tbList.reloadData()
        case BTN_ALL_SPEACIAL:
            landMarkSpecialWard = ""
            landMarkShowSpecialWard = "INF002_19".localizedString()
            loadItems()
            tbList.reloadData()
        default:
            println("nothing")
        }
    }
    
    func loadItems(){
        switch landMarkType{
        case 1:
            items = NSMutableArray.array()
            if(landMarkStatId != "" && landMarkStatId != nil){
                landMarkShowStatId = landMarkStatId!
                items.addObject(["PUBLIC_03".localizedString(),[landMarkShowStatId.station()]])
            }else{
                items.addObject(["PUBLIC_03".localizedString(),["INF002_19".localizedString()]])
            }
            
            if(landMarkSpecialWard == "" && landMarkStatId != nil){
                items.addObject(["INF002_12".localizedString(),["INF002_19".localizedString(),""]])
            }else{
                items.addObject(["INF002_12".localizedString(),[landMarkShowSpecialWard.specialWard(),""]])
            }
            items.addObject(["INF002_13".localizedString(),landMarksRange])
            items.addObject(["INF002_20".localizedString(),["INF002_21".localizedString(),"INF002_22".localizedString(),"INF002_23".localizedString(),"INF002_19".localizedString()]])
            var priceStr:String = "INF002_24".localizedString()
            items.addObject(["INF002_25".localizedString(),["5000" + priceStr,"1000" + priceStr,"INF002_26".localizedString(),"INF002_19".localizedString()]])
            items.addObject(["INF002_27".localizedString(), ["INF002_28".localizedString(),"INF002_29".localizedString(),"INF002_30".localizedString(),"INF002_19".localizedString()]])
            items.addObject(["INF002_10".localizedString(),["1-2分","2-3分","3-4分","4-5分","INF002_19".localizedString()]])
        default:
            items = NSMutableArray.array()
            if(landMarkStatId != ""){
                landMarkShowStatId = landMarkStatId!
                items.addObject(["PUBLIC_03".localizedString(),[landMarkShowStatId.station()]])
            }else{
                items.addObject(["PUBLIC_03".localizedString(),["INF002_19".localizedString()]])
            }
            if(landMarkSpecialWard == ""){
                items.addObject(["INF002_12".localizedString(),["INF002_19".localizedString(),""]])
            }else{
                items.addObject(["INF002_12".localizedString(),[landMarkShowSpecialWard.specialWard(),""]])
            }
            items.addObject(["INF002_13".localizedString(),landMarksRange])
        }
    }
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}