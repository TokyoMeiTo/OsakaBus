//
//  TimerThread.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/21.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

/**
 * 用于计时线程
 */
class TimerThread: NSOperation{
    
    // 到达站点所需时间,s,
    var arriveTime:Int = -1
    // 画面viewController
    var sender:RemindListController?
    // 到达站点剩余时间
    var surplusTime:Int = 0
    
    private override init(){
    }
    
    /**
     * 创建单例
     */
    class func shareInstance()->TimerThread{
        struct qzSingle{
            static var predicate:dispatch_once_t = 0;
            static var instance:TimerThread? = nil
        }
        if(qzSingle.instance == nil){
            qzSingle.instance = TimerThread()
        }else if(qzSingle.instance!.finished){
            qzSingle.instance = TimerThread()
        }
        return qzSingle.instance!
    }
    
    override func start() {
        super.start()
    }
    
    override func main() {
        for(var i=0;i <= arriveTime;i++){
            var surplusTime = arriveTime - i
            self.surplusTime = surplusTime
            sender!.updateTime(surplusTime)
//            println("surplusTime" + "\(surplusTime)")
//            println("arriveTime" + "\(arriveTime)")
            sleep(1)
        }
    }
    
    override func cancel() {
        super.cancel()
        arriveTime = -1
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.remindListController = nil
    }
}