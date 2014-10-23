//
//  Main.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class Main: UIViewController,UIScrollViewDelegate {
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    @IBOutlet weak var mMenuView: UIView!
    @IBOutlet weak var mBodyView: UIView!
    @IBOutlet weak var mBtnToSearchRoute: UIBarButtonItem!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mImgLineGraph: UIImageView!
    @IBOutlet weak var mStationInfoLayerView: UIView!
    @IBOutlet weak var mMainWrapper:UIView!
    @IBOutlet weak var mPopupStationView: UIView!
    @IBOutlet weak var mPopupStationNameJP: UILabel!
    @IBOutlet weak var mPopupStationName: UILabel!
    @IBOutlet weak var mPopupBtnStart: UIButton!
    @IBOutlet weak var mPopupBtnEnd: UIButton!
    @IBOutlet weak var mPopupBtnMore: UIButton!
    @IBOutlet weak var mPopupBtnShoping: UIButton!
    @IBOutlet weak var mPopupBtnFood: UIButton!
    @IBOutlet weak var mPopupBtnTravle: UIButton!
    @IBOutlet weak var mPopupViewSetImage: UIView!
    @IBOutlet weak var mBtnImgAdd: UIButton!
    @IBOutlet weak var mBtnImgDec: UIButton!
    @IBOutlet weak var mUpButton: UIButton!
    
    @IBOutlet weak var mMenuBtn04: UIButton!
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    // 记录设置的起点车站id
    var setStationStartId :String = ""
    // 记录设置的终点车站id
    var setStationEndId : String = ""
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    // 判断是否要显示底部menu
    var mIsMenuShow = false
    // 屏幕尺寸
    var mScreenSize: CGSize!
    // 设为起点的车站id
    var mCuttentStationID : String = ""
    // 记录点击点的坐标
    var locatPoint : CGPoint = CGPoint()
    // 从站点列表页面而来的车站id
    var stationIdFromStationList : String = ""
    // 显示弹框的车站的车站名 JP
    var selectStationNameJP : String = ""
    // 显示弹框的车站的车站id
    var selectStationID : String = ""
    // 显示弹框的车站的metroId
    var selectStationMetroID : String = ""
    // 显示弹框的车站的Kana
    var selectStationNameKana: String = ""
    
    // 收藏该条线路的group_id
    var selectStationGroupId = ""
    
    // 景点、购物、美食数组
    var landMarkArr: NSArray = NSArray.array()
    
    var stationGrideFromX:CGFloat = 0.0
    var stationGrideFromY:CGFloat = 0.0
    var stationGrideToX:CGFloat = 0.0
    var stationGrideToY:CGFloat = 0.0
    
    // 设置为起点的背景色
    var tagStartmViewShade  = 1
    // 设置为终点的背景色
    var tagEndmViewShade  = 1
    // 选中车站的背景色
    var tagmViewShade  = 1
    
    let IMAGEDOUBLEACTION: Selector = "doubleTapAction:"
    let IMAGESINGLEACTION: Selector = "singleTapAction:"
    let POPUPVIEWBTNACTION: Selector = "setStation:"
    
    var mViewStartShade : UIView = UIView()
    var mViewEndShade : UIView = UIView()
    var mViewShade : UIView = UIView()
    // 存放全局变量
    var appDelegate: AppDelegate!
    
    var cmn002Model:CMN002Model = CMN002Model();
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache")
        var fileExists = NSFileManager().fileExistsAtPath(path)
        
        if(!fileExists){
            var localCacheController = self.storyboard!.instantiateViewControllerWithIdentifier("localcache") as LocalCacheController
            localCacheController.classType = 0
            self.navigationController!.presentViewController(localCacheController, animated: true, completion: nil)
        }
        
        // ScreenSize
        self.mScreenSize = UIScreen.mainScreen().bounds.size
        
        // ScrollView
        self.mScrollView.minimumZoomScale = 0.5
        self.mScrollView.maximumZoomScale = 1.5
        self.mScrollView.zoomScale = self.mScrollView.minimumZoomScale
        self.mScrollView.contentSize = self.mMainWrapper.frame.size
        
        // 初始ScrollView位置
        var offertoPointInit : CGPoint = CGPoint()
        offertoPointInit.x = 150
        offertoPointInit.y = 10
        self.mScrollView.setContentOffset(offertoPointInit, animated: false)
        
        
        self.mStationInfoLayerView.hidden = false
        self.mStationInfoLayerView.alpha = 0.5
        self.mPopupStationView.backgroundColor = UIColor(patternImage: "main_pop".getImage())
        self.mPopupStationView.layer.cornerRadius = 4
        self.mPopupStationView.hidden = true
        self.mPopupStationView.alpha = 0.9
        //
        mPopupBtnStart.addTarget(self, action: POPUPVIEWBTNACTION, forControlEvents: UIControlEvents.TouchUpInside)
        mPopupBtnEnd.addTarget(self, action: POPUPVIEWBTNACTION, forControlEvents: UIControlEvents.TouchUpInside)
        mPopupBtnMore.addTarget(self, action: POPUPVIEWBTNACTION, forControlEvents: UIControlEvents.TouchUpInside)
        
        // 设置双击放大事件
        var myTapGesture :UITapGestureRecognizer = UITapGestureRecognizer()
        myTapGesture.addTarget(self, action: IMAGEDOUBLEACTION)
        self.mMainWrapper.userInteractionEnabled = true
        myTapGesture.numberOfTapsRequired = 2
        myTapGesture.numberOfTouchesRequired = 1
        mMainWrapper.addGestureRecognizer(myTapGesture)
        
        // 设置单击读取改点信息事件
        var mySingleTapGesture :UITapGestureRecognizer = UITapGestureRecognizer()
        mySingleTapGesture.addTarget(self, action: IMAGESINGLEACTION)
        self.mMainWrapper.userInteractionEnabled = true
        mySingleTapGesture.numberOfTapsRequired = 1
        mySingleTapGesture.numberOfTouchesRequired = 1
        mMainWrapper.addGestureRecognizer(mySingleTapGesture)
        
        // 禁止button同时点击
        mBtnImgAdd.enabled = true
        mBtnImgDec.enabled = true
        mBtnImgAdd.exclusiveTouch = true
        mBtnImgDec.exclusiveTouch = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mImgLineGraph.image = "MetroCH".image("LineGraph")
        
        self.mPopupStationView.hidden = true
        mIsMenuShow = false
        

        self.mUpButton.hidden = false
        mMenuView.frame = CGRectMake(0, mScreenSize.height - 75, mScreenSize.width, 75)
        
        mBodyView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        mBodyView.hidden = true
        
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        readStationIdCache()
        
        // 接受从站点列表中传递过来的站点ID
        if (stationIdFromStationList != ""){
            showPopViewByStationId(stationIdFromStationList)
        }
        // showPopViewByStationId("2801004")
        
        if (appDelegate.isShow == true) {
            mMenuBtn04.setBackgroundImage(UIImage(named: "menu_04_blue"), forState: UIControlState.Normal)
        } else {
            mMenuBtn04.setBackgroundImage(UIImage(named: "menu_04"), forState: UIControlState.Normal)
        }
    }
    
    /*******************************************************************************
    *    Implements Of UIScrollViewDelegate
    *******************************************************************************/
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return mMainWrapper
    }
    
    // scroll移动是也不断设置弹窗位置
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if mPopupStationView.hidden == false
        {
            getPopStationViewLocate(scrollView)
        }
    }
    
    // scroll放大和缩小后是也不断设置弹窗位置
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if mPopupStationView.hidden == false
        {
            getPopStationViewLocate(scrollView)
        }
    }
    
    func rectAfterZoomed() -> CGRect{
        var ptX:CGFloat=(locatPoint.x * mScrollView.zoomScale - mScrollView.contentOffset.x ) - mPopupStationView.frame.size.width / 2
        var ptY:CGFloat=(locatPoint.y * mScrollView.zoomScale - mScrollView.contentOffset.y) - mPopupStationView.frame.size.height / 2
        var height:CGFloat=mPopupStationView.frame.size.height
        var width:CGFloat=mPopupStationView.frame.size.width
        return CGRectMake(ptX,ptY,width,height)
    }
    
    // 获取弹窗消息的位置
    func getPopStationViewLocate(scrollView: UIScrollView) {
        
        var mpopViewSizeWidth:CGFloat = mPopupStationView.frame.size.width
        var mpopViewSizeHeigh:CGFloat = mPopupStationView.frame.size.height
        
        mPopupStationView.frame = CGRectMake((locatPoint.x * scrollView.zoomScale - scrollView.contentOffset.x ) - mpopViewSizeWidth / 2, (locatPoint.y * scrollView.zoomScale - scrollView.contentOffset.y) - mpopViewSizeHeigh, mpopViewSizeWidth, mpopViewSizeHeigh)
    }
    
    /*******************************************************************************
    *      IBActions
    *******************************************************************************/
    
    // 控制图片放大和缩小
    @IBAction func ControllImage(sender:UIButton) {
        var btnOffsetX:CGFloat = (mScrollView.bounds.size.width >
            mScrollView.contentSize.width) ? (mScrollView.bounds.size.width - mScrollView.contentSize.width)/2 : 0.0
        var btnOffsetY:CGFloat = (mScrollView.bounds.size.height >
            mScrollView.contentSize.height) ? (mScrollView.bounds.size.height - mScrollView.contentSize.height)/2 : 0.0
        
        self.mMainWrapper.center = CGPointMake(mScrollView.contentSize.width * 0.5 + btnOffsetX , mScrollView.contentSize.height * 0.5 + btnOffsetY)
        
        switch (sender) {
        case self.mBtnImgAdd:
            if (self.mScrollView.zoomScale < 1.5) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mScrollView.zoomScale = (self.mScrollView.zoomScale + 0.3)
                })
                self.mBtnImgAdd.enabled = true
            } else {
                self.mBtnImgAdd.enabled = false
            }
            self.mBtnImgDec.enabled = true
        case self.mBtnImgDec:
            
            if (self.mScrollView.zoomScale > 0.5) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mScrollView.zoomScale = (self.mScrollView.zoomScale - 0.3)
                })
                self.mBtnImgDec.enabled = true
            } else {
                self.mBtnImgDec.enabled = false
            }
            self.mBtnImgAdd.enabled = true
        default:
            self.mScrollView.zoomScale = self.mScrollView.zoomScale
            
        }
        
    }
    
    // 双击之后真个scrollView放大
    func doubleTapAction(myTapGesture :UITapGestureRecognizer) {
        var doubleOffsetX:CGFloat = (mScrollView.bounds.size.width >
            mScrollView.contentSize.width) ? (mScrollView.bounds.size.width - mScrollView.contentSize.width)/2 : 0.0
        var doubleOffsetY:CGFloat = (mScrollView.bounds.size.height >
            mScrollView.contentSize.height) ? (mScrollView.bounds.size.height - mScrollView.contentSize.height)/2 : 0.0
        
        self.mMainWrapper.center = CGPointMake(mScrollView.contentSize.width * 0.5 + doubleOffsetX , mScrollView.contentSize.height * 0.5 + doubleOffsetY)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mScrollView.zoomScale = (self.mScrollView.zoomScale + 0.5)
        })
    }
    
    /**
    *   展示和收起底部menu菜单
    */
    @IBAction func showMenu(sender: UIButton) {
        var image: UIImage!
        if (sender.tag == 601) {
            mIsMenuShow = false
            self.mUpButton.hidden = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.mMenuView.frame = CGRectMake(0, self.mScreenSize.height - 75, self.mScreenSize.width, 75)
                
            })
            
