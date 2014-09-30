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
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    /* 地标显示内容的数量 */
    let LANDMARK_DETAIL_COUNT:Int = 15
    
    /* 地标 */
    var landMark:MstT04LandMarkTable?
    
    /* UIContentContainer */
    var imgContainer:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, 750, 150))
    var viewContainer:UIView = UIView(frame: CGRectMake(0, 0, 750, 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if(landMark!.item(MSTT04_LANDMARK_IMAG_ID4) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID4))" != ""){
            imgContainer.contentSize = CGSizeMake(1210, 150)
        }else{
            imgContainer.contentSize = CGSizeMake(750, 150)
        }
        
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
        switch sender{
        case btnMap:
            var landMarkMapController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
            self.navigationController!.pushViewController(landMarkMapController, animated:true)
        default:
            println("nothing")
        }
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
            return 150
        case 1:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" == ""){
                return 0
            }
            return 30
        case 2:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" == ""){
                return 0
            }
            return 10
        case 3:
            // label自适应高度
            var infoFont:UIFont = UIFont.systemFontOfSize(12)
            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" as NSString
            var lblSize:CGSize = nsStr.sizeWithAttributes([NSFontAttributeName: infoFont])
            return 150//lblSize.height + 60
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" == ""){
                return 0
            }
            return 43
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" == ""){
                return 0
            }
            return 43
        case 6:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) == nil || "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" == ""){
                return 0
            }
            return 43
        case 7:
            return 43
        case 8:
            if(landMark!.item(MSTT04_LANDMARK_STAT_ID) == nil || "\(landMark!.item(MSTT04_LANDMARK_STAT_ID))" == ""){
                return 0
            }
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
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(15, 5, 150, 150))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID2) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID2))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(165, 5, 150, 150))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID3) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID3))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(315, 5, 150, 150))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID4) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID4))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(465, 5, 150, 150))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            if(landMark!.item(MSTT04_LANDMARK_IMAG_ID5) != nil && "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID1))" != ""){
                var imgLandMark = UIImage(named: "\(landMark!.item(MSTT04_LANDMARK_IMAG_ID5))")
                var imageViewLandMark = UIImageView(frame: CGRectMake(615, 5, 150, 150))
                imageViewLandMark.image = imgLandMark
                viewContainer.addSubview(imageViewLandMark)
            }
            imgContainer.addSubview(viewContainer)
            cell.addSubview(imgContainer)
        // 地标名（系统语言）
        case 1:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" != ""){
                var lblLocalNM = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 15,height:30))
                lblLocalNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
                lblLocalNM.font = UIFont.systemFontOfSize(18)
                lblLocalNM.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblLocalNM)
            }
        // 地标名（日文汉字）
        case 2:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))" != ""){
                var lblJpNM = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:15))
                lblJpNM.textColor = UIColor.lightGrayColor()
                lblJpNM.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_NAME_KANA))"
                lblJpNM.font = UIFont.systemFontOfSize(8)
                lblJpNM.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblJpNM)
            }
        // 地标详细介绍
        case 3:
            var lblInfo = UITextView(frame: CGRect(x:10,y:0,width:tableView.frame.width - 30,height:100))
//            lblInfo.numberOfLines = 0
//            lblInfo.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblInfo.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))"
            
            lblInfo.font = UIFont.systemFontOfSize(14)
            lblInfo.textAlignment = NSTextAlignment.Left
            lblInfo.editable = false
//            // label自适应高度
//            var infoFont:UIFont = UIFont.systemFontOfSize(13)
//            var nsStr:NSString = "\(landMark!.item(MSTT04_LANDMARK_LMAK_DESP))" as NSString
//            var lblSize:CGSize = nsStr.sizeWithAttributes([NSFontAttributeName: infoFont])
            
            lblInfo.frame.size.height = 150//lblSize.height + 60
            cell.addSubview(lblInfo)
        // 地标地址
        case 4:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))" != ""){
                var lblADDR = UITextView(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
                lblADDR.editable = false
//                lblADDR.numberOfLines = 0
//                lblADDR.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblADDR.text = "地址：\(landMark!.item(MSTT04_LANDMARK_LMAK_ADDR))"
                lblADDR.font = UIFont.systemFontOfSize(14)
                lblADDR.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblADDR)
            }
        // 地标票价
        case 5:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))" != ""){
                var lblPRIC = UITextView(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
                lblPRIC.editable = false
//                lblPRIC.numberOfLines = 0
//                lblPRIC.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblPRIC.text = "票价：\(landMark!.item(MSTT04_LANDMARK_LMAK_TICL_PRIC))"
                lblPRIC.font = UIFont.systemFontOfSize(14)
                lblPRIC.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblPRIC)
            }
        // 地标营业时间
        case 6:
            if(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME) != nil && "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))" != ""){
                var lblTime = UITextView(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
                lblTime.editable = false
//                lblTime.numberOfLines = 0
//                lblTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTime.text = "\(landMark!.item(MSTT04_LANDMARK_LMAK_AVAL_TIME))"
                lblTime.font = UIFont.systemFontOfSize(14)
                lblTime.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblTime)
            }
        // 地标附近线路
        case 7:
            var lblLine = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
            lblLine.numberOfLines = 0
            lblLine.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblLine.text = "附近线路："
            lblLine.font = UIFont.systemFontOfSize(14)
            lblLine.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblLine)
            
            var btnLine:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnLine.frame = CGRect(x:55,y:5,width:130,height:30)
            btnLine.setTitle("\(landMark!.item(MSTT04_LANDMARK_LINE_ID))".line(), forState: UIControlState.Normal)
            cell.addSubview(btnLine)
        // 地标附近站点
        case 8:
            var lblStation = UILabel(frame: CGRect(x:15,y:0,width:tableView.frame.width - 30,height:40))
            lblStation.numberOfLines = 0
            lblStation.lineBreakMode = NSLineBreakMode.ByCharWrapping
            lblStation.text = "附近站点："
            lblStation.font = UIFont.systemFontOfSize(14)
            lblStation.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblStation)
            
            var btnStation:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnStation.frame = CGRect(x:55,y:5,width:130,height:30)
            btnStation.setTitle("\(landMark!.item(MSTT04_LANDMARK_STAT_ID))".station(), forState: UIControlState.Normal)
            cell.addSubview(btnStation)
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