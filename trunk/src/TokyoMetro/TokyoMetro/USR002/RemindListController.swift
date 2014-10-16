//
//  RemindListController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import Foundation

/**
 * 提醒列表
 */
class RemindListController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource, UIAlertViewDelegate{
    
    /* SegmentedControl控件 */
    @IBOutlet weak var sgmMain: UISegmentedControl!
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    /* 上车UIButton */
    @IBOutlet weak var btnStart: UIButton!
    /* 取消UIButton */
    @IBOutlet weak var btnCancel: UIButton!
    /* 编辑UIButton */
    @IBOutlet weak var btnEdit: UIButton!
    /* 小时UILabel */
    @IBOutlet weak var lblHour: UILabel!
    /* 分钟UILabel */
    @IBOutlet weak var lblMin: UILabel!
    /* 秒UILabel */
    @IBOutlet weak var lblSec: UILabel!
    /* 到达站点的线路及方向信息 */
    @IBOutlet weak var lblArriveInfo: UILabel!
    /* 到达站点信息 */
    @IBOutlet weak var lblArriveStation: UILabel!
    
    /* 0 */
    let NUM_0 = 0
    /* 1 */
    let NUM_1 = 1
    /* 2 */
    let NUM_2 = 2
    /* 3 */
    let NUM_3 = 3
    /* -1 */
    let NUM_NEGATIVE_1 = -1
    /* 没有选择站点 */
    let NO_STATION = -1
    /* 确定删除本条提醒？ */
    let MSG_0001 = "USR002_18".localizedString()
    /* 通知 */
    let MSG_0002 = "USR002_19".localizedString()
    /* 确定 */
    let MSG_0003 = "USR002_20".localizedString()
    /* 取消 */
    let MSG_0004 = "USR002_21".localizedString()
    /* 到站提醒 */
    let ARRIVE_STATION_TITLE = "USR002_22".localizedString()
    /* 末班车提醒 */
    let LAST_METRO_TITLE = "USR002_23".localizedString()
    
    /* 到站提醒当前条目 */
    var alarm:UsrT01ArrivalAlarmTable?
    /* 末班车提醒条目 */
    var trainAlarms:Array<UsrT02TrainAlarmTable>?
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    /* 线路 */
    var lines:Array<String> = ["银座線：","半蔵門線：","南北線：","副都心線："]
    /* 方向1 */
    var directions1:Array<String> = ["浅草：","涉谷："]
    /* 方向2 */
    var directions2:Array<String> = ["押上<スカイツリー前>：","涉谷："]
    /* 方向3 */
    var directions3:Array<String> = ["赤羽岩渊：","目黑："]
    /* 方向4 */
    var directions4:Array<String> = ["涉谷：","和光市："]
    /* 线程池 */
    var queue:NSOperationQueue = NSOperationQueue()
    
