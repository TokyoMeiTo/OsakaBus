//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import CoreLocation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, GPSDelegate, UITextFieldDelegate{
    

    //////////////// 控件
    
    // 交换按钮
    @IBOutlet weak var btnExchange: UIButton!
    // 起点文本
    @IBOutlet weak var stationStart: UITextField!
    // 终点文本
    @IBOutlet weak var stationEnd: UITextField!
    // 显示数据的tableView
    @IBOutlet weak var tbView: UITableView!
    // 查询按钮
    @IBOutlet weak var btnSearchRoute: UIButton!
    // 收藏按钮1
    @IBOutlet weak var btnCollect1: UIButton!
    // 收藏按钮2
    @IBOutlet weak var btnCollect2: UIButton!
    // 最近站点
    @IBOutlet weak var btnNearlyStation: UIButton!
    // 收藏站点
    @IBOutlet weak var btnCollectionStation: UIButton!
    // 所有站点列表
    @IBOutlet weak var btnPopToStaionList: UIButton!
    // 提示当前tableView是查询结果
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var btnInView: UIView!
    
    // 屏幕尺寸
    var mScreenSize: CGSize!
    
    /* 加载进度条ActivityIndicatorView */
    @IBOutlet weak var gaiLoading: UIActivityIndicatorView!
    
    //////////////// 全局变量
    
    // 用来记录搜索出的搜友站点中文名
    var allOfStationItems : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点日文名
    var allOfStationItemsJP : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点Icon名
    var allOflineImageItems : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜站点日文名
    var allOfStationItemsJpKana : NSMutableArray = NSMutableArray.array()
    // 用来记录从数据库中所搜的所有站点的信息
    var stationItems : NSMutableArray = NSMutableArray.array()
    // 用来记录从数据库收藏表中的站点ID
    var usrStationIds : NSMutableArray = NSMutableArray.array()
    // 用来记录从数据库路线表中的路线结果
    var routeDetial : NSMutableArray = NSMutableArray.array()
    // 用来记录从数据库搜索的某一个站点的线路id
    var onStationlineGroup : NSMutableArray = NSMutableArray.array()
    // 用来记录从数据库搜索的每一个站点的线路id
    var allStationlineGroup : NSMutableArray = NSMutableArray.array()
    // 记录焦点位置 1为起点文本  2为终点文本
    var focusNumber : String = "1"
    // 记录起点站点名
    // 记录起点站点ID
    var routeStartStationId : String = " "
    // 记录终点站点名
    // 记录终点站点ID
    var routeEndStationId : String = " "
    // 记录路线ID
    var routeID : String = " "
    var startStationText : String = ""
    var endStationText : String = ""
    var mImgZoomScale : CGFloat = 0.0
    var mst02table = MstT02StationTable()
    var user03table = UsrT03FavoriteTable()
    var fare06table = LinT06FareTable()
    var routeDetial05table = LinT05RouteDetailTable()
    var testView: UIView = UIView()
    
    /* GPSHelper */
    let GPShelper: GPSHelper = GPSHelper()
    
    // 区分查询前页面和查询后结果页面。 1 为查询前页面。 2为查询后结果页面 3为附近站点
    var pageTag : String = "1"
    let FOUCSCHANGETO1 : Selector = "foucsChangeTo1"
    let FOUCSCHANGETO2 : Selector  = "foucsChangeTo2"
    let EXCHANGEACTION : Selector  = "exchangeAction"
    let SEARCHWAYACTION : Selector  = "searchWayAction"
    let ADDUSERFAVORITE : Selector  = "addUserfavorite:"
    let COLLECTEDSTATION : Selector  = "loadCollectedStation"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mScreenSize = UIScreen.mainScreen().bounds.size
        
        var strStart:NSString = "起点"
        var strEnd:NSString = "终点"
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        
        loadStation()
        btnExchange.layer.cornerRadius = 4

        btnExchange.addTarget(self, action: EXCHANGEACTION, forControlEvents: UIControlEvents.TouchUpInside)
        stationStart.addTarget(self, action: FOUCSCHANGETO1, forControlEvents: UIControlEvents.AllEditingEvents)
        stationEnd.addTarget(self, action: FOUCSCHANGETO2, forControlEvents: UIControlEvents.AllEditingEvents)
         // btnSearchRoute.addTarget(self, action: SEARCHWAYACTION, forControlEvents: UIControlEvents.TouchUpInside)
        btnCollectionStation.addTarget(self, action: COLLECTEDSTATION, forControlEvents: UIControlEvents.TouchUpInside)
        
        testView.frame = CGRectMake(320, 568, 320, 44)
        testView.backgroundColor = UIColor.whiteColor()
        mTipView()
        self.view.addSubview(testView)
        
        // 返回按钮点击事件
        var SearchButton:UIBarButtonItem = UIBarButtonItem(title: "查询", style: UIBarButtonItemStyle.Plain, target:self, action: "searchWayAction")
        self.navigationItem.rightBarButtonItem = SearchButton
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        readStationIdCache()
        if (startStationText != "") {
            self.stationStart.text = startStationText.station()
        } else {
            
        }
        
        if (endStationText != "") {
            self.stationEnd.text = endStationText.station()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        setSationIdCache()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.pageTag == "2" {
            return 70
        } else {
            return 40
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.pageTag == "2" {
            return self.routeDetial.count + 1
        } else {
            return self.allOfStationItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if (self.pageTag == "1" || self.pageTag == "3") {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            var celllblSatationName : UILabel = cell.viewWithTag(101) as UILabel!
            var celllblSatationNameJP : UILabel = cell.viewWithTag(102) as UILabel!
            var celllblCollection : UIImageView = cell.viewWithTag(100) as UIImageView!
            
            celllblSatationName.text  = self.allOfStationItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            
            var jpNameStr = self.allOfStationItemsJP.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            var jpNameKanaStr = self.allOfStationItemsJpKana.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            celllblSatationNameJP.text  = (jpNameStr! + "(" + jpNameKanaStr! +  ")") as String
            if (self.pageTag == "1") {
                celllblCollection.image = "route_collectionlight".getImage()
            } else if (self.pageTag == "3") {
                celllblCollection.image = "route_locate".getImage()
            }
            
            var lineImageItemsRow = self.allOflineImageItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as NSArray
            for (var i = 0; i < lineImageItemsRow.count; i++) {
                var map = lineImageItemsRow[i] as MstT02StationTable
                var lineIcon: UIImageView = UIImageView()
                lineIcon.frame = CGRectMake(CGFloat(270 - i * 20), 10, 20, 20)
                lineIcon.image = (map.item(MSTT02_LINE_ID) as String).getLineImage()
                cell.addSubview(lineIcon)
            }
           return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeResultCell", forIndexPath: indexPath) as UITableViewCell
            var resultCellIvStaionIcon : UIImageView = cell.viewWithTag(1001) as UIImageView
            var resultCelllblStationName : UILabel = cell.viewWithTag(1002) as UILabel
            var resultCelllblStationLineName : UILabel = cell.viewWithTag(1005) as UILabel
            var resultCelllblStationWaitTime : UILabel = cell.viewWithTag(1004) as UILabel
            var resultCelllblStationMoveTime : UILabel = cell.viewWithTag(1006) as UILabel
            
            if indexPath.row == 0 {
                resultCellIvStaionIcon.hidden = true
                resultCelllblStationName.hidden = true
                resultCelllblStationLineName.hidden = true
                resultCelllblStationWaitTime.hidden = true
                resultCelllblStationMoveTime.hidden = true

                var cellInfo:UIView = UIView()
                cellInfo.frame = CGRectMake(5,5,310,60)
                cellInfo.backgroundColor = UIColor.whiteColor()
                cellInfo.layer.cornerRadius = 4
                var lable1: UILabel! = cell.viewWithTag(2001) as? UILabel
                if (lable1 != nil) {
                    lable1.removeFromSuperview()
                }
                
                var resultCelllblStationTip1 : UILabel = UILabel()
                resultCelllblStationTip1.frame = CGRectMake(15,5,200,20)
                resultCelllblStationTip1.font = UIFont.systemFontOfSize(17)
                resultCelllblStationTip1.tag = 2001
                if (routeDetial.count - 2 > 0) {
                     resultCelllblStationTip1.text = "EXCHANGE_TYPE_1".localizedString() + (routeDetial.count - 2).description + " " + "CMN003_23".localizedString()
                } else {
                    resultCelllblStationTip1.hidden = true
                }

                var lable2: UILabel! = cell.viewWithTag(2002) as? UILabel
                if (lable2 != nil) {
                    lable2.removeFromSuperview()
                }

                var resultCelllblStationTip2 : UILabel = UILabel()
                resultCelllblStationTip2.font = UIFont.systemFontOfSize(14)
                resultCelllblStationTip2.frame = CGRectMake(15,30,200,20)
                resultCelllblStationTip2.tag = 2002
                resultCelllblStationTip2.text = "PUBLIC_10".localizedString() + getFare()

                cellInfo.addSubview(resultCelllblStationTip1)
                cellInfo.addSubview(resultCelllblStationTip2)
                cell.addSubview(cellInfo)
            } else {
                if (indexPath.row == routeDetial.count){
                    
                    resultCellIvStaionIcon.hidden = false
                    resultCelllblStationName.hidden = false
                    resultCelllblStationLineName.hidden = true
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationMoveTime.hidden = true
                    
                    // 设置终点图片
                    resultCellIvStaionIcon.image = "route_end".getImage()
                    resultCelllblStationName.text = stationEnd.text as String

                } else {  
                    var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
                    
                    var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString

                    var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                    var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
                    
                    resultCelllblStationLineName.font =  UIFont.systemFontOfSize(12)
                    
                    var strresultExchType = routStartDic["resultExchType"] as? NSString
                    
                    
                    resultCelllblStationName.text = (strresultExchStatId as String).station()
                    
                    resultCelllblStationWaitTime.text = "CMN003_02".localizedString() + (strresultExchWaitTime as String) + "CMN003_03".localizedString()
                    resultCelllblStationMoveTime.text = "CMN003_04".localizedString() + (strresultExchMoveTime as String) + "CMN003_03".localizedString()
                    
                    if (indexPath.row - 1 == 0){
                        // 设置起点图片
                        resultCellIvStaionIcon.image = "route_start".getImage()
                        
                        if (strresultExchType == "255") {
                            resultCelllblStationMoveTime.text = "CMN003_07".localizedString() + (strresultExchMoveTime as String) + "CMN003_03".localizedString()
                            resultCelllblStationLineName.hidden = true
                            resultCelllblStationWaitTime.hidden = true
                            
                        } else if (strresultExchType == "8") {
                            resultCelllblStationLineName.hidden = false
                            var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                            resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                            var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                             resultCelllblStationLineName.text = "CMN003_05".localizedString() + (strresultExchlineId as String).line() + "CMN003_06".localizedString() + (strresultExchDestId as String).station() + "PUBLIC_04".localizedString()
                        }

                    } else {
                        
                        if (strresultExchType == "255") {
                            resultCellIvStaionIcon.image = "routeexchange_walk".getImage()
                            resultCelllblStationMoveTime.text = "CMN003_07".localizedString() + (strresultExchMoveTime as String) + "CMN003_03".localizedString()
                            resultCelllblStationLineName.hidden = true
                            resultCelllblStationWaitTime.hidden = true
                            
                        } else if (strresultExchType == "8") {
                            resultCelllblStationLineName.hidden = false
                            var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                            resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                            resultCellIvStaionIcon.image = "routeexchange_metro".getImage()
                            var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                            resultCelllblStationLineName.text = "CMN003_01".localizedString() + (strresultExchlineId as String).line() + "CMN003_06".localizedString() + (strresultExchDestId as String).station() + "PUBLIC_04".localizedString()
                        }
                    }
                    
                }
            }
            return cell
        } 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (self.pageTag == "1" || self.pageTag == "3") {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            var celllblStaionName : UILabel = cell.viewWithTag(101) as UILabel
            var stationName : String? =  celllblStaionName.text
        
            if focusNumber == "1" {
                if !(stationName == self.stationEnd.text)  {
                    self.stationStart.text = stationName
                 } else {
                    errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_09".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
                }
            
            } else if focusNumber == "2" {
            
                if !(stationName == self.stationStart.text) {
                   self.stationEnd.text = stationName
                } else {
                   errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_09".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
                }
            
           }
        } else if (self.pageTag == "2") {
            
            setSationIdCache()
            if (indexPath.row  == routeDetial.count) {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
                var resultCelllblStationName : UILabel = cell.viewWithTag(1002) as UILabel
                var tempStationId = serarchStationIdByStationName(resultCelllblStationName.text as String!)
                var stationDetialArr:MstT02StationTable = getStationDetialById(tempStationId)
                var stationDetail : StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
                stationDetail.stat_id = tempStationId
                stationDetail.cellJPName = stationDetialArr.statName as String
                stationDetail.cellJPNameKana = stationDetialArr.statNameKana as String
                stationDetail.statMetroId = stationDetialArr.statNameMetroId as String
                self.navigationController?.pushViewController(stationDetail, animated:true)
                
            } else if (indexPath.row  != 0){
                var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
                var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
                
                var stationDetialArr:MstT02StationTable = getStationDetialById(strresultExchStatId as String)
                var stationDetail : StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
                stationDetail.stat_id = strresultExchStatId as String
                stationDetail.cellJPName = stationDetialArr.statName as String
                stationDetail.cellJPNameKana = stationDetialArr.statNameKana as String
                stationDetail.statMetroId = stationDetialArr.statNameMetroId as String
                self.navigationController?.pushViewController(stationDetail, animated:true)

            }
            
                  }
        hideKeyBoard()

    }
    
    // 起点和终点交换
    func exchangeAction(){
        
        var tempName:NSString = self.stationStart.text
        self.stationStart.text = self.stationEnd.text
        self.stationEnd.text = tempName
        hideKeyBoard()
    }
    
    
    func searchWayAction(){
        
        // 判断合法性
        if ( self.stationStart.text == "" || self.stationEnd.text == "" || self.stationStart.text == self.stationEnd.text) {
           errAlertView("CMN003_10".localizedString(), errMgs: "CMN003_11".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())        } else {
            searchRouteAction()
            hideKeyBoard()
         }
    }
    
    // 进行搜索操作
    func searchRouteAction() {
        
        self.routeStartStationId = serarchStationIdByStationName(stationStart.text)
        self.routeEndStationId = serarchStationIdByStationName(stationEnd.text)
        
        if (routeStartStationId == "" || routeEndStationId == "") {
            errAlertView("CMN003_10".localizedString(), errMgs: "CMN003_13".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
            return
        }
        showTipBtn("1")
        getRouteIdByStationId(routeStartStationId, endStationId: routeEndStationId)
        getRouteline()
        self.pageTag = "2"
        tbView.reloadData()
        
    }
    
    func foucsChangeTo1 () {
        self.focusNumber = "1"
        hideKeyBoard()
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"
        hideKeyBoard()
    }
    
    // 弹出对话框，判断是否要跳转到StationList页面
    @IBAction func isPopToStationList() {
        setSationIdCache()
        var searchAllStation : SearchStationList = self.storyboard?.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
        searchAllStation.focusNumber = self.focusNumber
        searchAllStation.classType = "routeSearch"
        self.navigationController?.pushViewController(searchAllStation, animated:true)
    }
    
    func isPopToAlarm() {
        var sureBtn: UIAlertView = UIAlertView(title: "CMN003_12".localizedString(), message: "CMN003_15".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_07".localizedString(), otherButtonTitles: "PUBLIC_06".localizedString())
        sureBtn.tag = 200
        sureBtn.show()
    }
    
    func isCollectionRoute() {
        var sureBtn: UIAlertView = UIAlertView(title: "CMN003_12".localizedString(), message: "CMN003_16".localizedString(), delegate: self, cancelButtonTitle: "PUBLIC_07".localizedString(), otherButtonTitles: "PUBLIC_06".localizedString())
        sureBtn.tag = 300
        sureBtn.show()
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {    
        if (buttonIndex == 1) {
            switch (alertView.tag) {
            case 200:
                // 跳转到设置提醒页面
                var remindListController : RemindListController = self.storyboard?.instantiateViewControllerWithIdentifier("RemindListController") as RemindListController
                remindListController.routeStatTable01 = getStationDetialById(routeStartStationId)
                remindListController.routeStatTable02 = getStationDetialById(routeEndStationId)
                self.navigationController?.pushViewController(remindListController, animated:true)

           case 300:
                addUserfavoriteRoute()
            
           default :
                self.pageTag == "1"
                tbView.reloadData()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 弹出错误提示框
    func errAlertView(errTitle:String, errMgs:String, errBtnTitle:String) {
        var eAv:UIAlertView = UIAlertView()
        eAv.title = errTitle
        eAv.message = errMgs
        eAv.addButtonWithTitle(errBtnTitle)
        eAv.show()
    }
    
    // 失去焦点，隐藏键盘
    func hideKeyBoard() {
        stationEnd.resignFirstResponder()
        stationStart.resignFirstResponder()
    }
    
    func loadCollectedStation(){
        loadStation()
        showTipBtn("0")
    }

    // 获取所有站的站名和图标
    func loadStation() {

        self.pageTag = "1"
        allStationlineGroup.removeAllObjects()
        allOfStationItems.removeAllObjects()
        allOfStationItemsJP.removeAllObjects()
        allOflineImageItems.removeAllObjects()
        allOfStationItemsJpKana.removeAllObjects()
        self.usrStationIds.removeAllObjects()
        self.tbView.reloadData()
        
        // 现将收藏表中所有id取出来
        user03table.favoType = "01"
        var user03IdsRow = user03table.selectAll()

        for user03IdsValus in user03IdsRow {
            user03IdsValus as UsrT03FavoriteTable
            var user03Values: String = user03IdsValus.item(USRT03_STAT_ID) as String
            self.usrStationIds.addObject(user03Values)
        }
        
        // 现将收藏表中所有id取出来在mst02中查询相关站的信息
        for usrStationid in usrStationIds {
            mst02table.statId = usrStationid as String
            var mst02StationID:NSArray = mst02table.selectAll()
            for key in mst02StationID {
                key as MstT02StationTable
                var stationNameJP:AnyObject = key.item(MSTT02_STAT_NAME)
                var stationName:AnyObject = key.item(MSTT02_STAT_NAME_EXT1)
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var stationNameKanatemp = key.item(MSTT02_STAT_NAME_KANA) as String
                
                var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                self.allOflineImageItems.addObject(statSeqArr)
                self.allOfStationItemsJP.addObject(stationNameJP)
                self.allOfStationItems.addObject(stationName)
                self.allOfStationItemsJpKana.addObject(stationNameKanatemp)

            }
            tbView.reloadData()
        }
        self.lblTip.text = "CMN003_17".localizedString()
    }

    // 根据车站名字搜索车站ID
    func serarchStationIdByStationName(StationNames:String) -> String {
        var resultid = ""
        var mst02table = MstT02StationTable()
        var mst02rowID = mst02table.excuteQuery("select STAT_ID from MSTT02_STATION where STAT_NAME_EXT1 = '" + StationNames + "' and STAT_ID like '280%' ")
        for mst02Row in mst02rowID {
            mst02Row as MstT02StationTable
            var searchstationId = mst02Row.item(MSTT02_STAT_ID) as String
            resultid = searchstationId
        }
        return resultid
    }


    // 添加收藏站点
    @IBAction func addUserfavoriteStation(sender: UIButton) {
        var insetStationName : String = ""
        switch sender {
        case btnCollect1:
            if stationStart.text != "" {
                insetStationName = stationStart.text
            } else {
                return
            }
            
        case btnCollect2:
            if stationEnd.text != "" {
                insetStationName = stationEnd.text
            } else {
                return
            }
            
        default:
            return
        }

        var user03table = UsrT03FavoriteTable()
        user03table.statId = serarchStationIdByStationName(insetStationName)
        user03table.favoType = "01"
        var user03insertBefore = user03table.selectAll()
        var checkInsert : NSMutableArray = NSMutableArray.array()
        for user03checkInsertValue in user03insertBefore {
            user03checkInsertValue  as UsrT03FavoriteTable
            var mst02ResultLineId:AnyObject = user03checkInsertValue.item(USRT03_STAT_ID)
            checkInsert.addObject(mst02ResultLineId)
        }

        if checkInsert.count > 0 {
            errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_19".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
        } else {
            user03table.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insert = user03table.insert()
            if !user03insert {
                errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_20".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
            } else {
                errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_21".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
            }
        }
    }
    
    // 添加收藏路线
    func addUserfavoriteRoute() {
        var user03table = UsrT03FavoriteTable()
        user03table.ruteId = self.routeID
        user03table.favoType = "04"
        var user03insertBefore = user03table.selectAll()
        
        var checkInsert : NSMutableArray = NSMutableArray.array()
        for user03checkInsertValue in user03insertBefore {
            user03checkInsertValue  as UsrT03FavoriteTable
            var mst02ResultLineId:AnyObject = user03checkInsertValue.item(USRT03_RUTE_ID)
            checkInsert.addObject(mst02ResultLineId)
        }
        
        if checkInsert.count > 0 {
            errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_24".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
        } else {
            user03table.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insert = user03table.insert()
            if !user03insert {
                errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_20".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
            } else {
                errAlertView("CMN003_18".localizedString(), errMgs:"CMN003_21".localizedString(), errBtnTitle:"PUBLIC_06".localizedString())
            }
        }
    }
    
    // 根据起点站和终点站获取路线ID
    func getRouteIdByStationId(startStaionId:NSString ,endStationId:NSString) -> String {
        
        var  nsStaionID1 : NSString = startStaionId as NSString
        var  nsStaionID2 : NSString = endStationId as NSString
        var routeId : NSString = ""
        routeId = (nsStaionID1.substringFromIndex(3) + nsStaionID2.substringFromIndex(3))
        routeID = routeId as String
        return routeID
    }
    // 根据路线ID查询费用
    func getFare() -> String {
        var resultFare : String = " "
        
        fare06table.ruteId = self.routeID
        var fare06Row = fare06table.selectAll()
        for key in fare06Row {
            key as LinT06FareTable
            var fare : String = key.item(LINT06_FARE_FARE_ADULT).description
            resultFare = fare
        }
        return resultFare
    }
    
    // 根据路线ID查询换乘路径
    func getRouteline() {
        
        self.routeDetial.removeAllObjects()
        routeDetial05table.ruteId = self.routeID
        var routeDeital05Row = routeDetial05table.selectAll()
        
        for key2 in routeDeital05Row {
            key2 as LinT05RouteDetailTable
            
          //  8 : 换乘  255：步行
            var resultExchType = key2.item(LINT05_ROUTE_DETAIL_EXCH_TYPE) as? String
            
            var resultExchStatId = key2.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID) as? NSString
            var resultExchlineId = key2.item(LINT05_ROUTE_DETAIL_EXCH_LINE_ID) as? NSString
            var resultExchDestId = key2.item(LINT05_ROUTE_DETAIL_EXCH_DEST_ID) as? NSString
            var resultExchSeq : AnyObject = key2.item(LINT05_ROUTE_DETAIL_EXCH_SEQ)
            var resultExchMoveTime : AnyObject = key2.item(LINT05_ROUTE_DETAIL_MOVE_TIME)
            var resultExchWaitTime: AnyObject = key2.item(LINT05_ROUTE_DETAIL_WAIT_TIME)
            
            var routeItem = ["resultExchStatId":resultExchStatId ,"resultExchlineId":resultExchlineId, "resultExchDestId":resultExchDestId, "resultExchSeq":resultExchSeq.description, "resultExchMoveTime":resultExchMoveTime.description, "resultExchWaitTime":resultExchWaitTime.description, "resultExchType":resultExchType]
            self.routeDetial.addObject(routeItem)
        }
        self.lblTip.text = "CMN003_22".localizedString()
       
    }
    
    // 跳转到站点详情页面
    func getStationDetialById(StationID:String) -> MstT02StationTable{
        var mst02table = MstT02StationTable()
        mst02table.statId = StationID
        var mMst02StationArr:MstT02StationTable = mst02table.select() as MstT02StationTable
        return mMst02StationArr
    }
    
        // 放置本地数据
        func setSationIdCache() {
    
            var accoutDefault : NSUserDefaults = NSUserDefaults()
            var historyStationdate: NSMutableArray = NSMutableArray.array()
            historyStationdate.addObject(startStationText)
            historyStationdate.addObject(endStationText)
            accoutDefault.setObject(historyStationdate, forKey: "historyStationdata")
        }
    
        // 读取本地数据
        func readStationIdCache() {
            var accoutDefaultRead : NSUserDefaults = NSUserDefaults()
            if accoutDefaultRead.objectForKey("historyStationdata") != nil {
                var readdate : NSMutableArray = accoutDefaultRead.objectForKey("historyStationdata") as NSMutableArray
                stationStart.text = (readdate[0] as String).station()
                stationEnd.text = (readdate[1] as String).station()
            }
        }
    
        //  清空本地数据
        func clearStationIdCache() {
            var accoutDefaultClear : NSUserDefaults = NSUserDefaults()
            accoutDefaultClear.setObject("", forKey: "historyStationdata")
        }
    
    /**
    * 加载当前位置
    */
    func loadLocation(){
        ActivityIndicatorController.show(gaiLoading)
        if(GPShelper.delegate == nil){
            GPShelper.delegate = self
        }
        GPShelper.updateLocation()
    }
    
    /**
    * 到DB中查找最近的站点
    */
    func selectStationTable(fromLocation: CLLocation) -> Array<MstT02StationTable>{
        var stations:Array<MstT02StationTable> = Array<MstT02StationTable>()
        
        var dao = Cmn003Dao()
        var coordinateOnMars: CLLocationCoordinate2D = fromLocation.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
        stations = dao.queryMiniDistance(lon,lat: lat) as Array<MstT02StationTable>
        return stations
        
    }
    
    @IBAction func locatNearlyStation() {
        // 定位时打开
        // loadLocation()
        // 起点軽度
        let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
        // 起点緯度
        let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
        var testLocation :CLLocation = CLLocation(latitude: 35.672737, longitude: 139.768898)
        locationUpdateComplete(testLocation)
    }
    
    // 位置定位到最近站点
    func locationUpdateComplete(testLocation: CLLocation){
        
        self.pageTag = "3"
        allStationlineGroup.removeAllObjects()
        allOfStationItems.removeAllObjects()
        allOfStationItemsJP.removeAllObjects()
        allOflineImageItems.removeAllObjects()
        allOfStationItemsJpKana.removeAllObjects()
        self.tbView.reloadData()
        
        var locationTest : CLLocation = CLLocation(latitude: testLocation.coordinate.latitude, longitude: testLocation.coordinate.longitude)
        // 获取最近的10个站点
        var stations : Array<MstT02StationTable> = selectStationTable(locationTest)

        // 显示唯10条
        for nearlystationId in stations{
            var mMst02tableNearlyStation = MstT02StationTable()
            
            mMst02tableNearlyStation.statGroupId = nearlystationId.statGroupId as String
            
            var mst02StationID:NSArray = mMst02tableNearlyStation.selectAll()
            
            for key in mst02StationID {
                
                key as MstT02StationTable
                var stationNameJP:AnyObject = key.item(MSTT02_STAT_NAME)
                var stationName:AnyObject = key.item(MSTT02_STAT_NAME_EXT1)
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var stationNameKanatemp = key.item(MSTT02_STAT_NAME_KANA) as String
                
                
                var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                self.allOflineImageItems.addObject(statSeqArr)
                self.allOfStationItemsJP.addObject(stationNameJP)
                self.allOfStationItems.addObject(stationName)
                self.allOfStationItemsJpKana.addObject(stationNameKanatemp)
            }
            
        }
        tbView.reloadData()
        self.lblTip.text = "PUBLIC_11".localizedString()
        showTipBtn("0")
    }
    
    // 进度转圈
    class ActivityIndicatorController{
        
        class func show(gaiLoading: UIActivityIndicatorView) ->
            Bool{
                gaiLoading.hidden = true
                gaiLoading.startAnimating()
                return false
        }
        
        class func disMiss(gaiLoading: UIActivityIndicatorView) ->
            Bool{
                gaiLoading.stopAnimating()
                gaiLoading.hidden = true
                return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        stationEnd.resignFirstResponder()
        stationStart.resignFirstResponder()
        return false
    }

    /**
    *   展示和收起底部menu菜单
    */
    func showTipBtn(index : String) {
        if (index == "0") {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.testView.frame = CGRectMake(0, self.mScreenSize.height, self.mScreenSize.width, 44)
                
            })
        } else if (index == "1"){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.testView.frame = CGRectMake(0, self.mScreenSize.height - 44, self.mScreenSize.width, 44)
            })
        }
    }
    
    func mTipView(){
        
        var btnCollectRoute: UIButton = UIButton(frame: CGRectMake(0, 0, 160, 44))
        btnCollectRoute.setTitle("CMN003_26".localizedString(), forState: UIControlState.Normal)
        btnCollectRoute.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnCollectRoute.addTarget(self, action: "isCollectionRoute", forControlEvents: UIControlEvents.TouchUpInside)
        self.testView.addSubview(btnCollectRoute)
        
        var btnSetAlarm: UIButton = UIButton(frame: CGRectMake(160, 0, 160, 44))
        btnSetAlarm.setTitle("CMN003_25".localizedString(), forState: UIControlState.Normal)
        btnSetAlarm.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnSetAlarm.addTarget(self, action: "isPopToAlarm", forControlEvents: UIControlEvents.TouchUpInside)
        self.testView.addSubview(btnSetAlarm)
        
        var btnCollectRouteImg: UIImageView = UIImageView(frame: CGRectMake(20, 11, 22, 22))
        btnCollectRouteImg.image = "route_alarm".getImage()
        self.testView.addSubview(btnCollectRouteImg)
        
        var btnSetAlarmImg: UIImageView = UIImageView(frame: CGRectMake(180, 11, 22, 22))
        btnSetAlarmImg.image = "route_collection".getImage()
        self.testView.addSubview(btnSetAlarmImg)

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideKeyBoard()
    }

}


