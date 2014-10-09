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
    let MSG_0001 = "通知"
    /* 通知 */
    let MSG_0002 = "确定取消提醒？"
    /* 确定 */
    let MSG_0003 = "是"
    /* 取消 */
    let MSG_0004 = "不是"
    /* 到站提醒 */
    let ARRIVE_STATION_TITLE = "编辑到站提醒"
    /* 末班车提醒 */
    let LAST_METRO_TITLE = "编辑末班车提醒"
    
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

    /**
     * 到站提醒
     */
    func arriveStation(){
        self.navigationItem.rightBarButtonItem = nil
        tbList.hidden = true
        // button点击事件
        btnCancel.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnStart.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnEdit.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        var alarms:Array<UsrT01ArrivalAlarmTable>? = selectArrivalAlarmTable()
        if(alarms!.count > 0){
            alarm = alarms![alarms!.count - NUM_1]
            if(alarm!.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG) == nil || alarm!.item(USRT01_ARRIVAL_ALARM_CANCEL_FLAG).integerValue == 1){
                // 当前没有到站提醒
                noAlarm()
                alarm = nil
            }else{
                lblArriveStation.text = "\(alarm!.item(USRT01_ARRIVAL_ALARM_STAT_TO_NAME_LOCL))"
                lblArriveInfo.text = "\(alarm!.item(USRT01_ARRIVAL_ALARM_LINE_TO_NAME_LOCL))"
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
            if(row == 0){
                if(trainAlarms![section].item(USRT02_TRAIN_ALARM_FIRST_FLAG).integerValue == 0){
                    trainAlarms![section].firstFlag = "1"
                }else{
                    trainAlarms![section].firstFlag = "0"
                }
                trainAlarms![section].update()
            }else if(row == 1){
                if(trainAlarms![section].item(USRT02_TRAIN_ALARM_LAST_FLAG).integerValue == 0){
                    trainAlarms![section].lastFlag = "1"
                }else{
                    trainAlarms![section].lastFlag = "0"
                }
                trainAlarms![section].update()
            }
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
                self.pushNotification("您到达了银座",min: self.NUM_NEGATIVE_1)
                self.alarm!.cancelFlag = "1"
                self.alarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                self.alarm!.update()
                self.btnStart.enabled = false
                self.btnCancel.enabled = false
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
            var directions = ["\(train.item(USRT02_TRAIN_ALARM_FIRST_TIME))","\(train.item(USRT02_TRAIN_ALARM_LAST_TIME))"]
            var trainFlag:Array<String> = [ "早班车：", "末班车："]
            items.addObject(["\(train.item(USRT02_TRAIN_ALARM_LINE_ID))".line() + ":" + "\(train.item(USRT02_TRAIN_ALARM_STAT_ID))".station(), directions, trainFlag])
        }
    }

    
    /**
     * 从DB查询到站信息
     */
    func selectArrivalAlarmTable() -> Array<UsrT01ArrivalAlarmTable>{
        var tableUsrT01 = UsrT01ArrivalAlarmTable()
        var arrivalAlarms:Array<UsrT01ArrivalAlarmTable> = tableUsrT01.selectAll() as Array<UsrT01ArrivalAlarmTable>
        return arrivalAlarms
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
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            if((subview.tag as Int) == 101 || (subview.tag as Int) == 102){
                subview.removeFromSuperview()
            }
        }
        cell.textLabel!.text = items[indexPath.section][2][indexPath.row] as? String
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:13)
        var lblLastMetroTime = UILabel(frame: CGRect(x:65,y:0,width:230,height:43))
        lblLastMetroTime.tag = 101
        lblLastMetroTime.text = items[indexPath.section][1][indexPath.row] as? String
        lblLastMetroTime.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLastMetroTime)
        
        var switchAralm = UISwitch(frame: CGRect(x:250,y:5,width:60,height:30))
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
            var strFirst:NSString = "\(trainAlarms![indexPath.section].item(USRT02_TRAIN_ALARM_FIRST_FLAG))"
            if(strFirst.integerValue == 0){
                switchAralm.on = false
            }else{
                switchAralm.on = true
            }
        }else if(indexPath.row == 1){
            var strLast:NSString = "\(trainAlarms![indexPath.section].item(USRT02_TRAIN_ALARM_LAST_FLAG))"
            if(strLast.integerValue == 0){
                switchAralm.on = false
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