//
//  RemindListController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

/**
 * 提醒列表
 */
class RemindListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
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
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
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
    /* 末班车提醒 */
    let SAVE_BUTTON_TAG:Int = 200201

    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/

    var routeStatTable01:MstT02StationTable?
    var routeStatTable02:MstT02StationTable?

    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    var mUsr002Model:USR002Model = USR002Model()
    
    var lblStart = UILabel(frame: CGRect(x:15,y:210,width:290,height: 35))
    
    var lblArrow = UILabel(frame: CGRect(x:15,y:210,width:290,height: 35))
    
    var lblEnd = UILabel(frame: CGRect(x:15,y:210,width:290,height: 35))
    
    var imageViewBeep = UIImageView(frame: CGRectMake(230, 260, 18, 18))
    
    /* 到站提醒当前条目 */
    var mAlarm:UsrT01ArrivalAlarmTableData?
    /* 末班车提醒条目 */
    var mTrainAlarms:Array<UsrT02TrainAlarmTableData>?
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
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期化变量
        // 准备数据
        intitValue()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 画面内容变更
        // 设置数据
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        lblArriveInfo.textColor = UIColor.redColor()
        lblArriveInfo.font = UIFont(name:"Helvetica-Bold", size:14)

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
        var remindDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
        remindDetailController.title = LAST_METRO_TITLE
        remindDetailController.segIndex = NUM_1
        remindDetailController.usrT02Data = mTrainAlarms![didSelectRowAtIndexPath.section]
        
        // 返回按钮点击事件
        var bakButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        bakButtonStyle.frame = CGRectMake(0, 0, 43, 43)
        bakButtonStyle.setTitle("PUBLIC_05".localizedString(), forState: UIControlState.Normal)
        bakButtonStyle.addTarget(remindDetailController.self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var backButton:UIBarButtonItem = UIBarButtonItem(customView: bakButtonStyle)
        remindDetailController.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController!.pushViewController(remindDetailController, animated:true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return nil//items[section][0] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//items[section][1].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "AlarmListCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }

        for subview in cell!.contentView.subviews{
            if(subview.isKindOfClass(UILabel) || (subview.tag as Int) == 102){
                subview.removeFromSuperview()
            }
        }
        
        //pushNotificationLastMetro("\(items[indexPath.section][0])的\(items[indexPath.section][3][indexPath.row])即将发车", notifyTime:"\(items[indexPath.section][3][indexPath.row])")
        
        var lblMetroType = UILabel(frame: CGRect(x:15,y:20,width:230,height:30))
        lblMetroType.font = UIFont.systemFontOfSize(14)
        lblMetroType.textColor = UIColor.lightGrayColor()
        lblMetroType.text = items[indexPath.section][2][0] as? String
        lblMetroType.textAlignment = NSTextAlignment.Left
        
        var lblLastMetroTime = UILabel(frame: CGRect(x:45,y:0,width:230,height:50))
        lblLastMetroTime.tag = 101
        var fontStyle:UIFont = UIFont.preferredFontForTextStyle("UltraLight")
        //fontStyle.fontName = "Helvetica Neue"
        var userFont:UIFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle("UltraLight")
        var font:UIFont = UIFont(descriptor: userFont.fontDescriptorWithFamily("Helvetica Neue"), size: 65)//UIFont(name: "Helvetica Neue", size: userFontSize)
        
        lblLastMetroTime.font = font//UIFont(name: "Helvetica Neue", size: 65)
        lblLastMetroTime.text = items[indexPath.section][3][indexPath.row] as? String
        lblLastMetroTime.textAlignment = NSTextAlignment.Left
        
        var lblLastMetroDirt = UILabel(frame: CGRect(x:200,y:50,width:105,height:30))
        lblLastMetroDirt.tag = 101
        lblLastMetroDirt.font = UIFont.systemFontOfSize(14)
        lblLastMetroDirt.textColor = UIColor.lightGrayColor()
        lblLastMetroDirt.text = items[indexPath.section][1][indexPath.row] as? String
        lblLastMetroDirt.textAlignment = NSTextAlignment.Right
        
        var lblStatInfo = UILabel(frame: CGRect(x:15,y:50,width:230,height:30))
        lblStatInfo.font = UIFont.systemFontOfSize(14)
        lblStatInfo.textColor = UIColor.lightGrayColor()
        lblStatInfo.text = items[indexPath.section][0] as? String
        lblStatInfo.textAlignment = NSTextAlignment.Left
        
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
            var strFirst:NSString = mTrainAlarms![indexPath.section].alamFlag
            if(strFirst.integerValue == 0){
                switchAralm.on = false
                cell!.backgroundColor = UIColor(red: 215/255,
                    green: 255/255,
                    blue: 255/255,
                    alpha: 1.0)
            }else{
                switchAralm.on = true
            }
        }else if(indexPath.row == 1){
            var strLast:NSString = mTrainAlarms![indexPath.section].alamFlag
            if(strLast.integerValue == 0){
                switchAralm.on = false
                cell!.backgroundColor = UIColor(red: 224/255,
                    green: 255/255,
                    blue: 255/255,
                    alpha: 1.0)
            }else{
                switchAralm.on = true
            }
        }
        
        cell!.contentView.addSubview(lblMetroType)
        cell!.contentView.addSubview(lblLastMetroTime)
        cell!.contentView.addSubview(lblLastMetroDirt)
        cell!.contentView.addSubview(lblStatInfo)
        cell!.contentView.addSubview(switchAralm)
        
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
    *      Implements Of UIAlertViewDelegate
    *******************************************************************************/

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
            mUsr002Model.deleteAlarm()
            btnEdit.enabled = true
            imageViewBeep.hidden = true
            
            pushNotification(nil,min: NUM_NEGATIVE_1)
            mAlarm!.cancelFlag = "1"
            mAlarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
            mUsr002Model.updateUsrT01(mAlarm!)
            mAlarm = nil
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
        sgmMain.addTarget(self,
            action: "segmentChanged:",
            forControlEvents: UIControlEvents.ValueChanged)
        sgmMain.setTitle("USR002_28".localizedString(), forSegmentAtIndex: 1)
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
        lblStart.hidden = false
        lblArrow.hidden = false
        lblEnd.hidden = false
        imageViewBeep.hidden = false
        
        // button点击事件
        btnCancel.addTarget(self,
            action: "buttonAction:",
            forControlEvents: UIControlEvents.TouchUpInside)
        btnStart.addTarget(self,
            action: "buttonAction:",
            forControlEvents: UIControlEvents.TouchUpInside)
        btnEdit.addTarget(self,
            action: "buttonAction:",
            forControlEvents: UIControlEvents.TouchUpInside)
        
        let usrt01Alarms:[UsrT01ArrivalAlarmTableData]? = mUsr002Model.findArrivalAlarm()
        
        for key in usrt01Alarms!{
            if(key.cancelFlag != "" && key.cancelFlag != "1"){
                mAlarm = key
                break
            }
        }
        if(mAlarm == nil || mAlarm!.cancelFlag == "1" || mAlarm!.cancelFlag == ""){
            // 当前没有到站提醒
            noAlarm()
            mAlarm = nil
        }else{
            var alarmStart:UsrT01ArrivalAlarmTableData? = usrt01Alarms![0]
            var alarmEnd:UsrT01ArrivalAlarmTableData? = usrt01Alarms![usrt01Alarms!.count - 1]
            
            lblArriveStation.text = "USR002_26".localizedString() + mAlarm!.statToId.station() + "USR002_27".localizedString()
            
            lblStart.backgroundColor = UIColor.clearColor()
            lblStart.font = UIFont.systemFontOfSize(15)
            lblStart.textColor = UIColor.blackColor()
            lblStart.text = alarmStart!.lineFromId.line() + " " + alarmStart!.statFromId.station()
            lblStart.textAlignment = NSTextAlignment.Left
            
            lblArrow.backgroundColor = UIColor.clearColor()
            lblArrow.font = UIFont.systemFontOfSize(15)
            lblArrow.textColor = UIColor.blackColor()
            lblArrow.text = "->"
            lblArrow.textAlignment = NSTextAlignment.Center
            
            lblEnd.backgroundColor = UIColor.clearColor()
            lblEnd.font = UIFont.systemFontOfSize(15)
            lblEnd.textColor = UIColor.blackColor()
            lblEnd.text = alarmEnd!.lineToId.line() + " " + alarmEnd!.statToId.station()
            lblEnd.textAlignment = NSTextAlignment.Right

            lblArriveInfo.text = mAlarm!.lineToId.line() + " " + mAlarm!.traiDirt.station() + "PUBLIC_04".localizedString()
            
            var imgBeep = UIImage(named: "usr007.png")
            imageViewBeep.image = imgBeep
            
            self.view.addSubview(lblStart)
            self.view.addSubview(lblEnd)
            self.view.addSubview(imageViewBeep)
            
            updateTime((mAlarm!.costTime as NSString).integerValue - (mAlarm!.alarmTime as NSString).integerValue)
            
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
    }
    
    /**
     * 末班车提醒
     */
    func lastMetro(){
        // 添加按钮点击事件
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self,
            action: "buttonAction:")
        self.navigationItem.rightBarButtonItem = addButton
        
        tbList.hidden = false
        lblStart.hidden = true
        lblArrow.hidden = true
        lblEnd.hidden = true
        imageViewBeep.hidden = true
        
        // 查询末班车信息
        mTrainAlarms = mUsr002Model.findTrainAlarmTable()
        
        loadItems()
        
        tbList.delegate = self
        tbList.dataSource = self
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
            
            if(mTrainAlarms![section].alamFlag == "0"){
                mTrainAlarms![section].alamFlag = "1"
            }else{
                mTrainAlarms![section].alamFlag = "0"
            }
            mUsr002Model.updateUsrT02(mTrainAlarms![section])
        }
        switch sender{
        case btnCancel:
            RemindDetailController.showMessage(MSG_0001,
                msg:MSG_0002,
                buttons:[MSG_0003, MSG_0004],
                delegate: self)
        case btnStart:
            // 开启线程计时
            var timerThread = TimerThread.shareInstance()
            timerThread.sender = self
            if(timerThread.arriveTime == NO_STATION){
                if(timerThread.executing){
                    return
                }
                var costTime:Int = (mAlarm!.costTime as NSString).integerValue
                // 线程未运行
                timerThread.arriveTime = costTime
                mAlarm!.onboardTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                mUsr002Model.updateUsrT01(mAlarm!)
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
            if(mAlarm == nil){
                remindDetailController.usrT01Data = nil
            }else{
                remindDetailController.usrT01Data = mAlarm!
            }
            // 返回按钮点击事件
            var bakButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            bakButtonStyle.frame = CGRectMake(0, 0, 43, 43)
            bakButtonStyle.setTitle("PUBLIC_05".localizedString(), forState: UIControlState.Normal)
            bakButtonStyle.addTarget(remindDetailController.self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var backButton:UIBarButtonItem = UIBarButtonItem(customView: bakButtonStyle)
            remindDetailController.navigationItem.leftBarButtonItem = backButton

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
            
            // 返回按钮点击事件
            var bakButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            bakButtonStyle.frame = CGRectMake(0, 0, 43, 43)
            bakButtonStyle.tag = SAVE_BUTTON_TAG
            bakButtonStyle.setTitle("PUBLIC_05".localizedString(), forState: UIControlState.Normal)
            bakButtonStyle.addTarget(remindDetailController.self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var backButton:UIBarButtonItem = UIBarButtonItem(customView: bakButtonStyle)
            remindDetailController.navigationItem.leftBarButtonItem = backButton
            
            self.navigationController!.pushViewController(remindDetailController, animated:true)
        default:
            println("nothing")
        }
    }
    
    /**
     * 当前没有提醒
     */
    func noAlarm(){
        btnCancel.enabled = false
        btnStart.enabled = false
        lblArriveStation.text = ""
        lblArriveInfo.text = "USR002_24".localizedString()
        lblStart.text = ""
        lblArrow.text = ""
        lblEnd.text = ""
        imageViewBeep.hidden = true
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
                self.pushNotification("USR002_25".localizedString() + self.mAlarm!.statToId.station(),min: self.NUM_NEGATIVE_1)
                self.mAlarm!.cancelFlag = "1"
                self.mAlarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                self.mUsr002Model.updateUsrT01(self.mAlarm!)
                self.btnStart.enabled = false
                self.btnCancel.enabled = false
                self.arriveStation()
            }else{
                var costTime:Int = (self.mAlarm!.costTime as NSString).integerValue
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
        for key in mTrainAlarms!{
            var trainFlag:Array<String> = [ "USR002_03".localizedString(), "USR002_04".localizedString()]
            var trainTime:Array<String> = [ "", ""]
            var directions:Array<String> = ["",""]
            
            if(key.alamType == "1"){
                trainFlag = ["USR002_03".localizedString()]
            }else{
                trainFlag = ["USR002_04".localizedString()]
            }
            
            trainTime = [convertTrainTime(key.alamTime),""]
            directions = [key.traiDirt.station() + "PUBLIC_04".localizedString(),""]
            
            items.addObject([key.lineId.line() + ":" + key.statId.station(), directions, trainFlag, trainTime])
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
     * 本地推送消息
     */
    func pushNotification(Msg: String?, min:Int?){
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
        AudioServicesPlaySystemSound(1007 as SystemSoundID)
//        AudioServicesPlaySystemSound(4095 as SystemSoundID)
        localNotif.soundName = UILocalNotificationDefaultSoundName
        if(Msg != nil){
            localNotif.alertBody = Msg
        }
        localNotif.applicationIconBadgeNumber = min!
        
        app.scheduleLocalNotification(localNotif)
    }

    /**
     * 本地推送消息(首末班车提醒)
     */
    func pushNotificationLastMetro(Msg: String?, notifyTime:String){
        if(countElements(notifyTime) < 4){
            return
        }
        var fromDate:NSDate = NSDate()
        var calendar:NSCalendar = NSCalendar(identifier: NSGregorianCalendar)
        calendar.timeZone = NSTimeZone.systemTimeZone()
        var dateComp:NSDateComponents = calendar.components((NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond), fromDate: fromDate)
        
        var dateToComp:NSDateComponents = NSDateComponents()
        dateToComp.setValue(dateComp.year, forComponent: NSCalendarUnit.CalendarUnitYear)
        dateToComp.setValue(dateComp.month, forComponent: NSCalendarUnit.CalendarUnitMonth)
        if((notifyTime.left(2) as NSString).integerValue == 0 || (notifyTime.left(2) as NSString).integerValue == 1){
            dateToComp.setValue(dateComp.day + 1, forComponent: NSCalendarUnit.CalendarUnitDay)
        }else{
            dateToComp.setValue(dateComp.day, forComponent: NSCalendarUnit.CalendarUnitDay)
        }
        dateToComp.setValue((notifyTime.left(2) as NSString).integerValue, forComponent: NSCalendarUnit.CalendarUnitHour)
        dateToComp.setValue((notifyTime.right(2) as NSString).integerValue, forComponent: NSCalendarUnit.CalendarUnitMinute)
        var calendarTo:NSCalendar = NSCalendar(identifier: NSGregorianCalendar)
        var toDate:NSDate = calendarTo.dateFromComponents(dateToComp)!
        
        
        // 注册推送权限
        var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
        
        var localNotif:UILocalNotification = UILocalNotification()
        localNotif.fireDate = toDate
        localNotif.timeZone = NSTimeZone.localTimeZone()
        AudioServicesPlaySystemSound(1007 as SystemSoundID)
//        AudioServicesPlaySystemSound(4095 as SystemSoundID)
        localNotif.soundName = UILocalNotificationDefaultSoundName
        if(Msg != nil){
            localNotif.alertBody = Msg
        }
        
        // 通知
        var app = UIApplication.sharedApplication()
        app.registerUserNotificationSettings(settings)
        app.scheduleLocalNotification(localNotif)
    }

    func calTime(toDate:NSDate) -> NSTimeInterval{
        return toDate.timeIntervalSinceNow
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/
    
    
}