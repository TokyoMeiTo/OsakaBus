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
import AudioToolbox

/**
 * 编辑提醒
 */
class RemindDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    /* UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
    let USR002_MODEL:USR002Model = USR002Model()
    
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 100 */
    let NUM_100 = 100
    
    /* 添加 */
    let ADD = "USR002_08".localizedString()
    /* 编辑 */
    let EDIT = "USR002_09".localizedString()
    /* 编辑 */
    let PICKERVIEW_STRING = "pickerview"
    /* 确定删除本条提醒？ */
    let MSG_0001 = "USR002_10".localizedString()
    /* 通知 */
    let MSG_0002 = "USR002_18".localizedString()
    /* 确定 */
    let MSG_0003 = "PUBLIC_06".localizedString()
    /* 取消 */
    let MSG_0004 = "PUBLIC_07".localizedString()
    /* 确定添加本条提醒？ */
    let MSG_0005 = "USR002_10".localizedString()
    /* 确定添加本条提醒？ */
    let MSG_0006 = "USR002_11".localizedString()
    
    let SAVE_BUTTON_TAG:Int = 200201
    let DELETE_BUTTON_TAG:Int = 200202
    let BACK_BUTTON_TAG:Int = 200203

    /*******************************************************************************
    * Public Properties
    *******************************************************************************/

    /* 上一个页面是否查找站点 */
    var isSearsh:Bool = false
    /* 选择的线路id */
    var selectLineId:String?
    /* 选择的线路站点id */
    var selectStationId:String?
    /* 线路画面站点id */
    var routeStatTable01:MstT02StationTable?
    var routeStatTable02:MstT02StationTable?

    /* UsrT01ArrivalAlarmTable 参数 */
    var usrT01Data: UsrT01ArrivalAlarmTableData?
    /* UsrT02TrainAlarmTable 参数 */
    var usrT02Data: UsrT02TrainAlarmTableData?
    
    var endLineId:String?
    var endStationId:String?
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    var mUsr002Model:USR002Model = USR002Model()
    
    /* 站点UIPickerView */
    var pickStations: UIPickerView = UIPickerView()
    /* 上车站点UIPickerView */
    var pickFromStations: UIPickerView = UIPickerView()
    /* 站点UIPickerView */
    var pickLineStations: Array<UIPickerView> = Array<UIPickerView>()
    
    /* segIndex */
    var segIndex:Int?
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* lines */
    var mLines:Array<MstT01LineTableData>?
    /* stations */
    var stations:Array<MstT02StationTable> = Array<MstT02StationTable>()
    /* fromStations */
    var fromStations:Array<MstT02StationTable> = Array<MstT02StationTable>()
    /* 提醒方式 */
    var remindsMethod:Array<String> = ["USR002_01".localizedString(),"USR002_02".localizedString()]
    /* 提醒时间 */
    var remindsTimeArrive:Array<String> = ["1分钟","2分钟","3分钟","4分钟","5分钟"]
    /* 提醒时间 */
    var remindsTime:Array<String> = ["5分钟","15分钟","20分钟","25分钟","30分钟"]
    /* line */
    var line:String = "LINE_28001".localizedString()
    /* station */
    var station:String = "STATION_2800101".localizedString()
    /* fromStation */
    var fromStation:String = "STATION_2800101".localizedString()
    /* station */
    var stationDirt0:String = "STATION_2800101".localizedString()
    /* station */
    var stationDirt1:String = "STATION_2800119".localizedString()
    /* station */
    var stationDirtFlag:Int = 0
    /* station */
    var traiDirt0:String = "2800101"
    /* station */
    var traiDirt1:String = "2800119"
    /* 提醒方式 */
    var remindType:Int = 0
    /* 提醒时间 */
    var remindTime:Int = 0
    /* pickerview高度 */
    var pickerViewHeight:CGFloat = 0
    /* pickerview */
    var pickerViewSection:Int = 0
    /* 选择的线路站点id */
    var statToId:String = "2800101"
    
    var mLineshow01:String = "LINE_28001".localizedString()
    var mLineshow02:String = "LINE_28001".localizedString()
    
    var mEditFlag:Bool = false
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 画面内容变更
        // 设置数据
        intitValue()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if(usrT02Data != nil && mEditFlag){
            saveLastMetro()
        }
    }

    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(segIndex == NUM_0){
            if(didSelectRowAtIndexPath.section == 0 || didSelectRowAtIndexPath.section == 1){
                setTableCellHeight(didSelectRowAtIndexPath)
                //                self.pickerViewSection = didSelectRowAtIndexPath.section
                //                var searchStationList = self.storyboard!.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
                //                searchStationList.classType = "remindDetailController"
                //                self.navigationController!.pushViewController(searchStationList, animated:true)
                return
            }
        }else if(segIndex == NUM_1){
            if(didSelectRowAtIndexPath.section == 0){
                setTableCellHeight(didSelectRowAtIndexPath)
                //                self.pickerViewSection = didSelectRowAtIndexPath.section
                //                var searchStationList = self.storyboard!.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
                //                searchStationList.classType = "remindDetailController"
                //                self.navigationController!.pushViewController(searchStationList, animated:true)
                return
            }
        }
        
        if(segIndex == NUM_0){
            if(didSelectRowAtIndexPath.section == 2){
                remindType = didSelectRowAtIndexPath.row
                // 提醒方式
                if(remindType == NUM_0){
                    usrT01Data!.beepFlag = "1"
                    usrT01Data!.voleFlag = "0"
                    pushNotification(nil, min: -1, beep: true)
                }else{
                    usrT01Data!.beepFlag = "0"
                    usrT01Data!.voleFlag = "1"
                    pushNotification(nil, min: -1, beep: false)
                }
            }else if(didSelectRowAtIndexPath.section == 3){
                remindTime = didSelectRowAtIndexPath.row
                // 提醒时间
                usrT01Data!.alarmTime = "\((remindTime + 1) * 60)"
            }
        }else if(segIndex == NUM_1){
            if(didSelectRowAtIndexPath.section == 3){
                remindType = didSelectRowAtIndexPath.row
                // 提醒方式
                if(remindType == NUM_0){
                    usrT02Data!.beepFlag = "1"
                    usrT02Data!.voleFlag = "0"
                    pushNotification(nil, min: -1, beep: true)
                }else{
                    usrT02Data!.beepFlag = "0"
                    usrT02Data!.voleFlag = "1"
                    pushNotification(nil, min: -1, beep: false)
                }
            }else if(didSelectRowAtIndexPath.section == 4){
                remindTime = didSelectRowAtIndexPath.row
                // 提醒时间
                usrT02Data!.alarmTime = "\((remindTime + 1) * 600)"
            }else if(didSelectRowAtIndexPath.section == 1){
                stationDirtFlag = didSelectRowAtIndexPath.row
                if(stationDirtFlag == 0){
                    usrT02Data!.traiDirt = traiDirt0
                }else{
                    usrT02Data!.traiDirt = traiDirt1
                }
            }else if(didSelectRowAtIndexPath.section == 2){
                if(didSelectRowAtIndexPath.row == 0){
                    usrT02Data!.alamType = "1"
                }else{
                    usrT02Data!.alamType = "9"
                }
            }
        }
        
        for(var i=0; i < items[didSelectRowAtIndexPath.section][1].count;i++){
            var indexPath = NSIndexPath(forRow: i, inSection: didSelectRowAtIndexPath.section)
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            if(cell != nil){
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)!.accessoryType =
            UITableViewCellAccessoryType.Checkmark
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 54
        }
        return 44
    }
    
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section][0] as? String
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var UIHeader:UIView = UIView()
        if(segIndex == NUM_0){
            if(section == 0){
                var imgStationTo = UIImage(named: "USR00204")
                var imageViewStationTo = UIImageView(frame: CGRectMake(15, 15, 25, 25))
                imageViewStationTo.image = imgStationTo
                UIHeader.addSubview(imageViewStationTo)
            }else if(section == 1){
                var imgStationFrom = UIImage(named: "USR00205")
                var imageViewStationFrom = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewStationFrom.image = imgStationFrom
                UIHeader.addSubview(imageViewStationFrom)
            }else{
                var imgAlarm = UIImage(named: "USR00206")
                var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewAlarm.image = imgAlarm
                UIHeader.addSubview(imageViewAlarm)
            }
        }else if(segIndex == NUM_1){
            if(section == 0){
                var imgStationTo = UIImage(named: "USR00204")
                var imageViewStationTo = UIImageView(frame: CGRectMake(15, 15, 25, 25))
                imageViewStationTo.image = imgStationTo
                UIHeader.addSubview(imageViewStationTo)
            }else{
                var imgAlarm = UIImage(named: "USR00206")
                var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewAlarm.image = imgAlarm
                UIHeader.addSubview(imageViewAlarm)
            }
        }
        
        var lblText = UILabel(frame: CGRect(x:50,y:15,width:tableView.frame.width - 100,height:25))
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
        let cellIdentifier:String = "AlarmDetailCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }
        
        cell!.accessoryType = UITableViewCellAccessoryType.None
        for subview in cell!.contentView.subviews{
            if(subview.isKindOfClass(UIPickerView)){
                subview.removeFromSuperview()
            }
        }
        if(segIndex == NUM_0){
            if(indexPath.section == 2 && indexPath.row == remindType){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.section == 3 && indexPath.row == remindTime){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 1){
                cell!.contentView.addSubview(pickLineStations[indexPath.section])
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }else if(segIndex == NUM_1){
            if(indexPath.section == 3 && indexPath.row == remindType){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.section == 4 && indexPath.row == remindTime){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 0) && indexPath.row == 1){
                cell!.contentView.addSubview(pickLineStations[indexPath.section])
            }else if((indexPath.section == 1) && indexPath.row == stationDirtFlag){
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 2)){
                if(indexPath.row == 0 && usrT02Data!.alamType == "1"){
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else if(indexPath.row == 1 && usrT02Data!.alamType == "9"){
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        cell!.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    /*******************************************************************************
    *      Implements Of UIPickerViewDelegate
    *******************************************************************************/

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView == pickStations){
            if(component == NUM_0){
                // 线路
                line = "\(mLines![row].lineId)".line()
                // 站点
                stations = selectStationTable(mLines![row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                mLineshow01 = line
                station = "\(stations[NUM_0].statId)".station()
                var stationsDirt = selectStationTableDirt(mLines![row].lineId)
                stationDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))".station()
                stationDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))".station()
                traiDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))"
                traiDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))"
                if(segIndex == NUM_0){
                    statToId = stations[NUM_0].statId
                    usrT01Data!.lineToId = mLines![row].lineId
                    usrT01Data!.statToId = stations[NUM_0].statId
                }else if(segIndex == NUM_1){
                    usrT02Data!.lineId = mLines![row].lineId
                    usrT02Data!.statId = stations[NUM_0].statId
                    usrT02Data!.traiDirt = "\(stationsDirt[1].item(MSTT02_STAT_ID))"
                }
            }else{
                if(row < stations.count){
                    mLineshow01 = line
                    station = "\(stations[row].statId)".station()
                    if(segIndex == NUM_0){
                        statToId = stations[row].statId
                        usrT01Data!.statToId = stations[row].statId
                    }else if(segIndex == NUM_1){
                        usrT02Data!.statId = stations[row].statId
                    }
                }
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                // 线路
                line = mLines![row].lineId.line()
                usrT01Data!.lineFromId = mLines![row].lineId
                // 站点
                fromStations = selectStationTable(mLines![row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                mLineshow02 =  mLines![row].lineId.line()
                fromStation = fromStations[NUM_0].statId.station()
                usrT01Data!.statFromId = fromStations[NUM_0].statId
            }else{
                if(row < fromStations.count){
                    mLineshow02 = line
                    fromStation = "\(fromStations[row].statId)".station()
                    usrT01Data!.statFromId = fromStations[row].statId
                }
            }
        }
        if(segIndex == NUM_0){
            loadArriveStationItems()
        }else if(segIndex == NUM_1){
            loadLastMetroItems()
        }
        tbList.reloadData()
    }

    
    /*******************************************************************************
    *      Implements Of UIPickerViewDataSource
    *******************************************************************************/

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        var title = ""
        if(pickerView == pickStations){
            if(component == NUM_0){
                if(row < mLines!.count){
                    title = "\(mLines![row].lineId)".line()
                }
            }else{
                if(row < stations.count){
                    title = "\(stations[row].statId)".station()
                }
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                if(row < mLines!.count){
                    title = "\(mLines![row].lineId)".line()
                }
            }else{
                if(row < fromStations.count){
                    title = "\(fromStations[row].statId)".station()
                }
            }
        }
        return title
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView == pickStations){
            if(component == NUM_0){
                return mLines!.count
            }else{
                return stations.count
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                return mLines!.count
            }else{
                return stations.count
            }
        }
        return 0
    }

    
    /*******************************************************************************
    *      Implements Of UIAlertViewDelegate
    *******************************************************************************/

    // after animation
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int){
        switch buttonIndex{
        case NUM_0:
            // 删除本条提醒
            mUsr002Model.deleteUsrT02(usrT02Data!)
//            var controllers:AnyObject? = self.navigationController!.viewControllers
//            if(controllers!.count > 1){
//                var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
//                lastController.viewDidLoad()
//            }
            self.navigationController!.popViewControllerAnimated(true)
        default:
            println("nothing")
        }
    }

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     *
     */
    func intitValue(){
        self.navigationItem.leftBarButtonItem = nil
 
        // 查询线路
        mLines = USR002_MODEL.findLineTable()

        if(segIndex == NUM_0){
            editArriveStation()
        }else if(segIndex == NUM_1){
            editLastMetro()
        }
    }
    
    func initArriveAlarm(mUsrT01Data:UsrT01ArrivalAlarmTableData?){
        if(usrT01Data == nil){
            return
        }
        mUsrT01Data!.lineFromId = "28001"
        mUsrT01Data!.statFromId = "2800101"
        mUsrT01Data!.lineToId = "28001"
        mUsrT01Data!.statToId = "2800101"
        mUsrT01Data!.traiDirt = "2800119"
        mUsrT01Data!.beepFlag = "1"
        mUsrT01Data!.voleFlag = "0"
        mUsrT01Data!.costTime = "0"
        mUsrT01Data!.alarmTime = "0"
        mUsrT01Data!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
        mUsrT01Data!.onboardTime = "000000000000"
        mUsrT01Data!.cancelFlag = "0"
        mUsrT01Data!.cancelTime = "00000000000000"

    }
 
    func initUsrT01Data(mUsrT01Data:UsrT01ArrivalAlarmTableData?){
        if(usrT01Data == nil){
            return
        }
        mUsrT01Data!.lineFromId = usrT01Data!.lineFromId
        mUsrT01Data!.statFromId = usrT01Data!.statFromId
        mUsrT01Data!.lineToId = usrT01Data!.lineToId
        mUsrT01Data!.statToId = usrT01Data!.statToId
        mUsrT01Data!.traiDirt = usrT01Data!.traiDirt
        mUsrT01Data!.beepFlag = usrT01Data!.beepFlag
        mUsrT01Data!.voleFlag = usrT01Data!.voleFlag
        mUsrT01Data!.costTime = usrT01Data!.costTime
        mUsrT01Data!.alarmTime = usrT01Data!.alarmTime
        mUsrT01Data!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
        mUsrT01Data!.onboardTime = "000000000000"
        mUsrT01Data!.cancelFlag = "0"
        mUsrT01Data!.cancelTime = "00000000000000"
        
    }
    
    func initLastAlarm(mUsrT02Data:UsrT02TrainAlarmTableData?){
        if(mUsrT02Data == nil){
            return
        }
        mUsrT02Data!.lineId = "28001"
        mUsrT02Data!.statId = "2800101"
        mUsrT02Data!.alamType = "9"
        mUsrT02Data!.alamTime = "2310"
        mUsrT02Data!.alamFlag = "1"
        mUsrT02Data!.traiDirt = "2800119"
        mUsrT02Data!.beepFlag = "1"
        mUsrT02Data!.voleFlag = "0"
        mUsrT02Data!.alarmTime = "0"
        mUsrT02Data!.saveTime = "00000000000000"
    }
    
    /**
     * 编辑到站提醒
     */
    func editArriveStation(){
        self.title = "编辑"
        self.navigationItem.rightBarButtonItem = nil
        // 完成按钮点击事件
        var saveButton:UIBarButtonItem = UIBarButtonItem(title: "USR002_06".localizedString(), style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem!.tag = SAVE_BUTTON_TAG
        
        self.navigationItem.leftBarButtonItem = nil
        
        if(usrT01Data == nil){
            self.title = "添加"
            usrT01Data = UsrT01ArrivalAlarmTableData()
            initArriveAlarm(usrT01Data!)
        }
        
        if(!(endLineId == nil) && !(endStationId == nil)){
            usrT01Data!.lineToId = endLineId!
            usrT01Data!.statToId = endStationId!
            // 线路
            line = endLineId!.line()
            statToId = endStationId!
        }
        
        if(fromRoute() && routeStatTable01!.item(MSTT02_STAT_ID) != nil && routeStatTable02!.item(MSTT02_STAT_ID) != nil){
            usrT01Data!.statFromId = "\(routeStatTable01!.item(MSTT02_STAT_ID))"
            usrT01Data!.lineFromId = "\(routeStatTable01!.item(MSTT02_LINE_ID))"
            usrT01Data!.statToId = "\(routeStatTable02!.item(MSTT02_STAT_ID))"
            usrT01Data!.lineToId = "\(routeStatTable02!.item(MSTT02_LINE_ID))"
            // 线路
            line = "\(routeStatTable02!.item(MSTT02_LINE_ID))".line()
            statToId = "\(routeStatTable02!.item(MSTT02_STAT_ID))"
        }
        
        if(usrT01Data!.statToId != ""){
            station = usrT01Data!.statToId.station()
        }
        if(usrT01Data!.statFromId != ""){
            fromStation = usrT01Data!.statFromId.station()
        }
        if(usrT01Data!.beepFlag == "1"){
            remindType = 0
        }else{
            remindType = 1
        }
        if(usrT01Data!.alarmTime != "0" && usrT01Data!.alarmTime != ""){
            remindTime = (usrT01Data!.alarmTime as NSString).integerValue / 60 - 1
        }
        
        // 到达站点
        stations = selectStationTable(usrT01Data!.lineToId)
        
        mLineshow01 = usrT01Data!.lineToId.line()
        
        mLineshow02 = usrT01Data!.lineFromId.line()
        // 上车站点
        fromStations = selectStationTable(usrT01Data!.lineFromId)
        
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
        
        // 查询线路
        var lineIndexTo:Int = getLineIndex(usrT01Data!.lineToId)
        // 查询站点
        var stationIndexTo:Int = getStationIndex(usrT01Data!.lineToId, statId: usrT01Data!.statToId)
        
        pickStations.selectRow(lineIndexTo, inComponent: NUM_0, animated: false)
        pickStations.selectRow(stationIndexTo, inComponent: NUM_1, animated: false)
        
        // 查询线路
        var lineIndexFrom: Int = getLineIndex(usrT01Data!.lineFromId)
        // 查询站点
        var stationIndexFrom:Int = getStationIndex(usrT01Data!.lineFromId, statId: usrT01Data!.statFromId)
        
        pickFromStations.selectRow(lineIndexFrom, inComponent: NUM_0, animated: false)
        pickFromStations.selectRow(stationIndexFrom, inComponent: NUM_1, animated: false)
    }
    
    /**
     * 编辑末班车提醒
     */
    func editLastMetro(){
        self.title = "编辑"
        // 删除按钮点击事件
        var delButton:UIBarButtonItem! = self.navigationItem.rightBarButtonItem
        if(delButton != nil){
            delButton.tag = DELETE_BUTTON_TAG
            delButton.target = self
            delButton.action = "buttonAction:"
        }
        
        mEditFlag = true
        
        if(usrT02Data == nil){
            mEditFlag = false
            self.title = "添加"
            self.navigationItem.rightBarButtonItem = nil
            // 完成按钮点击事件
            var saveButton:UIBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
            self.navigationItem.rightBarButtonItem = saveButton
            self.navigationItem.rightBarButtonItem!.tag = SAVE_BUTTON_TAG

            self.navigationItem.leftBarButtonItem = nil
            
            usrT02Data = UsrT02TrainAlarmTableData()
            initLastAlarm(usrT02Data!)
        }
        
        if(isSearsh){
            usrT02Data!.lineId = selectLineId!
            usrT02Data!.statId = selectStationId!
        }
        
        if(usrT02Data!.statId != ""){
            station = usrT02Data!.statId.station()
        }
        if(usrT02Data!.beepFlag == "1"){
            remindType = 0
        }else{
            remindType = 1
        }
        if(usrT02Data!.alarmTime != "0"){
            remindTime = (usrT02Data!.alarmTime as NSString).integerValue / 600 - 1
        }
        
        var stationsDirt = selectStationTableDirt(usrT02Data!.lineId)
        
        stationDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))".station()
        stationDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))".station()
        traiDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))"
        traiDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))"
        
        if(usrT02Data!.traiDirt == "\(stationsDirt[0].item(MSTT02_STAT_ID))"){
            stationDirtFlag = 0
        }else if(usrT02Data!.traiDirt == "\(stationsDirt[1].item(MSTT02_STAT_ID))"){
            stationDirtFlag = 1
        }
        
        // 到达站点
        stations = selectStationTable(usrT02Data!.lineId)
        
        loadLastMetroItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
        
        pickStations.hidden = true
        pickStations.delegate = self
        pickStations.dataSource = self
        
        pickLineStations.append(pickStations)
        
        // 查询线路
        var lineIndex: Int = getLineIndex(usrT02Data!.lineId)
        // 查询站点
        var stationIndex:Int = getStationIndex(usrT02Data!.lineId, statId: usrT02Data!.statId)
        
        pickStations.selectRow(lineIndex, inComponent: NUM_0, animated: false)
        pickStations.selectRow(stationIndex, inComponent: NUM_1, animated: false)
    }
    
    /**
     * 保存到站提醒
     */
    func saveArriveStation(){
        if(usrT01Data!.statFromId == "2800101" && usrT01Data!.statToId == "2800101"){
            self.navigationController!.popViewControllerAnimated(true)
            return
        }

        var routeDetails:Array<LinT05RouteDetailTable>? = selectLinT05RouteDetailTable(usrT01Data!.statFromId, toStationId: usrT01Data!.statToId)
        
        if(routeDetails == nil || routeDetails!.count < 1){
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0006,buttons:[MSG_0003], delegate: nil)
            self.navigationController!.popViewControllerAnimated(true)
            return
        }
        
        deleteAlarm()
        
        // 删除失败
        var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
        if(!(alarms == nil) && alarms!.count > 1){
            return
        }
        
        var tableLinT04:LinT04RouteTable? = findRoute04(usrT01Data!.statFromId, toStationId: usrT01Data!.statToId)
        
        var statFrom:String?
        var lineFrom:String?