    var routeStatTable01:MstT02StationTable?
    var routeStatTable02:MstT02StationTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitValue()
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 到站提醒
            arriveStation()
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 末班车提醒
            lastMetro()
        }else{
        }
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *
     */
    func intitValue(){
        sgmMain.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        lblArriveInfo.textColor = UIColor.redColor()
        lblArriveInfo.font = UIFont(name:"Helvetica-Bold", size:14)
        
    }
    
    /**
     * sgmMain点击事件
     */
    func segmentChanged(sender: AnyObject){
        // 获得UISegmentedControl索引位置
        if(sgmMain.selectedSegmentIndex == NUM_0){
            // 到站提醒
            arriveStation()
        }else if(sgmMain.selectedSegmentIndex == NUM_1){
            // 末班车提醒
            lastMetro()
        }else{
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
     * 到站提醒
     */
    func arriveStation(){
        self.navigationItem.rightBarButtonItem = nil
        tbList.hidden = true
        
        if(fromRoute()){
            sgmMain.hidden = true
            if(selectLinT04RouteTable("\(routeStatTable01!.item(MSTT02_STAT_ID))", toStationId: "\(routeStatTable02!.item(MSTT02_STAT_ID))")){
                insertUsrT01()
            }else{
                RemindDetailController.showMessage("USR002_18".localizedString(), msg:"USR002_11".localizedString(),buttons:[MSG_0003], delegate: nil)
            }
        }
        
        // button点击事件
        btnCancel.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnStart.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnEdit.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
        if(alarms!.count > 0){
            for(var i=0; i < alarms!.count;i++){
                if(alarms![i].item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG) != nil && alarms![i].item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG).integerValue != 1){
                    alarm = alarms![i]
                    break
                }
            }
            if(alarm == nil || alarm!.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG) == nil || alarm!.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG).integerValue == 1){
                // 当前没有到站提醒
                noAlarm()
                alarm = nil
            }else{
                lblArriveStation.text = "到达" + "\(alarm!.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID))".station() + "还需"
                lblArriveInfo.text = "\(alarm!.item(USRT01_ARRIVAL_ALARM_LINE_TO_ID))".line()
                updateTime(alarm!.item(USRT01_ARRIVAL_ALARM_COST_TIME).integerValue)
                // 开启线程计时
                var timerThread = TimerThread.shareInstance()
                timerThread.sender = self
                if(timerThread.arriveTime == NO_STATION){
                    // 没有上车
                    btnCancel.enabled = false
                    btnStart.enabled = true
                }else{
                    btnCancel.enabled = true
                    btnStart.enabled = false
                    // 线程已经运行,显示当前剩余时间
                    showTime(convertTime(timerThread.surplusTime))
                }
            }
        }else{
            noAlarm()
        }
    }
    
    /**
     * 末班车提醒
     */
    func lastMetro(){
        // 添加按钮点击事件
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = addButton
        tbList.hidden = false
        // 查询末班车信息
        trainAlarms = selectTrainAlarmTable()
        
        loadItems()
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
    }
    
    /**
     * 从线路选择画面过来
     */
    func fromRoute() -> Bool{
        return routeStatTable01 != nil && routeStatTable02 != nil
    }
    
    func insertUsrT01(){
        var routeDetails:Array<LinT05RouteDetailTable>? = selectLinT05RouteDetailTable("\(routeStatTable01!.item(MSTT02_STAT_ID))", toStationId: "\(routeStatTable02!.item(MSTT02_STAT_ID))")
        
        deleteAlarm()
        
        for(var i=0;i<routeDetails!.count;i++){
            var routeDetail:LinT05RouteDetailTable = routeDetails![i]
            var costTime:Int = ("\(routeDetail.item(LINT05_ROUTE_DETAIL_MOVE_TIME))" as NSString).integerValue * 60
            if(i == 0){
                var tableUsrT01Start:UsrT01ArrivalAlarmTable = UsrT01ArrivalAlarmTable()
                initArriveAlarm(tableUsrT01Start)

                tableUsrT01Start.costTime = "\(costTime)"
                tableUsrT01Start.arriAlamId = "1"
                if(routeDetails!.count > 2){
                    tableUsrT01Start.statFromId = "\(routeStatTable01!.item(MSTT02_STAT_ID))"
                    tableUsrT01Start.statToId = routeDetails![i+1].exchStatId
                    tableUsrT01Start.insert()
                }else{
                    tableUsrT01Start.statFromId = "\(routeStatTable01!.item(MSTT02_STAT_ID))"
                    tableUsrT01Start.statToId = "\(routeStatTable02!.item(MSTT02_STAT_ID))"
                    tableUsrT01Start.insert()
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
                tableUsrT01Arrive.statFromId = routeDetails![i+1].exchStatId
                tableUsrT01Arrive.statToId = "\(routeStatTable02!.item(MSTT02_STAT_ID))"
                tableUsrT01Arrive.costTime = "\(costTime)"
                tableUsrT01Arrive.insert()
            }else if(i < routeDetails!.count - 1){
                var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
                var alarm:UsrT01ArrivalAlarmTable? = alarms![alarms!.count - NUM_1]
                var tableUsrT01Exch:UsrT01ArrivalAlarmTable = UsrT01ArrivalAlarmTable()
                
                initArriveAlarm(tableUsrT01Exch)
                
                tableUsrT01Exch.arriAlamId = "\(alarm!.item(USRT01_ARRIVAL_ALARM_ARRI_ALAM_ID).integerValue + 1)"
                tableUsrT01Exch.statFromId = routeDetails![i].exchStatId
                tableUsrT01Exch.statToId = routeDetails![i+1].exchStatId
                tableUsrT01Exch.costTime = "\(costTime)"
                tableUsrT01Exch.insert()
            }
        }
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        if((sender.tag as Int) == 102){
            var section:Int = -1
            var row:Int = -1
            for subview in sender.subviews{
                if((subview.tag as Int) == 103){
                    var strSection:NSString = (subview as UILabel).text!
                    section = strSection.integerValue
                }else if((subview.tag as Int) == 104){
                    var strRow:NSString = (subview as UILabel).text!
                    row = strRow.integerValue
                }
            }
            
            if(trainAlarms![section].item(USRT02_TRAIN_ALARM_ALAM_FLAG).integerValue == 0){
                trainAlarms![section].alamFlag = "1"
            }else{
                trainAlarms![section].alamFlag = "0"
            }
            trainAlarms![section].update()
        }
        switch sender{
        case btnCancel:
            RemindDetailController.showMessage(MSG_0001, msg:MSG_0002,buttons:[MSG_0003, MSG_0004], delegate: self)
        case btnStart:
            // 开启线程计时
            var timerThread = TimerThread.shareInstance()
            timerThread.sender = self
            if(timerThread.arriveTime == NO_STATION){
                if(timerThread.executing){
                    return
                }
                var costTime:Int = alarm!.item(USRT01_ARRIVAL_ALARM_COST_TIME).integerValue
                // 线程未运行
                timerThread.arriveTime = costTime
                alarm!.onboardTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                alarm!.update()
                queue.addOperation(timerThread)
            }else{
                // 线程已经运行,显示当前剩余时间
                showTime(convertTime(timerThread.surplusTime))
            }
            btnStart.enabled = false
            btnCancel.enabled = true
            btnEdit.enabled = false
        case btnEdit:
            var remindDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
            remindDetailController.title = ARRIVE_STATION_TITLE
            remindDetailController.segIndex = NUM_0
            if(alarm == nil){
                remindDetailController.tableUsrT01 = nil
            }else{
                remindDetailController.tableUsrT01 = alarm!
            }
            self.navigationController!.pushViewController(remindDetailController, animated:true)
        case self.navigationItem.rightBarButtonItem!:
            var remindDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
            if(sgmMain.selectedSegmentIndex == NUM_0){
                remindDetailController.title = ARRIVE_STATION_TITLE
                remindDetailController.segIndex = NUM_0
            }else if(sgmMain.selectedSegmentIndex == NUM_1){
                remindDetailController.title = LAST_METRO_TITLE
                remindDetailController.segIndex = NUM_1
            }else{
            }
            self.navigationController!.pushViewController(remindDetailController, animated:true)
        default:
            println("nothing")
        }
    }
    
    /**
     * 当前没有提醒
     */
    func noAlarm(){
        println("no alarm !")
        btnCancel.enabled = false
        btnStart.enabled = false
        lblArriveStation.text = ""
        lblArriveInfo.text = "当前没有设置提醒"
    }
    
    /**
     * 更新剩余时间
     */
    func updateTime(time: Int){
        var times = convertTime(time)
        if(times.count < 1){
            return
        }
        // 在子线程中更新UI
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.showTime(times)
            if(time == self.NUM_0){
                self.pushNotification("USR002_25".localizedString() + "\(self.alarm!.item(USRT01_ARRIVAL_ALARM_STAT_TO_ID))".station(),min: self.NUM_NEGATIVE_1)
                self.alarm!.cancelFlag = "1"
                self.alarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                self.alarm!.update()
                self.btnStart.enabled = false
                self.btnCancel.enabled = false
                self.arriveStation()
            }else{
                var costTime:Int = self.alarm!.item(USRT01_ARRIVAL_ALARM_COST_TIME).integerValue
                if(time % 60 == 0){
                    self.pushNotification(nil,min: (time/60)%60)
                }
            }
        }
    }
    
    /**
     * s2hh:mm:ss
     */
    func convertTime(time: Int) -> Array<String>{
        var sec:String = String(time%60)
        if(time%60 < 10){
            sec = "0" + sec
        }
        var min:String = String((time/60)%60)
        if((time/60)%60 < 10){
            min = "0" + min
        }
        var hour:String = String((time/60)/60)
        if((time/60)/60 < 10){
            hour = "0" + hour
        }
        var times = [hour,min,sec]
        return times
    }
    
    /**
     * 显示时间
     */
    func showTime(times: Array<String>){
        self.lblHour.text = times[self.NUM_0]
        self.lblMin.text = times[self.NUM_1]
        self.lblSec.text = times[self.NUM_2]
    }
    
    /**
     * 加载items
     */
    func loadItems(){
        items = NSMutableArray.array()
        for(var i=0;i < trainAlarms!.count;i++){
            var train:UsrT02TrainAlarmTable = trainAlarms![i]
            
            var trainFlag:Array<String> = [ "早班车：", "末班车："]
            var trainTime:Array<String> = [ "", ""]
            var directions:Array<String> = ["",""]
            if("\(train.item(USRT02_TRAIN_ALARM_ALAM_TYPE))" == "1"){
                trainFlag = ["早班车："]
            }else{
                trainFlag = ["末班车："]
            }
            
            trainTime = [convertTrainTime("\(train.item(USRT02_TRAIN_ALARM_ALAM_TIME))"),""]
            directions = ["\(train.item(USRT02_TRAIN_ALARM_TRAI_DIRT))".station() + "方向",""]
            
            items.addObject(["\(train.item(USRT02_TRAIN_ALARM_LINE_ID))".line() + ":" + "\(train.item(USRT02_TRAIN_ALARM_STAT_ID))".station(), directions, trainFlag, trainTime])
        }
    }

    func convertTrainTime(time:String) -> String{
        if(countElements(time) < 4){
            return time
        }
        
        var tempStr = "0123"
        
        var indexHourTo = tempStr.rangeOfString("1")
        var indexMinFrom = tempStr.rangeOfString("2")
        
        return "  " + time.substringToIndex(indexHourTo!.endIndex) + ":" + time.substringFromIndex(indexMinFrom!.startIndex) + "  "
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
     * 从DB查询站点信息
     */
    func selectStationTableOne(stationId: String) -> MstT02StationTable{
        var tableMstT02 = MstT02StationTable()
        tableMstT02.statId = stationId
        var station:MstT02StationTable = tableMstT02.select() as MstT02StationTable
        return station
    }
    
    /**
     * 从DB查询线路
     */
    func selectLinT04RouteTable(startStationId: String, toStationId: String) -> Bool{
        var tableLinT04 = LinT04RouteTable()
        tableLinT04.startStatId = "\((selectStationTableOne(startStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        tableLinT04.termStatId = "\((selectStationTableOne(toStationId) as MstT02StationTable).item(MSTT02_STAT_GROUP_ID))"
        return (tableLinT04.ruteId == nil)
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
     * 本地推送消息
     */
    func pushNotification(Msg: String?, min:Int?){
        // 注册推送权限
        var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
        
        var localNotif:UILocalNotification = UILocalNotification()
        localNotif.fireDate = NSDate()
        localNotif.timeZone = NSTimeZone.localTimeZone()
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
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        var remindDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
        remindDetailController.title = LAST_METRO_TITLE
        remindDetailController.segIndex = NUM_1
        remindDetailController.tableUsrT02 = trainAlarms![didSelectRowAtIndexPath.section]
        self.navigationController!.pushViewController(remindDetailController, animated:true)
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//items[section][1].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            if(subview.isKindOfClass(UILabel) || (subview.tag as Int) == 102){
                subview.removeFromSuperview()
            }
        }
        
        var lblMetroType = UILabel(frame: CGRect(x:15,y:50,width:230,height:30))
        lblMetroType.font = UIFont.systemFontOfSize(14)
        lblMetroType.textColor = UIColor.lightGrayColor()
        lblMetroType.text = items[indexPath.section][2][0] as? String
        lblMetroType.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblMetroType)
        
        var lblLastMetroTime = UILabel(frame: CGRect(x:0,y:0,width:230,height:50))
        lblLastMetroTime.tag = 101
        lblLastMetroTime.font = UIFont(name: "Helvetica Neue", size: 40)//.boldSystemFontOfSize(22)
        lblLastMetroTime.text = items[indexPath.section][3][indexPath.row] as? String
        lblLastMetroTime.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLastMetroTime)
        
        var lblLastMetroDirt = UILabel(frame: CGRect(x:80,y:50,width:230,height:30))
        lblLastMetroDirt.tag = 101
        lblLastMetroDirt.font = UIFont.systemFontOfSize(14)
        lblLastMetroDirt.textColor = UIColor.lightGrayColor()
        lblLastMetroDirt.text = items[indexPath.section][1][indexPath.row] as? String
        lblLastMetroDirt.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLastMetroDirt)
        
        var switchAralm = UISwitch(frame: CGRect(x:255,y:20,width:60,height:30))
        switchAralm.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.ValueChanged)
        switchAralm.tag = 102
        var lblSection = UILabel()
        lblSection.hidden = true
        lblSection.tag = 103
        lblSection.text = "\(indexPath.section)"
        var lblRow = UILabel()
        lblRow.tag = 104
        lblRow.hidden = true
        lblRow.text = "\(indexPath.row)"
        switchAralm.addSubview(lblSection)
        switchAralm.addSubview(lblRow)
        
        if(indexPath.row == 0){
            var strFirst:NSString = "\(trainAlarms![indexPath.section].item(USRT02_TRAIN_ALARM_ALAM_FLAG))"
            if(strFirst.integerValue == 0){
                switchAralm.on = false
                cell.backgroundColor = UIColor(red: 215/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }else{
                switchAralm.on = true
            }
        }else if(indexPath.row == 1){
            var strLast:NSString = "\(trainAlarms![indexPath.section].item(USRT02_TRAIN_ALARM_ALAM_FLAG))"
            if(strLast.integerValue == 0){
                switchAralm.on = false
                cell.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }else{
                switchAralm.on = true
            }
        }
        
        cell.addSubview(switchAralm)
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
    
    // after animation
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int){
        switch buttonIndex{
        case NUM_0:
            // 停止计时
            var timerThread = TimerThread.shareInstance()
            timerThread.cancel()
            self.lblHour.text = "00"
            self.lblMin.text = "00"
            self.lblSec.text = "00"
            noAlarm()
            btnEdit.enabled = true
            pushNotification(nil,min: NUM_NEGATIVE_1)
            alarm!.cancelFlag = "1"
            alarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
            alarm!.update()
            alarm = nil
        default:
            println("nothing")
        }
    }
}

/**
 * 用于计时线程
 */
class TimerThread: NSOperation{
    
    // 到达站点所需时间,s,
    var arriveTime:Int = -1
    // 画面viewController
    var sender:AnyObject?
    // 到达站点剩余时间
    var surplusTime:Int = 0
    
    private override init(){
    }
    
    /**
     * 创建单例
     */
    class func shareInstance()->TimerThread{
        struct qzSingle{
            static var predicate:dispatch_once_t = 0;
            static var instance:TimerThread? = nil
        }
        if(qzSingle.instance == nil){
            qzSingle.instance = TimerThread()
        }else if(qzSingle.instance!.finished){
            qzSingle.instance = TimerThread()
        }
        return qzSingle.instance!
    }
    
    override func start() {
        super.start()
    }
    
    override func main() {
        for(var i=0;i <= arriveTime;i++){
            var surplusTime = arriveTime - i
            self.surplusTime = surplusTime
            sender!.updateTime(surplusTime)
            
            sleep(1)
        }
        println("NSOperation over.")
    }
    
    override func cancel() {
        super.cancel()
        arriveTime = -1
    }
}