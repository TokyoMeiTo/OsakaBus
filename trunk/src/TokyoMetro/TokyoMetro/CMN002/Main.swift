//
//  Main.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class Main: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var popStation: UIView!
   // @IBOutlet weak var lineImage: UITouchableView!
    @IBOutlet weak var lineImage: UITouchableView!
    // 判断是否要显示底部menu
    var isMenuShow = false
    // 屏幕尺寸
    var size: CGSize!
    // 设为起点的车站id
    var setCuttentStationID : String = ""
    
    @IBOutlet weak var poplblSationNameJP: UILabel!
    @IBOutlet weak var popbtnStart: UIButton!
    @IBOutlet weak var popbtnMore: UIButton!
    @IBOutlet weak var popbtnEnd: UIButton!
    @IBOutlet weak var poplblStationName: UILabel!
    // 记录点击点的坐标
    var locatPoint : CGPoint = CGPoint()
    // 记录设置的起点车站id
    var setStationStartId :String = ""
    // 记录设置的终点车站id
    var setStationEndId : String = ""
    
    var stationGrideFromX:CGFloat = 0.0
    var stationGrideFromY:CGFloat = 0.0
    var stationGrideToX:CGFloat = 0.0
    var stationGrideToY:CGFloat = 0.0
    
    var tagStartUIShade  = 1
    var tagEndUIShade  = 1
    var tagUIShade  = 1
    
    var uiStartShade : UIView = UIView()
    var uiEndShade : UIView = UIView()
    var uiShade : UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = UIScreen.mainScreen().bounds.size

        
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 10
        scroll.zoomScale = 1.5
        
        self.popStation.hidden = true
        self.popStation.layer.borderWidth = 1
        self.popStation.layer.cornerRadius = 4
        self.popStation.alpha = 0.8
        
        popbtnStart.addTarget(self, action: "setStation:", forControlEvents: UIControlEvents.TouchUpInside)
        popbtnEnd.addTarget(self, action: "setStation:", forControlEvents: UIControlEvents.TouchUpInside)
        popbtnMore.addTarget(self, action: "setStation:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 设置双击放大事件
        var myTapGesture :UITapGestureRecognizer = UITapGestureRecognizer()
        myTapGesture.addTarget(self, action: "doubleTapAction:")
        self.lineImage.userInteractionEnabled = true
        myTapGesture.numberOfTapsRequired = 2
        myTapGesture.numberOfTouchesRequired = 1
        lineImage.addGestureRecognizer(myTapGesture)
        
        // 设置单击读取改点信息事件
        var mySingleTapGesture :UITapGestureRecognizer = UITapGestureRecognizer()
        mySingleTapGesture.addTarget(self, action: "singleTapAction")
        self.lineImage.userInteractionEnabled = true
        mySingleTapGesture.numberOfTapsRequired = 1
        mySingleTapGesture.numberOfTouchesRequired = 1
        lineImage.addGestureRecognizer(mySingleTapGesture)
        
     
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isMenuShow = false
        
        menuView.frame = CGRectMake(0, size.height - 65, size.width, 65)
        bodyView.hidden = true
        bodyView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return lineImage
    }
    // 双击之后真个scrollView放大
    func doubleTapAction(myTapGesture :UITapGestureRecognizer) {
        var offsetX:CGFloat = (scroll.bounds.size.width >
            scroll.contentSize.width) ? (scroll.bounds.size.width - scroll.contentSize.width)/2 : 0.0
        var offsetY:CGFloat = (scroll.bounds.size.height >
            scroll.contentSize.height) ? (scroll.bounds.size.height - scroll.contentSize.height)/2 : 0.0
        self.lineImage.center = CGPointMake(scroll.contentSize.width * 0.5 + offsetX , scroll.contentSize.height * 0.5 + offsetY)

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scroll.zoomScale = (self.scroll.zoomScale + 1)
        })

    }

    
    
    /** 
     *   展示和收起底部menu菜单
     */
    @IBAction func showMenu() {
        
        if (isMenuShow) {
            isMenuShow = false
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.menuView.frame = CGRectMake(0, self.size.height - 65, self.size.width, 65)
                
            })
            
            // 隐藏遮罩
            bodyView.hidden = true
            
        
        } else {
        
            isMenuShow = true
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.menuView.frame = CGRectMake(0, self.size.height - 240, self.size.width, 240)
            })

            // 显示遮罩
            bodyView.hidden = false
            
        }
        
    }
    // 根据点击的像素点从db中获取车站id
    func singleTapAction() {
        
        
        // 获取点击点的像素坐标
        var touchX :CGFloat = self.lineImage.touchedPoint.x
        var touchY :CGFloat = self.lineImage.touchedPoint.y
        

        locatPoint.x = touchX
        locatPoint.y = touchY
        
        println("触碰点坐标")
        println("\(touchX)   \(touchY)")
        
        
        // 根据获取点击点的像素坐标  进行数据库搜索，判断坐标是否是车站坐标
        
        var sqlStr = "select * from CMNT03_STATION_GRID where PONT_X_FROM < " + (touchX * 2).description + " and PONT_X_TO > " + (touchX * 2).description + " and PONT_Y_FROM < " + (touchY * 2).description + " and PONT_Y_TO > " + (touchY * 2).description + "" as String
        var cmnt03table = CmnT03StationGridTable()
        var cmnt03row = cmnt03table.excuteQuery(sqlStr)
        
        if cmnt03row != nil {
            for value in cmnt03row{
                value as CmnT03StationGridTable
                var stationId:AnyObject = value.item(CMNT03_STAT_ID)
                println("车站信息")
                println("\(stationId)")
                
                stationGrideFromX = value.item(CMNT03_PONT_X_FROM) as CGFloat / 2
                println("车站信息")
                println("\(stationGrideFromX)")
                stationGrideFromY = value.item(CMNT03_PONT_Y_FROM) as CGFloat / 2
                println("车站信息")
                println("\(stationGrideFromY)")
                stationGrideToX = value.item(CMNT03_PONT_X_TO) as CGFloat / 2
                println("车站信息")
                println("\(stationGrideToX)")
                stationGrideToY = value.item(CMNT03_PONT_Y_TO) as CGFloat / 2
                println("车站信息")
                println("\(stationGrideToY)")

                
                // 设置成全局变量
                self.setCuttentStationID = stationId.description
                if stationId.description != nil {
                    
                    // 车站名
                    var mst02StationName : String = ""
                    // GroupID
                    var mst02GroupId : String = ""
                    // 车站名 JP
                     var mst02StationNameJP : String = ""
                    
                    var mst02 = MstT02StationTable()
                    
                    // 根据搜索到的车站id，去数据库搜索车站名
                    mst02.statId = stationId.description
                    var mst02Row = mst02.selectAll()
                    
                    for mst02Value in mst02Row {
                        mst02Value as MstT02StationTable
                        var mst02ResultStationName:AnyObject = mst02Value.item(MSTT02_STAT_NAME)
                        println("车站名")
                        println("\(mst02ResultStationName)")
                        
                        var mst02ResultGroupId:AnyObject = mst02Value.item(MSTT02_STAT_GROUP_ID)
                        println("groupID")
                        println("\(mst02ResultGroupId)")
                        
                        var mst02ResultJapName:AnyObject = mst02Value.item(MSTT02_STAT_NAME_EXT1)
                        println("groupID")
                        println("\(mst02ResultJapName)")
                        mst02StationNameJP = mst02ResultJapName.description
                        mst02StationName = mst02ResultStationName.description
                        mst02GroupId = mst02ResultGroupId.description
                    }    
                    
                    var mst02RowGroupId : NSArray = mst02.excuteQuery("select LINE_ID from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(mst02GroupId)")
                    
                    var lineGroup : NSMutableArray = NSMutableArray.array()
                    for mst02GroupIdValue in mst02RowGroupId {
                        mst02GroupIdValue  as MstT02StationTable
                        var mst02ResultLineId:AnyObject = mst02GroupIdValue.item(MSTT02_LINE_ID)
                        lineGroup.addObject(mst02ResultLineId)
                    }
                    println("lineCount")
                    println("\(lineGroup.count)")
                    for (var i = 0; i < lineGroup.count; i++) {
                        
                        var lineGrouplineImg: UIImageView = UIImageView()
                        lineGrouplineImg.frame = CGRectMake(CGFloat(160 - i * 20), 55, 25, 25)
                        lineGrouplineImg.image = lineImageNormal(lineGroup[i] as String)
                        
                        self.popStation.addSubview(lineGrouplineImg)
                    }

                    // 将scroll大小固定，设置弹出气泡信息
                    self.scroll.zoomScale = 1
                    var offertoPoint : CGPoint = CGPoint()
                    offertoPoint.x = touchX - 160
                    offertoPoint.y = -64 + touchY - 266.5
                    self.scroll.setContentOffset(offertoPoint, animated: true)
                    
                    self.poplblStationName.text = mst02StationName
                    self.poplblSationNameJP.text = mst02StationNameJP
                    self.popStation.hidden = false
                    self.popStation.frame = CGRectMake(locatPoint.x - 100, locatPoint.y - 200, 200, 160)
                    
                    self.lineImage.addSubview(popStation)
                    
                    
                    addUITag()
                    
                }
            }
        }
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
    
    // 点击弹框中的设置起点和终点， 记录当前的数据， 完成后跳转页面
    func setStation(sender:UIButton) {
        switch sender {
        case popbtnStart:
            self.setStationStartId = self.setCuttentStationID
            println("setStartStationID      2222222222222222")
            println("\(setStationStartId)")
            
            
            addUStartITag()
            
            // 判断终点是否设置，设置了的话，就直接跳查找结果页面
            if (setStationEndId != "") {
                popToRouteSearchResult(setStationStartId, statEndID : setStationEndId)
            }

            
        case popbtnEnd:
            self.setStationEndId = self.setCuttentStationID
            
            println("setStationEndId        ================")
            println("\(setStationEndId)")
            addUEndITag()
            // 判断起点是否设置，设置了的话，就直接跳查找结果页面
            if (setStationStartId != "") {
                popToRouteSearchResult(setStationStartId, statEndID : setStationEndId)
            }
        case popbtnMore:
            // 跳转到此站详细页面
            popStation.hidden = true
        default:
            popStation.hidden = false
        }
    }
    
    
    // 携带起点和终点车站id 跳转到路线搜索结果页面
    func popToRouteSearchResult(statStartID : String, statEndID : String) {
        
        var routeSearchResult : RouteSearchResult = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearchResult") as RouteSearchResult

        routeSearchResult.routeStart = statStartID
        routeSearchResult.routeEnd = statEndID
        self.navigationController?.pushViewController(routeSearchResult, animated:true)
    }
    
    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUStartITag() {


        if self.tagStartUIShade == 2 {
            uiShade.removeFromSuperview()
        }
        uiStartShade.layer.borderColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5).CGColor
        uiStartShade.layer.borderWidth = 1
        uiStartShade.layer.cornerRadius = 4
        uiStartShade.backgroundColor =  UIColor(red: 0, green: 255, blue: 0, alpha: 0.5)
        uiStartShade.alpha = 0.5
        
        uiStartShade.frame = CGRectMake(stationGrideFromX + 5, stationGrideFromY + 5, stationGrideToX -  stationGrideFromX - 10, stationGrideToY -  stationGrideFromY - 10)
        
        self.lineImage.addSubview(uiStartShade)
        
        self.tagStartUIShade = 2
        
    }
    
    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUEndITag() {
        
        
        if self.tagEndUIShade == 2 {
            uiShade.removeFromSuperview()
        }
        uiEndShade.layer.borderColor = UIColor(red: 0, green: 51, blue: 255, alpha: 0.5).CGColor
        uiEndShade.layer.borderWidth = 1
        uiEndShade.layer.cornerRadius = 4
        uiEndShade.backgroundColor =  UIColor(red: 0, green: 204, blue: 155, alpha: 0.5)
        uiEndShade.alpha = 0.5
        
        uiEndShade.frame = CGRectMake(stationGrideFromX + 5, stationGrideFromY + 5, stationGrideToX -  stationGrideFromX - 10, stationGrideToY -  stationGrideFromY - 10)
        
        self.lineImage.addSubview(uiEndShade)
        
        self.tagEndUIShade = 2
        
    }
    
    
    // 根据选中的车站的左上角坐标 ，在选中的地方添加半透明遮罩
    func addUITag() {
        
        
        if self.tagUIShade == 2 {
            uiShade.removeFromSuperview()
        }
        uiShade.layer.borderColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5).CGColor
        uiShade.layer.borderWidth = 1
        uiShade.layer.cornerRadius = 4
        uiShade.backgroundColor =  UIColor(red: 255, green: 155, blue: 0, alpha: 0.5)
        uiShade.alpha = 0.5
        
        uiShade.frame = CGRectMake(stationGrideFromX + 5, stationGrideFromY + 5, stationGrideToX -  stationGrideFromX - 10, stationGrideToY -  stationGrideFromY - 10)
        
        self.lineImage.addSubview(uiShade)
        
        self.tagUIShade = 2
        
    }

    
    
    
}
