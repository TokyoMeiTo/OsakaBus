//
//  LandMarkDetailController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LandMarkDetailController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource{
    /* 页面跳转UIButton */
    @IBOutlet weak var btnMap: UIButton!
    /* 收藏UIButton */
    @IBOutlet weak var btnFav: UIButton!
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    let SMALL_TEXT_SIZE:CGFloat = 15
    let LABEL_TEXT_SIZE:CGFloat = 20
    
    /* 地标显示内容的数量 */
    var itemCount:Int = 9
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    
    /* UIContentContainer */
    var imgContainer:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, 1600, 200))
    var viewContainer:UIView = UIView(frame: CGRectMake(0, 0, 1600, 200))
    
    var stations:Array<MstT02StationTable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btnFav.hidden = true
        btnMap.hidden = true
        
        intitValue()
        
//        // 返回按钮点击事件
//        var backButton:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
//        self.navigationItem.leftBarButtonItem = backButton
        
        imgContainer.contentSize = CGSizeMake(1600, 200)
        imgContainer.pagingEnabled = true
        
        imgContainer.delegate = self
        imgContainer.showsHorizontalScrollIndicator = false
        imgContainer.directionalLockEnabled = true
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *
     */
    func intitValue(){
        //var daoINF002 = INF002Dao()
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        stations = mstT04Table.queryLandMarkStations(landMark!)
        itemCount = stations!.count + 11
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case 101:
            var tableUsrT03:INF002FavDao = INF002FavDao()
            var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))")
            //
            if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
                lmkFav!.delete()
                tbList.reloadData()
            }else{
                var lmkFavAdd:UsrT03FavoriteTable = UsrT03FavoriteTable()
                lmkFavAdd.lmakId = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))"
                lmkFavAdd.favoType = "3"
                lmkFavAdd.favoTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                lmkFavAdd.lineId = "\(landMark!.item(MSTT04_LANDMARK_LINE_ID))"
                lmkFavAdd.statId = "\(landMark!.item(MSTT04_LANDMARK_STAT_ID))"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ruteId = "0"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ext4 = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TYPE))"
                if(lmkFavAdd.insert()){
                    tbList.reloadData()
                }
            }
            
        case 102:
            var landMarkMapController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
            landMarkMapController.title = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            landMarkMapController.landMark = landMark!
            self.navigationController!.pushViewController(landMarkMapController, animated:true)
        case 103:
            var stationDetail = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as StationDetail
            
            self.navigationController!.pushViewController(stationDetail, animated:true)
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

    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(didSelectRowAtIndexPath.row > 9){
            var stationDetail = self.storyboard!.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            stationDetail.stat_id = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_ID))"
            stationDetail.cellJPName = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_NAME))"
            stationDetail.cellJPNameKana = "\(stations![didSelectRowAtIndexPath.row - 10].item(MSTT02_STAT_NAME_KANA))"
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController!.pushViewController(stationDetail, animated:true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCount
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 200
        case 1:
            // 地标名（系统语言）
            return 40
        case 2:
            return 25
        case 3:
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            
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
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        case 7:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        case 8:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" as String
            var lblSize:CGSize = CGSizeMake(290,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 40
        default:
            if(indexPath.row > 9){
                return 55
            }
           return 43
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        // 初始化tablecell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.backgroundColor = UIColor.whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.selected = false
        
        switch indexPath.row{
        // 地标图片
        case 0:
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID1) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1600, 200)
                var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))"))
                var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID2) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1920, 200)
                var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMark!.item(MSTT04_LANDMARK_IMAG_ID2))"))
                var imageViewLandMark = UIImageView(frame: CGRectMake(320, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID3) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2240, 200)
                var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMark!.item(MSTT04_LANDMARK_IMAG_ID3))"))
                var imageViewLandMark = UIImageView(frame: CGRectMake(640, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID4) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2560, 200)
                var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMark!.item(MSTT04_LANDMARK_IMAG_ID4))"))
                var imageViewLandMark = UIImageView(frame: CGRectMake(960, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID5) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2880, 200)
                var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMark!.item(MSTT04_LANDMARK_IMAG_ID5))"))
                var imageViewLandMark = UIImageView(frame: CGRectMake(1280, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            imgContainer.addSubview(viewContainer)
            cell.addSubview(imgContainer)
            
            // 地标地址
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" != ""){
                var lblADDR = UILabel(frame: CGRect(x:130,y:135,width:190,height:50))
                lblADDR.numberOfLines = 0
                lblADDR.backgroundColor = UIColor.clearColor()
                lblADDR.textColor = UIColor.whiteColor()
                lblADDR.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
                lblADDR.font = UIFont.boldSystemFontOfSize(15)
                lblADDR.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblADDR)
            }
            
            var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnFav.frame = CGRect(x:15,y:135,width:50,height:50)
            
            var tableUsrT03:INF002FavDao = INF002FavDao()
            var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))")
            
            var imgFav = UIImage(named: "INF00202.png")
            if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
                imgFav = UIImage(named: "INF00206.png")
            }
            btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
            btnFav.tag = 101
            
            btnFav.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(btnFav)
            
            var lblTemp = UILabel(frame: CGRect(x:67.5,y:145,width:1,height:30))
            lblTemp.backgroundColor = UIColor.lightGrayColor()
            cell.addSubview(lblTemp)
            
            var btnMap:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnMap.frame = CGRect(x:70,y:135,width:50,height:50)
            var imgMap = UIImage(named: "INF00201.png")
            btnMap.setBackgroundImage(imgMap, forState: UIControlState.Normal)
            btnMap.tag = 102
            
            btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(btnMap)
            
        // 地标名（系统语言）
        case 1:
            var lblLocalNM = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 15,height:40))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" != "nil"){
                lblLocalNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            }else{
                lblLocalNM.text = ""
            }
            
            lblLocalNM.font = UIFont.boldSystemFontOfSize(20)
            lblLocalNM.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblLocalNM)
        // 地标名（日文汉字）
        case 2:
            var lblJpNM = UILabel(frame: CGRect(x:15,y:3,width:tableView.frame.width - 30,height:25))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "nil"){
                lblJpNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))"
            }else{
                lblJpNM.text = ""
            }
            lblJpNM.textColor = UIColor.lightGrayColor()
            lblJpNM.font = UIFont.systemFontOfSize(13)
            lblJpNM.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblJpNM)
            
            var lblTemp = UILabel(frame: CGRect(x:0,y:23,width:tableView.frame.width,height:1))
            lblTemp.textColor = UIColor.lightGrayColor()
            lblTemp.backgroundColor = UIColor.lightGrayColor()
            cell.addSubview(lblTemp)
        // 地标详细介绍
        case 3:
            var lblInfoTitle = UILabel(frame: CGRect(x:15,y:15,width:tableView.frame.width - 30,height:30))
            lblInfoTitle.textColor = UIColor.lightGrayColor()
            lblInfoTitle.text = "INF002_03".localizedString()
            lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
            lblInfoTitle.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblInfoTitle)
            
            var lblInfo = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:100))
            if((landMark!.item(MSTT04_LANDMARK_LMAK_DESP) == nil) || ("\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" == "nil") || ("\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" == "")){
                lblInfo.text = "INF002_04".localizedString()
            }else{
                lblInfo.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))"
            }
            lblInfo.numberOfLines = 0
            lblInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblInfo.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
            lblInfo.textAlignment = NSTextAlignment.Left
            
            var size:CGSize = CGSizeMake(290,2000)
            lblInfo.frame.size.height = calLblHeight(lblInfo.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
            cell.addSubview(lblInfo)
        // 地标票价
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_MICI_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "米其林" + "\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" + "星餐厅"
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                for(var i=0;i<("\(landMark!.item(MSTT04_LANDMARK_MICI_RANK))" as NSString).integerValue; i++){
                    var xFloat:CGFloat = 15//100
                    
                    for(var j=0;j<i;j++){
                        xFloat = xFloat + 20
                    }
                    var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 40, 15, 15))
                    var imageStar = UIImage(named: "INF00211.png")
                    imageViewStar.image = imageStar
                    cell.addSubview(imageViewStar)
                }
            }
        // 地标营业时间
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_RANK) != nil && "\(landMark!.item(MSTT04_LANDMARK_RANK))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "评分"
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                // ("\(landMark!.item(MSTT04_LANDMARK_RANK))" as NSString).integerValue
                for(var i=0;i<4; i++){
                    var xFloat:CGFloat = 15//100
                    
                    for(var j=0;j<i;j++){
                        xFloat = xFloat + 20
                    }
                    var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 40, 15, 15))
                    var imageStar = UIImage(named: "INF00209.png")
                    imageViewStar.image = imageStar
                    cell.addSubview(imageViewStar)
                }
            }
        // 地址
        case 6:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "PUBLIC_10".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                var lblPRIC = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblPRIC.numberOfLines = 0
                lblPRIC.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblPRIC.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))"
                lblPRIC.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblPRIC.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(290,2000)
                lblPRIC.frame.size.height = calLblHeight(lblPRIC.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell.addSubview(lblPRIC)
            }
        // 地标附近线路
        case 7:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_05".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                var lblTime = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblTime.numberOfLines = 0
                lblTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTime.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
                lblTime.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblTime.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(290,2000)
                lblTime.frame.size.height = calLblHeight(lblTime.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell.addSubview(lblTime)
            }
        case 8:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "INF002_06".localizedString()
                lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                var lblADDR = UILabel(frame: CGRect(x:15,y:40,width:tableView.frame.width - 30,height:40))
                lblADDR.numberOfLines = 0
                lblADDR.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
                lblADDR.font = UIFont.systemFontOfSize(SMALL_TEXT_SIZE)
                lblADDR.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(320,2000)
                lblADDR.frame.size.height = calLblHeight(lblADDR.text!, font: UIFont.systemFontOfSize(SMALL_TEXT_SIZE), constrainedToSize: size).height
                
                cell.addSubview(lblADDR)
            }
        case 9:
            var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
            lblInfoTitle.textColor = UIColor.lightGrayColor()
            lblInfoTitle.text = "INF002_07".localizedString()
            lblInfoTitle.font = UIFont.systemFontOfSize(LABEL_TEXT_SIZE)
            lblInfoTitle.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblInfoTitle)
        default:
            println("nothing")
        }
        
        if(indexPath.row > 9 && indexPath.row < itemCount - 1){
            if("\(stations![indexPath.row - 10].item(MSTT02_LINE_ID))" != "nil"){
                var tableMstT02 = stations![indexPath.row - 10]
                
                var statNm:String = "\(tableMstT02.item(MSTT02_STAT_ID))".station()
                
                var lblStation = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30))
                lblStation.font = UIFont.systemFontOfSize(17)
                lblStation.text = statNm
                lblStation.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblStation)
                
                var lblDetail = UILabel(frame: CGRect(x:15,y:30,width:tableView.frame.width - 30,height:25))
                lblDetail.font = UIFont.systemFontOfSize(13)
                lblDetail.textColor = UIColor.darkGrayColor()
                lblDetail.text = "\(tableMstT02.item(MSTT02_STAT_NAME))" + "(\(tableMstT02.item(MSTT02_STAT_NAME_KANA)))"
                lblDetail.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblDetail)
                
                var imageViewLine = UIImageView(frame: CGRectMake(tableView.frame.width - 55, 12.5, 30, 30))
                imageViewLine.image = "\(tableMstT02.item(MSTT02_LINE_ID))".getLineImage()
                cell.addSubview(imageViewLine)
                
                var lblTemp1 = UILabel(frame: CGRect(x:15,y:54,width:tableView.frame.width - 30,height:1))
                lblTemp1.alpha = 0.3
                lblTemp1.textColor = UIColor.lightGrayColor()
                lblTemp1.backgroundColor = UIColor.lightGrayColor()
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
                cell.addSubview(lblStation)
                cell.addSubview(lblTemp1)
            }
        }
        return cell
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
    
    // UIScrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return viewContainer
    }
}