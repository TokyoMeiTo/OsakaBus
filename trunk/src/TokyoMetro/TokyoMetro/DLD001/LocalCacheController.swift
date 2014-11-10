//
//  LocalCache.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LocalCacheController: UIViewController, UIAlertViewDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    /* 缓存信息 */
    @IBOutlet weak var imgMain: UIImageView!
    /* 缓存信息 */
    @IBOutlet weak var btnDownload: UIButton!
    /* 缓存信息 */
    @IBOutlet weak var lblCacheVersion: UILabel!
    /* 缓存信息 */
    @IBOutlet weak var lblCacheSize: UILabel!
    /* 缓存信息 */
    @IBOutlet weak var lblMoibleSize: UILabel!
    /* 缓存信息 */
    @IBOutlet weak var lblTip: UILabel!
    /* 缓存信息 */
    @IBOutlet weak var lblProgress: UILabel!
    /* 缓存信息 */
    @IBOutlet weak var lblTip2: UILabel!
    /* 加载进度条ActivityIndicatorView */
    @IBOutlet weak var gaiLoading: UIActivityIndicatorView!

    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    // "http://osakabus.sinaapp.com/Resource.zip"
    // "http://192.168.1.84/Resource.zip"
    // "http://www.okasan.net/Resource.zip"
    let uri:String = "http://192.168.1.84/Resource.zip"
    
    let filePath:String = "Resource.zip"
    let unZipPath:String = "TokyoMetroCache"

    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    var classType:Int = 0

    var mainController:Main?
    
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* NSFileManager */
    let fileManager = NSFileManager()
    var mProgress:NSProgress?
    var updateComplete:Bool = false
    var canUpdate:Bool = false
    
    var downloading:Bool = false
    var UIloading:Bool = false
    var loadProgress:String? = ""
    var tipText:String = "DLD001_08".localizedString()
    /* 线程池 */
    var mQueue:NSOperationQueue = NSOperationQueue()
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitValue()
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
    
    /**
     * NSProgress监听事件
     */
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        if (keyPath=="fractionCompleted") {
            var progress:NSProgress = object as NSProgress;
            if(countElements("\(progress.fractionCompleted)") > 5 && progress.fractionCompleted > 0.0001){
                // 在子线程中更新UI
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.showProgress()
                    
                    if(progress.fractionCompleted > 0.99){
                        self.lblProgress.text = "DLD001_02".localizedString()
                    }else{
                        var progressTemp = "\(progress.fractionCompleted * 100)".decimal(2)
                        self.loadProgress = "DLD001_09".localizedString() + ": " + "\(progressTemp)" + " %"
                        self.lblProgress.text = self.loadProgress
                    }
                }
            }
        }
    }
    
    
    /*******************************************************************************
    * Overrides From UIAlertViewDelegate
    *******************************************************************************/

    // after animation
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int){
        switch buttonIndex{
        case 0:
            downloadCompressFile(uri)
//            var mDownloadThread = DownloadThread.shareInstance()
//            mDownloadThread.controller = self
//            if(!(mDownloadThread.isRun == nil)){
//                if(mDownloadThread.isRun!){
//                    threadIsRunning(mDownloadThread)
//                }else{
//                    threadIsNoRunning(mDownloadThread)
//                }
//            }
            runInBackground()
        default:
            println("nothing")
        }
    }

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    func intitValue(){
        self.title = "DLD001_01".localizedString()
        self.navigationItem.rightBarButtonItem = nil
        lblProgress.hidden = true
        lblCacheVersion.text = "DLD001_12".localizedString()
        lblCacheSize.text = "DLD001_13".localizedString() + "81.1 MB"
        lblMoibleSize.text = "DLD001_14".localizedString() + "\(LocalCacheController.getMemorySize()) GB"
        lblTip.text = tipText
        lblTip.numberOfLines = 0
        lblTip.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        lblTip2.text = "DLD001_11".localizedString()
        
        disMiss(gaiLoading)
        
        switch classType{
        case 0:
            self.navigationItem.setHidesBackButton(true, animated: false)
        default:
            println("nothing")
        }
        btnDownload.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        showDownloadBtn()
    }
    
    /**
     * ボタン点击事件
     * @param sender UIButton
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case 101:
            if(!downloading){
                downloadCompressFile(uri)
            }
        case 102:
            if(mainController != nil){
                mainController!.viewDidLoad()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        case 103:
            self.dismissViewControllerAnimated(true, completion: nil)
        case btnDownload.tag:
            switch classType{
            case 0:
                if(!downloading && !updateComplete){
                    downloadCompressFile(uri)
//                    var mDownloadThread = DownloadThread.shareInstance()
//                    mDownloadThread.controller = self
//                    if(!(mDownloadThread.isRun == nil)){
//                        if(mDownloadThread.isRun!){
//                            threadIsRunning(mDownloadThread)
//                        }else{
//                            threadIsNoRunning(mDownloadThread)
//                        }
//                    }
                    runInBackground()
                }else if(!downloading && updateComplete){
                    if(mainController != nil){
                        mainController!.viewDidLoad()
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            default:
                if(!downloading){
                    RemindDetailController.showMessage("PUBLIC_08".localizedString(),
                        msg:"DLD001_18".localizedString(),
                        buttons:["PUBLIC_06".localizedString(), "PUBLIC_07".localizedString()],
                        delegate: self)
                }
            }
        default:
            println("nothing")
        }
    }
    
    func threadIsRunning(mDownloadThread: DownloadThread){
        mProgress = mDownloadThread.progress!
        downloading = true
        updateComplete = false
        lblProgress.text = ""
        load(gaiLoading)
        showProgress()
        hideDownloadBtn()
        if(!(mProgress == nil)){
            mProgress!.setUserInfoObject("DO SOME", forKey: "11111")
            mProgress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
        }
    }
    
    func threadIsNoRunning(mDownloadThread: DownloadThread){
        mDownloadThread.progress = NSProgress(totalUnitCount: 1)
        mProgress = mDownloadThread.progress!
        mQueue.addOperation(mDownloadThread)
//        if(!(mProgress == nil)){
//            mProgress!.setUserInfoObject("DO SOME", forKey: "11111")
//            mProgress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
//        }
    }
    
    /**
     * 显示进度
     */
    func showProgress(){
        lblProgress.hidden = false
    }
    
    /**
     * 隐藏进度
     */
    func dimisProgress(){
        lblProgress.hidden = true
    }
    
    /**
     * 显示 开始下载/重新下载
     */
    func showDownloadBtn(){
        switch classType{
        case 0:
            btnDownload.setBackgroundImage(UIImage(named: "DLD00101"), forState: UIControlState.Normal)
        case 1:
            btnDownload.setBackgroundImage(UIImage(named: "dld009"), forState: UIControlState.Normal)
        default:
            println("nothing")
        }
        btnDownload.enabled = true
    }
    
    /**
     * 显示 立即使用
     */
    func showUseBtn(){
        btnDownload.setBackgroundImage(UIImage(named: "DLD00102"), forState: UIControlState.Normal)
        btnDownload.enabled = true
    }
    
    /**
     * 隐藏 开始下载/重新下载
     */
    func hideDownloadBtn(){
        switch classType{
        case 0:
            btnDownload.setBackgroundImage(UIImage(named: "DLD00105"), forState: UIControlState.Normal)
        case 1:
            btnDownload.setBackgroundImage(UIImage(named: "dld008"), forState: UIControlState.Normal)
        default:
            println("nothing")
        }
        btnDownload.enabled = false
    }

    /**
     * 下载压缩文件
     */
    func downloadCompressFile(uri: String){
        var request = NSURLRequest(URL: NSURL(string: uri), cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval:  (30 * 60) * 24)
        
        let session = AFHTTPSessionManager()
        
        mProgress = NSProgress(totalUnitCount: 1)

        downloading = true
        updateComplete = false
        self.lblProgress.text = ""
        
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let unzipPath = folder.stringByAppendingPathComponent(filePath)
        // 删除文件
        fileManager.removeItemAtPath(unzipPath, error: nil)
        
        load(gaiLoading)
        
        self.showProgress()
        var downloadTask = session.downloadTaskWithRequest(request, progress: &mProgress, destination: {(file, response) in self.pathUrl},
            completionHandler:{
                response, localfile, error in
                if(error == nil){
                    println("下载成功解压文件")
                    self.unzipFile()
                }else{
                    println("下载失败")
                    println(error)
                    self.downloading = false
                    self.loadProgress = "DLD001_03".localizedString()
                    self.lblProgress.text = self.loadProgress
                    self.showDownloadBtn()
                    self.disMiss(self.gaiLoading)
                }
        })
        downloadTask.resume()
        
        hideDownloadBtn()
        
        // 设置这个progress的唯一标示符
        mProgress!.setUserInfoObject("DO SOME", forKey: "11111")
        downloadTask.resume()
        
        // 给这个progress添加监听任务
        mProgress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    }
    
    /**
     * 获取文件路径
     */
    var pathUrl: NSURL{
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let path = folder.stringByAppendingPathComponent(filePath)
            let url = NSURL(fileURLWithPath: path)
            return url
    }
    
    /**
     * 展开压缩文件
     */
    func unzipFile(){
        var unzip:ZipArchive = ZipArchive()
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let zipPath = folder.stringByAppendingPathComponent(filePath)
        let unzipPath = folder.stringByAppendingPathComponent(unZipPath)
        // 删除文件夹
        fileManager.removeItemAtPath(unzipPath, error: nil)
        // 创建文件夹
        fileManager.createDirectoryAtPath(unzipPath, withIntermediateDirectories:true, attributes:nil, error:nil)
        if(unzip.UnzipOpenFile(zipPath)){
            // 解压文件
            var result = unzip.UnzipFileTo(unzipPath, overWrite:true);
            if(result){
                println("解压成功")
                loadProgress = "DLD001_05".localizedString()
                updateComplete = true
                if(classType == 0){
                    showUseBtn()
                }else{
                    showDownloadBtn()
                }
            }else{
                println("解压失败")
                loadProgress = "DLD001_07".localizedString()
                showDownloadBtn()
            }
            self.disMiss(gaiLoading)
            self.lblProgress.text = loadProgress
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
            loadProgress = "DLD001_07".localizedString()
            self.lblProgress.text = loadProgress
            showDownloadBtn()
            self.disMiss(gaiLoading)
        }
        downloading = false
    }
    
    /**
     * 在后台执行
     */
    func runInBackground(){
        let app = UIApplication.sharedApplication()
        var backgroundTask = app.beginBackgroundTaskWithExpirationHandler { () -> Void in
            println("run in background...Over")
        }
    }
    
    /**
     * 获取设备剩余存储空间
     */
    class func getMemorySize() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileSysAttributes:NSDictionary = fileManager.attributesOfFileSystemForPath(folder, error: nil)!
        var freeSpace: AnyObject? = fileSysAttributes.objectForKey(NSFileSystemFreeSize as AnyObject)
        var totalSpace: AnyObject? = fileSysAttributes.objectForKey(NSFileSystemSize as AnyObject)
        
        var formatter:NSNumberFormatter = NSNumberFormatter()
        formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        formatter.positiveFormat = "0.00;"
        
        return formatter.stringFromNumber(("\(freeSpace!)" as NSString).doubleValue/1024.0/1024.0/1024.0)
    }
    
    /**
     * 将文件解压并拷贝到指定路径
     */
    func copyResource2Cache(unZipPath:String){
        //将文件拷贝到路径
        let fileMan:NSFileManager = NSFileManager.defaultManager();
        let mDocumentFolder = NSHomeDirectory() + "/Documents/"
        let path = mDocumentFolder.stringByAppendingPathComponent(unZipPath)
        // 文件不存在
        if(!fileMan.fileExistsAtPath(path)){
            let resourcePath = NSBundle.mainBundle().pathForResource("Resource", ofType: "zip")
            
        }
    }
    
    func load(gaiLoading: UIActivityIndicatorView) ->
        Bool{
            gaiLoading.hidden = false
            gaiLoading.startAnimating()
            return false
    }
    
    func disMiss(gaiLoading: UIActivityIndicatorView) ->
        Bool{
            gaiLoading.stopAnimating()
            gaiLoading.hidden = true
            return false
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}