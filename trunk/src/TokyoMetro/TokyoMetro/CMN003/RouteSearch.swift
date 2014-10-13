//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate{
    

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
    // 收藏路径按钮
    @IBOutlet weak var btnCollectRoute: UIButton!
    // 设定闹钟
    @IBOutlet weak var btnSetAlarm: UIButton!
    // 提示当前tableView是查询结果
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var ivCollection: UIImageView!
    @IBOutlet weak var ivAlarm: UIImageView!
    
    //////////////// 全局变量
    
    // 用来记录搜索出的搜友站点中文名
    var allOfStationItems : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点日文名
    var allOfStationItemsJP : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点Icon名
    var allOflineImageItems : NSMutableArray = NSMutableArray.array()
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
    
    var mst02table = MstT02StationTable()
    var user03table = UsrT03FavoriteTable()
    var fare06table = LinT06FareTable()
    var routeDetial05table = LinT05RouteDetailTable()
    
    // 区分查询前页面和查询后结果页面。 1 为查询前页面。 2为查询后结果页面
    var pageTag : String = "1"
    
    
    let FOUCSCHANGETO1 : Selector = "foucsChangeTo1"
    let FOUCSCHANGETO2 : Selector  = "foucsChangeTo2"
    let EXCHANGEACTION : Selector  = "exchangeAction"
    let SEARCHWAYACTION : Selector  = "searchWayAction"
    let ADDUSERFAVORITE : Selector  = "addUserfavorite:"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var strStart:NSString = "起点"
        var strEnd:NSString = "终点"
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        
        loadStation()
        
        btnExchange.layer.cornerRadius = 4
        btnCollectRoute.hidden = true
        btnSetAlarm.hidden = true
        ivCollection.hidden = true
        ivAlarm.hidden = true

        btnExchange.addTarget(self, action: EXCHANGEACTION, forControlEvents: UIControlEvents.TouchUpInside)
        stationStart.addTarget(self, action: FOUCSCHANGETO1, forControlEvents: UIControlEvents.EditingDidBegin)
        stationEnd.addTarget(self, action: FOUCSCHANGETO2, forControlEvents: UIControlEvents.EditingDidBegin)
        btnSearchRoute.addTarget(self, action: SEARCHWAYACTION, forControlEvents: UIControlEvents.TouchUpInside)
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
        if self.pageTag == "1" {
            return 40
        } else {
            return 70
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.pageTag == "1" {
             return self.allOfStationItems.count
        } else {
            return self.routeDetial.count + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if self.pageTag == "1" {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            var celllblSatationName : UILabel = cell.viewWithTag(101) as UILabel!
            var celllblSatationNameJP : UILabel = cell.viewWithTag(102) as UILabel!
            var celllblCollection : UIImageView = cell.viewWithTag(100) as UIImageView!
            
            celllblSatationName.text  = self.allOfStationItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            celllblSatationNameJP.text  = self.allOfStationItemsJP.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            
            var lineImageItemsRow = self.allOflineImageItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as NSArray
            for (var i = 0; i < lineImageItemsRow.count; i++) {
                var map = lineImageItemsRow[i] as MstT02StationTable
                var lineIcon: UIImageView = UIImageView()
                lineIcon.frame = CGRectMake(CGFloat(260 - i * 25), 5, 30, 30)
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
                // resultCelllblStationDirection.hidden = true
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
                     resultCelllblStationTip1.text = "换乘" + (routeDetial.count - 2).description + "次"
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
                resultCelllblStationTip2.text = "票价" + getFare()

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
                    
                    resultCelllblStationWaitTime.text = "等待" + (strresultExchWaitTime as String) + "分钟"
                    resultCelllblStationMoveTime.text = "乘车" + (strresultExchMoveTime as String) + "分钟"
                    
                    if (indexPath.row - 1 == 0){
                        // 设置起点图片
                        resultCellIvStaionIcon.image = "route_start".getImage()
                        
                        if (strresultExchType == "255") {
                            resultCelllblStationMoveTime.text = "步行" + (strresultExchMoveTime as String) + "分钟"
                            resultCelllblStationLineName.hidden = true
                            resultCelllblStationWaitTime.hidden = true
                            
                        } else if (strresultExchType == "8") {
                            resultCelllblStationLineName.hidden = false
                            var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                            resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                            var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                            resultCelllblStationLineName.text = "乘" + (strresultExchlineId as String).line() + " 往" + (strresultExchDestId as String).station() + "方向"
                        }

                    } else {
                        
                        if (strresultExchType == "255") {
                            resultCellIvStaionIcon.image = "routeexchange_walk".getImage()
                            resultCelllblStationMoveTime.text = "步行" + (strresultExchMoveTime as String) + "分钟"
                            resultCelllblStationLineName.hidden = true
                            resultCelllblStationWaitTime.hidden = true
                            
                        } else if (strresultExchType == "8") {
                            resultCelllblStationLineName.hidden = false
                            var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                            resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                            resultCellIvStaionIcon.image = "routeexchange_metro".getImage()
                            var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                            resultCelllblStationLineName.text = "换乘" + (strresultExchlineId as String).line() + " 往" + (strresultExchDestId as String).station() + "方向"
                        }
                    }
                    
                }
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if self.pageTag == "1" {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            var celllblStaionName : UILabel = cell.viewWithTag(101) as UILabel
            var stationName : String? =  celllblStaionName.text
        
            if focusNumber == "1" {
                if !(stationName == self.stationEnd.text)  {
                    self.stationStart.text = stationName
                 } else {
                    errAlertView("错误信息", errMgs: "站点名相同", errBtnTitle: "确认")
                }
            
            } else if focusNumber == "2" {
            
                if !(stationName == self.stationStart.text) {
                   self.stationEnd.text = stationName
                } else {
                   errAlertView("错误信息", errMgs: "站点名相同", errBtnTitle: "确认")
                }
            
           }
        } else if (self.pageTag == "2") {
            
            setSationIdCache()
            
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
            errAlertView("提示信息", errMgs: "请重新输入车站名", errBtnTitle: "确认")
        } else {
            searchRouteAction()
            hideKeyBoard()
         }
    }
    
    // 进行搜索操作
    func searchRouteAction() {
        
        self.routeStartStationId = serarchStationIdByStationName(stationStart.text)
        self.routeEndStationId = serarchStationIdByStationName(stationEnd.text)
        
        if (routeStartStationId == "" || routeEndStationId == "") {
            errAlertView("提示", errMgs: "您输入的车站名无效", errBtnTitle: "确认")
            return
        }
        getRouteIdByStationId(routeStartStationId, endStationId: routeEndStationId)
        getRouteline()
        self.pageTag = "2"
        tbView.reloadData()
    }
    
    func foucsChangeTo1 () {
        self.focusNumber = "1"
        isPopToStationList()
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"
        isPopToStationList()
    }
    
    // 弹出对话框，判断是否要跳转到StationList页面
    func isPopToStationList() {
        var sureBtn: UIAlertView = UIAlertView(title: "提示", message: "您确定跳转到所有站点列表,进行站点查找吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        sureBtn.tag = 100
        sureBtn.show()
    }
    
    @IBAction func isPopToAlarm() {
        var sureBtn: UIAlertView = UIAlertView(title: "提示", message: "您确定设定到站提醒吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        sureBtn.tag = 200
        sureBtn.show()
    }
    
    @IBAction func isCollectionRoute() {
        var sureBtn: UIAlertView = UIAlertView(title: "提示", message: "您确定收藏该路线？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        sureBtn.tag = 300
        sureBtn.show()
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {    
        if (buttonIndex == 1) {
            switch (alertView.tag) {
            case 100:
                setSationIdCache()
                var searchAllStation : SearchStationList = self.storyboard?.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
                searchAllStation.focusNumber = self.focusNumber
                searchAllStation.classType = "routeSearch"
                self.navigationController?.pushViewController(searchAllStation, animated:true)
            
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

    // 获取所有站的站名和图标
    func loadStation() {

        self.pageTag = "1"
        allStationlineGroup.removeAllObjects()
        allOfStationItems.removeAllObjects()
        allOfStationItemsJP.removeAllObjects()
        allOflineImageItems.removeAllObjects()
        
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
                
                var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                self.allOflineImageItems.addObject(statSeqArr)
                self.allOfStationItemsJP.addObject(stationNameJP)
                self.allOfStationItems.addObject(stationName)

            }
            tbView.reloadData()
        }
        self.lblTip.text = " 所有收藏站点"
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
        println("车站ID")
        println("\(resultid)")
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
            errAlertView("数据操作", errMgs:"收藏失败,站点已收藏", errBtnTitle:"确定")
        } else {
            user03table.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insert = user03table.insert()
            if !user03insert {
                errAlertView("数据操作", errMgs:"收藏失败", errBtnTitle:"确定")
            } else {
                errAlertView("数据操作", errMgs:"收藏成功", errBtnTitle:"确定")
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
            errAlertView("数据操作", errMgs:"收藏失败,路线已收藏", errBtnTitle:"确定")
        } else {
            user03table.favoTime = NSDate.date().description.yyyyMMddHHmmss()
            
            var user03insert = user03table.insert()
            if !user03insert {
                errAlertView("数据操作", errMgs:"收藏失败", errBtnTitle:"确定")
            } else {
                errAlertView("数据操作", errMgs:"收藏成功", errBtnTitle:"确定")
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
        self.lblTip.text = "   路线搜索结果"
        btnCollectRoute.hidden = false
        btnSetAlarm.hidden = false
        ivCollection.hidden = false
        ivAlarm.hidden = false
    }
    
    // 跳转到站点详情页面
    func getStationDetialById(StationID:String) -> MstT02StationTable{
        
        mst02table.statId = StationID
        var mMst02StationArr:MstT02StationTable = mst02table.select() as MstT02StationTable
        return mMst02StationArr
    }
    
        // 放置本地数据
        func setSationIdCache() {
    
            var accoutDefault : NSUserDefaults = NSUserDefaults()
            var historyStationdate: NSMutableArray = NSMutableArray.array()
//            if accoutDefault.objectForKey("historyStationdata") != nil {
//                historyStationdate = accoutDefault.objectForKey("historyStationdata") as NSMutableArray
//                historyStationdate.setObject(startStationText, atIndexedSubscript: 0)
//                historyStationdate.setObject(endStationText, atIndexedSubscript: 1)
//            } else {
                historyStationdate.addObject(startStationText)
                historyStationdate.addObject(endStationText)
//            }
            
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        stationStart.resignFirstResponder()
        stationEnd.resignFirstResponder()
        return true
    }
}


