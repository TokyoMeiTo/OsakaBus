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
    
    /* 地标显示内容的数量 */
    let LANDMARK_DETAIL_COUNT:Int = 15
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    
    /* UIContentContainer */
    var imgContainer:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, 1600, 200))
    var viewContainer:UIView = UIView(frame: CGRectMake(0, 0, 1600, 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btnFav.hidden = true
        btnMap.hidden = true
        
        // 返回按钮点击事件
        var backButton:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
        self.navigationItem.leftBarButtonItem = backButton
        
        imgContainer.contentSize = CGSizeMake(1600, 200)
        
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
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case 101:
            var tableUsrT03:INF002FavDao = INF002FavDao()
            var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))")
            if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
                RemindDetailController.showMessage("通知", msg:"此地标已经在收藏中", buttons:["OK"], delegate: nil)
            }else{
                var lmkFavAdd:UsrT03FavoriteTable = UsrT03FavoriteTable()
                lmkFavAdd.lmakId = "\(landMark!.item(MSTT04_LANDMARK_LMAK_ID))"
                lmkFavAdd.favoType = "3"
                lmkFavAdd.favoTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                lmkFavAdd.lineId = "\(landMark!.item(MSTT04_LANDMARK_LINE_ID))"
                lmkFavAdd.statId = "\(landMark!.item(MSTT04_LANDMARK_STAT_ID))"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ruteId = "0"
                if(lmkFavAdd.insert()){
//                    RemindDetailController.showMessage("通知", msg:"收藏成功", buttons:["OK"], delegate: nil)
                }
            }
            
        case 102:
            var landMarkMapController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
            landMarkMapController.landMark = landMark!
            self.navigationController!.pushViewController(landMarkMapController, animated:true)
        case self.navigationItem.leftBarButtonItem!.tag:
            var controllers:AnyObject? = self.navigationController!.viewControllers
            if(controllers!.count > 1){
                var lastController:LandMarkListController = controllers![controllers!.count - 2] as LandMarkListController
                lastController.viewDidLoad()
            }
            self.navigationController!.popViewControllerAnimated(true)
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

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LANDMARK_DETAIL_COUNT
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        // 地标名（系统语言）
        case 0:
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID1) == nil || "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" == ""){
                return 0
            }
            return 200
        case 1:
            return 30
        case 2:
            return 15
        case 3:
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(15)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" as String
            var lblSize:CGSize = CGSizeMake(320,2000)
            
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 50
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(14)
            var nsStr:String = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" as String
            var lblSize:CGSize = CGSizeMake(320,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 10
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" == ""){
                return 0
            }
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(14)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" as String
            var lblSize:CGSize = CGSizeMake(320,2000)
            return calLblHeight(nsStr, font: infoFont, constrainedToSize: lblSize).height + 10
        case 6:
            return 43
        default:
           return 43
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        switch indexPath.row{
        // 地标图片
        case 0:
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID1) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1600, 200)
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID2) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(1920, 200)
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID2))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(320, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID3) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2240, 200)
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID3))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(640, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID4) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2560, 200)
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID4))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(960, 0, 320, 200))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID5) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                imgContainer.contentSize = CGSizeMake(2880, 200)
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID5))")
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
            var lblLocalNM = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 15,height:30))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" != "nil"){
                lblLocalNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            }else{
                lblLocalNM.text = ""
            }
            
            lblLocalNM.font = UIFont.systemFontOfSize(20)
            lblLocalNM.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblLocalNM)
        // 地标名（日文汉字）
        case 2:
            var lblJpNM = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:15))
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "" && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != "nil"){
                lblJpNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))"
            }else{
                lblJpNM.text = ""
            }
            lblJpNM.textColor = UIColor.lightGrayColor()
            lblJpNM.font = UIFont.systemFontOfSize(10)
            lblJpNM.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblJpNM)
            
            var lblTemp = UILabel(frame: CGRect(x:0,y:15,width:tableView.frame.width,height:1))
            lblTemp.textColor = UIColor.lightGrayColor()
            lblTemp.backgroundColor = UIColor.lightGrayColor()
            cell.addSubview(lblTemp)
        // 地标详细介绍
        case 3:
            var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
            lblInfoTitle.textColor = UIColor.lightGrayColor()
            lblInfoTitle.text = "简介"
            lblInfoTitle.font = UIFont.systemFontOfSize(20)
            lblInfoTitle.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblInfoTitle)
            
            var lblInfo = UILabel(frame: CGRect(x:15,y:45,width:tableView.frame.width - 30,height:100))
            if((landMark!.item(MSTT04_LANDMARK_LMAK_DESP) == nil) || ("\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" == "nil") || ("\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" == "")){
                lblInfo.text = "暂时没有介绍"
            }else{
                lblInfo.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))"
            }
            lblInfo.numberOfLines = 0
            lblInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblInfo.font = UIFont.systemFontOfSize(15)
            lblInfo.textAlignment = NSTextAlignment.Left
            
            var size:CGSize = CGSizeMake(320,2000)
            lblInfo.frame.size.height = calLblHeight(lblInfo.text!, font: UIFont.systemFontOfSize(15), constrainedToSize: size).height
            cell.addSubview(lblInfo)
        // 地标票价
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "票价"
                lblInfoTitle.font = UIFont.systemFontOfSize(20)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                var lblPRIC = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
                lblPRIC.numberOfLines = 0
                lblPRIC.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblPRIC.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))"
                lblPRIC.font = UIFont.systemFontOfSize(14)
                lblPRIC.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(320,2000)
                lblPRIC.frame.size.height = calLblHeight(lblPRIC.text!, font: UIFont.systemFontOfSize(14), constrainedToSize: size).height
                
                cell.addSubview(lblPRIC)
            }
        // 地标营业时间
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" != ""){
                var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
                lblInfoTitle.textColor = UIColor.lightGrayColor()
                lblInfoTitle.text = "开放时间"
                lblInfoTitle.font = UIFont.systemFontOfSize(20)
                lblInfoTitle.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblInfoTitle)
                
                var lblTime = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
                lblTime.numberOfLines = 0
                lblTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTime.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
                lblTime.font = UIFont.systemFontOfSize(14)
                lblTime.textAlignment = NSTextAlignment.Left
                
                var size:CGSize = CGSizeMake(320,2000)
                lblTime.frame.size.height = calLblHeight(lblTime.text!, font: UIFont.systemFontOfSize(14), constrainedToSize: size).height
                
                cell.addSubview(lblTime)
            }
        // 地标附近线路
        case 6:
            var lblInfoTitle = UILabel(frame: CGRect(x:15,y:10,width:tableView.frame.width - 30,height:30))
            lblInfoTitle.textColor = UIColor.lightGrayColor()
            lblInfoTitle.text = "附近站点"
            lblInfoTitle.font = UIFont.systemFontOfSize(20)
            lblInfoTitle.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblInfoTitle)
            
            var btnLine:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnLine.frame = CGRect(x:15,y:45,width:130,height:30)
            btnLine.setTitle("\(landMark!.item(MSTT04_LANDMARK_LINE_ID))".line() + "\(landMark!.item(MSTT04_LANDMARK_STAT_ID))".station(), forState: UIControlState.Normal)
            cell.addSubview(btnLine)
        default:
            println("nothing")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    // UIScrollView
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return viewContainer
    }
}