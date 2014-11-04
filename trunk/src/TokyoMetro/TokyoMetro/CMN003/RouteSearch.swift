 //
//  SESearch.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import CoreLocation
class RouteSearch : UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, GPSDelegate, UISearchBarDelegate{
    
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    // 交换按钮
    @IBOutlet weak var btnExchange: UIButton!
    // 显示起点站 button
    @IBOutlet weak var btnStatStartText: UIButton!
    // 显示终点站 button
    @IBOutlet weak var btnStatEndText: UIButton!
    //
    @IBOutlet weak var lblStatStartTextTip: UILabel!
    //
    @IBOutlet weak var lblStatEndTextTip: UILabel!
    //
    @IBOutlet weak var viewStatStartText: UIView!
    //
    @IBOutlet weak var viewStatEndText: UIView!
    
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
    
    var SearchButton:UIBarButtonItem?
    
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
    var endStationLandMarkId : String = ""
    
    var mImgZoomScale : CGFloat = 0.0
    var mst02table = MstT02StationTable()
    var user03table = UsrT03FavoriteTable()
    var fare06table = LinT06FareTable()
    var routeDetial05table = LinT05RouteDetailTable()

    var vline: UIView = UIButton(frame: CGRectMake(0, 1, 320, 1))
    var btnCollectRoute: UIButton = UIButton(frame: CGRectMake(0, 0, 160, 44))
    var btnSetAlarm: UIButton = UIButton(frame: CGRectMake(160, 0, 160, 44))
    
    // 总时间
    var totalTime : Int = 0
    // 总时间
    var totalExchangeTimes : Int = -1
    
    // 存放全局变量
    var appDelegate: AppDelegate!
    
    var cmn003Model : CMN003Model = CMN003Model()
    var mUsr002Model: USR002Model = USR002Model()
    var usr001Model : Usr001AddSubwayModel = Usr001AddSubwayModel()

    /* GPSHelper */
    let GPShelper: GPSHelper = GPSHelper()
    
    var sta002StationDetialModel: Sta002StationDetailModel = Sta002StationDetailModel()
    
    // 区分查询前页面和查询后结果页面。 1 为查询前页面。 2为查询后结果页面 3为附近站点
    var pageTag : String = "1"
    // 路线是否被收藏的tag, 1 未收藏，2 已经收藏
    var isAlarmFlag:String = "1"
    let SEARCHWAYACTION : Selector  = "searchWayAction"
    let ADDUSERFAVORITE : Selector  = "addUserfavorite:"
    let COLLECTEDSTATION : Selector  = "loadCollectedStation"
    let TABLEVIEW_TAG_SATTION_LIST : Int = 888
    let TABLEVIEW_TAG_ROUTE : Int = 999
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mScreenSize = UIScreen.mainScreen().bounds.size
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        
        lblStatStartTextTip.text = "PUBLIC_01".localizedString() + ":"
        lblStatEndTextTip.text = "PUBLIC_02".localizedString() + ":"

        
        self.tbResultView.hidden = true
        self.vtbResultView.hidden = true
        self.vtbView.hidden = false
        self.tbView.hidden = false
        
        
        btnExchange.layer.cornerRadius = 4
        btnCollectionStation.addTarget(self, action: COLLECTEDSTATION, forControlEvents: UIControlEvents.TouchUpInside)
        
        testView.frame = CGRectMake(320, 568, 320, 33)
        testView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(testView)
        
        SearchButton = UIBarButtonItem(title: "CMN003_10".localizedString(), style: UIBarButtonItemStyle.Plain, target:self, action: "searchWayAction")

        self.navigationItem.rightBarButtonItem = SearchButton!
        
        mNearlyLogo.image = "route_locate".getImage()
        mCollectionLogo.image = "route_collectedlight".getImage()
        // 显示收藏站点时 tag ＝ 10001 否则为10011
        // 显示附近站点时 tag ＝ 10002 否则为10012
        btnCollectionStation.tag = 10001
        btnNearlyStation.tag = 10002
        btnCollect1.tag = 1133
        btnCollect2.tag = 2133
        loadStation()
        reloadCollectedRouteId()
        