//        var statTo:String?
        var metroRoutes:Array<LinT05RouteDetailTable>? = Array<LinT05RouteDetailTable>()
        for routeDetail in routeDetails!{
            if(routeDetail.exchType == nil || routeDetail.exchType == "255" || routeDetail.exchType == "0"){
                continue
            }
            metroRoutes!.append(routeDetail)
        }
        var metroRoutesNoFirst:Array<LinT05RouteDetailTable>? = Array<LinT05RouteDetailTable>()
        for(var i=0;i<routeDetails!.count;i++){
            var routeDetail:LinT05RouteDetailTable = routeDetails![i]
            if(i == 0 && (routeDetail.exchType == nil || routeDetail.exchType == "255" || routeDetail.exchType == "0")){
                continue
            }
            metroRoutesNoFirst!.append(routeDetail)
        }
        for(var i=0;i<metroRoutesNoFirst!.count;i++){
            var routeDetail:LinT05RouteDetailTable = metroRoutesNoFirst![i]
            if(routeDetail.exchType == nil || routeDetail.exchType == "255"){
//                statFrom = routeDetail.exchStatId
                continue
            }
            statFrom = routeDetail.exchStatId
            lineFrom = routeDetail.exchLineId
            var costTime:Int = ("\(routeDetail.item(LINT05_ROUTE_DETAIL_MOVE_TIME))" as NSString).integerValue * 60
            // 不需要换乘
            if(i == 0 && metroRoutes!.count < 2){
                var mUsrT01Data:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
                initUsrT01Data(mUsrT01Data!)
                mUsrT01Data!.costTime = "\(costTime)"
                mUsrT01Data!.arriAlamId = "1"
                if(!(statFrom == nil)){
                    mUsrT01Data!.statFromId = statFrom!
                }
                if(!(lineFrom == nil)){
                    mUsrT01Data!.lineFromId = lineFrom!
                }
                if(!(routeDetail.exchDestId == nil)){
                    mUsrT01Data!.traiDirt = routeDetail.exchDestId
                }
                if(!(tableLinT04 == nil)  && !(tableLinT04!.termStatId == nil)){
                    mUsrT01Data!.statToId = tableLinT04!.termStatId
                    mUsrT01Data!.lineToId = USR002_MODEL.findStationTableOne(tableLinT04!.termStatId).lineId
                }
                if(mUsr002Model.insertUsrT01(mUsrT01Data!)){
                    if(fromRoute()){
                        var remindListController: RemindListController = self.storyboard?.instantiateViewControllerWithIdentifier("RemindListController") as RemindListController
                        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
                        self.navigationItem.backBarButtonItem = backButton
                        self.navigationController?.pushViewController(remindListController, animated: true)
                    }else{
                        var controllers:AnyObject? = self.navigationController!.viewControllers
                        if(controllers!.count > 1){
                            var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                            lastController.viewDidLoad()
                        }
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                    break
                }
            }
            // 需要换乘,起点
            if(i == 0 && metroRoutes!.count > 1){
                var mUsrT01Data:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
                initUsrT01Data(mUsrT01Data!)
                mUsrT01Data!.costTime = "\(costTime)"
                mUsrT01Data!.arriAlamId = "1"
                if(!(statFrom == nil)){
                    mUsrT01Data!.statFromId = statFrom!
                }
                if(!(lineFrom == nil)){
                    mUsrT01Data!.lineFromId = lineFrom!
                }
                if(!(routeDetail.exchDestId == nil)){
                    mUsrT01Data!.traiDirt = routeDetail.exchDestId
                }
                if(i + 1 < metroRoutesNoFirst!.count){
                    if(!(metroRoutesNoFirst![i+1].exchStatId == nil)){
                        mUsrT01Data!.statToId = metroRoutesNoFirst![i+1].exchStatId
                        mUsrT01Data!.lineToId = USR002_MODEL.findStationTableOne(metroRoutesNoFirst![i+1].exchStatId).lineId
                    }
                }
                
                mUsr002Model.insertUsrT01(mUsrT01Data!)
                continue
            }
            // 需要换乘,中间站点
            if(!(i == 0) && i < routeDetails!.count - 2){
                var mUsrT01Data:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
                initUsrT01Data(mUsrT01Data!)
                mUsrT01Data!.costTime = "\(costTime)"
                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
                mUsrT01Data!.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
                if(!(statFrom == nil)){
                    mUsrT01Data!.statFromId = statFrom!
                }
                if(!(lineFrom == nil)){
                    mUsrT01Data!.lineFromId = lineFrom!
                }
                if(!(routeDetail.exchDestId == nil)){
                    mUsrT01Data!.traiDirt = routeDetail.exchDestId
                }
                if(i + 1 < metroRoutesNoFirst!.count){
                    if(!(metroRoutesNoFirst![i+1].exchStatId == nil)){
                        mUsrT01Data!.statToId = metroRoutesNoFirst![i+1].exchStatId
                        mUsrT01Data!.lineToId = USR002_MODEL.findStationTableOne(metroRoutesNoFirst![i+1].exchStatId).lineId
                    }
                }
                
                mUsr002Model.insertUsrT01(mUsrT01Data!)
                continue
            }
            // 需要换乘,终点
            if(i == routeDetails!.count - 2){
                var mUsrT01Data:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
                initUsrT01Data(mUsrT01Data!)
                mUsrT01Data!.costTime = "\(costTime)"
                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
                mUsrT01Data!.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
                if(!(statFrom == nil)){
                    mUsrT01Data!.statFromId = statFrom!
                }
                if(!(lineFrom == nil)){
                    mUsrT01Data!.lineFromId = lineFrom!
                }
                if(!(routeDetail.exchDestId == nil)){
                    mUsrT01Data!.traiDirt = routeDetail.exchDestId
                }
                if(!(tableLinT04 == nil)  && !(tableLinT04!.termStatId == nil)){
                    mUsrT01Data!.statToId = tableLinT04!.termStatId
                    mUsrT01Data!.lineToId = USR002_MODEL.findStationTableOne(tableLinT04!.termStatId).lineId
                }
                if(mUsr002Model.insertUsrT01(mUsrT01Data!)){
                    if(fromRoute()){
                        var remindListController: RemindListController = self.storyboard?.instantiateViewControllerWithIdentifier("RemindListController") as RemindListController
                        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
                        self.navigationItem.backBarButtonItem = backButton
                        self.navigationController?.pushViewController(remindListController, animated: true)
                    }else{
                        var controllers:AnyObject? = self.navigationController!.viewControllers
                        if(controllers!.count > 1){
                            var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                            lastController.viewDidLoad()
                        }
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                    break
                }
            }
        }
        
        
//        for(var i=0;i<routeDetails!.count;i++){
//            var routeDetail:LinT05RouteDetailTable = routeDetails![i]
//            var costTime:Int = ("\(routeDetail.item(LINT05_ROUTE_DETAIL_MOVE_TIME))" as NSString).integerValue * 60
//            if(i == 0){
//                usrT01Data!.costTime = "\(costTime)"
//                usrT01Data!.arriAlamId = "1"
//                if(routeDetails!.count > 2){
//                    if(routeDetails![i+1].exchStatId != nil){
//                        usrT01Data!.statToId = routeDetails![i+1].exchStatId
//                    }
//                    if(routeDetails![i].exchLineId != nil){
//                        usrT01Data!.lineToId = routeDetails![i].exchLineId
//                    }
//                    mUsr002Model.insertUsrT01(usrT01Data!)
//                }else{
//                    mUsr002Model.insertUsrT01(usrT01Data!)
//                    var controllers:AnyObject? = self.navigationController!.viewControllers
//                    if(controllers!.count > 1){
//                        var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
//                        lastController.viewDidLoad()
//                    }
//                    self.navigationController!.popViewControllerAnimated(true)
//                }
//            }else if(i == routeDetails!.count - 2 && routeDetails!.count > 1){
//                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
//                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
//                var mUsrT01ArriveData:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
//                
//                initArriveAlarm(mUsrT01ArriveData!)
//                
//                mUsrT01ArriveData!.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
//                if(routeDetails![i-1].exchLineId != nil){
//                    mUsrT01ArriveData!.lineFromId = routeDetails![i-1].exchLineId
//                }
//                if(routeDetails![i].exchStatId != nil){
//                    mUsrT01ArriveData!.statFromId = routeDetails![i].exchStatId
//                }
//                if(routeDetails![i].exchLineId != nil){
//                    mUsrT01ArriveData!.lineToId = routeDetails![i].exchLineId
//                }
//                if(routeDetails![i].exchDestId != nil){
//                    mUsrT01ArriveData!.traiDirt = routeDetails![i].exchDestId
//                }
//                mUsrT01ArriveData!.statToId = statToId
//                mUsrT01ArriveData!.costTime = "\(costTime)"
//                mUsr002Model.insertUsrT01(mUsrT01ArriveData!)
//
//                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//                appDelegate.isShow = true
//                
//                if(fromRoute()){
//                    var remindListController: RemindListController = self.storyboard?.instantiateViewControllerWithIdentifier("RemindListController") as RemindListController
//                    var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
//                    self.navigationItem.backBarButtonItem = backButton
//                    self.navigationController?.pushViewController(remindListController, animated: true)
//                }else{
//                    var controllers:AnyObject? = self.navigationController!.viewControllers
//                    if(controllers!.count > 1){
//                        var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
//                        lastController.viewDidLoad()
//                    }
//                    self.navigationController!.popViewControllerAnimated(true)
//                }
//            }else if(i < routeDetails!.count - 1){
//                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
//                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
//                var mUsrT01Data:UsrT01ArrivalAlarmTableData? = UsrT01ArrivalAlarmTableData()
//                
//                initArriveAlarm(mUsrT01Data!)
//                if(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID) != nil){
//                     mUsrT01Data!.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
//                }
//                if(routeDetails![i-1].exchLineId != nil){
//                    mUsrT01Data!.lineFromId = routeDetails![i-1].exchLineId
//                }
//                if(routeDetails![i].exchStatId != nil){
//                    mUsrT01Data!.statFromId = routeDetails![i].exchStatId
//                }
//                if(routeDetails![i+1].exchLineId != nil){
//                    mUsrT01Data!.lineToId = routeDetails![i+1].exchLineId
//                }else if(routeDetails![i].exchLineId != nil){
//                    mUsrT01Data!.lineToId = routeDetails![i].exchLineId
//                }
//                if(routeDetails![i+1].exchStatId != nil){
//                    mUsrT01Data!.statToId = routeDetails![i+1].exchStatId
//                }
//                mUsrT01Data!.costTime = "\(costTime)"
//                mUsr002Model.insertUsrT01(mUsrT01Data!)
//            }
//            
//        }
    }
    
    /**
     * 保存末班车提醒
     */
    func saveLastMetro(){
        var trainAlarms:Array<UsrT02TrainAlarmTable>? = selectTrainAlarmTable()
        var usr002Dao:USR002DAO = USR002DAO()
        // "\((selectStationTableOne(usrT02Data!.statId) as MstT02StationTable).item(MSTT02_STAT_ID))"
        usrT02Data!.alamTime = usr002Dao.queryDepaTime(usrT02Data!.lineId, statId: usrT02Data!.statId, destId: usrT02Data!.traiDirt, trainFlag: usrT02Data!.alamType, scheType: "1")
        if(usrT02Data!.alamTime == ""){
            RemindDetailController.showMessage(MSG_0002, msg:"USR002_05".localizedString(),buttons:[MSG_0003], delegate: nil)
            mEditFlag = false
            //self.navigationController!.popViewControllerAnimated(true)
            return
        }
        if(trainAlarms!.count > 0){
            if(usrT02Data!.rowid == ""){
                usrT02Data!.traiAlamId = "\(trainAlarms![trainAlarms!.count - 1].item(USRT02_TRAIN_ALARM_TRAI_ALAM_ID).integerValue + 1)"
                usrT02Data!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                if(mUsr002Model.insertUsrT02(usrT02Data!)){
                    var controllers:AnyObject? = self.navigationController!.viewControllers
                    if(controllers!.count > 1){
                        var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                        lastController.viewDidLoad()
                    }
                    self.navigationController!.popViewControllerAnimated(true)
                }else{
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }else{
                usrT02Data!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                if(mUsr002Model.updateUsrT02(usrT02Data!)){
//                    var controllers:AnyObject? = self.navigationController!.viewControllers
//                    if(controllers!.count > 1){
//                        var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
//                        lastController.viewDidLoad()
//                    }
                    //self.navigationController!.popViewControllerAnimated(true)
                }else{
                    //self.navigationController!.popViewControllerAnimated(true)
                }
            }
        }else{
            usrT02Data!.traiAlamId = "1"
            usrT02Data!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
            if(mUsr002Model.insertUsrT02(usrT02Data!)){
                var controllers:AnyObject? = self.navigationController!.viewControllers
                if(controllers!.count > 1){
                    var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                    lastController.viewDidLoad()
                }
                self.navigationController!.popViewControllerAnimated(true)
            }else{
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }
    
    /**
     * 加载items
     */
    func loadArriveStationItems(){
        items = NSMutableArray.array()
        items.addObject(["USR002_12".localizedString(),[mLineshow01 + " " + station,""]])
        items.addObject(["USR002_13".localizedString(),[mLineshow02 + " " + fromStation,""]])
        items.addObject(["USR002_14".localizedString(),remindsMethod])
        items.addObject(["USR002_15".localizedString(),remindsTimeArrive])
    }
    
    /**
     * 加载items
     */
    func loadLastMetroItems(){
        items = NSMutableArray.array()
        items.addObject(["USR002_12".localizedString(),[mLineshow01 + " " + station,""]])
        items.addObject(["PUBLIC_04".localizedString() + ":",[stationDirt0 + "PUBLIC_04".localizedString(),stationDirt1 + "PUBLIC_04".localizedString()]])
        items.addObject(["USR002_07".localizedString(),["USR002_03".localizedString(), "USR002_04".localizedString()]])
        items.addObject(["USR002_14".localizedString(),remindsMethod])
        items.addObject(["USR002_15".localizedString(),remindsTime])
    }
    
    /**
    * ボタン点击事件
    * @param sender
    */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case SAVE_BUTTON_TAG:
            // 保存末班车提醒
            if(segIndex == NUM_0){
                // 保存到站提醒
                saveArriveStation()
            }else if(segIndex == NUM_1){
                // 保存末班车提醒
                saveLastMetro()
            }
//        case BACK_BUTTON_TAG:
//            self.navigationController!.popViewControllerAnimated(true)
//        case self.navigationItem.leftBarButtonItem!.tag:
//            if(segIndex == NUM_0){
//                // 保存到站提醒
//                saveArriveStation()
//            }else if(segIndex == NUM_1){
//                // 保存末班车提醒
//                saveLastMetro()
//            }
        case self.navigationItem.rightBarButtonItem!.tag:
            mEditFlag = false
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0001,buttons:[MSG_0003, MSG_0004], delegate: self)
        default:
            println("nothing")
        }
    }
    
    /**
     * 从线路选择画面过来
     */
    func fromRoute() -> Bool{
        return routeStatTable01 != nil && routeStatTable02 != nil
    }
    
    func isNilStat(lintTable05: LinT05RouteDetailTable) -> Bool{
        return lintTable05.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID) == nil || lintTable05.item(LINT05_ROUTE_DETAIL_EXCH_DEST_ID) == nil || "\(lintTable05.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID))" == "" || "\(lintTable05.item(LINT05_ROUTE_DETAIL_EXCH_DEST_ID))" == ""
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
    func selectLineTableOne(lineId: String?) -> MstT01LineTable{
        var tableMstT01 = MstT01LineTable()
        tableMstT01.lineId = lineId
        var line:MstT01LineTable = tableMstT01.select() as MstT01LineTable
        return line
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
     * 从DB查询站点信息
     */
    func selectStationTableOne(stationId: String) -> MstT02StationTable{
        var tableMstT02 = MstT02StationTable()
        tableMstT02.statId = stationId
        var station:MstT02StationTable = tableMstT02.select() as MstT02StationTable
        return station
    }
    
    /**
     * 从DB查询到站信息
     */
    func selectArrivalAlarmTable() -> Array<UsrT01ArrivalAlarmTable>{
        var tableUsrT01 = UsrT01ArrivalAlarmTable()
        var arrivalAlarms:Array<UsrT01ArrivalAlarmTable> = tableUsrT01.selectAll() as Array<UsrT01ArrivalAlarmTable>
        return arrivalAlarms
    }

    func deleteAlarm(){
        var tableUsrT01 = UsrT01ArrivalAlarmTable()
        var arrivalAlarms:Array<UsrT01ArrivalAlarmTable> = tableUsrT01.selectAll() as Array<UsrT01ArrivalAlarmTable>
        for arrivalAlarm in arrivalAlarms{
            arrivalAlarm.delete()
        }
    }
    
    /**
     * 从DB查询末班车信息
     */
    func selectTrainAlarmTable() -> Array<UsrT02TrainAlarmTable>{
        var tableUsrT02 = UsrT02TrainAlarmTable()
        var trainAlarms:Array<UsrT02TrainAlarmTable> = tableUsrT02.selectAll() as Array<UsrT02TrainAlarmTable>
        return trainAlarms
    }
    
    /**
     * 从DB查询花费时间
     */
    func selectLinT05RouteDetailTable(startStationId: String, toStationId: String) -> Array<LinT05RouteDetailTable>?{
        let QUERY_EXCH = "select * , ROWID from LINT05_ROUTE_DETAIL where RUTE_ID = ?"
        
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = startStationId//"\((selectStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = toStationId//"\((selectStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        var ruteId: String = "\((tableLinT04.select() as LinT04RouteTable).item(LINT04_ROUTE_RUTE_ID))"
        var costTime:Int = 0
        var tableLinT05 = LinT05RouteDetailTable()
        
        var args:NSMutableArray = NSMutableArray.array();
        args.addObject(ruteId);
        
        return tableLinT05.excuteQuery(QUERY_EXCH, withArgumentsInArray: args) as? Array<LinT05RouteDetailTable>
    }

    func findRoute04(startStationId: String, toStationId: String) -> LinT04RouteTable{
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = startStationId//"\((selectStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = toStationId//"\((selectStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        return tableLinT04.select() as LinT04RouteTable
    }
    
    /**
     * 从DB查询终点站信息
     */
    func selectStationTableDirt(lineId:String) -> Array<MstT02StationTable>{
        var stationdirt:Array<MstT02StationTable> = Array<MstT02StationTable>()
        var tableMstT02 = MstT02StationTable()
        var stations:Array<MstT02StationTable> = selectStationTable(lineId)
        for(var i=0;i<stations.count;i++){
            if(i == 0 || i == (stations.count - 1)){
                stationdirt.append(stations[i])
            }
        }
        return stationdirt
    }
    
    func getLineIndex(lineId:NSString) -> Int{
        switch lineId.integerValue{
        case 28001:
            return 0
        case 28002:
            return 1
        case 28003:
            return 2
        case 28004:
            return 3
        case 28005:
            return 4
        case 28006:
            return 5
        case 28008:
            return 6
        case 28009:
            return 7
        case 28010:
            return 8
        default:
            println("nothing")
        }
        return 0
    }
    
    func getStationIndex(lineId: String, statId: String) -> Int{
        var stations:Array<MstT02StationTable> = selectStationTable(lineId)
        for(var i=0;i<stations.count;i++){
            if ("\(stations[i].item(MSTT02_STAT_ID))" == statId){
                return i
            }
        }
        return 0
    }
    
    /**
     * 本地推送消息
     */
    func pushNotification(Msg: String?, min:Int?, beep: Bool){
        var mDeviceVersion:Double = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
        // 通知
        var app = UIApplication.sharedApplication()
        // ios8以下
        if(mDeviceVersion >= 7.0 && mDeviceVersion <= 7.9){
            app.registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound)
        }else{
            // 注册推送权限
            var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
            app.registerUserNotificationSettings(settings)
        }
        
        var localNotif:UILocalNotification = UILocalNotification()
        localNotif.fireDate = NSDate()
        localNotif.timeZone = NSTimeZone.localTimeZone()
        if(beep){
            AudioServicesPlaySystemSound(1007 as SystemSoundID)
        }else{
            AudioServicesPlaySystemSound(4095 as SystemSoundID)
        }
        
        localNotif.soundName = UILocalNotificationDefaultSoundName
        if(Msg != nil){
            localNotif.alertBody = Msg
        }
        localNotif.applicationIconBadgeNumber = min!
        
        app.scheduleLocalNotification(localNotif)
    }

    /**
     * alertView
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

    /**
     * 设置当前时区
     */
    class func convertDate2LocalTime(forDate:NSDate) -> String{
        var calendar:NSCalendar = NSCalendar()// identifier: NSGregorianCalendar
        calendar.timeZone = NSTimeZone.systemTimeZone()
        var dateComp:NSDateComponents = calendar.components((NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond), fromDate: forDate)
        
        var mDateStr:String = ""
        mDateStr = mDateStr + "\(dateComp.year)"
        if(dateComp.month < 10){
            mDateStr = mDateStr + "0\(dateComp.month)"
        }else{
            mDateStr = mDateStr + "\(dateComp.month)"
        }
        if(dateComp.day < 10){
            mDateStr = mDateStr + "0\(dateComp.day)"
        }else{
            mDateStr = mDateStr + "\(dateComp.day)"
        }
        if(dateComp.hour < 10){
            mDateStr = mDateStr + "0\(dateComp.hour)"
        }else{
            mDateStr = mDateStr + "\(dateComp.hour)"
        }
        if(dateComp.minute < 10){
            mDateStr = mDateStr + "0\(dateComp.minute)"
        }else{
            mDateStr = mDateStr + "\(dateComp.minute)"
        }
        
        return mDateStr
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

}