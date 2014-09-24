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
//        
//        for view in scroll.subviews {
//            if (view.isKindOfClass(UIImageView)) {
//                
//                return view as UIView
//            }
//            
//        }
//        
//        return nil
        return lineImage
    }
    // 双击之后真个scrollView放大
    func doubleTapAction(myTapGesture :UITapGestureRecognizer) {
        var offsetX:CGFloat = (scroll.bounds.size.width >
            scroll.contentSize.width) ? (scroll.bounds.size.width - scroll.contentSize.width)/2 : 0.0
        var offsetY:CGFloat = (scroll.bounds.size.height >
            scroll.contentSize.height) ? (scroll.bounds.size.height - scroll.contentSize.height)/2 : 0.0
        self.lineImage.center = CGPointMake(scroll.contentSize.width * 0.5 + offsetX , scroll.contentSize.height * 0.5 + offsetY)
        
        scroll.zoomScale = (scroll.zoomScale + 0.2)
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
    
}
