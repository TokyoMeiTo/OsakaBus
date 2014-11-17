//
//  AppDelegate.swift
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var isShow: Bool = false
    var startStatId: String = ""
    var endStatId: String = ""
    var remindListController:RemindListController?
    var arriveTime:Int?
    var enterBackTime:NSDate?
    
    var localCacheController:LocalCacheController?
    var downloadTask:NSURLSessionDownloadTask?
    var downloadData:NSData?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if(!(downloadTask == nil)){
            downloadTask!.cancelByProducingResumeData { (resumeData) -> Void in
                self.downloadData = resumeData
            }
        }
        
        if(remindListController == nil){
            return
        }
        var timerThread = TimerThread.shareInstance()
        arriveTime = timerThread.surplusTime
        enterBackTime = NSDate()
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if(!(localCacheController == nil) && !(downloadData == nil)){
            localCacheController!.mDownloadData = downloadData
        }
        if(remindListController == nil || arriveTime == nil || enterBackTime == nil){
            return
        }
        var secondsBetweenDates:Int = ("\(enterBackTime!.timeIntervalSinceNow)" as NSString).integerValue * -1
        var timerThread = TimerThread.shareInstance()
//        timerThread.sender = remindListController
        if(secondsBetweenDates >= arriveTime!){
            timerThread.cancel()
        }else if(secondsBetweenDates > 0 && secondsBetweenDates < arriveTime!){
            timerThread.arriveTime = timerThread.arriveTime - secondsBetweenDates
        }
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

