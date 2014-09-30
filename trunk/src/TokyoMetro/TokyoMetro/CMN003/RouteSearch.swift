//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource {
    

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
    // 提示当前tableView是查询结果
    @IBOutlet weak var lblTip: UILabel!
    
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
    
    // 区分路线方向。 1 为从小到大， 2为从大到小
    var routeDirectionTag : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var strStart:NSString = "起点"
        var strEnd:NSString = "终点"
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        self.stationStart.text = startStationText.station()
        self.stationEnd.text = endStationText.station()
        
        stationStart.becomeFirstResponder()
        loadStation()

       
        btnExchange.addTarget(self, action: "exchangeAction", forControlEvents: UIControlEvents.TouchUpInside)

        stationStart.addTarget(self, action: "foucsChangeTo1", forControlEvents: UIControlEvents.AllEditingEvents)
        stationEnd.addTarget(self, action: "foucsChangeTo2", forControlEvents: UIControlEvents.AllEditingEvents)
        
        btnSearchRoute.addTarget(self, action: "searchWayAction", forControlEvents: UIControlEvents.TouchUpInside)
        btnCollect1.addTarget(self, action: "addUserfavorite:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCollect2.addTarget(self, action: "addUserfavorite:", forControlEvents: UIControlEvents.TouchUpInside)
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
            
            celllblSatationName.text  = self.allOfStationItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            celllblSatationNameJP.text  = self.allOfStationItemsJP.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as? String
            
            var lineImageItemsRow = self.allOflineImageItems.objectAtIndex(self.allOfStationItems.count - 1 - indexPath.row) as NSArray
            for (var i = 0; i < lineImageItemsRow.count; i++) {
                var map = lineImageItemsRow[i] as MstT02StationTable
                var lineIcon: UIImageView = UIImageView()
                lineIcon.frame = CGRectMake(CGFloat(160 + i * 25), 5, 30, 30)
                lineIcon.image = lineImageNormal(map.item(MSTT02_LINE_ID) as String)
                cell.addSubview(lineIcon)
            }
           return cell
        } else {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeResultCell", forIndexPath: indexPath) as UITableViewCell
            var resultCellIvStaionIcon : UIImageView = cell.viewWithTag(1001) as UIImageView
            var resultCelllblStationName : UILabel = cell.viewWithTag(1002) as UILabel
            var resultCelllblStationDirection : UILabel = cell.viewWithTag(1003) as UILabel
            var resultCelllblStationLineName : UILabel = cell.viewWithTag(1005) as UILabel
            var resultCelllblStationWaitTime : UILabel = cell.viewWithTag(1004) as UILabel
            var resultCelllblStationMoveTime : UILabel = cell.viewWithTag(1006) as UILabel
            if indexPath.row == 0 {
                resultCellIvStaionIcon.hidden = true
                resultCelllblStationDirection.hidden = true
                resultCelllblStationName.hidden = true
                resultCelllblStationLineName.hidden = true
                resultCelllblStationWaitTime.hidden = true
                resultCelllblStationMoveTime.hidden = true
                var resultCelllblStationTip1 : UILabel = UILabel()
                resultCelllblStationTip1.frame = CGRectMake(20,10,200,20)
                resultCelllblStationTip1.font = UIFont.systemFontOfSize(15)
                resultCelllblStationTip1.text = "换乘" + (routeDetial.count - 2).description + "次"
                var resultCelllblStationTip2 : UILabel = UILabel()
                resultCelllblStationTip1.font = UIFont.systemFontOfSize(15)
                resultCelllblStationTip2.frame = CGRectMake(20,35,200,20)
                resultCelllblStationTip2.text = "票价" + getFare()
                
                cell.addSubview(resultCelllblStationTip1)
                cell.addSubview(resultCelllblStationTip2)
            } else {

                 //resultCellIvStaionIcon.image = lineImageNormal(getStationIconByStationName(resultCelllblStationName.text!))
                
                if (indexPath.row == routeDetial.count){
                    
                    resultCellIvStaionIcon.hidden = true
                    resultCelllblStationDirection.hidden = true
                    resultCelllblStationName.hidden = true
                    resultCelllblStationLineName.hidden = true
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationMoveTime.hidden = true
                    
                    
                } else {
                    
                    if (self.routeDirectionTag == "1") {
                        var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
                        
                        var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
                        resultCelllblStationName.text = (strresultExchStatId as String).station()
                        
                        var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                        resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                        
                        var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                        resultCelllblStationDirection.text = (strresultExchDestId as String).station() + "方向"
                        
                        var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                        resultCelllblStationWaitTime.text = "等待" + (strresultExchWaitTime as String) + "分钟"
                        
                        var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
                        resultCelllblStationMoveTime.text = "移动" + (strresultExchMoveTime as String) + "分钟"
                    } else {
                        var routStartDic = self.routeDetial.objectAtIndex(self.routeDetial.count - indexPath.row - 1) as NSDictionary
                        
                        var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
                        resultCelllblStationName.text = (strresultExchStatId as String).station()
                        
                        var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                        resultCelllblStationLineName.text = (strresultExchlineId as String).line()
                        
                        var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                        resultCelllblStationDirection.text = (strresultExchDestId as String).station() + "方向"
                        
                        var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                        resultCelllblStationWaitTime.text = "等待" + (strresultExchWaitTime as String) + "分钟"
                        
                        var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
                        resultCelllblStationMoveTime.text = "移动" + (strresultExchMoveTime as String) + "分钟"
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
        } else {
            
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
            
            self.lblTip.text = "   路线搜索中..."
            searchRouteAction()
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
//        loadStation()
//        tbView.reloadData()
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"
//        loadStation()
//        tbView.reloadData()
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
//        self.pageTag = "1"
//        
//        allOfStationItems.removeAllObjects()
//        allOfStationItemsJP.removeAllObjects()
//        allOflineImageItems.removeAllObjects()
//
//     
//        if self.focusNumber == "1" {
//            mst02table.statName = stationStart.text
//        } else {
//            mst02table.statName = stationEnd.text
//        }
//        var mst02Rows:NSArray = mst02table.selectLike()
//        
//        
//        for key in mst02Rows {
//            key as MstT02StationTable
//            var stationNameJP:AnyObject = key.item(MSTT02_STAT_NAME)
//            var stationName:AnyObject = key.item(MSTT02_STAT_NAME_EXT1)
//            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
//            
//            var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
//            
//            self.allOflineImageItems.addObject(statSeqArr)
//            self.allOfStationItemsJP.addObject(stationNameJP)
//            self.allOfStationItems.addObject(stationName)
//         }
//        tbView.reloadData()
        
        
        self.pageTag = "1"
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
            println("0000002342342342342342342342342342342342")
            println(usrStationid.description)
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
        
        self.lblTip.text = "  所有收藏站点"
    }
    
    // 根据数据库中的路线id获取图片
    func lineImageNormal(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_g.png")
        switch (lineNum) {
            
        case "28001":
            image = UIImage(named: "tablecell_lineicon_g.png")
        case "28002":
            image = UIImage(named: "tablecell_lineicon_m.png")
        case "28003":
            image = UIImage(named: "tablecell_lineicon_h.png")
        case "28004":
            image = UIImage(named: "tablecell_lineicon_t.png")
        case "28005":
            image = UIImage(named: "tablecell_lineicon_c.png")
        case "28006":
            image = UIImage(named: "tablecell_lineicon_y.png")
        case "28008":
            image = UIImage(named: "tablecell_lineicon_z.png")
        case "28009":
            image = UIImage(named: "tablecell_lineicon_n.png")
        case "28010":
            image = UIImage(named: "tablecell_lineicon_f.png")
            
        default:
            image = UIImage(named: "tablecell_lineicon_g.png")
            
        }
        
        return image
    }

    // 根据groupid 判断是否属于换乘站，换乘返回可以换乘图标，不是换乘返回车站的图标
    func decideSationIconByGroupId(stationGroupId:String) -> String {
        
        var mst02table = MstT02StationTable()
        
        var mst02RowGroupIdStart : NSArray = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(stationGroupId)")
        
        var lineGroup : NSMutableArray = NSMutableArray.array()
        for mst02GroupIdValue in mst02RowGroupIdStart {
            mst02GroupIdValue  as MstT02StationTable
            var mst02ResultLineId:AnyObject = mst02GroupIdValue.item(MSTT02_LINE_ID)
            lineGroup.addObject(mst02ResultLineId)
        }
        if lineGroup.count == 1 {
            return lineGroup[0] as String
        } else {
            return "1"
        }
    }

    // 根据车站名字搜索车站ID
    func serarchStationIdByStationName(StationNames:String) -> String {
        var resultid = ""
        var mst02table = MstT02StationTable()
        mst02table.statNameExt1 = StationNames
        var mst02rowID = mst02table.selectAll()
        for mst02Row in mst02rowID {
            mst02Row as MstT02StationTable
            var searchstationId = mst02Row.item(MSTT02_STAT_ID) as String
            resultid = searchstationId
        }
        println("车站ID")
        println("\(resultid)")
        return resultid
    }
    
//    // 根据车站名获取车站的Icon
//    func getStationIconByStationName(StationName:String) -> String {
//        
//        var resultGroupid = " "
//        var mst02table = MstT02StationTable()
//        mst02table.statName = StationName
//        var mst02rowID = mst02table.selectAll()
//        for mst02Row in mst02rowID {
//            mst02Row as MstT02StationTable
//            var searchstationEndGroupId = mst02Row.item(MSTT02_STAT_GROUP_ID) as String
//            resultGroupid = searchstationEndGroupId
//        }
//        
//        var mst02RowLine : NSArray = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(resultGroupid)")
//        
//        var mst02RowLineItems2 : NSMutableArray = NSMutableArray.array()
//        
//        for (var i = 0; i < mst02RowLineItems2.count; i++) {
//            var map = mst02RowLineItems2[i] as MstT02StationTable
//            mst02RowLineItems2.addObject(map.item(MSTT02_LINE_ID) as String)
//            println("============         mst02RowLineItems2")
//            println("\(mst02RowLineItems2.count)")
//            println("\(map.item(MSTT02_LINE_ID) as String)")
//        }
//        
//        println("============         mst02RowLineItems2.count")
//        println("\(mst02RowLineItems2.count)")
//        println("\(mst02RowLineItems2.description)")
//        if mst02RowLineItems2.count == 1 {
//            return mst02RowLineItems2[0] as String
//        } else {
//            return "28008"
//        }
//
//    }

    // 添加收藏
    func addUserfavorite(sender: UIButton) {
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
        println("121122222232222222222222")
        println(serarchStationIdByStationName(insetStationName))
        user03table.statId = serarchStationIdByStationName(insetStationName)
        user03table.favoType = "01"
        user03table.favoTime = NSDate.date().description.yyyyMMddHHmmss()
        
        var user03insert = user03table.insert()
        if !user03insert {
            errAlertView("数据操作", errMgs:"收藏失败", errBtnTitle:"确定")
        } else {
            errAlertView("数据操作", errMgs:"收藏成功", errBtnTitle:"确定")
        }
    }
    
    // 根据起点站和终点站获取路线ID
    func getRouteIdByStationId(startStaionId:NSString ,endStationId:NSString) -> String {
        
        var  nsStaionID1 : NSString = startStaionId as NSString
        var  nsStaionID2 : NSString = endStationId as NSString
        
        if (nsStaionID1.intValue < nsStaionID2.intValue) {
            self.routeDirectionTag = "1"
        } else {
            self.routeDirectionTag = "2"
            var tempStationID = nsStaionID2
            nsStaionID2 = nsStaionID1
            nsStaionID1 = tempStationID
        }
        var routeId : NSString = ""
        
        routeId = (nsStaionID1.substringFromIndex(3) + nsStaionID2.substringFromIndex(3))
        routeID = routeId as String
        println("1234567899000000000111111111   routeID")
        println("\(routeID)")
  
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
        
        println("1234567899000000000111111111   frae")
        println("\(resultFare)")
        return resultFare
    }
    
    // 根据路线ID查询换乘路径
    func getRouteline() {
        println("1234567899000000000111111111   routeDeital05Row  routeID")
        println(self.routeID)

        routeDetial05table.ruteId = self.routeID
        var routeDeital05Row = routeDetial05table.selectAll()
        
        for key2 in routeDeital05Row {
            key2 as LinT05RouteDetailTable
          //  var resultGroupId = key.item(LINT05_ROUTE_DETAIL_RUTE_ID_GROUP_ID) as? String
          //  var resultExchType = key.item(LINT05_ROUTE_DETAIL_EXCH_TYPE) as? String
            
            var resultExchStatId = key2.item(LINT05_ROUTE_DETAIL_EXCH_STAT_ID) as? NSString
            var resultExchlineId = key2.item(LINT05_ROUTE_DETAIL_EXCH_LINE_ID) as? NSString
            var resultExchDestId = key2.item(LINT05_ROUTE_DETAIL_EXCH_DEST_ID) as? NSString
            var resultExchSeq : AnyObject = key2.item(LINT05_ROUTE_DETAIL_EXCH_SEQ)
            var resultExchMoveTime : AnyObject = key2.item(LINT05_ROUTE_DETAIL_MOVE_TIME)
            var resultExchWaitTime: AnyObject = key2.item(LINT05_ROUTE_DETAIL_WAIT_TIME)
            
            var routeItem = ["resultExchStatId":resultExchStatId ,"resultExchlineId":resultExchlineId, "resultExchDestId":resultExchDestId, "resultExchSeq":resultExchSeq.description, "resultExchMoveTime":resultExchMoveTime.description, "resultExchWaitTime":resultExchWaitTime.description]
            self.routeDetial.addObject(routeItem)
        }
        self.lblTip.text = "   路线搜索结果"
    }


}


