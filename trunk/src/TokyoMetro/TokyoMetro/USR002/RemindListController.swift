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
    /* contentView控件 */
    @IBOutlet weak var contentView: UIView!
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
    
    @IBOutlet weak var lblStart: UILabel!
    
    @IBOutlet weak var lblEnd: UILabel!
    
    @IBOutlet weak var imageViewStart: UIImageView!
    
    @IBOutlet weak var imageViewEnd: UIImageView!
    
    /* 到达站点信息 */
    @IBOutlet weak var lblStep1: UILabel!
    
    @IBOutlet weak var lblStep2: UILabel!
    
    @IBOutlet weak var lblStep3: UILabel!
    
    
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
    let MSG_0003 = "PUBLIC_06".localizedString()
    /* 取消 */
    let MSG_0004 = "PUBLIC_07".localizedString()
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
    
    var endLineId:String?
    var endStationId:String?
    
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    var imgViewBeep:UIImageView = UIImageView(frame: CGRect(x: 151,y: 260,width: 18,height: 18))
    
    var mUsr002Model:USR002Model = USR002Model()
    
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
        
//        // 返回按钮点击事件
//        var bakButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        bakButtonStyle.frame = CGRectMake(0, 0, 43, 43)
//        bakButtonStyle.setTitle("PUBLIC_05".localizedString(), forState: UIControlState.Normal)
//        bakButtonStyle.addTarget(remindDetailController.self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        var backButton:UIBarButtonItem = UIBarButtonItem(customView: bakButtonStyle)
//        remindDetailController.navigationItem.leftBarButtonItem = backButton
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
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
        tableView.backgroundColor = UIColor(red: 239/255,
            green: 239/255,
            blue: 244/255,
            alpha: 1.0)
        
        let cellIdentifier:String = "AlarmListCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }

        for subview in cell!.contentView.subviews{
            if(subview.tag as Int == 111){
                continue
            }
            if(subview.isKindOfClass(UILabel) || (subview.tag as Int) == 102){
                subview.removeFromSuperview()
            }
        }
        
        if(mTrainAlarms![indexPath.section].alamFlag == "1" && mTrainAlarms![indexPath.section].voleFlag == "1"){
             pushNotificationLastMetro("\(items[indexPath.section][0])的\(items[indexPath.section][3][indexPath.row])即将发车", notifyTime:"\(items[indexPath.section][3][indexPath.row])",soundId:1)
        }else if(mTrainAlarms![indexPath.section].alamFlag == "1" && mTrainAlarms![indexPath.section].voleFlag == "0"){
            pushNotificationLastMetro("\(items[indexPath.section][0])的\(items[indexPath.section][3][indexPath.row])即将发车", notifyTime:"\(items[indexPath.section][3][indexPath.row])",soundId:0)
        }
        
        var lblMetroType = UILabel(frame: CGRect(x:200,y:50,width:105,height:30))
        lblMetroType.font = UIFont.systemFontOfSize(14)
        lblMetroType.textColor = UIColor.lightGrayColor()
        lblMetroType.text = items[indexPath.section][2][0] as? String
        lblMetroType.textAlignment = NSTextAlignment.Right
        
        var lblLastMetroTime:UILabel? = cell!.contentView.viewWithTag(111) as? UILabel
        if(lblLastMetroTime == nil){
            lblLastMetroTime = UILabel(frame: CGRect(x:15,y:0,width:230,height:50))
            lblLastMetroTime!.font = UIFont.systemFontOfSize(60)
        }
        lblLastMetroTime!.text = items[indexPath.section][3][indexPath.row] as? String
        lblLastMetroTime!.textAlignment = NSTextAlignment.Left
        
        var lblLastMetroDirt = UILabel(frame: CGRect(x:160,y:50,width:105,height:30))
        lblLastMetroDirt.font = UIFont.systemFontOfSize(14)
        lblLastMetroDirt.textColor = UIColor.blackColor()
        lblLastMetroDirt.text = items[indexPath.section][1][indexPath.row] as? String
        lblLastMetroDirt.textAlignment = NSTextAlignment.Left
        lblLastMetroDirt.adjustsFontSizeToFitWidth = true
        
        var lblStatInfo = UILabel(frame: CGRect(x:15,y:50,width:230,height:30))
        lblStatInfo.font = UIFont.systemFontOfSize(14)
        lblStatInfo.textColor = UIColor.blackColor()
        lblStatInfo.text = "\(items[indexPath.section][0])" + "USR002_29".localizedString()
        lblStatInfo.textAlignment = NSTextAlignment.Left
        lblStatInfo.adjustsFontSizeToFitWidth = true
        
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
                cell!.backgroundColor = UIColor(red: 239/255,
                    green: 239/255,
                    blue: 244/255,
                    alpha: 1.0)
                lblLastMetroTime!.textColor = UIColor.lightGrayColor()
                lblMetroType.textColor = UIColor.lightGrayColor()
                lblLastMetroDirt.textColor = UIColor.lightGrayColor()
                lblStatInfo.textColor = UIColor.lightGrayColor()
            }else{
                switchAralm.on = true
                cell!.backgroundColor = UIColor.whiteColor()
                lblLastMetroTime!.textColor = UIColor.blackColor()
                lblMetroType.textColor = UIColor.blackColor()
                lblLastMetroDirt.textColor = UIColor.blackColor()
                lblStatInfo.textColor = UIColor.blackColor()
            }
        }else if(indexPath.row == 1){
            var strLast:NSString = mTrainAlarms![indexPath.section].alamFlag
            if(strLast.integerValue == 0){
                switchAralm.on = false
                cell!.backgroundColor = UIColor(red: 224/255,
                    green: 255/255,
                    blue: 255/255,
                    alpha: 1.0)
                lblLastMetroTime!.textColor = UIColor.lightGrayColor()
            }else{
                switchAralm.on = true
            }
        }
        
        cell!.contentView.addSubview(lblMetroType)
        cell!.contentView.addSubview(lblLastMetroDirt)
        cell!.contentView.addSubview(lblStatInfo)
        cell!.contentView.addSubview(switchAralm)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
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
            imgViewBeep.hidden = true
            imageViewStart.hidden = true
            imageViewEnd.hidden = true
            
            pushNotification(nil,min: NUM_NEGATIVE_1,soundId: 0)
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
        sgmMain.setTitle("USR001_29".localizedString(), forSegmentAtIndex: 1)
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
        contentView.hidden = false
        imgViewBeep.hidden = false
        imageViewStart.hidden = false
        imageViewEnd.hidden = false
        
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
        
        let lblSteps:[UILabel] = [lblStep1,lblStep2,lblStep3]
        for(var i=0;i<usrt01Alarms!.count;i++){
            if(i >= lblSteps.count){
                break
            }
            var mUsrT01Data:UsrT01ArrivalAlarmTableData = usrt01Alarms![i]
            lblSteps[i].text = "\(i). " + mUsrT01Data.statFromId.station() + "  ->  " + mUsrT01Data.statToId.station()
            if(mUsrT01Data.cancelFlag != "" && mUsrT01Data.cancelFlag != "1" && mAlarm == nil){
                mAlarm = mUsrT01Data
            }
        }
        
        if(mAlarm == nil || mAlarm!.cancelFlag == "1" || mAlarm!.cancelFlag == ""){
            // 当前没有到站提醒
            noAlarm()
            mAlarm = nil
        }else{
            var alarmStart:UsrT01ArrivalAlarmTableData? = usrt01Alarms![0]
            var alarmEnd:UsrT01ArrivalAlarmTableData? = usrt01Alarms![usrt01Alarms!.count - 1]
            
            if(mAlarm!.statToId == alarmEnd!.statToId){
                lblArriveStation.text = "USR002_16".localizedString() + mAlarm!.statToId.station() +  "USR002_17".localizedString() + "," + "USR002_27".localizedString()
            }else{
                lblArriveStation.text = "USR002_16".localizedString() + mAlarm!.statToId.station() + "CMN003_01".localizedString() + "," + "USR002_27".localizedString()
            }
            
            lblStart.backgroundColor = UIColor.clearColor()
            lblStart.font = UIFont.systemFontOfSize(15)
            lblStart.textColor = UIColor.blackColor()
            lblStart.text = alarmStart!.lineFromId.line() + " " + alarmStart!.statFromId.station()
            lblStart.textAlignment = NSTextAlignment.Left
            
            lblEnd.backgroundColor = UIColor.clearColor()
            lblEnd.font = UIFont.systemFontOfSize(15)
            lblEnd.textColor = UIColor.blackColor()
            lblEnd.text = alarmEnd!.lineToId.line() + " " + alarmEnd!.statToId.station()
            lblEnd.textAlignment = NSTextAlignment.Right
            
            endLineId = alarmEnd!.lineToId
            endStationId = alarmEnd!.statToId

            lblArriveInfo.text = "USR002_28".localizedString()
            var imgBeep = UIImage(named: "usr007")
            if(mAlarm!.voleFlag == "1"){
                 imgBeep = UIImage(named: "usr008")
            }
            imgViewBeep.image = imgBeep
            
            contentView.addSubview(imgViewBeep)
            
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
                showTime(mUsr002Model.convertTime(timerThread.surplusTime))
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
        contentView.hidden = true
        
        // 查询末班车信息
        mTrainAlarms = mUsr002Model.findTrainAlarmTable()
        
        items = mUsr002Model.loadItems(mTrainAlarms)
        
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
            items = mUsr002Model.loadItems(mTrainAlarms)
            tbList.reloadData()
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
                runInBackground()
            }else{
                // 线程已经运行,显示当前剩余时间
                showTime(mUsr002Model.convertTime(timerThread.surplusTime))
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
                remindDetailController.endLineId = endLineId
                remindDetailController.endStationId = endStationId
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
        btnEdit.enabled = true
        lblArriveStation.text = ""
        lblArriveInfo.text = "USR002_24".localizedString()
        lblStart.text = ""
        lblEnd.text = ""
        imgViewBeep.hidden = true
        imageViewStart.hidden = true
        imageViewEnd.hidden = true
    }
    
    /**
     * 更新剩余时间
     */
    func updateTime(time: Int){
        var times = mUsr002Model.convertTime(time)
        if(times.count < 1){
            return
        }
        // 在子线程中更新UI
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.showTime(times)
            if(time == self.NUM_0){
                if(self.mAlarm!.beepFlag == "0"){
                     self.pushNotification("USR002_25".localizedString() + self.mAlarm!.statToId.station(),min: self.NUM_NEGATIVE_1,soundId: 1007)
                }else{
                    self.pushNotification("USR002_25".localizedString() + self.mAlarm!.statToId.station(),min: self.NUM_NEGATIVE_1,soundId: 4095)
                }
                self.mAlarm!.cancelFlag = "1"
                self.mAlarm!.cancelTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                self.mUsr002Model.updateUsrT01(self.mAlarm!)
                self.btnStart.enabled = false
                self.btnCancel.enabled = false
                self.arriveStation()
            }else{
                var costTime:Int = (self.mAlarm!.costTime as NSString).integerValue
                if(time % 60 == 0){
                    self.pushNotification(nil,min: (time/60)%60,soundId: 0)
                }
            }
        }
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
     * 在后台执行
     */
    func runInBackground(){
        let app = UIApplication.sharedApplication()
        var controller:RemindListController = self
        var backgroundTask = app.beginBackgroundTaskWithExpirationHandler { () -> Void in
            println("run in background...Over")
        }
    }
    
    /**
     * 本地推送消息
     */
    func pushNotification(Msg: String?, min:Int?, soundId: UInt32){
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
        if(soundId != 0){
            AudioServicesPlaySystemSound(soundId as SystemSoundID)// 1007,4095
        }
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
    func pushNotificationLastMetro(Msg: String?, notifyTime:String,soundId: UInt32){
        if(countElements(notifyTime) < 4){
            return
        }
        var fromDate:NSDate = NSDate()
        var calendar:NSCalendar = NSCalendar.currentCalendar()// identifier: NSGregorianCalendar
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
        var calendarTo:NSCalendar = NSCalendar.currentCalendar()// identifier: NSGregorianCalendar
        var toDate:NSDate = calendarTo.dateFromComponents(dateToComp)!
        
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
        localNotif.fireDate = toDate
        localNotif.timeZone = NSTimeZone.localTimeZone()
        if(soundId != 0){
            AudioServicesPlaySystemSound(soundId as SystemSoundID)// 1007,4095
        }
        localNotif.soundName = UILocalNotificationDefaultSoundName
        if(Msg != nil){
            localNotif.alertBody = Msg
        }

        app.scheduleLocalNotification(localNotif)
    }

    func calTime(toDate:NSDate) -> NSTimeInterval{
        return toDate.timeIntervalSinceNow
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/
    
    
}