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
class RemindDetailController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate{
    /* UITableView */
    @IBOutlet weak var tbList: UITableView!
    
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
    var lines:Array<MstT01LineTable> = Array<MstT01LineTable>()
    /* stations */
    var stations:Array<MstT02StationTable> = Array<MstT02StationTable>()
    /* fromStations */
    var fromStations:Array<MstT02StationTable> = Array<MstT02StationTable>()
    /* UsrT01ArrivalAlarmTable 参数 */
    var tableUsrT01: UsrT01ArrivalAlarmTable?
    /* UsrT02TrainAlarmTable 参数 */
    var tableUsrT02: UsrT02TrainAlarmTable?
    /* 提醒方式 */
    var remindsMethod:Array<String> = ["USR002_01".localizedString(),"USR002_02".localizedString()]
    /* 提醒时间 */
    var remindsTimeArrive:Array<String> = ["USR002_03".localizedString(),"USR002_04".localizedString(),"USR002_05".localizedString(),"USR002_06".localizedString(),"USR002_07".localizedString()]
    /* 提醒时间 */
    var remindsTime:Array<String> = ["USR002_03".localizedString(),"USR002_04".localizedString(),"USR002_05".localizedString(),"USR002_06".localizedString(),"USR002_07".localizedString()]
    /* line */
    var line:String = "東西線"
    /* station */
    var station:String = "浅草"
    /* fromStation */
    var fromStation:String = "浅草"
    /* station */
    var stationDirt0:String = "浅草"
    /* station */
    var stationDirt1:String = "涉谷"
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
    /* 上一个页面是否查找站点 */
    var isSearsh:Bool = false
    /* 选择的线路id */
    var selectLineId:String?
    /* 选择的线路站点id */
    var selectStationId:String?
    
    var routeStatTable01:MstT02StationTable?
    var routeStatTable02:MstT02StationTable?
    
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 100 */
    let NUM_100 = 100
    
    /* 线路数量 */
    let LINE_COUNT:UInt = 9
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
    let MSG_0003 = "USR002_20".localizedString()
    /* 取消 */
    let MSG_0004 = "USR002_21".localizedString()
    /* 确定添加本条提醒？ */
    let MSG_0005 = "USR002_10".localizedString()
    /* 确定添加本条提醒？ */
    let MSG_0006 = "USR002_11".localizedString()
    
    let SAVE_BUTTON_TAG:Int = 200201
    let DELETE_BUTTON_TAG:Int = 200202
    let BACK_BUTTON_TAG:Int = 200203
    
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
        self.navigationItem.leftBarButtonItem = nil
        // 返回按钮点击事件
        var bakButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        bakButtonStyle.frame = CGRectMake(0, 0, 43, 43)
        bakButtonStyle.setTitle("PUBLIC_05".localizedString(), forState: UIControlState.Normal)
        bakButtonStyle.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        var backButton:UIBarButtonItem =  UIBarButtonItem(customView: bakButtonStyle)
        self.navigationItem.leftBarButtonItem = backButton
        // 查询线路
        lines = selectLineTable()

