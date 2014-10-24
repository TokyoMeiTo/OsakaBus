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

    let uri:String = "http://192.168.1.84/Resource.zip"//"http://www.okasan.net/Resource.zip"//"http://osakabus.sinaapp.com/Resource.zip"
    let filePath:String = "Resource.zip"
    let unZipPath:String = "TokyoMetroCache"

    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    var classType:Int = 0

    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* NSFileManager */
    let fileManager = NSFileManager()
    var progress:NSProgress?
    var updateComplete:Bool = false
    var canUpdate:Bool = false
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    var downloading:Bool = false
    var UIloading:Bool = false
    var loadProgress:String? = ""
    var tipText:String = "数据下载完成前,您将无法使用本产品。下载数据时,建议使用WIFI方式。若使用3G/2G下载将产生流量费用。资费标准请咨询通讯运营商。"
    
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
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/

    // after animation
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int){
        switch buttonIndex{
        case 0:
            downloadCompressFile(uri)
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
        lblCacheSize.text = "DLD001_13".localizedString() + "83.5 MB"
        lblMoibleSize.text = "DLD001_14".localizedString() + "\(LocalCacheController.getMemorySize())GB"
        lblTip.text = tipText
        lblTip.numberOfLines = 0
        lblTip.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        lblTip2.text = "请耐心等待下载完成,中途退出会中断下载"
        
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
    
    func loadItems(){
        switch classType{
        case 0:
            items = NSMutableArray.array()
            items.addObject(["",[""]])
            items.addObject(["",[""]])
            items.addObject(["",[""]])
        default:
            items = NSMutableArray.array()
            items.addObject(["",[""]])
            items.addObject(["",[""]])
            items.addObject(["",[""]])
        }
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case 101:
            if(!downloading){
                downloadCompressFile(uri)
            }
        case 102:
            self.dismissViewControllerAnimated(true, completion: nil)
        case 103:
            self.dismissViewControllerAnimated(true, completion: nil)
        case btnDownload.tag:
            switch classType{
            case 0:
                if(!downloading && !updateComplete){
                    downloadCompressFile(uri)
                }else if(!downloading && updateComplete){
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            default:
                if(!downloading){
                    RemindDetailController.showMessage("PUBLIC_08".localizedString(),
                        msg:"确定要重新下载?",
                        buttons:["PUBLIC_06".localizedString(), "PUBLIC_07".localizedString()],
                        delegate: self)
                }
            }
        default:
            println("nothing")
        }
    }
    
    func showProgress(){
        lblProgress.hidden = false
    }
    
    func dimisProgress(){
        lblProgress.hidden = true
    }
    
    func showDownloadBtn(){
        switch classType{
        case 0:
            btnDownload.setBackgroundImage(UIImage(named: "DLD00101.png"), forState: UIControlState.Normal)
        case 1:
            btnDownload.setBackgroundImage(UIImage(named: "dld009.png"), forState: UIControlState.Normal)
        default:
            println("nothing")
        }
        btnDownload.enabled = true
    }
    
    func showUseBtn(){
        btnDownload.setBackgroundImage(UIImage(named: "DLD00102.png"), forState: UIControlState.Normal)
        btnDownload.enabled = true
    }
    
    func hideDownloadBtn(){
        switch classType{
        case 0:
            btnDownload.setBackgroundImage(UIImage(named: "DLD00105.png"), forState: UIControlState.Normal)
        case 1:
            btnDownload.setBackgroundImage(UIImage(named: "dld008.png"), forState: UIControlState.Normal)
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
        
        progress = NSProgress(totalUnitCount: 1)

        downloading = true
        updateComplete = false
        
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let unzipPath = folder.stringByAppendingPathComponent(filePath)
        // 删除文件
        fileManager.removeItemAtPath(unzipPath, error: nil)
        
        load(gaiLoading)
        
        var downloadTask = session.downloadTaskWithRequest(request, progress: &progress, destination: {(file, response) in self.pathUrl},
            completionHandler:
            {
                response, localfile, error in
                if(error == nil){
                    println("下载成功解压文件")
//                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                        self.lblProgress.text = "下载成功解压文件..."
//                    }
                    self.unzipFile()
                }else{
                    println("下载失败")
                    println(error)
                    // 在子线程中更新UI
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.downloading = false
                        self.loadProgress = "DLD001_04".localizedString()
                        self.lblProgress.text = "DLD001_03".localizedString()
                        self.btnDownload.setBackgroundImage(UIImage(named: "DLD00101.png"), forState: UIControlState.Normal)
                        self.disMiss(self.gaiLoading)
                    }
                }
        })
        downloadTask.resume()
        
        hideDownloadBtn()
        
        // 设置这个progress的唯一标示符
        progress?.setUserInfoObject("DO SOME", forKey: "11111")
        downloadTask.resume()
        
        // 给这个progress添加监听任务
        progress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    }
    
    /**
     * NSProgress监听事件
     */
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        if (keyPath=="fractionCompleted") {
            var progress:NSProgress = object as NSProgress;
            if(countElements("\(progress.fractionCompleted)") > 5 && progress.fractionCompleted > 0.0001){
                // 在子线程中更新UI
                dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                    self.showProgress()
                    var formatter:NSNumberFormatter = NSNumberFormatter()
                    formatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
                    formatter.positiveFormat = "0.00;"
                    
                    var progressTemp = formatter.stringFromNumber(progress.fractionCompleted * 100) //"\(progress.fractionCompleted * 100)".left(5)
                    self.loadProgress = "DLD001_09".localizedString() + ": " + "\(progressTemp)" + " %"
                    //self.tbList.reloadData()
                    self.lblProgress.text = self.loadProgress
                }
            }
        }
    }
    
    func convertProgress(progress:String?) -> String{
        var tempStr = "01234"
        
        var indexTo = tempStr.rangeOfString("4")
        
        if(progress == nil){
            return ""
        }
        return progress!.substringToIndex(indexTo!.endIndex) + "%"
    }
    
    var pathUrl: NSURL
        {
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
                loadProgress = "DLD001_06".localizedString()
                updateComplete = true
                self.lblProgress.text = "下载成功"
                if(classType == 0){
                    showUseBtn()
                    self.disMiss(gaiLoading)
                }else{
                    showDownloadBtn()
                    self.disMiss(gaiLoading)
                }
            }else{
                println("解压失败")
                loadProgress = "DLD001_04".localizedString()
                self.lblProgress.text = "DLD001_03".localizedString()
                showDownloadBtn()
                self.disMiss(gaiLoading)
            }
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
            loadProgress = "DLD001_04".localizedString()
            self.lblProgress.text = "DLD001_03".localizedString()
            showDownloadBtn()
            self.disMiss(gaiLoading)
        }
        downloading = false
    }
    
    /**
     * 读取文件
     */
    class func readFile(name:String) -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("/TokyoMetroCache/Resource/Landmark/" + name)//  + ".png"
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
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