        self.tbResultView.tag = TABLEVIEW_TAG_ROUTE
        self.tbView.tag = TABLEVIEW_TAG_SATTION_LIST

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        readStationIdCache()
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
        viewStatStartText.layer.cornerRadius = 4
        viewStatEndText.layer.cornerRadius = 4
        searchWayAction()
    }
    
    // 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setSationIdCache()
    }

    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.pageTag == "2" && tableView.tag == TABLEVIEW_TAG_ROUTE) {
            if (indexPath.row == 0) {
                return 38
            } else {
                return 77
            }
        } else {
            return 55
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        var viewSection : UIView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 22))
        viewSection.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)

        
        var lblViewSectionText : UILabel = UILabel(frame: CGRect(x: 10,y: 0,width: 200,height: 22))
        lblViewSectionText.font = UIFont.systemFontOfSize(15)
        lblViewSectionText.tag = 32022
        if (self.pageTag == "1" && tableView == tbView) {
            lblViewSectionText.text = "CMN003_17".localizedString()
        } else if (self.pageTag == "2" && tableView == tbResultView){
            lblViewSectionText.text = "CMN003_22".localizedString()
        } else {
            lblViewSectionText.text = "PUBLIC_11".localizedString()
        }
        
        viewSection.addSubview(lblViewSectionText)
        return viewSection
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        //TODO:判空
        if (self.pageTag == "2" && tableView == tbResultView) {
          //  if self.routeDetial == nil {
                return self.routeDetial.count + 1
           // }
        } else if (self.pageTag == "3" && tableView == tbView) {
           // if self.allOfNearlyStationItemsId == nil {
                return self.allOfNearlyStationItemsId.count
           // }
        }else if (self.pageTag == "1" && tableView == tbView){
           // if self.allOfStationItemsId == nil {
                return self.allOfStationItemsId.count
            //}
        } else {

        }
        return 0
    }
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if (self.pageTag == "1" && tableView.tag == TABLEVIEW_TAG_SATTION_LIST) {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            tableViewCellCollectedStation(cell, cellForRowAtIndexPath: indexPath)
            return cell
        } else if ( self.pageTag == "3" && tableView.tag == TABLEVIEW_TAG_SATTION_LIST) {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SECell", forIndexPath: indexPath) as UITableViewCell
            tableViewCellNearlyStation(cell, cellForRowAtIndexPath: indexPath)
            return cell
            
            
            
        }else if ( self.pageTag == "2" && tableView.tag == TABLEVIEW_TAG_ROUTE) {
            
            if (indexPath.row == 0) {
                
                let cellTip: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeTip", forIndexPath: indexPath) as UITableViewCell
                tableViewCellRouteResultTip(cellTip, cellForRowAtIndexPath: indexPath)
                return cellTip
                
            } else {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("routeResultCell", forIndexPath: indexPath) as UITableViewCell
                cell.tag  = 2222
                
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
        mCellLineView.frame = CGRectMake(150, 18, 120, 22)
        mCellLineView.tag = 4001
        
        for (var i = 0; i < lineImageItemsRow.count; i++) {
            var map = lineImageItemsRow[i] as MstT02StationTable
            var lineIcon: UIImageView = UIImageView()
            
            lineIcon.frame = CGRectMake(CGFloat(120 - i * 20), 2, 18, 18)
            lineIcon.image = (map.item(MSTT02_LINE_ID) as String).getLineMiniImage()
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
        
        mCellLineView.frame = CGRectMake(150, 18, 120, 22)
        mCellLineView.tag = 4001
        
        for (var i = 0; i < lineImageItemsRow.count; i++) {
            
            var map = lineImageItemsRow[i] as MstT02StationTable
            var lineIcon: UIImageView = UIImageView()
            
            lineIcon.frame = CGRectMake(CGFloat(120 - i * 20), 2, 18, 18)
            lineIcon.image = (map.item(MSTT02_LINE_ID) as String).getLineMiniImage()
            mCellLineView.addSubview(lineIcon)
        }

        cell.addSubview(mCellLineView)
    }
    
    // 路线信息tablecell
    func tableViewCellRouteResultTip(cellTip:UITableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath){
        var resultTipCelllblStationExchange : UILabel = cellTip.viewWithTag(9001) as UILabel
        var resultTipCelllblStationExchangeTip : UILabel = cellTip.viewWithTag(9002) as UILabel
        var resultTipCelllblStationExchangeTipAfter : UILabel = cellTip.viewWithTag(9102) as UILabel
        
        var resultTipCelllblStationFare : UILabel = cellTip.viewWithTag(9003) as UILabel
        var resultTipCelllblStationFareTip : UILabel = cellTip.viewWithTag(9004) as UILabel
        var resultTipCelllblStationFareTipAfter : UILabel = cellTip.viewWithTag(9104) as UILabel
        var resultTipCelllblStationTime : UILabel = cellTip.viewWithTag(9005) as UILabel
        var resultTipCelllblStationTimeTip : UILabel = cellTip.viewWithTag(9006) as UILabel
        var resultTipCelllblStationTimeTipAfter : UILabel = cellTip.viewWithTag(9106) as UILabel
        
        if (self.totalExchangeTimes > 0){
            resultTipCelllblStationExchange.text = "EXCHANGE_TYPE_1".localizedString()
            resultTipCelllblStationExchangeTip.text = String(self.totalExchangeTimes)
            resultTipCelllblStationExchangeTipAfter.text = "CMN003_23".localizedString()
        } else {
            resultTipCelllblStationExchange.hidden = true
            resultTipCelllblStationExchangeTip.hidden = true
            resultTipCelllblStationExchangeTipAfter.hidden = true
        }
        
        
        if(self.totalTime > 0) {
            resultTipCelllblStationFare.text = "PUBLIC_10".localizedString()
            resultTipCelllblStationFareTip.text = getFare()
            resultTipCelllblStationFareTipAfter.text = "CMN003_26".localizedString()
            resultTipCelllblStationTime.text = "预计耗时"
            resultTipCelllblStationTimeTip.text = String(self.totalTime)
            resultTipCelllblStationTimeTipAfter.text = "CMN003_03".localizedString()
        } else {
            resultTipCelllblStationFareTipAfter.hidden = true
            resultTipCelllblStationFareTip.hidden = true
            resultTipCelllblStationFare.hidden = true
            resultTipCelllblStationTimeTipAfter.hidden = true
            resultTipCelllblStationTimeTip.hidden = true
            resultTipCelllblStationTime.hidden = true
        }
        

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
        var resultCelllblStationMoveDestNameAfter : UILabel = cell.viewWithTag(1109) as UILabel
        var resultCelllblStationLineNameTip : UILabel = cell.viewWithTag(1111) as UILabel
        var resultCelllblStationWaitTimeTip : UILabel = cell.viewWithTag(1012) as UILabel
        var resultCelllblStationWaitTimeTipAfter : UILabel = cell.viewWithTag(1112) as UILabel
        var resultCelllblStationMoveTimeTip : UILabel = cell.viewWithTag(1013) as UILabel
        var resultCelllblStationMoveTimeTipAfter : UILabel = cell.viewWithTag(1113) as UILabel
        var resultCelllblStationEixtInfo : UIView = cell.viewWithTag(9500) as UIView!
        

        var routStartDic = self.routeDetial.objectAtIndex(indexPath.row - 1) as NSDictionary
        var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
        var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
        var strresultExchType = routStartDic["resultExchType"] as? NSString
        
        if (indexPath.row == routeDetial.count){
            resultCelllblStationLineName.hidden = true
            resultCelllblStationWaitTime.hidden = true
            resultCelllblStationMoveTime.hidden = true
            resultCelllblStationWaitTimeTip.hidden = true
            resultCelllblStationWaitTimeTipAfter.hidden = true
            resultCelllblStationMoveTimeTip.hidden = true
            resultCelllblStationMoveTimeTipAfter.hidden = true
            resultCelllblStationLineImg.hidden = true
            resultCelllblStationMoveDestTip.hidden = true
            resultCelllblStationMoveDestName.hidden = true
            resultCelllblStationMoveDestNameAfter.hidden = true
            resultCelllblStationLineNameTip.hidden = true
            
            
            resultCellIvStaionIcon.hidden = false
            resultCelllblStationName.hidden = false
            
            resultCellIvStaionIcon.image = "route_end".getImage()
            resultCelllblStationName.text = self.endStationText.station()
            
            if (!endStationLandMarkId.isEmpty) {
                if(landMarkExitInfo(endStationLandMarkId) != nil){
                    var exitInfoDic = landMarkExitInfo(endStationLandMarkId)
                    resultCelllblStationEixtInfo = mViewExitInfo(exitInfoDic!, viewInfo: resultCelllblStationEixtInfo, cell:cell)
                    endStationLandMarkId = ""
                }
            }
            
            
            
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
                resultCelllblStationWaitTimeTipAfter.hidden = true
                resultCelllblStationMoveDestTip.hidden = true
                resultCelllblStationMoveDestName.hidden = true
                resultCelllblStationMoveDestNameAfter.hidden = true
                
                resultCelllblStationMoveTimeTip.hidden = false
                resultCelllblStationMoveTimeTipAfter.hidden = false
                resultCelllblStationMoveTime.hidden = false
                
                resultCelllblStationMoveTime.text = "CMN003_07".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String)
                resultCelllblStationMoveTimeTipAfter.text = "CMN003_03".localizedString()
            
            } else if (strresultExchType == "8") {
                
                resultCelllblStationLineName.hidden = false
                resultCelllblStationLineNameTip.hidden  = false
                resultCelllblStationLineImg.hidden  = false
                resultCelllblStationMoveDestTip.hidden  = false
                resultCelllblStationMoveDestName.hidden  = false
                resultCelllblStationMoveDestNameAfter.hidden = false
                resultCelllblStationWaitTime.hidden = false
                resultCelllblStationWaitTimeTip.hidden = false
                resultCelllblStationWaitTimeTipAfter.hidden = false
                
                var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                if ((strresultExchWaitTime as String) != "0") {
                    resultCelllblStationWaitTime.text = "CMN003_02".localizedString()
                    resultCelllblStationWaitTimeTip.text = (strresultExchWaitTime as String)
                    resultCelllblStationWaitTimeTipAfter.text = "CMN003_03".localizedString()

                } else {
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationWaitTimeTip.hidden = true
                    resultCelllblStationWaitTimeTipAfter.hidden = true
                }
                
                resultCelllblStationMoveTime.text = "CMN003_04".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String)
                resultCelllblStationMoveTimeTipAfter.text = "CMN003_03".localizedString()
                var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                
                resultCelllblStationLineName.text = "CMN003_05".localizedString()
                resultCelllblStationLineImg.image =  (strresultExchlineId as String).getLineMiniImage()
                resultCelllblStationLineNameTip.text = (strresultExchlineId as String).line()
                
                resultCelllblStationMoveDestTip.text = "CMN003_06".localizedString()
                resultCelllblStationMoveDestName.text = (strresultExchDestId as String).station()
                resultCelllblStationMoveDestNameAfter.text = "PUBLIC_04".localizedString()
            
            }
            
        } else {
            var strresultExchStatId = routStartDic["resultExchStatId"] as? NSString
            resultCelllblStationName.text = (strresultExchStatId as String).station()

            if (strresultExchType == "255") {
                
                resultCelllblStationLineName.hidden = true
                resultCelllblStationLineNameTip.hidden = true
                resultCelllblStationWaitTime.hidden = true
                resultCelllblStationWaitTimeTip.hidden = true
                resultCelllblStationWaitTimeTipAfter.hidden = true
                resultCelllblStationMoveDestTip.hidden = true
                resultCelllblStationMoveDestName.hidden = true
                resultCelllblStationMoveDestNameAfter.hidden = true
                resultCelllblStationLineImg.hidden = true
                
                resultCellIvStaionIcon.hidden = false
                resultCelllblStationMoveTime.hidden = false
                resultCelllblStationMoveTimeTip.hidden = false
                resultCelllblStationMoveTimeTipAfter.hidden = false
                
                resultCellIvStaionIcon.image = "routeexchange_walk".getImage()
                resultCelllblStationMoveTime.text = "CMN003_07".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String)
                resultCelllblStationMoveTimeTipAfter.text = "CMN003_03".localizedString()

                
            } else if (strresultExchType == "8") {
                
                resultCelllblStationLineName.hidden = false
                resultCelllblStationLineNameTip.hidden = false
                resultCelllblStationLineImg.hidden = false
                resultCelllblStationMoveDestTip.hidden = false
                resultCelllblStationMoveDestName.hidden = false
                resultCelllblStationMoveDestNameAfter.hidden = false
                resultCellIvStaionIcon.hidden = false
                resultCelllblStationWaitTime.hidden = false
                resultCelllblStationWaitTimeTip.hidden = false
                resultCelllblStationWaitTimeTipAfter.hidden = false
                
                var strresultExchWaitTime = routStartDic["resultExchWaitTime"] as? NSString
                if ((strresultExchWaitTime as String) != "0") {
                    resultCelllblStationWaitTime.text = "CMN003_02".localizedString()
                    resultCelllblStationWaitTimeTip.text = (strresultExchWaitTime as String)
                    resultCelllblStationWaitTimeTipAfter.text = "CMN003_03".localizedString()
                } else {
                    resultCelllblStationWaitTime.hidden = true
                    resultCelllblStationWaitTimeTip.hidden = true
                    resultCelllblStationWaitTimeTipAfter.hidden = true
                    
                }
                
                var strresultExchMoveTime = routStartDic["resultExchMoveTime"] as? NSString
                
                resultCelllblStationMoveTime.text = "CMN003_04".localizedString()
                resultCelllblStationMoveTimeTip.text = (strresultExchMoveTime as String)
                resultCelllblStationMoveTimeTipAfter.text = "CMN003_03".localizedString()

                resultCellIvStaionIcon.image = "routeexchange_metro".getImage()
                
                var strresultExchlineId = routStartDic["resultExchlineId"] as? NSString
                resultCelllblStationLineName.text = "CMN003_01".localizedString()
                resultCelllblStationLineNameTip.text = (strresultExchlineId as String).line()
                resultCelllblStationLineImg.image =  (strresultExchlineId as String).getLineMiniImage()
                
                var strresultExchDestId = routStartDic["resultExchDestId"] as? NSString
                resultCelllblStationMoveDestTip.text = "CMN003_06".localizedString()
                resultCelllblStationMoveDestName.text = (strresultExchDestId as String).station()
                resultCelllblStationMoveDestNameAfter.text = "PUBLIC_04".localizedString()
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
    }
    
    // 选择tableView 焦点为显示 收藏站点或者 附近站点
    func tableViewCellSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        var celllblStaionName : UILabel = cell.viewWithTag(101) as UILabel
        var stationName : String? =  celllblStaionName.text
        
        if focusNumber == "1" {
            if !(stationName == self.endStationText.station())  {
                self.btnStatStartText.setTitle(stationName, forState: UIControlState.Normal)
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
                errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_08".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
                
            }
            
        } else if focusNumber == "2" {
            
            if !(stationName == self.startStationText.station()) {
               //  self.stationEnd.text = stationName
                self.btnStatEndText.setTitle(stationName, forState: UIControlState.Normal)
                
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
                errAlertView("PUBLIC_04".localizedString(), errMgs: "CMN003_08".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
                
            }
        }
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
    
    @IBAction func foucsChangeTo1 () {
        self.focusNumber = "1"
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
        btnCollectRoute.setBackgroundImage("route_collectionRoute".getImage(), forState: UIControlState.Normal)
        setSationIdCache()
        
        viewStatStartText.backgroundColor = UIColor(patternImage: "btnText_focus".getImage())
        viewStatEndText.backgroundColor = UIColor(patternImage: "btnText_normal".getImage())
    }
    
    @IBAction func foucsChangeTo2 () {
        self.focusNumber = "2"
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
        btnCollectRoute.setBackgroundImage("route_collectionRoute".getImage(), forState: UIControlState.Normal)
        setSationIdCache()
        viewStatStartText.backgroundColor = UIColor(patternImage: "btnText_normal".getImage())
        viewStatEndText.backgroundColor = UIColor(patternImage: "btnText_focus".getImage())
    }
    
    // 判断是否要跳转到StationList页面
    @IBAction func isPopToStationList() {
        setSationIdCache()
        var searchAllStation : SearchStationList = self.storyboard?.instantiateViewControllerWithIdentifier("SearchStationList") as SearchStationList
        searchAllStation.focusNumber = self.focusNumber
        searchAllStation.classType = "routeSearch"
        searchAllStation.routeSearch = self
        self.navigationController?.pushViewController(searchAllStation, animated: true)
        
        btnCollectionStation.tag == 10001
        btnNearlyStation.tag = 10002
    }
    
    
    @IBAction func locatNearlyStation() {
        if (btnNearlyStation.tag == 10002) {
            // 定位时打开
            loadLocation()

            btnCollectionStation.tag = 10001
            btnNearlyStation.tag = 10012
        }
    }
    
    
    // 起点和终点交换
     @IBAction func exchangeAction(){

        var tempStationId:String = startStationText
        startStationText  = endStationText
        endStationText  = tempStationId

        self.btnStatStartText.setTitle(self.startStationText.station(), forState: UIControlState.Normal)
        self.btnStatEndText.setTitle(self.endStationText.station(), forState: UIControlState.Normal)

        if (startStationText != "" && statIsCollected(startStationText)){
            btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            btnCollect1.tag == 1233
        } else {
            btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
            btnCollect1.tag == 1133
        }
        
        
        if (endStationText != "" && statIsCollected(endStationText)){
            btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
            btnCollect2.tag == 2233
        } else {
            btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
            btnCollect2.tag == 2133
        }
        
        if (self.startStationText != "" && self.endStationText != ""){
            var tempRoute = getRouteIdByStationId(startStationText as NSString, endStationId: endStationText as NSString)
            if (routeIsCollected(tempRoute)) {
                
                btnCollectRoute.setBackgroundImage("route_collectionRoutelight".getImage(), forState: UIControlState.Normal)
            } else {
                btnCollectRoute.setBackgroundImage("route_collectionRoute".getImage(), forState: UIControlState.Normal)
            }
        }
        
    }
    
    // 搜索路线
    func searchWayAction(){
        if (isSearchable()){
            searchRouteAction()
            SearchButton?.enabled = true
        } else {
            SearchButton?.enabled = false
        
        }
    }
    
     @IBAction func isPopToAlarm() {
        // 7512 表示已经设置过提醒 7511 表示还没设置提醒 btnSetAlarm.tag = 7511
   
        if (isAlarmFlag == "2") {
            // 弹信息： 表示已经设置过提醒，无法跳转，需要跳转。需要去线路页面取消现在的提醒
            errAlertView("CMN003_12".localizedString(), errMgs: "请先取消已存在的提醒", errBtnTitle: "PUBLIC_06".localizedString())
        } else {
            var remindDetailController : RemindDetailController = self.storyboard?.instantiateViewControllerWithIdentifier("reminddetail") as RemindDetailController
            remindDetailController.routeStatTable01 = cmn003Model.getStationDetialById(routeStartStationId)
            remindDetailController.routeStatTable02 = cmn003Model.getStationDetialById(routeEndStationId)
            remindDetailController.segIndex = 0
            self.navigationController?.pushViewController(remindDetailController, animated:true)
        }
        
       
        
    }
    
    // 添加收藏站点
    @IBAction func addUserfavoriteStation(sender: UIButton) {
        var insertStationId : String = ""
        switch sender {
        case btnCollect1:
            if self.startStationText != "" {
                insertStationId = self.startStationText
            } else {
                return
            }
            
        case btnCollect2:
            if self.endStationText != "" {
                insertStationId = self.endStationText
            } else {
                return
            }
            
        default:
            return
        }
        
        
        if ((btnCollect1.tag == 1233) && (sender == btnCollect1)) {
            
            var  isDeleteStat = cmn003Model.removeUserFavorite(insertStationId, deleteType: "01")
            if isDeleteStat {
                btnCollectionStation.tag = 10001
                loadStation()
                btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
                btnCollect1.tag = 1133
            }
            
            
        } else if ((btnCollect1.tag == 1133) && (sender == btnCollect1)){
            var  isInsertStat = cmn003Model.addUserFavoriteStat(insertStationId)
            if isInsertStat {
                btnCollectionStation.tag = 10001
                loadStation()
                btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
                btnCollect1.tag = 1233
                
            }
        }
        
        if ((btnCollect2.tag == 2233) && (sender == btnCollect2)) {
            
            var  isDeleteStat = cmn003Model.removeUserFavorite(insertStationId, deleteType: "01")
            if isDeleteStat {
                btnCollectionStation.tag = 10001
                loadStation()
                btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
                btnCollect2.tag = 2133
            }
            
            
        } else if ((btnCollect2.tag == 2133) && (sender == btnCollect2)){
            var  isInsertStat = cmn003Model.addUserFavoriteStat(insertStationId)
            if isInsertStat {
                btnCollectionStation.tag = 10001
                loadStation()
                btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
                btnCollect2.tag = 2233
                
            }
        }
     }
    
    // 添加收藏路线
    func addUserfavoriteRoute() {
        // 235 表示已经收藏，进行删除     255 表示还未收藏，进行添加
        if (btnCollectRoute.tag == 235) {
            var isDeleteRoute = cmn003Model.removeUserFavorite(self.routeID, deleteType: "04")
            if isDeleteRoute {
                reloadCollectedRouteId()
                btnCollectRoute.setBackgroundImage("route_collectionRoute".getImage(), forState: UIControlState.Normal)
                btnCollectRoute.tag = 255
            }
        
        } else {
            
            var isInsertRoute = cmn003Model.addUserFavoriteRoute(self.routeID)
            if isInsertRoute {
                reloadCollectedRouteId()
                btnCollectRoute.setBackgroundImage("route_collectionRoutelight".getImage(), forState: UIControlState.Normal)
                btnCollectRoute.tag = 235
            }
        }
    }
    // 显示所有收藏站点
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
        btnCollectionStation.tag = 10001
        btnNearlyStation.tag = 10002
    }

    /**
    *   展示和收起底部提醒和收藏
    */
    func showTipBtn(index : String) {
        mTipView()
        if (index == "0") {
            self.testView.frame = CGRectMake(0, self.mScreenSize.height, self.mScreenSize.width, 44)

        } else if (index == "1"){
            
            self.testView.frame = CGRectMake(0, self.mScreenSize.height - 44, self.mScreenSize.width, 44)
            
        }
    }

    /**
     * 到DB中查找最近的站点
     */
    func selectStationTable(currentLocation: CLLocation) -> Array<MstT02StationTableData>?{
        let mMstT02Dao:MstT02StationTable = MstT02StationTable()
        
        var coordinateOnMars: CLLocationCoordinate2D = currentLocation.coordinate
        var lon:CDouble = coordinateOnMars.longitude
        var lat:CDouble = coordinateOnMars.latitude
        
        var mMst02Tables:Array<MstT02StationTable> = mMstT02Dao.queryNearbyStations(lon,lat: lat) as Array<MstT02StationTable>
        
        var mMst02Datas:Array<MstT02StationTableData> = Array<MstT02StationTableData>()
        for mMst02Table in mMst02Tables{
            var mMst02Data:MstT02StationTableData = MstT02StationTableData()
            mMst02Datas.append(mMst02Data.fromDAO(mMst02Table) as MstT02StationTableData)
        }
        
        return mMst02Datas
    }
    
    // 收藏路径和提醒UIView
    func mTipView(){

        vline.backgroundColor = UIColor.lightGrayColor()
        self.testView.addSubview(vline)

        btnCollectRoute.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnCollectRoute.addTarget(self, action: "addUserfavoriteRoute", forControlEvents: UIControlEvents.TouchUpInside)
        if (routeIsCollected(self.routeID)){
            btnCollectRoute.setBackgroundImage("route_collectionRoutelight".getImage(), forState: UIControlState.Normal)
            
            btnCollectRoute.tag = 235
        } else {
            btnCollectRoute.setBackgroundImage("route_collectionRoute".getImage(), forState: UIControlState.Normal)
            btnCollectRoute.tag = 255
        }
        self.testView.addSubview(btnCollectRoute)
        
        let usrt01Alarms:[UsrT01ArrivalAlarmTableData]? = mUsr002Model.findArrivalAlarm()
//        var isAlarmFlag:String = "1"
        for key in usrt01Alarms!{
            if(key.cancelFlag != "" && key.cancelFlag == "0"){
                isAlarmFlag = "2"
                break
            }
        }
        // 7512 表示已经设置过提醒 7511 表示还没设置提醒 btnSetAlarm.tag = 7511
        if (isAlarmFlag == "2"){
            btnSetAlarm.setBackgroundImage("route_routeAlarmlight".getImage(), forState: UIControlState.Normal)
            btnSetAlarm.tag = 7511
        } else {
            btnSetAlarm.setBackgroundImage("route_routeAlarm".getImage(), forState: UIControlState.Normal)
            btnSetAlarm.tag = 7512
        }
        
        btnSetAlarm.addTarget(self, action: "isPopToAlarm", forControlEvents: UIControlEvents.TouchUpInside)
        self.testView.addSubview(btnSetAlarm)

    }

    /**
    * 加载当前位置
    */
    func loadLocation(){
        if(GPShelper.delegate == nil){
            GPShelper.delegate = self
        }
        GPShelper.updateLocation()
    }
    
    

    
    
    // 弹出错误提示框
    func errAlertView(errTitle:String, errMgs:String, errBtnTitle:String) {
        var eAv:UIAlertView = UIAlertView()
        eAv.title = errTitle
        eAv.message = errMgs
        eAv.addButtonWithTitle(errBtnTitle)
        eAv.show()
    }

    // 获取所有站的站名和图标
    func loadStation() {
        
        if (btnCollectionStation.tag == 10001){
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
                    
                    
                    var statSeqArr = mst02table.excuteQuery("select LINE_ID, ROWID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
                    
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
            
            btnCollectionStation.tag = 10011
            btnNearlyStation.tag = 10002
        }
        
        
        
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
    
    // 获取换乘的次数
    func getTotalExchangeTimes(){
        self.totalExchangeTimes = self.totalExchangeTimes + 1
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
        self.totalExchangeTimes = -1
        
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
            
            if (resultExchType == "8"){
                getTotalExchangeTimes()
            }
        }
    }

    // 位置定位到最近站点
    func locationUpdateComplete(location: CLLocation){
        println("UpdateComplete")
        self.pageTag = "3"
        self.allOfNearlyStationItemsId = NSMutableArray.array()
        self.allOfNearlyStationItemsJP = NSMutableArray.array()
        self.allOfNearlylineImageItems = NSMutableArray.array()
        self.allOfNearlyStationItemsJpKana = NSMutableArray.array()
        self.allNearlyStationlineGroup = NSMutableArray.array()
        self.vtbResultView.hidden = true
        self.tbResultView.hidden = true
        self.tbView.hidden = false
        self.vtbView.hidden = false
        self.tbView.reloadData()
        // 获取最近的10个站点
        var nearlyStations : Array<MstT02StationTableData>? = selectStationTable(location)

        if(!(nearlyStations == nil) && nearlyStations!.count > 0){
            // 显示唯10条
            for nearlystation in nearlyStations!{
                var stationNameJP:AnyObject = nearlystation.statId.station()
                var stationId:AnyObject = nearlystation.statId
                var statSeqArr:NSArray = NSArray.array()
                
                var mst02table:MstT02StationTable = MstT02StationTable()
                statSeqArr = mst02table.excuteQuery("select LINE_ID, ROWID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(nearlystation.statGroupId)")
                var stationNameKanatemp:AnyObject = nearlystation.statNameKana

                self.allOfNearlylineImageItems.addObject(statSeqArr)
                self.allOfNearlyStationItemsJP.addObject(stationNameJP)
                self.allOfNearlyStationItemsId.addObject(stationId)
                self.allOfNearlyStationItemsJpKana.addObject(stationNameKanatemp)
                
//                var mMst02tableNearlyStation = MstT02StationTable()
//                
//                mMst02tableNearlyStation.statId = nearlystationId.statId as String
//                
//                var mst02StationID:NSArray = mMst02tableNearlyStation.selectAll()
                
                
                
                
//                for key in nearlystationId {
                
//                    key as MstT02StationTable
//                }
                
            }
            self.vtbResultView.hidden = true
            self.tbResultView.hidden = true
            self.tbView.hidden = false
            self.vtbView.hidden = false
            self.tbView.reloadData()
        }
        self.showTipBtn("0")
        self.mNearlyLogo.image = "route_locatelight".getImage()
        self.mCollectionLogo.image = "route_collected".getImage()
        self.btnCollectionStation.tag = 10001
        self.btnNearlyStation.tag = 10012
    }
    
    // 放置本地数据
    func setSationIdCache() {
        
        self.appDelegate.startStatId = startStationText
        self.appDelegate.endStatId = endStationText
        
        if (focusNumber == "1"){
            if (startStationText != "" && statIsCollected(startStationText)){
                btnCollect1.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
                btnCollect1.tag = 1233
                
            } else {
                btnCollect1.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
                btnCollect1.tag = 1133
            }
        } else if (focusNumber == "2"){
            
            if (endStationText != "" && statIsCollected(endStationText)){
                btnCollect2.setBackgroundImage("route_collectionlight".getImage(), forState: UIControlState.Normal)
                btnCollect2.tag = 2233
            } else {
                btnCollect2.setBackgroundImage("searchroute_collection".getImage(), forState: UIControlState.Normal)
                btnCollect2.tag = 2133
            }
        }
        
        if (isSearchable()) {
            self.SearchButton?.enabled = true
        } else {
            self.SearchButton?.enabled = false
        }
        
    
    }
    
    // 读取本地数据
    func readStationIdCache() {

        if (self.startStationText != ""){
            self.btnStatStartText.setTitle(self.startStationText.station(), forState: UIControlState.Normal)
        } else {
            self.btnStatStartText.setTitle(self.appDelegate.startStatId.station(), forState: UIControlState.Normal)
            self.startStationText = self.appDelegate.startStatId
        }
        if (self.endStationText != ""){
            self.btnStatEndText.setTitle(self.endStationText.station(), forState: UIControlState.Normal)
        } else {
            self.endStationText = self.appDelegate.endStatId
            self.btnStatEndText.setTitle(self.appDelegate.endStatId.station(), forState: UIControlState.Normal)
        }
        
        if (self.endStationText == self.startStationText && self.endStationText != "") {
            errAlertView("CMN003_12".localizedString(), errMgs: "CMN003_08".localizedString(), errBtnTitle: "PUBLIC_06".localizedString())
        }
        
        if (isSearchable()){
            SearchButton?.enabled = true
        } else {
            SearchButton?.enabled = false
        }
        
        if (self.focusNumber == "1") {
            viewStatStartText.backgroundColor = UIColor(patternImage: "btnText_focus".getImage())
            viewStatEndText.backgroundColor = UIColor(patternImage: "btnText_normal".getImage())
        } else {
            viewStatStartText.backgroundColor = UIColor(patternImage: "btnText_normal".getImage())
            viewStatEndText.backgroundColor = UIColor(patternImage: "btnText_focus".getImage())
        
        }
        
        
    }
    

    //
    func isSearchable() -> Bool {
        if (self.startStationText != "" && self.startStationText != self.endStationText && self.endStationText != ""){
            return true
        } else {
            return false
        }
    
    }
    
    // 根据lmak——ID 查询相关景点的出口信息
    func landMarkExitInfo(lmakId:String) -> Dictionary<String, String>? {
        
        
        var exitId: String = ""
        var exitMoveTime: String = ""
        var exitInfo: String = ""
        
        var lmakName:String = ""
        
        if (!lmakId.isEmpty) {
            var mst04LandMarkTable : MstT04LandMarkTable = MstT04LandMarkTable()
            mst04LandMarkTable.lmakId = lmakId
            var lmak04SearchResult : Array = mst04LandMarkTable.selectAll()
     
            if (lmak04SearchResult.count == 1) {
                if (lmak04SearchResult[0].statExitId.description != "nil" ) {
                        exitId = lmak04SearchResult[0].statExitId.description
                }
                if (lmak04SearchResult[0].statExitTime.description != "nil") {
                        exitMoveTime = lmak04SearchResult[0].statExitTime.description
                    }
                if (lmak04SearchResult[0].lmakName.description != "nil") {
                    lmakName = lmak04SearchResult[0].lmakName.description
                    
                }

             
                
            } else {
                return nil
            }
        
        }
        
        var exitInfoDic : Dictionary = ["exitId":exitId, "exitMoveTime":exitMoveTime,"lmakName":lmakName]

        return exitInfoDic
    
    }
    
    func mViewExitInfo(exitInfoDic: Dictionary<String, String>, viewInfo: UIView, cell:UITableViewCell) -> UIView{
        

        if (!exitInfoDic.isEmpty) {
            var exitId: String? = exitInfoDic["exitId"] as String!
            if ((exitId != nil) && (exitId != "")) {
                lblExitInfo(viewInfo, exitIdFunc: exitId!, exitInfoDicFunc: exitInfoDic)
            }
        }
        return viewInfo

    }
    
    
    func lblExitInfo(viewInfoFunc: UIView, exitIdFunc: String, exitInfoDicFunc: Dictionary<String, String>) {
        
        var lblNameBefore = viewInfoFunc.viewWithTag(4501)
        if (lblNameBefore != nil ){
            lblNameBefore?.removeFromSuperview()
        }
        var lblExitNameBefor : UILabel = UILabel()
        lblExitNameBefor.font = UIFont.systemFontOfSize(11)
        lblExitNameBefor.textColor = UIColor.lightGrayColor()
        lblExitNameBefor.text = "请从"
        lblExitNameBefor.tag = 4501
        lblExitNameBefor.frame = CGRectMake(0, 10, 25, 33)
        
        var mlblExitName = viewInfoFunc.viewWithTag(4502)
        if (mlblExitName != nil ){
            mlblExitName?.removeFromSuperview()
        }
        var lblExitName : UILabel = UILabel()
        lblExitName.tag = 4502
        lblExitName.font = UIFont.systemFontOfSize(15)
        lblExitName.frame = CGRectMake(25, 10, 190, 33)
        lblExitName.textAlignment = NSTextAlignment.Center
        lblExitName.text = exitIdFunc.stationExit()
        var mlblExitNameAfter = viewInfoFunc.viewWithTag(4503)
        if (mlblExitNameAfter != nil ){
            mlblExitNameAfter?.removeFromSuperview()
        }
        var lblExitNameAfter : UILabel = UILabel()
        lblExitNameAfter.tag = 4503
        lblExitNameAfter.font = UIFont.systemFontOfSize(11)
        lblExitNameAfter.textColor = UIColor.lightGrayColor()
        lblExitNameAfter.frame = CGRectMake(205, 10, 25, 33)
        lblExitNameAfter.text = "出站"
        
        viewInfoFunc.addSubview(lblExitNameBefor)
        viewInfoFunc.addSubview(lblExitName)
        viewInfoFunc.addSubview(lblExitNameAfter)
        
        
        var exitMoveTimeFunc: String? = exitInfoDicFunc["exitMoveTime"] as String!
        if ((exitMoveTimeFunc != nil)) {
            
            
            if ((exitMoveTimeFunc != "0") && (exitMoveTimeFunc != "")) {
                var lblTimeBefore = viewInfoFunc.viewWithTag(5501)
                if (lblTimeBefore != nil ){
                    lblTimeBefore?.removeFromSuperview()
                }
                var lblExitTimeBefor : UILabel = UILabel()
                lblExitTimeBefor.font = UIFont.systemFontOfSize(11)
                lblExitTimeBefor.textColor = UIColor.lightGrayColor()
                lblExitTimeBefor.text = "步行大约"
                lblExitTimeBefor.tag = 5501
                lblExitTimeBefor.frame = CGRectMake(0, 33, 50, 22)
                
                var mlblTimeName = viewInfoFunc.viewWithTag(5502)
                if (mlblTimeName != nil ){
                    mlblTimeName?.removeFromSuperview()
                }
                var lblExitTime : UILabel = UILabel()
                lblExitTime.tag = 5502
                lblExitTime.font = UIFont.systemFontOfSize(15)
                lblExitTime.frame = CGRectMake(50, 33, 15, 22)
                lblExitTime.textAlignment = NSTextAlignment.Center
                lblExitTime.text = exitMoveTimeFunc
                var mlblExitTimeAfter = viewInfoFunc.viewWithTag(5503)
                if (mlblExitTimeAfter != nil ){
                    mlblExitTimeAfter?.removeFromSuperview()
                }
                var lblExitTimeAfter : UILabel = UILabel()
                lblExitTimeAfter.tag = 5503
                lblExitTimeAfter.font = UIFont.systemFontOfSize(11)
                lblExitTimeAfter.textColor = UIColor.lightGrayColor()
                lblExitTimeAfter.frame = CGRectMake(70, 33, 60, 22)
                lblExitTimeAfter.text = "CMN003_03".localizedString() + ",到达"
                viewInfoFunc.addSubview(lblExitTimeBefor)
                viewInfoFunc.addSubview(lblExitTime)
                viewInfoFunc.addSubview(lblExitTimeAfter)
        
            } else {
                var mlblGoStraight = viewInfoFunc.viewWithTag(7501)
                if (mlblGoStraight != nil ){
                    mlblGoStraight?.removeFromSuperview()
                }
                var lblGoStraight : UILabel = UILabel()
                lblGoStraight.font = UIFont.systemFontOfSize(11)
                lblGoStraight.textColor = UIColor.lightGrayColor()
                lblGoStraight.text = "直接到达"
                lblGoStraight.tag = 7501
                lblGoStraight.frame = CGRectMake(0, 33, 120, 22)
                viewInfoFunc.addSubview(lblGoStraight)

            }
                
            
            
        
        }
 
        var endStationLandMarkName: String? = exitInfoDicFunc["lmakName"] as String!
        if ((endStationLandMarkName != nil) && (endStationLandMarkName != "") ) {

            
            var mlblLandName = viewInfoFunc.viewWithTag(6502)
            if (mlblLandName != nil ){
                mlblLandName?.removeFromSuperview()
            }
            var lblLandName : UILabel = UILabel()
            lblLandName.tag = 6502
            lblLandName.font = UIFont.systemFontOfSize(15)
            lblLandName.frame = CGRectMake(130, 33, 150, 22)
            lblLandName.textAlignment = NSTextAlignment.Left
            lblLandName.text = endStationLandMarkName
            
            viewInfoFunc.addSubview(lblLandName)
        }
        
    }

    /**
     * checkLocation
     * @param latitude,longitude
     *  -> Bool
     */
    func checkLocation(latitude: Double?, longitude: Double?) -> Bool{
        return !(latitude == nil) && !(longitude == nil) && latitude > 0 && latitude < 90 && longitude > 0 && longitude < 180
    }
    

    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/
    
    // 起点终点设置相同，就设置当前为 选择车站
    func startStatIdEqualEndStatId () {
        if (self.focusNumber == "1" ){
            
            self.endStationText = self.startStationText
            self.startStationText = ""
            self.btnStatStartText.setTitle("", forState: UIControlState.Normal)
            self.btnStatEndText.setTitle(self.endStationText.station(), forState: UIControlState.Normal)
            
        } else {
            self.startStationText = self.endStationText
            self.endStationText = ""
            self.btnStatStartText.setTitle(self.endStationText.station(), forState: UIControlState.Normal)
            self.btnStatEndText.setTitle("", forState: UIControlState.Normal)
            
        }
    }
    
    /**
     * 位置定位完成
     */
    func locationUpdateError(){
    }
    
}