        if(segIndex == NUM_0){
            editArriveStation()
        }else if(segIndex == NUM_1){
            editLastMetro()
        }
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        println(sender.tag)
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
        case BACK_BUTTON_TAG:
            self.navigationController!.popViewControllerAnimated(true)
        case self.navigationItem.leftBarButtonItem!.tag:
            if(segIndex == NUM_0){
                // 保存到站提醒
                saveArriveStation()
            }else if(segIndex == NUM_1){
                // 保存末班车提醒
                saveLastMetro()
            }
        case self.navigationItem.rightBarButtonItem!.tag:
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0001,buttons:[MSG_0003, MSG_0004], delegate: self)
        default:
            println("nothing")
        }
    }
    
    func initArriveAlarm(usrT01Table:UsrT01ArrivalAlarmTable){
        usrT01Table.lineFromId = "28001"
        usrT01Table.statFromId = "2800101"
        usrT01Table.lineToId = "28001"
        usrT01Table.statToId = "2800101"
        usrT01Table.traiDirt = "2800119"
        usrT01Table.beepFlag = "1"
        usrT01Table.voleFlag = "0"
        usrT01Table.costTime = "0"
        usrT01Table.alarmTime = "0"
        usrT01Table.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
        usrT01Table.onboardTime = "000000000000"
        usrT01Table.cancelFlag = "0"
        usrT01Table.cancelTime = "00000000000000"
    }
    
    /**
     * 编辑到站提醒
     */
    func editArriveStation(){
        self.navigationItem.rightBarButtonItem = nil
        // 完成按钮点击事件
        var saveButton:UIBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem!.tag = SAVE_BUTTON_TAG
        
        self.navigationItem.leftBarButtonItem = nil
        
        if(tableUsrT01 == nil){
            tableUsrT01 = UsrT01ArrivalAlarmTable()
            initArriveAlarm(tableUsrT01!)
        }
        
        if(isSearsh && pickerViewSection == 0){
            tableUsrT01!.lineToId = selectLineId
            tableUsrT01!.statToId = selectStationId
        }else if(isSearsh && pickerViewSection == 1){
            tableUsrT01!.lineFromId = selectLineId
            tableUsrT01!.statFromId = selectStationId
        }
        
        if(fromRoute()){
            tableUsrT01!.statFromId = "\(routeStatTable01!.item(MSTT02_STAT_ID))"
            tableUsrT01!.statToId = "\(routeStatTable02!.item(MSTT02_STAT_ID))"
        }
        
        if(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID) != nil){
            station = "\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID))".station()
        }
        if(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_FROM_ID) != nil){
            fromStation = "\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_FROM_ID))".station()
        }
        if(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_BEEP_FLAG) == nil || tableUsrT01!.item(USRT01_ARRIVAL_ALARM_BEEP_FLAG).integerValue == 1){
            remindType = 0
        }else{
            remindType = 1
        }
        if(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_ALARM_TIME) != nil && tableUsrT01!.item(USRT01_ARRIVAL_ALARM_ALARM_TIME).integerValue != 0){
            remindTime = tableUsrT01!.item(USRT01_ARRIVAL_ALARM_ALARM_TIME).integerValue / 60 - 1
        }
        
        // 到达站点
        stations = selectStationTable("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID))")
        // 上车站点
        fromStations = selectStationTable("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_FROM_ID))")
        
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
        var lineIndexTo: Int = getLineIndex("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID))")
        // 查询站点
        var stationIndexTo:Int = getStationIndex("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID))", statId: "\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID))")
        println(stationIndexTo)
        pickStations.selectRow(lineIndexTo, inComponent: NUM_0, animated: false)
        pickStations.selectRow(stationIndexTo, inComponent: NUM_1, animated: false)
        
        // 查询线路
        var lineIndexFrom: Int = getLineIndex("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_FROM_ID))")
        // 查询站点
        var stationIndexFrom:Int = getStationIndex("\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_LINE_FROM_ID))", statId: "\(tableUsrT01!.item(USRT01_ARRIVAL_ALARM_STAT_FROM_ID))")
        
        pickFromStations.selectRow(lineIndexFrom, inComponent: NUM_0, animated: false)
        pickFromStations.selectRow(stationIndexFrom, inComponent: NUM_1, animated: false)
    }
    
    /**
     * 编辑末班车提醒
     */
    func editLastMetro(){
        // 删除按钮点击事件
        var delButton:UIBarButtonItem! = self.navigationItem.rightBarButtonItem
        if(delButton != nil){
            delButton.tag = DELETE_BUTTON_TAG
            delButton.target = self
            delButton.action = "buttonAction:"
        }
        
        if(tableUsrT02 == nil){
            self.navigationItem.rightBarButtonItem = nil
            // 完成按钮点击事件
            var saveButton:UIBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
            self.navigationItem.rightBarButtonItem = saveButton
            self.navigationItem.rightBarButtonItem!.tag = SAVE_BUTTON_TAG

            self.navigationItem.leftBarButtonItem = nil
            
            tableUsrT02 = UsrT02TrainAlarmTable()
            tableUsrT02!.lineId = "28001"
            tableUsrT02!.statId = "2800101"
            tableUsrT02!.alamType = "9"
            tableUsrT02!.alamTime = "2310"
            tableUsrT02!.alamFlag = "1"
            tableUsrT02!.traiDirt = "2800119"
            tableUsrT02!.beepFlag = "1"
            tableUsrT02!.voleFlag = "0"
            tableUsrT02!.alarmTime = "0"
            tableUsrT02!.saveTime = "00000000000000"
        }
        
        if(isSearsh){
            tableUsrT02!.lineId = selectLineId
            tableUsrT02!.statId = selectStationId
        }
        
        if(tableUsrT02!.item(USRT02_TRAIN_ALARM_STAT_ID) != nil){
            station = "\(tableUsrT02!.item(USRT02_TRAIN_ALARM_STAT_ID))".station()
        }
        if(tableUsrT02!.item(USRT02_TRAIN_ALARM_BEEP_FLAG) == nil || tableUsrT02!.item(USRT02_TRAIN_ALARM_BEEP_FLAG).integerValue == 1){
            remindType = 0
        }else{
            remindType = 1
        }
        if(tableUsrT02!.item(USRT02_TRAIN_ALARM_ALARM_TIME) != nil && tableUsrT02!.item(USRT02_TRAIN_ALARM_ALARM_TIME).integerValue != 0){
            remindTime = tableUsrT02!.item(USRT02_TRAIN_ALARM_ALARM_TIME).integerValue / 60 - 1
        }
        
        var stationsDirt = selectStationTableDirt("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_LINE_ID))")
        
        stationDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))".station()
        stationDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))".station()
        traiDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))"
        traiDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))"
        
        if("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_TRAI_DIRT))" == "\(stationsDirt[0].item(MSTT02_STAT_ID))"){
            stationDirtFlag = 0
        }else if("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_TRAI_DIRT))" == "\(stationsDirt[1].item(MSTT02_STAT_ID))"){
            stationDirtFlag = 1
        }
        
        // 到达站点
        stations = selectStationTable("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_LINE_ID))")
        
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
        var lineIndex: Int = getLineIndex("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_LINE_ID))")
        // 查询站点
        var stationIndex:Int = getStationIndex("\(tableUsrT02!.item(USRT02_TRAIN_ALARM_LINE_ID))", statId: "\(tableUsrT02!.item(USRT02_TRAIN_ALARM_STAT_ID))")
        
        pickStations.selectRow(lineIndex, inComponent: NUM_0, animated: false)
        pickStations.selectRow(stationIndex, inComponent: NUM_1, animated: false)
    }
    
    /**
     * 保存到站提醒
     */
    func saveArriveStation(){
        if(tableUsrT01!.statFromId == "2800101" && tableUsrT01!.statToId == "2800101"){
            self.navigationController!.popViewControllerAnimated(true)
            return
        }

        var routeDetails:Array<LinT05RouteDetailTable>? = selectLinT05RouteDetailTable(tableUsrT01!.statFromId, toStationId: tableUsrT01!.statToId)
        
        if(routeDetails == nil || routeDetails!.count < 1){
            RemindDetailController.showMessage(MSG_0002, msg:MSG_0006,buttons:[MSG_0003], delegate: nil)
            self.navigationController!.popViewControllerAnimated(true)
            return
        }
        
        deleteAlarm()
        
        for(var i=0;i<routeDetails!.count;i++){
            var routeDetail:LinT05RouteDetailTable = routeDetails![i]
            var costTime:Int = ("\(routeDetail.item(LINT05_ROUTE_DETAIL_MOVE_TIME))" as NSString).integerValue * 60
            if(i == 0){
                tableUsrT01!.costTime = "\(costTime)"
                tableUsrT01!.arriAlamId = "1"
                if(routeDetails!.count > 2){
                    tableUsrT01!.statToId = routeDetails![i+1].exchStatId
                    tableUsrT01!.lineToId = routeDetails![i].exchLineId
                    tableUsrT01!.insert()
                }else{
                    tableUsrT01!.insert()
                    var controllers:AnyObject? = self.navigationController!.viewControllers
                    if(controllers!.count > 1){
                        var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                        lastController.viewDidLoad()
                    }
                    self.navigationController!.popViewControllerAnimated(true)
                }
            }else if(i == routeDetails!.count - 2 && routeDetails!.count > 1){
                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
                var tableUsrT01Arrive:UsrT01ArrivalAlarmTable = UsrT01ArrivalAlarmTable()
                
                initArriveAlarm(tableUsrT01Arrive)
                
                tableUsrT01Arrive.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
                tableUsrT01Arrive.lineFromId = routeDetails![i-1].exchLineId
                tableUsrT01Arrive.statFromId = routeDetails![i].exchStatId
                tableUsrT01Arrive.lineToId = routeDetails![i].exchLineId
                tableUsrT01Arrive.traiDirt = routeDetails![i].exchDestId
                tableUsrT01Arrive.statToId = statToId
                tableUsrT01Arrive.costTime = "\(costTime)"
                tableUsrT01Arrive.insert()

                var controllers:AnyObject? = self.navigationController!.viewControllers
                if(controllers!.count > 1){
                    var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                    lastController.viewDidLoad()
                }
                self.navigationController!.popViewControllerAnimated(true)
            }else if(i < routeDetails!.count - 1){
                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
                var tableUsrT01Exch:UsrT01ArrivalAlarmTable = UsrT01ArrivalAlarmTable()
                
                initArriveAlarm(tableUsrT01Exch)
                
                tableUsrT01Exch.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
                tableUsrT01Exch.lineFromId = routeDetails![i-1].exchLineId
                tableUsrT01Exch.statFromId = routeDetails![i].exchStatId
                tableUsrT01Exch.lineToId = routeDetails![i].exchLineId
                tableUsrT01Exch.statToId = routeDetails![i+1].exchStatId
                tableUsrT01Exch.costTime = "\(costTime)"
                tableUsrT01Exch.insert()
            }
            
        }
    }
    
    /**
     * 保存末班车提醒
     */
    func saveLastMetro(){
        var trainAlarms:Array<UsrT02TrainAlarmTable>? = selectTrainAlarmTable()
        var usr002Dao:USR002Dao = USR002Dao()
        tableUsrT02!.alamTime = usr002Dao.queryDepaTime(tableUsrT02!.lineId, statId: "\((selectStationTableOne(tableUsrT02!.statId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))", destId: tableUsrT02!.traiDirt, trainFlag: tableUsrT02!.alamType, scheType: "1")
        if(tableUsrT02!.alamTime == nil || tableUsrT02!.alamTime == "nil" || tableUsrT02!.alamTime == ""){
            RemindDetailController.showMessage(MSG_0002, msg:"请重新选择车站",buttons:[MSG_0003], delegate: nil)
            self.navigationController!.popViewControllerAnimated(true)
            return
        }
        if(trainAlarms!.count > 0){
            if((tableUsrT02!.rowid) == nil || (tableUsrT02!.rowid) == ""){
                tableUsrT02!.traiAlamId = "\(trainAlarms![trainAlarms!.count - 1].item(USRT02_TRAIN_ALARM_TRAI_ALAM_ID).integerValue + 1)"
                tableUsrT02!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                if(tableUsrT02!.insert()){
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
                tableUsrT02!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                if(tableUsrT02!.update()){
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
        }else{
            tableUsrT02!.traiAlamId = "1"
            tableUsrT02!.saveTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
            if(tableUsrT02!.insert()){
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
        items.addObject(["USR002_12".localizedString(),[station,""]])
        items.addObject(["USR002_13".localizedString(),[fromStation,""]])
        items.addObject(["USR002_14".localizedString(),remindsMethod])
        items.addObject(["USR002_15".localizedString(),remindsTimeArrive])
    }
    
    /**
     * 加载items
     */
    func loadLastMetroItems(){
        items = NSMutableArray.array()
        items.addObject(["提醒站点：",[station,""]])
        items.addObject(["方向：",[stationDirt0 + "方向",stationDirt1 + "方向"]])
        items.addObject(["早末班车：",["USR002_26".localizedString(), "USR002_27".localizedString()]])
        items.addObject(["USR002_16".localizedString(),remindsMethod])
        items.addObject(["USR002_17".localizedString(),remindsTime])
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
    func selectLineTable() -> Array<MstT01LineTable>{
        var tableMstT01 = MstT01LineTable()
        var lines:Array<MstT01LineTable> = tableMstT01.selectTop(LINE_COUNT) as Array<MstT01LineTable>
        return lines
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
        tableLinT04.startStatId = "\((selectStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = "\((selectStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        var ruteId: String = "\((tableLinT04.select() as LinT04RouteTable).item(LINT04_ROUTE_RUTE_ID))"
        var costTime:Int = 0
        var tableLinT05 = LinT05RouteDetailTable()
        
        var args:NSMutableArray = NSMutableArray.array();
        args.addObject(ruteId);
        
        return tableLinT05.excuteQuery(QUERY_EXCH, withArgumentsInArray: args) as? Array<LinT05RouteDetailTable>
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
        // 注册推送权限
        var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
        
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
        
        // 通知
        var app = UIApplication.sharedApplication()
        app.registerUserNotificationSettings(settings)
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
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyyMMddHHmmss")
        formatter.timeZone = NSTimeZone.localTimeZone()
        let nsDate = formatter.stringFromDate(forDate)
        return nsDate
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
                    tableUsrT01!.beepFlag = "1"
                    tableUsrT01!.voleFlag = "0"
                    pushNotification(nil, min: -1, beep: true)
                }else{
                    tableUsrT01!.beepFlag = "0"
                    tableUsrT01!.voleFlag = "1"
                    pushNotification(nil, min: -1, beep: false)
                }
            }else if(didSelectRowAtIndexPath.section == 3){
                remindTime = didSelectRowAtIndexPath.row
                // 提醒时间
                tableUsrT01!.alarmTime = "\((remindTime + 1) * 60)"
            }
        }else if(segIndex == NUM_1){
            if(didSelectRowAtIndexPath.section == 3){
                remindType = didSelectRowAtIndexPath.row
                // 提醒方式
                if(remindType == NUM_0){
                    tableUsrT02!.beepFlag = "1"
                    tableUsrT02!.voleFlag = "0"
                    pushNotification(nil, min: -1, beep: true)
                }else{
                    tableUsrT02!.beepFlag = "0"
                    tableUsrT02!.voleFlag = "1"
                    pushNotification(nil, min: -1, beep: false)
                }
            }else if(didSelectRowAtIndexPath.section == 4){
                remindTime = didSelectRowAtIndexPath.row
                // 提醒时间
                tableUsrT02!.alarmTime = "\((remindTime + 1) * 60)"
            }else if(didSelectRowAtIndexPath.section == 1){
                stationDirtFlag = didSelectRowAtIndexPath.row
                if(stationDirtFlag == 0){
                    tableUsrT02!.traiDirt = traiDirt0
                }else{
                    tableUsrT02!.traiDirt = traiDirt1
                }
            }else if(didSelectRowAtIndexPath.section == 2){
                if(didSelectRowAtIndexPath.row == 0){
                    tableUsrT02!.alamType = "1"
                }else{
                    tableUsrT02!.alamType = "9"
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var UIHeader:UIView = UIView()
        if(segIndex == NUM_0){
            if(section == 0){
                var imgStationTo = UIImage(named: "USR00204.png")
                var imageViewStationTo = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                    imageViewStationTo.image = imgStationTo
                UIHeader.addSubview(imageViewStationTo)
            }else if(section == 1){
                var imgStationFrom = UIImage(named: "USR00205.png")
                var imageViewStationFrom = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewStationFrom.image = imgStationFrom
                UIHeader.addSubview(imageViewStationFrom)
            }else{
                var imgAlarm = UIImage(named: "USR00206.png")
                var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewAlarm.image = imgAlarm
                UIHeader.addSubview(imageViewAlarm)
            }
        }else if(segIndex == NUM_1){
            if(section == 0){
                var imgStationTo = UIImage(named: "USR00204.png")
                var imageViewStationTo = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewStationTo.image = imgStationTo
                UIHeader.addSubview(imageViewStationTo)
            }else{
                var imgAlarm = UIImage(named: "USR00206.png")
                var imageViewAlarm = UIImageView(frame: CGRectMake(15, 5, 25, 25))
                imageViewAlarm.image = imgAlarm
                UIHeader.addSubview(imageViewAlarm)
            }
        }

        var lblText = UILabel(frame: CGRect(x:50,y:5,width:tableView.frame.width - 100,height:25))
        lblText.textColor = UIColor.lightGrayColor()
        lblText.font = UIFont.systemFontOfSize(15)
        lblText.text = items[section][0] as? String
        lblText.textAlignment = NSTextAlignment.Left
        UIHeader.addSubview(lblText)
        
        return UIHeader
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section][0] as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
        for subview in cell.subviews{
            if(subview.isKindOfClass(UIPickerView)){
                subview.removeFromSuperview()
            }
        }
        if(segIndex == NUM_0){
            if(indexPath.section == 2 && indexPath.row == remindType){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.section == 3 && indexPath.row == remindTime){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 1){
                cell.addSubview(pickLineStations[indexPath.section])
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }else if(segIndex == NUM_1){
            if(indexPath.section == 3 && indexPath.row == remindType){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if(indexPath.section == 4 && indexPath.row == remindTime){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 0) && indexPath.row == 1){
                cell.addSubview(pickLineStations[indexPath.section])
            }else if((indexPath.section == 1) && indexPath.row == stationDirtFlag){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else if((indexPath.section == 2)){
                if(indexPath.row == 0 && tableUsrT02?.alamType == "1"){
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else if(indexPath.row == 1 && tableUsrT02?.alamType == "9"){
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        cell.textLabel!.text = items[indexPath.section][1][indexPath.row] as? String
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
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        var title = ""
        if(pickerView == pickStations){
            if(component == NUM_0){
                if(row < lines.count){
                    title = "\(lines[row].lineId)".line()
                }
            }else{
                if(row < stations.count){
                    title = "\(stations[row].statId)".station()
                }
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                if(row < lines.count){
                    title = "\(lines[row].lineId)".line()
                }
            }else{
                if(row < fromStations.count){
                    title = "\(fromStations[row].statId)".station()
                }
            }
        }
        return title
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
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

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView == pickStations){
            if(component == NUM_0){
                // 线路
                line = "\(lines[row].lineId)".line()
                // 站点
                stations = selectStationTable(lines[row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                station = "\(stations[NUM_0].statId)".station()
                var stationsDirt = selectStationTableDirt(lines[row].lineId)
                stationDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))".station()
                stationDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))".station()
                traiDirt0 = "\(stationsDirt[0].item(MSTT02_STAT_ID))"
                traiDirt1 = "\(stationsDirt[1].item(MSTT02_STAT_ID))"
                if(segIndex == NUM_0){
                    statToId = stations[NUM_0].statId
                    tableUsrT01!.lineToId = lines[row].lineId
                    tableUsrT01!.statToId = stations[NUM_0].statId
                }else if(segIndex == NUM_1){
                    tableUsrT02!.lineId = lines[row].lineId
                    tableUsrT02!.statId = stations[NUM_0].statId
                }
            }else{
                if(row < stations.count){
                    station = "\(stations[row].statId)".station()
                    if(segIndex == NUM_0){
                        statToId = stations[row].statId
                        tableUsrT01!.statToId = stations[row].statId
                    }else if(segIndex == NUM_1){
                        tableUsrT02!.statId = stations[row].statId
                    }
                }
            }
        }else if(pickerView == pickFromStations){
            if(component == NUM_0){
                // 线路
                line = lines[row].lineId.line()
                tableUsrT01!.lineFromId = lines[row].lineId
                // 站点
                fromStations = selectStationTable(lines[row].lineId)
                pickerView.reloadComponent(NUM_1)
                pickerView.selectRow(NUM_0, inComponent: NUM_1, animated: true)
                fromStation = "\(fromStations[NUM_0].statName)"
                tableUsrT01!.statFromId = stations[NUM_0].statId
            }else{
                if(row < fromStations.count){
                    fromStation = "\(fromStations[row].statId)".station()
                    tableUsrT01!.statFromId = stations[row].statId
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
    
    // after animation
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int){
        switch buttonIndex{
        case NUM_0:
            // 删除本条提醒
            tableUsrT02!.delete()
            var controllers:AnyObject? = self.navigationController!.viewControllers
            if(controllers!.count > 1){
                var lastController:RemindListController = controllers![controllers!.count - 2] as RemindListController
                lastController.viewDidLoad()
            }
            self.navigationController!.popViewControllerAnimated(true)
        default:
            println("nothing")
        }
    }

}