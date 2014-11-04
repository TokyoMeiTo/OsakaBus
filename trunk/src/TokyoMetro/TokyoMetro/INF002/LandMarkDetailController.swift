//
//  LandMarkDetailController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LandMarkDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/

    /* 页面跳转UIButton */
    @IBOutlet weak var btnMap: UIButton!
    /* 收藏UIButton */
    @IBOutlet weak var btnFav: UIButton!
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
    let SMALL_TEXT_SIZE:CGFloat = 15
    let LABEL_TEXT_SIZE:CGFloat = 20
    /* Resource下的图片路径 */
    let FOLDER_NAME:String = "Landmark"
    
    let BTN_ROUTE_TAG:Int = 120
    
    let HEAD_SPACE:String = "    "
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* 地标显示内容的数量 */
    var itemCount:Int = 9
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    
    /* UIContentContainer */
    var imgContainer:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, 1600, 200))
    var viewContainer:UIView = UIView(frame: CGRectMake(0, 0, 1600, 200))
    
    var stations:Array<MstT02StationTable>?
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btnFav.hidden = true
        btnMap.hidden = true
        
        intitValue()
        
        imgContainer.pagingEnabled = true
        
        imgContainer.delegate = self
        imgContainer.showsHorizontalScrollIndicator = false
        imgContainer.directionalLockEnabled = true
        
        tbList.delegate = self
        tbList.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 画面内容变更
        // 设置数据
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
        if(didSelectRowAtIndexPath.row > 9 && didSelectRowAtIndexPath.row < itemCount - 2){
            var stationDetail = self.storyboard!.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            if(didSelectRowAtIndexPath.row - 10 >= stations!.count){
                return
            }
            stationDetail.stat_id = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_ID))"
            stationDetail.cellJPName = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_NAME))"
            stationDetail.cellJPNameKana = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_NAME_KANA))"
            if(landMark != nil && landMark!.item(MSTT04_LANDMARK_LMAK_ID) != nil){
                stationDetail.ruteLandMarkId = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))"
            }
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController!.pushViewController(stationDetail, animated:true)
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 200
        case 1:
            // 地标名（系统语言）
            return 38
        case 2:
            return 35
        case 3:
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            
            var mLandMarkDesp:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))"
            mLandMarkDesp = mLandMarkDesp.relpaceAll(" ", target: "")
            
            if(mLandMarkDesp.split("\\n").count > 1){
                return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 70
            }
            
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_MICI_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" != ""){
                return 55
            }else{
                return 0
            }
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_RANK))" != ""){
                return 55
            }else{
                return 0
            }
        case 6:
            var mLandMarkPric:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
            mLandMarkPric = mLandMarkPric.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) == nil || mLandMarkPric == "" || "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))" == "3"){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        case 7:
            var mLandMarkAvalTime:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
            mLandMarkAvalTime = mLandMarkAvalTime.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) == nil || mLandMarkAvalTime == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        case 8:
            var mLandMarkAddr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
            mLandMarkAddr = mLandMarkAddr.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) == nil || mLandMarkAddr == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        default:
            if(indexPath.row > 9 && indexPath.row < itemCount - 2){
                return 55
            }else if(indexPath.row == itemCount - 2){
                if(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID) != nil && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != "0" && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != ""){
                    return 70
                }
                return 0
            }
            return 43
        }
    }

    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorColor = UIColor.clearColor()
        
        let cellIdentifier:String = "LandMarkDetailCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }
        
        // 初始化tablecell
        for subview in cell!.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.backgroundColor = UIColor.whiteColor()
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        switch indexPath.row{
            // 地标图片
        case 0:
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID1) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1600, 200)
                var imgLandMark = "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))".image(FOLDER_NAME)
                var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID2) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1920, 200)
                var imgLandMark = "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID2))".image(FOLDER_NAME)
                var imageViewLandMark = UIImageView(frame: CGRectMake(320, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID3) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2240, 200)
                var imgLandMark = "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID3))".image(FOLDER_NAME)
                var imageViewLandMark = UIImageView(frame: CGRectMake(640, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID4) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2560, 200)
                var imgLandMark = "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID4))".image(FOLDER_NAME)
                var imageViewLandMark = UIImageView(frame: CGRectMake(960, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID5) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2880, 200)
                var imgLandMark = "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID5))".image(FOLDER_NAME)
                var imageViewLandMark = UIImageView(frame: CGRectMake(1280, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            imgContainer.addSubview(viewContainer)
            cell!.contentView.addSubview(imgContainer)
            
            // 地标地址
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" != ""){
                var lblADDR = UILabel(frame: CGRect(x:130,y:135,width:190,height:50))
                lblADDR.numberOfLines = 0
                lblADDR.backgroundColor = UIColor.clearColor()
                lblADDR.textColor = UIColor.whiteColor()
                lblADDR.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
                lblADDR.font = UIFont.boldSystemFontOfSize(15)
                lblADDR.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblADDR)
            }
            
            var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnFav.frame = CGRect(x:15,y:135,width:50,height:50)
            
            var mINF002Model:INF002Model = INF002Model()
            
            var mINF002Data:UsrT03FavoriteTableData = mINF002Model.findFav("\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))")
            
            var imgFav = UIImage(named: "INF00202")
            if(mINF002Data.ext4 != ""){
                imgFav = UIImage(named: "INF00206")
            }
            btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
            btnFav.tag = 101
            
            btnFav.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell!.contentView.addSubview(btnFav)
            
            var lblTemp = UILabel(frame: CGRect(x:67.5,y:145,width:1,height:30))
            lblTemp.backgroundColor = UIColor.lightGrayColor()
            cell!.contentView.addSubview(lblTemp)
            
            var btnMap:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnMap.frame = CGRect(x:70,y:135,width:50,height:50)
            var imgMap = UIImage(named: "INF00201")
            btnMap.setBackgroundImage(imgMap, forState: UIControlState.Normal)
            btnMap.tag = 102
            
            btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell!.contentView.addSubview(btnMap)
            
        // 地标名（系统语言）
        case 1:
            var lblLocalNM = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 15,height:38))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME))" != "nil"){
                lblLocalNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME))"
            }else{
                lblLocalNM.text = ""
            }
            
            lblLocalNM.font = UIFont.boldSystemFontOfSize(20)
            lblLocalNM.textAlignment = NSTextAlignment.Left
            cell!.contentView.addSubview(lblLocalNM)
        // 地标名（日文汉字）
        case 2:
            var lblJpNM = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:35))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "nil"){
                lblJpNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))"
            }else{
                lblJpNM.text = ""
            }
            lblJpNM.textColor = UIColor.lightGrayColor()
            lblJpNM.font = UIFont.systemFontOfSize(13)
            lblJpNM.textAlignment = NSTextAlignment.Left
            cell!.contentView.addSubview(lblJpNM)
            
            var lblTemp = UILabel(frame: CGRect(x:0,y:33,width:tableView.frame.width,height:1))
            lblTemp.textColor = UIColor.lightGrayColor()
            lblTemp.backgroundColor = UIColor.lightGrayColor()
            cell!.contentView.addSubview(lblTemp)
        // 地标详细介绍
        case 3:
            var lblInfoTitle = UILabel(frame: CGRect(x:15,y:15,width:tableView.frame.width - 30,height:30))
            lblInfoTitle.textColor = UIColor.lightGrayColor()
            lblInfoTitle.text = "INF002_03".localizedString()
            lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
            lblInfoTitle.textAlignment = NSTextAlignment.Left
            cell!.contentView.addSubview(lblInfoTitle)
                
            var lblInfo = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:100))

            var mLandMarkDesp:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))"
            mLandMarkDesp = mLandMarkDesp.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_DESP) == nil || mLandMarkDesp == ""){
                lblInfo.text = HEAD_SPACE + "INF002_04".localizedString()
            }else{
                lblInfo.text = HEAD_SPACE + "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))".relpaceAll("\\n", target: "\n    ")
            }
            lblInfo.numberOfLines = 0
            lblInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblInfo.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            lblInfo.textAlignment = NSTextAlignment.Left
                
            var size:CGSize = CGSizeMake(290,2000)
            
            if(mLandMarkDesp.split("\\n").count > 1){
                lblInfo.frame.size.height = calLblHeight(lblInfo.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height + 30
            }else{
                lblInfo.frame.size.height = calLblHeight(lblInfo.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
            }
            
            cell!.contentView.addSubview(lblInfo)
        // 米其林星级
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_MICI_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_17".localizedString() + "\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" + "INF002_18".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                
                for(var i=0;i<("\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" as NSString).integerValue; i++){
                    var xFloat:CGFloat = 30
                    
                    for(var j=0;j<i;j++){
                        xFloat = xFloat + 20
                    }
                    var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 40, 15, 15))
                    var imageStar = UIImage(named: "INF00211")
                    imageViewStar.image = imageStar
                    cell!.contentView.addSubview(imageViewStar)
                }
            }
        // 评分
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_RANK))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_10".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                var mLandMarkRank:Int = ("\(landMark!.item(MSTT04_LANDMARK_RANK))" as NSString).integerValue
                var mIntRank = mLandMarkRank/100
                var xFloat:CGFloat = 30
                for(var i=0;i < mIntRank; i++){
                    xFloat = 30
                    for(var j=0;j<i;j++){
                        xFloat = xFloat + 20
                    }
                    
                    var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 40, 15, 15))
                    var imageStar = UIImage(named: "INF00209")
                    imageViewStar.image = imageStar
                    cell!.contentView.addSubview(imageViewStar)
                }
                
                var mSurplus:Int = ("\(landMark!.item(MSTT04_LANDMARK_RANK))" as NSString).integerValue % 100
                var mSurplusRank:Double = ("\(mSurplus)" as NSString).doubleValue/100.0
                if(mSurplusRank > 0.5){
                    xFloat = xFloat + 20
                    var imageViewHalfStar = UIImageView(frame: CGRectMake(xFloat, 40, 15, 15))
                    imageViewHalfStar.image = UIImage(named: "INF00210")
                    cell!.contentView.addSubview(imageViewHalfStar)
                }
            }
        // 预算价格
        case 6:
            var mLandMarkPric:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))"
            mLandMarkPric = mLandMarkPric.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) != nil && mLandMarkPric != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))" != "3"){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                
                if("\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))" == "1"){
                    lblInfoTitle.text = "PUBLIC_10".localizedString()
                }else if("\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))" == "2"){
                    lblInfoTitle.text = "INF002_25".localizedString().relpaceAll("：", target: "")
                }
                
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                
                var lblPRIC = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblPRIC.numberOfLines = 0
                lblPRIC.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblPRIC.text = HEAD_SPACE + "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))".relpaceAll("\\n", target: "\n    ")
                lblPRIC.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblPRIC.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(290,2000)
                lblPRIC.frame.size.height = calLblHeight(lblPRIC.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell!.contentView.addSubview(lblPRIC)
            }
        // 开放时间
        case 7:
            var mLandMarkAvalTime:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
            mLandMarkAvalTime = mLandMarkAvalTime.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) != nil && mLandMarkAvalTime != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_05".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                
                var lblTime = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblTime.numberOfLines = 0
                lblTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTime.text = HEAD_SPACE + "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))".relpaceAll("\\n", target: "\n    ")
                lblTime.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblTime.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(290,2000)
                lblTime.frame.size.height = calLblHeight(lblTime.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell!.contentView.addSubview(lblTime)
            }
        // 地址
        case 8:
            var mLandMarkAddr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
            mLandMarkAddr = mLandMarkAddr.relpaceAll(" ", target: "")
            
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) != nil && mLandMarkAddr != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_06".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                
                var lblADDR = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblADDR.numberOfLines = 0
                lblADDR.text = HEAD_SPACE + "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
                lblADDR.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblADDR.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(290,2000)
                lblADDR.frame.size.height = calLblHeight(lblADDR.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell!.contentView.addSubview(lblADDR)
            }
        // 附近车站
        case 9:
            if(!(stations == nil) && stations!.count > 0){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "PUBLIC_11".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
            }
        default:
            println("nothing")
        }
        
        if(indexPath.row > 9 && indexPath.row < itemCount - 2){
            if(stations![indexPath.row - 10].item(MSTT02_LINE_ID) != nil && "\(stations![indexPath.row - 10].item(MSTT02_LINE_ID))" != "nil"){
                var tableMstT02 = stations![indexPath.row - 10]
                
                var statNm:String = "\(tableMstT02.item(MSTT02_STAT_ID))".station()
                
                var lblStation = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30))
                lblStation.font = UIFont.systemFontOfSize(17)
                lblStation.text = statNm
                lblStation.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblStation)
                
                var lblDetail = UILabel(frame: CGRect(x:15,y:30,width:tableView.frame.width - 30,height:25))
                lblDetail.font = UIFont.systemFontOfSize(13)
                lblDetail.textColor = UIColor.darkGrayColor()
                lblDetail.text = "\(tableMstT02.item(MSTT02_STAT_NAME))" + "(\(tableMstT02.item(MSTT02_STAT_NAME_KANA)))"
                lblDetail.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblDetail)
                
                var imageViewLine = UIImageView(frame: CGRectMake(tableView.frame.width - 55, 12.5, 30, 30))
                imageViewLine.image = "\(tableMstT02.item(MSTT02_LINE_ID))".getLineImage()
                cell!.contentView.addSubview(imageViewLine)
                
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell!.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
                cell!.selectionStyle = UITableViewCellSelectionStyle.Default
                cell!.contentView.addSubview(lblStation)
            }
        }
        // 出站口
        if(indexPath.row == itemCount - 2){
            if(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID) != nil && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != "0" && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_32".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell!.contentView.addSubview(lblInfoTitle)
                
                var lblExit = UILabel(frame: CGRect(x:30,y:40,width:tableView.frame.width - 30,height:40))
                lblExit.numberOfLines = 0
                
                var mWalkTime:String = "INF002_36".localizedString()
                if(!(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_TIME) == nil)){
                    mWalkTime = "CMN003_07".localizedString() + "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_TIME))" + "CMN003_03".localizedString()
                }
                
                var exitId:String = "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))"
                lblExit.text = exitId.stationExit() + " " + mWalkTime
                lblExit.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblExit.textAlignment = NSTextAlignment.Left
                
                cell!.contentView.addSubview(lblExit)
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    /*******************************************************************************
    *      Implements Of UIScrollViewDelegate
    *******************************************************************************/

    // UIScrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return viewContainer
    }

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     *
     */
    func intitValue(){
        //var daoINF002 = INF002Dao()
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        stations = mstT04Table.queryLandMarkStations(landMark!)
        itemCount = stations!.count + 12
        
        if(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID) != nil && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != "0" && "\(landMark!.item(MSTT04_LANDMARK_STAT_EXIT_ID))" != ""){
            // 查询按钮点击事件
            var searchButtonTemp:UIButton? = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            searchButtonTemp!.frame = CGRect(x:0,y:0,width:25,height:25)
            var imgLandMark = UIImage(named: "inf00223")
            searchButtonTemp!.setBackgroundImage(imgLandMark, forState: UIControlState.Normal)
            searchButtonTemp!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            searchButtonTemp!.tag = BTN_ROUTE_TAG
            var searchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButtonTemp!)
            self.navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case 101:
            var mINF002Model:INF002Model = INF002Model()
            
            var mINF002Data:UsrT03FavoriteTableData = mINF002Model.findFav("\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))")
            //
            if(mINF002Data.ext4 != ""){
                mINF002Model.deleteFav(mINF002Data)
                tbList.reloadData()
            }else{
                var lmkFavAdd:UsrT03FavoriteTableData = UsrT03FavoriteTableData()
                lmkFavAdd.lmakId = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))"
                lmkFavAdd.favoType = "03"
                lmkFavAdd.favoTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                lmkFavAdd.statId = "\(landMark!.item(MSTT04_LANDMARK_STAT_ID))"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ruteId = "0"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ext4 = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))"
                mINF002Model.insertFav(lmkFavAdd)
                tbList.reloadData()
            }
            
        case 102:
            var landMarkMapController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
            landMarkMapController.title = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            landMarkMapController.landMark = landMark!
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController!.pushViewController(landMarkMapController, animated:true)
        case 103:
            var stationDetail = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as StationDetail
            
            self.navigationController!.pushViewController(stationDetail, animated:true)
        case BTN_ROUTE_TAG:
            var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
            if(!(landMark!.statId == nil)){
                routeSearch.endStationText = landMark!.statId
            }
            if(!(landMark!.lmakId == nil)){
                routeSearch.endStationLandMarkId = landMark!.lmakId
            }
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController!.pushViewController(routeSearch, animated: true)
        default:
            println("nothing")
        }
    }
    
    func calLblHeight(text:String, font:UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize?
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = text.sizeWithAttributes(attributes)
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize!
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}