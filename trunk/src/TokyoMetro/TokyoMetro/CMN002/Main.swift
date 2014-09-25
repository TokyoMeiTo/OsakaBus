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
    @IBOutlet weak var lineImage: UIImageView!
    // 判断是否要显示底部menu
    var isMenuShow = false
    // 屏幕尺寸
    var size: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = UIScreen.mainScreen().bounds.size
        
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5
        scroll.zoomScale = 1.5
        
        
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
        
        var cmnt03table = CmnT03StationGridTable()
        var cmnt03row = cmnt03table.excuteQuery("select STAT_ID from CMNT03_STATION_GRID where PONT_X_FROM < 2300 and PONT_X_TO > 2300 and PONT_Y_FROM < 1250 and PONT_Y_TO > 1250")
        
        if cmnt03row != nil {
            for value in cmnt03row{
                value as CmnT03StationGridTable
                var stationId:AnyObject = value.item(CMNT03_STAT_ID)
                println("【2300,1250】2800108 车站信息")
                println("\(stationId)")
            }
        }
         self.scroll = CGPointMake(2300 , 1250)
    }
    
//    func addPopView() {
//        
//    }
    
    
    
    
    
}
