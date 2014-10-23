//
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import CoreLocation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, GPSDelegate, UITextFieldDelegate, UISearchBarDelegate{
    
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    // 交换按钮
    @IBOutlet weak var btnExchange: UIButton!
    // 起点文本
    @IBOutlet weak var stationStart: UITextField!
    // 终点文本
    @IBOutlet weak var stationEnd: UITextField!
    // 显示数据的tableView
    @IBOutlet weak var tbView: UITableView!
    
    // 显示数据的tableView
    @IBOutlet weak var vtbView: UIView!
    // 显示数据的tableView
    @IBOutlet weak var tbResultView: UITableView!
    
    // 显示数据的tableView
    @IBOutlet weak var vtbResultView: UIView!
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
    // 收藏站点图片
    @IBOutlet weak var mCollectionLogo: UIImageView!
    // 收藏附近站点图片
    @IBOutlet weak var mNearlyLogo: UIImageView!
    /* 加载进度条ActivityIndicatorView */
    @IBOutlet weak var gaiLoading: UIActivityIndicatorView!
    
    var testView: UIView = UIView()
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    // 屏幕尺寸
    var mScreenSize: CGSize!
    // 用来记录搜索出的搜友站点ID
    var allOfStationItemsId : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点日文名
    var allOfStationItemsJP : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜友站点Icon名
    var allOflineImageItems : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的搜站点日文名
    var allOfStationItemsJpKana : NSMutableArray = NSMutableArray.array()
    
    
    // 用来记录搜索出的附近站点ID
    var allOfNearlyStationItemsId : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的附近站点日文名
    var allOfNearlyStationItemsJP : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的附近站点Icon名
    var allOfNearlylineImageItems : NSMutableArray = NSMutableArray.array()
    // 用来记录搜索出的附近站点日文名
    var allOfNearlyStationItemsJpKana : NSMutableArray = NSMutableArray.array()
    
    // 用来记录从数据库搜索的每一个站点的线路id
    var allNearlyStationlineGroup : NSMutableArray = NSMutableArray.array()
    
    // 用来记录从数据
    var allOfCollectedRouteId : NSMutableArray = NSMutableArray.array()
    
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

    // 路径查询结果后，设置路径收藏
    var btnCollectRouteImg: UIImageView = UIImageView(frame: CGRectMake(30, 9, 22, 22))
    var btnSetAlarmImg: UIImageView = UIImageView(frame: CGRectMake(190, 9, 22, 22))
    
    
    var vline: UIView = UIButton(frame: CGRectMake(0, 1, 320, 1))
    var btnCollectRoute: UIButton = UIButton(frame: CGRectMake(0, 0, 160, 44))
    var btnSetAlarm: UIButton = UIButton(frame: CGRectMake(160, 0, 160, 44))
    
    // 总时间
    var totalTime : Int = 0
    
    // 存放全局变量
    var appDelegate: AppDelegate!
    
    var cmn003Model : CMN003Model = CMN003Model()

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
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mScreenSize = UIScreen.mainScreen().bounds.size
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var strStart:NSString = "PUBLIC_01".localizedString()
        var strEnd:NSString = "PUBLIC_02".localizedString()
        self.stationStart.placeholder = strStart
        self.stationEnd.placeholder = strEnd
        
        self.tbResultView.hidden = true
        self.vtbResultView.hidden = true
        self.vtbView.hidden = false
        self.tbView.hidden = false
        
        loadStation()
        reloadCollectedRouteId()
        btnExchange.layer.cornerRadius = 4
        
        btnExchange.addTarget(self, action: EXCHANGEACTION, forControlEvents: UIControlEvents.TouchUpInside)
        stationStart.addTarget(self, action: FOUCSCHANGETO1, forControlEvents: UIControlEvents.AllEditingEvents)
        stationEnd.addTarget(self, action: FOUCSCHANGETO2, forControlEvents: UIControlEvents.AllEditingEvents)
        btnCollectionStation.addTarget(self, action: COLLECTEDSTATION, forControlEvents: UIControlEvents.TouchUpInside)
        
        testView.frame = CGRectMake(320, 568, 320, 33)
        testView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(testView)
        
        // 返回按钮点击事件
        var SearchButton:UIBarButtonItem = UIBarButtonItem(title: "CMN003_10".localizedString(), style: UIBarButtonItemStyle.Plain, target:self, action: "searchWayAction")
        self.navigationItem.rightBarButtonItem = SearchButton
        
        mNearlyLogo.image = "route_locate".getImage()
        mCollectionLogo.image = "route_collectedlight".getImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        readStationIdCache()
        if (startStationText != "") {
            self.stationStart.text = startStationText.station()
        }
        
        if (endStationText != "") {
            self.stationEnd.text = endStationText.station()
        }
        setSationIdCache()
        
        btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        
        if (startStationText != "" && statIsCollected(startStationText)){
            btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        
        if (endStationText != "" && statIsCollected(endStationText)){
            btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        searchWayAction()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setSationIdCache()
    }

    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.pageTag == "2" && tableView == tbResultView) {
            return 77
        } else {
            return 44
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.pageTag == "1" && tableView == tbView) {
            return "CMN003_17".localizedString()
        } else if (self.pageTag == "2" && tableView == tbResultView){
            return "CMN003_22".localizedString()
        } else {
            return "PUBLIC_11".localizedString()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.pageTag == "2" && tableView == tbResultView) {
            return self.routeDetial.count + 1
        } else if (self.pageTag == "3" && tableView == tbView) {
            return self.allOfNearlyStationItemsId.count
        }else if (self.pageTag == "1" && tableView == tbView){
            return self.allOfStationItemsId.count
        } else {
            return 0
        }
    }
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if (self.pageTag == "1" && tableView == tbView) {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            tableViewCellCollectedStation(cell, cellForRowAtIndexPath: indexPath)
            return cell
        } else if ( self.pageTag == "3" && tableView == tbView) {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            tableViewCellNearlyStation(cell, cellForRowAtIndexPath: indexPath)
            return cell
            
            
            
        }else if ( self.pageTag == "2" && tableView == tbResultView) {
            
            if (indexPath.row == 0) {
                
                let cellTip: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeTip", forIndexPath: indexPath) as UITableViewCell
                tableViewCellRouteResultTip(cellTip, cellForRowAtIndexPath: indexPath)
                return cellTip
                
            } else {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeResultCell", forIndexPath: indexPath) as UITableViewCell
                tableViewCellRouteResultContent(cell, cellForRowAtIndexPath: indexPath)
                return cell
                
            }
        } else {
            return UITableViewCell()
        }
    }
    
    
    // 收藏站点tablecell
    func tableViewCellCollectedStation(cell:UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath){
        var celllblSatationName : UILabel = cell.viewWithTag(101) as UILabel!
        var celllblSatationNameJP : UILabel = cell.viewWithTag(102) as UILabel!
        var celllblCollection : UIImageView = cell.viewWithTag(100) as UIImageView!

        celllblSatationName.text  = (self.allOfStationItemsId.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as? String)?.station()
        
        var jpNameStr = self.allOfStationItemsJP.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as? String
        
        var jpNameKanaStr = self.allOfStationItemsJpKana.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as? String
        
        celllblSatationNameJP.text  = (jpNameStr! + "(" + jpNameKanaStr! +  ")") as String
        celllblCollection.image = "route_collectionlight".getImage()
        
        var lineImageItemsRow = self.allOflineImageItems.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as NSArray
        var mView = cell.viewWithTag(4001) as UIView!
        if (mView != nil) {
            mView.removeFromSuperview()
        }
        
        var mCellLineView = UIView()
        mCellLineView.frame = CGRectMake(150, 11, 120, 22)
        mCellLineView.tag = 4001
        
        for (var i = 0; i < lineImageItemsRow.count; i++) {
            var map = lineImageItemsRow[i] as MstT02StationTable
            var lineIcon: UIImageView = UIImageView()
            
            lineIcon.frame = CGRectMake(CGFloat(120 - i * 18), 2, 18, 18)
            lineIcon.image = (map.item(MSTT02_LINE_ID) as String).getLineImage()
            mCellLineView.addSubview(lineIcon)
        }
        cell.addSubview(mCellLineView)
    }
    
    // 附近站点tablecell
    func tableViewCellNearlyStation(cell:UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath){
        var celllblSatationName : UILabel = cell.viewWithTag(101) as UILabel!
        var celllblSatationNameJP : UILabel = cell.viewWithTag(102) as UILabel!
        var celllblCollection : UIImageView = cell.viewWithTag(100) as UIImageView!
        
        celllblSatationName.text  = (self.allOfNearlyStationItemsId.objectAtIndex(indexPath.row) as? String)?.station()
        
        var jpNameStr = self.allOfNearlyStationItemsJP.objectAtIndex( indexPath.row) as? String
        var jpNameKanaStr = self.allOfNearlyStationItemsJpKana.objectAtIndex( indexPath.row) as? String
        
        celllblSatationNameJP.text  = (jpNameStr! + "(" + jpNameKanaStr! +  ")") as String
        celllblCollection.image = "route_locate".getImage()

        var lineImageItemsRow = self.allOfNearlylineImageItems.objectAtIndex( indexPath.row) as NSArray
        
        var mView = cell.viewWithTag(4001) as UIView!
        if (mView != nil) {
            mView.removeFromSuperview()
        }

        var mCellLineView = UIView()
        
        mCellLineView.frame = CGRectMake(150, 11, 120, 22)
        mCellLineView.tag = 4001
        
        for (var i = 0; i < lineImageItemsRow.count; i++) {
            
            var map = lineImageItemsRow[i] as MstT02StationTable
            var lineIcon: UIImageView = UIImageView()
            
            lineIcon.frame = CGRectMake(CGFloat(120 - i * 18), 2, 18, 18)
            lineIcon.image = (map.item(MSTT02_LINE_ID) as String).getLineImage()
            mCellLineView.addSubview(lineIcon)
        }

        cell.addSubview(mCellLineView)
    }
    
    // 路线信息tablecell
    func tableViewCellRouteResultTip(cellTip:UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath){
        var resultTipCelllblStationExchange : UILabel = cellTip.viewWithTag(9001) as UILabel
        var resultTipCelllblStationExchangeTip : UILabel = cellTip.viewWithTag(9002) as UILabel
        var resultTipCelllblStationFare : UILabel = cellTip.viewWithTag(9003) as UILabel
        var resultTipCelllblStationFareTip : UILabel = cellTip.viewWithTag(9004) as UILabel
        var resultTipCelllblStationTime : UILabel = cellTip.viewWithTag(9005) as UILabel
        var resultTipCelllblStationTimeTip : UILabel = cellTip.viewWithTag(9006) as UILabel
        
        if ((routeDetial.count - 2) != 0){
            resultTipCelllblStationExchange.text = "EXCHANGE_TYPE_1".localizedString()
            resultTipCelllblStationExchangeTip.text = (routeDetial.count - 2).description + " " + "CMN003_23".localizedString()
        } else {
            resultTipCelllblStationExchange.hidden = true
            resultTipCelllblStationExchangeTip.hidden = true
        }
        
        resultTipCelllblStationFare.text = "PUBLIC_10".localizedString()
        resultTipCelllblStationFareTip.text = getFare() + "CMN003_26".localizedString()
        resultTipCelllblStationTime.text = "CMN003_27".localizedString()
        resultTipCelllblStationTimeTip.text = String(self.totalTime) + "CMN003_03".localizedString()

    }
    
    // 路线详细tablecell
    func tableViewCellRouteResultContent(cell:UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath){
        
        var resultCellIvStaionIcon : UIImageView = cell.viewWithTag(1001) as UIImageView
        var resultCelllblStationName : UILabel = cell.viewWithTag(1002) as UILabel
        var resultCelllblStationLineName : UILabel = cell.viewWithTag(1005) as UILabel
        var resultCelllblStationWaitTime : UILabel = cell.viewWithTag(1004) as UILabel
        var resultCelllblStationMoveTime : UILabel = cell.viewWithTag(1006) as UILabel
        var resultCelllblStationLineImg : UIImageView = cell.viewWithTag(1007) as UIImageView
        var resultCelllblStationMoveDestTip : UILabel = cell.viewWithTag(1008) as UILabel
        var resultCelllblStationMoveDestName : UILabel = cell.viewWithTag(1009) as UILabel
        var resultCelllblStationLineNameTip : UILabel = cell.viewWithTag(1111) as UILabel
        var resultCelllblStationWaitTimeTip : UILabel = cell.viewWithTag(1012) as UILabel
        var resultCelllblStationMoveTimeTip : UILabel = cell.viewWithTag(1013) as UILabel

        var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
        var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
        var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
        var strresultExchType = routStartDic["resultExchType"] as? NSString
        
        if (indexPath.row == routeDetial.count){

            
            resultCelllblStationLineName.hidden = true
            resultCelllblStationWaitTime.hidden = true
            resultCelllblStationMoveTime.hidden = true
            resultCelllblStationWaitTimeTip.hidden = true
            resultCelllblStationMoveTimeTip.hidden = true
            resultCelllblStationLineImg.hidden = true
            resultCelllblStationMoveDestTip.hidden = true
            resultCelllblStationMoveDestName.hidden = true
            resultCelllblStationLineNameTip.hidden = true
            
            resultCellIvStaionIcon.hidden = false
            resultCelllblStationName.hidden = false
            
            resultCellIvStaionIcon.image = "route_end".getImage()
            resultCelllblStationName.text = self.endStationText.station()
            
            
        } else if (indexPath.row  == 1){
            
            
            var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
            resultCelllblStationName.text = (strresultExchStatId as String).station()
            resultCellIvStaionIcon.image = "route_start".getImage()
            
            if (strresultExchType == "255"){
                
                resultCelllblStationLineName.hidden = true
                resultCelllblStationLineNameTip.hidden = true
                resultCelllblStationLineImg.hidden = true
                resultCelllblStationWaitTime.hidden = true
                resultCelllblStationWaitTimeTip.hidden = true
                resultCelllblStationMoveDestTip.hidden = true
                resultCelllblStationMoveDestName.hidden = true
                
                resultCelllblStationMoveTimeTip.hidden = false
                resultCelllblStationMoveTime.hidden = false
                
                resultCelllblStationMoveTime.text = "CMN003_07".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String) + "CMN003_03".localizedString()
            
            } else if (strresultExchType == "8") {
                
                resultCelllblStationLineName.hidden = false
                resultCelllblStationLineNameTip.hidden  = false
                resultCelllblStationLineImg.hidden  = false
                resultCelllblStationMoveDestTip.hidden  = false
                resultCelllblStationMoveDestName.hidden  = false
                resultCelllblStationWaitTime.hidden = false
                resultCelllblStationWaitTimeTip.hidden = false
                
                var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                if ((strresultExchWaitTime as String) != "0") {
                    resultCelllblStationWaitTime.text = "CMN003_02".localizedString()
                    resultCelllblStationWaitTimeTip.text = (strresultExchWaitTime as String) + "CMN003_03".localizedString()

                } else {
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationWaitTimeTip.hidden = true
                }
                
                resultCelllblStationMoveTime.text = "CMN003_04".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String) + "CMN003_03".localizedString()
                var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                
                resultCelllblStationLineName.text = "CMN003_05".localizedString()
                resultCelllblStationLineImg.image =  (strresultExchlineId as String).getLineImage()
                resultCelllblStationLineNameTip.text = (strresultExchlineId as String).line()
                
                resultCelllblStationMoveDestTip.text = "CMN003_06".localizedString()
                resultCelllblStationMoveDestName.text = (strresultExchDestId as String).station() + "PUBLIC_04".localizedString()
            
            }
            
        } else {
            var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
            resultCelllblStationName.text = (strresultExchStatId as String).station()

            if (strresultExchType == "255") {
                
                resultCelllblStationLineName.hidden = true
                resultCelllblStationLineNameTip.hidden = true
                resultCelllblStationWaitTime.hidden = true
                resultCelllblStationWaitTimeTip.hidden = true
                resultCelllblStationMoveDestTip.hidden = true
                resultCelllblStationMoveDestName.hidden = true
                resultCelllblStationLineImg.hidden = true
                
                resultCellIvStaionIcon.hidden = false
                resultCelllblStationMoveTime.hidden = false
                resultCelllblStationMoveTimeTip.hidden = false
                
                resultCellIvStaionIcon.image = "routeexchange_walk".getImage()
                resultCelllblStationMoveTime.text = "CMN003_07".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String) + "CMN003_03".localizedString()

                
            } else if (strresultExchType == "8") {
                
                resultCelllblStationLineName.hidden = false
                resultCelllblStationLineNameTip.hidden = false
                resultCelllblStationLineImg.hidden = false
                resultCelllblStationMoveDestTip.hidden = false
                resultCelllblStationMoveDestName.hidden = false
                resultCellIvStaionIcon.hidden = false
                resultCelllblStationWaitTime.hidden = false
                resultCelllblStationWaitTimeTip.hidden = false
                
                var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                if ((strresultExchWaitTime as String) != "0") {
                    resultCelllblStationWaitTime.text = "CMN003_02".localizedString()
                    resultCelllblStationWaitTimeTip.text = (strresultExchWaitTime as String) + "CMN003_03".localizedString()
                } else {
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationWaitTimeTip.hidden = true
                }
                
                var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
                resultCelllblStationMoveTime.text = "CMN003_04".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String) + "CMN003_03".localizedString()

                resultCellIvStaionIcon.image = "routeexchange_metro".getImage()
                
                var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                resultCelllblStationLineName.text = "CMN003_05".localizedString()
                resultCelllblStationLineNameTip.text = (strresultExchlineId as String).line()
                resultCelllblStationLineImg.image =  (strresultExchlineId as String).getLineImage()
                
                var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                resultCelllblStationMoveDestTip.text = "CMN003_06".localizedString()
                resultCelllblStationMoveDestName.text = (strresultExchDestId as String).station() + "PUBLIC_04".localizedString()
            }
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (self.pageTag == "1" || self.pageTag == "3") {
            tableViewCellSelect(tableView, didSelectRowAtIndexPath: indexPath)

        } else if (self.pageTag == "2") {
            
            setSationIdCache()
            if (indexPath.row  == routeDetial.count) {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
                var resultCelllblStationName : UILabel = cell.viewWithTag(1002) as UILabel
                
                var tempStationId = self.endStationText
                
                if (statIsMetro(tempStationId as NSString!)){
                    var stationDetialArr:MstT02StationTable = cmn003Model.getStationDetialById(tempStationId)
                    var stationDetail : StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
                    stationDetail.stat_id = tempStationId
                    stationDetail.cellJPName = stationDetialArr.statName as String
                    stationDetail.cellJPNameKana = stationDetialArr.statNameKana as String
                    stationDetail.statMetroId = stationDetialArr.statNameMetroId as String
                    self.navigationController?.pushViewController(stationDetail, animated:true)
                }
            } else if (indexPath.row  != 0){
                var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
                var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
                if (statIsMetro(strresultExchStatId!)){
                    var stationDetialArr:MstT02StationTable = cmn003Model.getStationDetialById(strresultExchStatId as String)
                    var stationDetail : StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
                    stationDetail.stat_id = strresultExchStatId as String
                    stationDetail.cellJPName = stationDetialArr.statName as String
                    stationDetail.cellJPNameKana = stationDetialArr.statNameKana as String
                    stationDetail.statMetroId = stationDetialArr.statNameMetroId as String
                    self.navigationController?.pushViewController(stationDetail, animated:true)
                }
                
            }
            
        }
        hideKeyBoard()
    }
    
    // 选择tableView 焦点为显示 收藏站点或者 附近站点
    func tableViewCellSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        var celllblStaionName : UILabel = cell.viewWithTag(101) as UILabel
        var stationName : String? =  celllblStaionName.text
        
        if focusNumber == "1" {
            if !(stationName == self.stationEnd.text)  {
                self.stationStart.text = stationName
                if (self.pageTag == "1") {
                    var tempStatId = self.allOfStationItemsId.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as? String
                    self.startStationText = tempStatId as String!
                    setSationIdCache()
                    
                } else {
                    var tempStatId = self.allOfNearlyStationItemsId.objectAtIndex(indexPath.row) as? String
                    self.startStationText = tempStatId as String!
                    setSationIdCache()
                }
                
            } else {
                errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_09".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
            }
            
        } else if focusNumber == "2" {
            
            if !(stationName == self.stationStart.text) {
                self.stationEnd.text = stationName
                
                if (self.pageTag == "1") {
                    var tempStatId = self.allOfStationItemsId.objectAtIndex(self.allOfStationItemsId.count - 1 - indexPath.row) as? String
                    self.endStationText = tempStatId as String!
                    
                    setSationIdCache()
                } else {
                    var tempStatId = self.allOfNearlyStationItemsId.objectAtIndex(indexPath.row) as? String
                    self.endStationText = tempStatId as String!
                    setSationIdCache()
                }
                
            } else {
                errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_09".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
            }
            
        }
    
    
    }
    
    /*******************************************************************************
    *    Implements Of UITextFileDelegate
    *******************************************************************************/
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        stationEnd.resignFirstResponder()
        stationStart.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideKeyBoard()
    }
    
    /*******************************************************************************
    *    Implements Of UISearchBarDelegate
    *******************************************************************************/
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }

    
    /*******************************************************************************
    *      IBActions
    *******************************************************************************/
    
    // 判断是否要跳转到StationList页面
    @IBAction func isPopToStationList() {
        setSationIdCache()
        var searchAllStation : SearchStationList = self.storyboard?.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
        searchAllStation.focusNumber = self.focusNumber
        searchAllStation.classType = "routeSearch"
        searchAllStation.routeSearch = self
        var nav:UINavigationController = UINavigationController(rootViewController: searchAllStation)
        
        nav.navigationBar.barTintColor = UIColor(red: 86/255, green: 127/255, blue: 188/255, alpha: 1)
        
        // 返回按钮点击事件
        var rightButtonStyle:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        rightButtonStyle.frame = CGRectMake(0, 0, 43, 43)
        rightButtonStyle.setTitle("", forState: UIControlState.Normal)
        rightButtonStyle.addTarget(self, action: nil, forControlEvents: UIControlEvents.TouchUpInside)
        var rightButton:UIBarButtonItem =  UIBarButtonItem(customView: rightButtonStyle)
        searchAllStation.navigationController!.navigationBar.backgroundColor = UIColor.blackColor()//
        searchAllStation.navigationController!.navigationItem.rightBarButtonItem = rightButton
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationController!.navigationItem.backBarButtonItem = backButton
        self.navigationController!.presentViewController(nav, animated: true, completion: nil)
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
    
    
    // 起点和终点交换
    func exchangeAction(){
        
        var tempName:NSString = self.stationStart.text
        self.stationStart.text = self.stationEnd.text
        self.stationEnd.text = tempName
        
        var tempStationId:String = startStationText
        startStationText  = endStationText
        endStationText  = tempStationId

        if (startStationText != "" && statIsCollected(startStationText)){
            btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        
        if (endStationText != "" && statIsCollected(endStationText)){
            btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        hideKeyBoard()
    }
    
    // 搜索路线
    func searchWayAction(){
        
        // 判断合法性
        if ( self.startStationText != "" && self.endStationText != "" && self.startStationText != self.endStationText) {
            searchRouteAction()
            hideKeyBoard()
        }
    }
    
    func isPopToAlarm() {
        
        var remindDetailController : RemindDetailController = self.storyboard?.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
        remindDetailController.routeStatTable01 = cmn003Model.getStationDetialById(routeStartStationId)
        remindDetailController.routeStatTable02 = cmn003Model.getStationDetialById(routeEndStationId)
        remindDetailController.segIndex = 0
        self.navigationController?.pushViewController(remindDetailController, animated:true)
        
    }
    
    // 添加收藏站点
    @IBAction func addUserfavoriteStation(sender: UIButton) {
        var insertStationId : String = ""
        switch sender {
        case btnCollect1:
            if stationStart.text != "" {
                insertStationId = self.startStationText
            } else {
                return
            }
            
        case btnCollect2:
            if stationEnd.text != "" {
                insertStationId = self.endStationText
            } else {
                return
            }
            
        default:
            return
        }
        

       var  isInsertStat = cmn003Model.addUserFavoriteStat(insertStationId)
        
       if isInsertStat {
            loadStation()
            if (sender == btnCollect1){
                btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            } else if (sender == btnCollect2){
                btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            }
        }
        
    }
    
    // 添加收藏路线
    func addUserfavoriteRoute() {

        var isInsertRoute = cmn003Model.addUserFavoriteRoute(self.routeID)
        if isInsertRoute {
            reloadCollectedRouteId()
            btnCollectRouteImg.image = "route_collectionlight".getImage()
        }
    }
    
    func loadCollectedStation(){
        loadStation()
        showTipBtn("0")
    }

    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    // 进行路径搜索操作
    func searchRouteAction() {
        
        self.routeStartStationId = self.startStationText
        self.routeEndStationId = self.endStationText
        
        if (routeStartStationId == "" || routeEndStationId == "") {
            errAlertView("CMN003_12".localizedString(), errMgs: "CMN003_11".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
            return
        }
        
        getRouteIdByStationId(startStationText as NSString, endStationId: endStationText as NSString)
        getRouteline()
        showTipBtn("1")
        self.pageTag = "2"
        
        self.tbResultView.hidden = false
        self.vtbResultView.hidden = false
        self.vtbView.hidden = true
        self.tbView.hidden = true
        tbResultView.reloadData()
        mNearlyLogo.image = "route_locate".getImage()
        mCollectionLogo.image = "route_collected".getImage()
        
    }

    /**
    *   展示和收起底部menu菜单
    */
    func showTipBtn(index : String) {
        mTipView()
        if (index == "0") {
            self.testView.frame = CGRectMake(0, self.mScreenSize.height, self.mScreenSize.width, 44)
            
            
        } else if (index == "1"){
            self.testView.frame = CGRectMake(0, self.mScreenSize.height - 44, self.mScreenSize.width, 44)
            
        }
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
    
    // 收藏路径和提醒UIView
    func mTipView(){

        vline.backgroundColor = UIColor.lightGrayColor()
        self.testView.addSubview(vline)

        btnCollectRoute.setTitle("CMN003_25".localizedString(), forState: UIControlState.Normal)
        btnCollectRoute.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnCollectRoute.addTarget(self, action: "addUserfavoriteRoute", forControlEvents: UIControlEvents.TouchUpInside)
        self.testView.addSubview(btnCollectRoute)
        
        
        btnSetAlarm.setTitle("CMN003_14".localizedString(), forState: UIControlState.Normal)
        btnSetAlarm.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnSetAlarm.addTarget(self, action: "isPopToAlarm", forControlEvents: UIControlEvents.TouchUpInside)
        self.testView.addSubview(btnSetAlarm)
        
        
        if (routeIsCollected(self.routeID)){
            btnCollectRouteImg.image = "route_collectionlight".getImage()
        } else {
            btnCollectRouteImg.image = "route_collection".getImage()
        }
        
        self.testView.addSubview(btnCollectRouteImg)
        
        
        btnSetAlarmImg.image = "route_alarm".getImage()
        self.testView.addSubview(btnSetAlarmImg)
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
    
    
    func foucsChangeTo1 () {
        self.focusNumber = "1"
        hideKeyBoard()
        
        if (startStationText != "" && statIsCollected(startStationText)){
            btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        
        if (endStationText != "" && statIsCollected(endStationText)){
            btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }

        btnCollectRouteImg.image = "route_collection".getImage()
        setSationIdCache()
    }
    
    func foucsChangeTo2 () {
        self.focusNumber = "2"
        hideKeyBoard()
        
        if (startStationText != "" && statIsCollected(startStationText)){
            btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        if (endStationText != "" && statIsCollected(endStationText)){
            btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
        } else {
            btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
        }
        
        btnCollectRouteImg.image = "route_collection".getImage()
        setSationIdCache()
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
        allOfStationItemsId.removeAllObjects()
        allOfStationItemsJP.removeAllObjects()
        allOflineImageItems.removeAllObjects()
        allOfStationItemsJpKana.removeAllObjects()
        self.usrStationIds.removeAllObjects()
        
        self.tbResultView.hidden = true
        self.vtbResultView.hidden = true
        self.vtbView.hidden = false
        self.tbView.hidden = false
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
                var stationId:AnyObject = key.item(MSTT02_STAT_ID)
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var stationNameKanatemp = key.item(MSTT02_STAT_NAME_KANA) as String
                
                
                var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                
                // var statSeqArr = Cmn003Dao.queryLineIdByGroupId(statGroupId)
                self.allOflineImageItems.addObject(statSeqArr)
                self.allOfStationItemsJP.addObject(stationNameJP)
                self.allOfStationItemsId.addObject(stationId)
                self.allOfStationItemsJpKana.addObject(stationNameKanatemp)
                
            }
            self.vtbResultView.hidden = true
            self.tbResultView.hidden = true
            self.vtbView.hidden = false
            self.tbView.hidden = false
            tbView.reloadData()
        }
        
        
        mNearlyLogo.image = "route_locate".getImage()
        mCollectionLogo.image = "route_collectedlight".getImage()
        
    }
    
    // 搜索所有已经被收藏的路径Id
    func reloadCollectedRouteId() {
        
        self.allOfCollectedRouteId.removeAllObjects()
        var user03tableAdd = UsrT03FavoriteTable()
        user03tableAdd.favoType = "04"
        var user03Add = user03tableAdd.selectAll()
        
        
        for user03checkInsertValue in user03Add {
            user03checkInsertValue  as UsrT03FavoriteTable
            var mst02ResultRouteId:AnyObject = user03checkInsertValue.item(USRT03_RUTE_ID)
            self.allOfCollectedRouteId.addObject(mst02ResultRouteId)
        }
        
    }
    
    // 获取乘车总时间
    func getTotalTime(time:NSString) {
        var tempTime : Int = time.integerValue
        self.totalTime = self.totalTime + tempTime
    }
    
    // 判断站点是否已经被收藏
    func statIsCollected(statID:String) -> Bool {
        for key in allOfStationItemsId {
            if (statID == (key as String) || statID.station() == (key as String).station()) {
                return true
            }
        }
        return false
    }
    
    // 判断路线是否被收藏
    func routeIsCollected(routeId:String) -> Bool {
        for key in self.allOfCollectedRouteId{
            if (routeId == (key as String)){
                return true
            }
            
        }
        return false
    }
    
    // 判断换成站点是否是都运营线路
    func statIsMetro(statId:NSString) -> Bool {
        var checkId : NSString = ""
        checkId = statId.substringToIndex(3)
        if (checkId == "280"){
            return true
        }
        return false
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
        
        self.totalTime = 0
        
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
            
            getTotalTime(resultExchMoveTime.description as NSString)
            getTotalTime(resultExchWaitTime.description as NSString)
        }

    }

    // 位置定位到最近站点
    func locationUpdateComplete(location: CLLocation){
        
        self.pageTag = "3"
        allOfNearlyStationItemsId.removeAllObjects()
        allOfNearlyStationItemsJP.removeAllObjects()
        allOfNearlylineImageItems.removeAllObjects()
        allOfNearlyStationItemsJpKana.removeAllObjects()
        allNearlyStationlineGroup.removeAllObjects()
        self.vtbResultView.hidden = true
        self.tbResultView.hidden = true
        self.tbView.hidden = false
        self.vtbView.hidden = false
        self.tbView.reloadData()
        
        var locationTest : CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // 获取最近的10个站点
        var nearlyStations : Array<MstT02StationTable> = selectStationTable(location)
        
        // 显示唯10条
        for nearlystationId in nearlyStations{
            var mMst02tableNearlyStation = MstT02StationTable()
            
            mMst02tableNearlyStation.statId = nearlystationId.statId as String
            
            var mst02StationID:NSArray = mMst02tableNearlyStation.selectAll()
            
            for key in mst02StationID {
                
                key as MstT02StationTable
                var stationNameJP:AnyObject = key.item(MSTT02_STAT_NAME)
                var stationId:AnyObject = key.item(MSTT02_STAT_ID)
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var stationNameKanatemp = key.item(MSTT02_STAT_NAME_KANA) as String
                var statSeqArr = mst02table.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                
                self.allOfNearlylineImageItems.addObject(statSeqArr)
                self.allOfNearlyStationItemsJP.addObject(stationNameJP)
                self.allOfNearlyStationItemsId.addObject(stationId)
                self.allOfNearlyStationItemsJpKana.addObject(stationNameKanatemp)
            }
            
        }
        vtbResultView.hidden = true
        tbResultView.hidden = true
        tbView.hidden = false
        vtbView.hidden = false
        tbView.reloadData()
        showTipBtn("0")
        
        mNearlyLogo.image = "route_locatelight".getImage()
        mCollectionLogo.image = "route_collected".getImage()
        
        
    }
    
    // 放置本地数据
    func setSationIdCache() {
        
        self.appDelegate.startStatId = startStationText
        self.appDelegate.endStatId = endStationText
        
        if (focusNumber == "1"){
            if (startStationText != "" && statIsCollected(startStationText)){
                btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            } else {
                btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
            }
        } else if (focusNumber == "2"){
            
            if (endStationText != "" && statIsCollected(endStationText)){
                btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            } else {
                btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
            }
        }
    }
    
    // 读取本地数据
    func readStationIdCache() {
        
        if (self.startStationText != ""){
            stationStart.text = self.startStationText.station()
        } else {
            stationStart.text = self.appDelegate.startStatId.station()
            self.startStationText = self.appDelegate.startStatId
        }
        if (self.endStationText != ""){
            stationEnd.text = self.endStationText.station()
        } else {
            stationEnd.text = self.appDelegate.endStatId.station()
            self.endStationText = self.appDelegate.endStatId
        }
        
    }

    

    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

    
    //
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