//            self.mUpButton.setBackgroundImage(image, forState: UIControlState.Normal)
//            self.mUpButton.setBackgroundImage(image, forState: UIControlState.Highlighted)
            // 隐藏遮罩
            mBodyView.hidden = true
        } else {
            mIsMenuShow = true
            image = UIImage(named: "helf_down_btn")

            self.mUpButton.hidden = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.mMenuView.frame = CGRectMake(0, self.mScreenSize.height - 250, self.mScreenSize.width, 250)
            })
            
//            self.mUpButton.setBackgroundImage(image, forState: UIControlState.Normal)
//            self.mUpButton.setBackgroundImage(image, forState: UIControlState.Highlighted)
            // 显示遮罩
            mBodyView.hidden = false
        }
    }
    
    @IBAction func showStationLine(sender: UIButton) {
        var stationLine: StationLine = self.storyboard?.instantiateViewControllerWithIdentifier("StationLine") as StationLine
        
        if (sender.tag == 502) {
            stationLine.segmentIndex = 0
        } else if (sender.tag == 503) {
            stationLine.segmentIndex = 1
        }
                
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(stationLine, animated: true)
    }
    
    @IBAction func showStationTips() {
        var tipsList: TipsContentList = self.storyboard?.instantiateViewControllerWithIdentifier("TipsContentList") as TipsContentList
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(tipsList, animated: true)
    }
    

    
    @IBAction func showLandMark() {
        var landMarkListController: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        landMarkListController.landMarkType = 0
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(landMarkListController, animated: true)
    }
    
    @IBAction func showFood() {
        var landMarkListController: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        landMarkListController.landMarkType = 1
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(landMarkListController, animated: true)
    }
    
    @IBAction func showShopping() {
        var landMarkListController: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        landMarkListController.landMarkType = 2
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(landMarkListController, animated: true)
    }
    
    
    @IBAction func showStationHelpContent() {
        var helpContentList: HelpContentList = self.storyboard?.instantiateViewControllerWithIdentifier("HelpContentList") as HelpContentList
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(helpContentList, animated: true)
    }
    
    
    @IBAction func rightTopButtonClick() {
        var addSubway: AddSubway = self.storyboard?.instantiateViewControllerWithIdentifier("AddSubway") as AddSubway
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(addSubway, animated: true)
    }
    
    @IBAction func showSetting() {
        var setting: Setting = self.storyboard?.instantiateViewControllerWithIdentifier("Setting") as Setting
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(setting, animated: true)
    }
    
    @IBAction func showSelectRaiders() {
        var selectRaiders: SelectRaiders = self.storyboard?.instantiateViewControllerWithIdentifier("SelectRaiders") as SelectRaiders
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(selectRaiders, animated: true)
    }
    
    @IBAction func showStationListController() {
        var stationListController: StationListController = self.storyboard?.instantiateViewControllerWithIdentifier("StationListController") as StationListController
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(stationListController, animated: true)
    }
    
    @IBAction func showRemindListController() {
        var remindListController: RemindListController = self.storyboard?.instantiateViewControllerWithIdentifier("RemindListController") as RemindListController
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(remindListController, animated: true)
    }
    
    @IBAction func showHelpIcon() {
        var helpIcon: HelpIcon = self.storyboard?.instantiateViewControllerWithIdentifier("HelpIcon") as HelpIcon
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(helpIcon, animated: true)
    }
    
    // 携带起点和终点车站id 跳转到路线搜索结果页面
    @IBAction func popToRouteSearchResult() {
        
        var routeSearch : RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
        
        routeSearch.startStationText = self.setStationStartId
        routeSearch.endStationText = self.setStationEndId
        
        setSationIdCache()
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(routeSearch, animated:true)
    }
    
    // 跳转到相应地表
    @IBAction func showLnadMarkList(sender : UIButton) {
        var landMark: LandMarkListController = self.storyboard?.instantiateViewControllerWithIdentifier("landmarklist") as LandMarkListController
        
        var landTypeTemp : Int = 0
        if (sender == mPopupBtnTravle) {
            odbLandMark("PUBLIC_12".localizedString())
            landTypeTemp = 0
            landMark.title = "INF002_11".localizedString()
        } else if (sender == mPopupBtnFood) {
            odbLandMark("PUBLIC_13".localizedString())
            landTypeTemp = 1
            landMark.title = "INF002_09".localizedString()
        } else {
            odbLandMark("PUBLIC_09".localizedString())
            landTypeTemp = 2
            landMark.title = "PUBLIC_09".localizedString()
        }
        
        if(landMarkArr.count != 0){
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            landMark.landMarks = landMarkArr as? Array<MstT04LandMarkTable>
            landMark.landMarkStatId = self.selectStationGroupId
            landMark.landMarkType = landTypeTemp
            self.navigationController?.pushViewController(landMark, animated: true)
        }
        
    }
    
    // 点击弹框中的设置起点和终点， 记录当前的数据， 完成后跳转页面
    func setStation(sender:UIButton) {
        switch sender {
        case mPopupBtnStart:
            self.setStationStartId = self.mCuttentStationID
            
            self.mPopupStationView.hidden = true
            addUStartITag()
            
            // 判断终点是否设置，设置了的话，就直接跳查找结果页面
            if (setStationEndId != "") {
                popToRouteSearchResult()
            }
            
            
        case mPopupBtnEnd:
            self.setStationEndId = self.mCuttentStationID
            self.mPopupStationView.hidden = true
            addUEndITag()
            
            // 判断起点是否设置，设置了的话，就直接跳查找结果页面
            if (setStationStartId != "") {
                popToRouteSearchResult()
            }
        case mPopupBtnMore:
            // 跳转到此站详细页面
            mPopupStationView.hidden = true
            var stationDetail : StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            stationDetail.stat_id = self.mCuttentStationID
            stationDetail.statMetroId = self.selectStationMetroID
            stationDetail.cellJPName = self.selectStationNameJP
            stationDetail.cellJPNameKana = self.selectStationNameKana
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController?.pushViewController(stationDetail, animated:true)
            
        default:
            mPopupStationView.hidden = false
        }
    }




    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    // 根据点击的像素点从db中获取车站id
    func singleTapAction(sender:UITapGestureRecognizer) {
        
        var touchedPoint:CGPoint = sender.locationInView(self.mMainWrapper)
        
        // 获取点击点的像素坐标
        var touchX :CGFloat = touchedPoint.x
        var touchY :CGFloat = touchedPoint.y
        
        var stationData:CMN002StationData! = cmn002Model.findTouchedStation(touchX, touchY: touchY)
        //画面显示
        
        if (stationData != nil) {
            
            setPageData(stationData)
            popStaionViewLinesImg(stationData)
            setPopViewInLineGraph(touchX , PointY : touchY)
        } else {
            mPopupStationView.hidden = true
        }
    }
    
    // 传递站点过来 显示站点位置和弹窗信息
    func showPopViewByStationId(stationID : String) {
        
        var stationDataById:CMN002StationData! = cmn002Model.findTouchedStationStatId(stationID)
        if (stationDataById != nil){
            
            setPageData(stationDataById)
            popStaionViewLinesImg(stationDataById)
            // setPopViewInLineGraph((stationDataById.statFromX ) / 2 , PointY : ((stationDataById.statFromY) / 2 - (stationDataById.statToY - stationDataById.statFromY) / 4))
            
            
            
            
            // 将scroll大小固定，设置弹出气泡信息
            self.mScrollView.zoomScale = 1
            var offertoPoint : CGPoint = CGPoint()
            offertoPoint.x = ((stationDataById.statFromX + stationDataById.statToX) / 4) - (mScreenSize.width / 2 )
            
            offertoPoint.y = ((stationDataById.statToY + stationDataById.statFromY) / 4) - (mScreenSize.height / 2 )
            self.mScrollView.setContentOffset(offertoPoint, animated: true)
            
            var ptX1:CGFloat=(locatPoint.x * mScrollView.zoomScale - mScrollView.contentOffset.x ) - mPopupStationView.frame.size.width / 2
            var ptY1:CGFloat=(locatPoint.y * mScrollView.zoomScale - mScrollView.contentOffset.y) - mPopupStationView.frame.size.height
            
            println("\(locatPoint.x),\(locatPoint.y )     ?         \(mScrollView.zoomScale),   \(mScrollView.contentOffset.y)")
            
            var height1:CGFloat=mPopupStationView.frame.size.height
            var width1:CGFloat=mPopupStationView.frame.size.width
            mPopupStationView.frame = CGRectMake(ptX1, ptY1, width1, height1)
            mPopupStationView.hidden = false
            
            addUITag()
        }
    }
    
    // 设定全局变量
    func setPageData(stationData: CMN002StationData) {
        
        self.mPopupStationName.text = stationData.statNameExt1 as String
        self.mPopupStationNameJP.text = stationData.statName as String + "(" +  stationData.statNameKana as String + ")"
        
        self.mCuttentStationID = stationData.statId as String
        self.selectStationNameJP  = stationData.statName as String
        self.selectStationMetroID = stationData.statNameMetroId as String
        self.selectStationNameKana = stationData.statNameKana as String
        self.stationGrideFromX = stationData.statFromX / 2
        self.stationGrideFromY = stationData.statFromY / 2
        self.stationGrideToX = stationData.statToX / 2
        self.stationGrideToY = stationData.statToY / 2
        self.selectStationGroupId = stationData.statGroupId as String
        
        locatPoint.x = (stationGrideFromX  + stationGrideToX ) / 2
        locatPoint.y = stationGrideFromY
        
    }
    
    func setPopViewInLineGraph(PointX : CGFloat, PointY : CGFloat) {

        // 将scroll大小固定，设置弹出气泡信息
        self.mScrollView.zoomScale = 1
        var offertoPoint : CGPoint = CGPoint()
        offertoPoint.x = PointX - (mScreenSize.width / 2)
        
        offertoPoint.y = -64 + PointY - (mScreenSize.height / 2)
        self.mScrollView.setContentOffset(offertoPoint, animated: true)
        
        var ptX1:CGFloat=(locatPoint.x * mScrollView.zoomScale - mScrollView.contentOffset.x ) - mPopupStationView.frame.size.width / 2
        var ptY1:CGFloat=(locatPoint.y * mScrollView.zoomScale - mScrollView.contentOffset.y) - mPopupStationView.frame.size.height / 2
        
        
        
        println("\(locatPoint.y)     ?      \(mScrollView.zoomScale)  ?  \(mScrollView.contentOffset.y)")
        
        var height1:CGFloat=mPopupStationView.frame.size.height
        var width1:CGFloat=mPopupStationView.frame.size.width
        mPopupStationView.frame = CGRectMake(ptX1, ptY1, width1, height1)
        mPopupStationView.hidden = false
        
        addUITag()
    }
    

    
    // 显示弹框上站点的所有线路图标
    func popStaionViewLinesImg(stationData:CMN002StationData) {
        
        // 显示弹框上站点的所有线路图标
        var mFindeStationLines:NSMutableArray = cmn002Model.findStationLines(stationData)
        var view = mPopupViewSetImage.viewWithTag(202) as UIView!
        if (view != nil) {
            view.removeFromSuperview()
        }
        var mPopupLineView = UIView()
        mPopupLineView.frame = CGRectMake(0, 0, 160, 25)
        mPopupLineView.tag = 202
        
        for (var i = 0; i < mFindeStationLines.count; i++) {
            var mlinesLineImg: UIImageView = UIImageView()
            mlinesLineImg.frame = CGRectMake(CGFloat(190 - i * 20), 0, 25, 25)
            mlinesLineImg.image = (mFindeStationLines[i] as String).getLineImage()
            mPopupLineView.addSubview(mlinesLineImg)
        }
        mPopupViewSetImage.addSubview(mPopupLineView)

        // 添加相应的地表个数
         odbLandMark("PUBLIC_09".localizedString())
         if (landMarkArr.count > 0 ){
            mViewShowLandMark(landMarkArr.count, viewTag : 2004)
         } else {
            mViewShowLandMark(0, viewTag : 2004)
        }
        
         odbLandMark("PUBLIC_12".localizedString())
         if (landMarkArr.count > 0 ){
            mViewShowLandMark(landMarkArr.count, viewTag : 2002)
         } else {
            mViewShowLandMark(0, viewTag : 2002)
         }
         odbLandMark("PUBLIC_13".localizedString())
         if (landMarkArr.count > 0 ){
            mViewShowLandMark(landMarkArr.count, viewTag : 2003)
         } else {
            mViewShowLandMark(0, viewTag : 2003)
         }

    }

    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUStartITag() {
        
        if self.tagStartmViewShade == 2 {
            mViewShade.removeFromSuperview()
        }
        mViewStartShade.layer.borderColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5).CGColor
        mViewStartShade.layer.borderWidth = 1
        mViewStartShade.layer.cornerRadius = 4
        mViewStartShade.backgroundColor =  UIColor(red: 0, green: 255, blue: 0, alpha: 0.5)
        mViewStartShade.alpha = 0.5
        
        mViewStartShade.frame = CGRectMake(stationGrideFromX - 5, stationGrideFromY - 5, stationGrideToX -  stationGrideFromX + 10, stationGrideToY -  stationGrideFromY + 10)
        self.mImgLineGraph.addSubview(mViewStartShade)
        self.tagStartmViewShade = 2
        
    }
    
    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUEndITag() {
        
        if self.tagEndmViewShade == 2 {
            mViewShade.removeFromSuperview()
        }
        mViewEndShade.layer.borderColor = UIColor(red: 0, green: 51, blue: 255, alpha: 0.5).CGColor
        mViewEndShade.layer.borderWidth = 1
        mViewEndShade.layer.cornerRadius = 4
        mViewEndShade.backgroundColor =  UIColor(red: 0, green: 204, blue: 155, alpha: 0.5)
        mViewEndShade.alpha = 0.5
        
        mViewEndShade.frame = CGRectMake(stationGrideFromX - 5, stationGrideFromY - 5, stationGrideToX -  stationGrideFromX + 10, stationGrideToY -  stationGrideFromY + 10)
        self.mImgLineGraph.addSubview(mViewEndShade)
        self.tagEndmViewShade = 2
    }
    
    
    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUITag() {
        
        if self.tagmViewShade == 2 {
            mViewShade.removeFromSuperview()
        }
        mViewShade.layer.borderColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5).CGColor
        mViewShade.layer.borderWidth = 1
        mViewShade.layer.cornerRadius = 4
        mViewShade.backgroundColor =  UIColor(red: 255, green: 155, blue: 0, alpha: 0.5)
        mViewShade.alpha = 0.5
        
        mViewShade.frame = CGRectMake(stationGrideFromX - 5, stationGrideFromY - 5, stationGrideToX -  stationGrideFromX + 10, stationGrideToY -  stationGrideFromY + 10)
        
        self.mImgLineGraph.addSubview(mViewShade)
        self.tagmViewShade = 2
    }
    
    // 查询站点的地标信息
    func odbLandMark(type: String) {

        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
         landMarkArr = mstT04Table.queryLandMarkByStatId(self.selectStationGroupId, lmakType: type)
        
    }

    // 添加某站点附近地表个数的小lable
    func mViewShowLandMark(landMarkCount : Int, viewTag : Int) {
        if (landMarkCount == 0){
            var mlbl = mPopupStationView.viewWithTag(viewTag) as UILabel!
            if (mlbl != nil) {
                mlbl.removeFromSuperview()
            }
        } else {
            
            var mlbl = mPopupStationView.viewWithTag(viewTag) as UILabel!
            if (mlbl != nil) {
                mlbl.removeFromSuperview()
            }
            
            var mlblShowCount : UILabel = UILabel()
            mlblShowCount.tag = viewTag
            mlblShowCount.text = String(landMarkCount)
            mlblShowCount.font = UIFont.systemFontOfSize(12)
            mlblShowCount.textColor = UIColor.whiteColor()
            mlblShowCount.textAlignment = NSTextAlignment.Center
            mlblShowCount.backgroundColor = UIColor(patternImage: "mpop_point".getImage())
            if (viewTag == 2002) {
                mlblShowCount.frame = CGRectMake(71,156,11,11)
            } else if (viewTag == 2003) {
                mlblShowCount.frame = CGRectMake(141,156,11,11)
            } else if (viewTag == 2004) {
                mlblShowCount.frame = CGRectMake(211,156,11,11)
            }
            
            self.mPopupStationView.addSubview(mlblShowCount)

        }

    }
    
    // 放置本地数据 记录起点和终点的ID
    func setSationIdCache() {
        self.appDelegate.startStatId = self.setStationStartId
        self.appDelegate.endStatId = self.self.setStationEndId
    }
    
    // 读取本地数据 记录起点和终点的ID
    func readStationIdCache() {
        self.setStationStartId = self.appDelegate.startStatId
        self.setStationEndId = self.appDelegate.endStatId
    }
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
