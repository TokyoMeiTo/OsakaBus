//
//  LocalCache.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/10.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LocalCacheController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource{
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

    var classType:Int = 0
    
    let uri:String = "http://192.168.1.84/Resource.zip"//"http://www.okasan.net/Resource.zip"//"http://osakabus.sinaapp.com/Resource.zip"
    let filePath:String = "Resource.zip"
    let unZipPath:String = "TokyoMetroCache"
    
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
    var tipText:String = "DLD001_08".localizedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func intitValue(){
        self.title = "DLD001_01".localizedString()
        self.navigationItem.rightBarButtonItem = nil
        lblProgress.hidden = true
        lblCacheVersion.text = "DLD001_12".localizedString()
        lblCacheSize.text = "DLD001_13".localizedString() + "83593KB"
        lblMoibleSize.text = "DLD001_14".localizedString() + "\(LocalCacheController.getMemorySize())GB"
        lblTip.text = tipText
        lblTip.numberOfLines = 0
        lblTip.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
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
                    downloadCompressFile(uri)
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
        btnDownload.setBackgroundImage(UIImage(named: "DLD00101.png"), forState: UIControlState.Normal)
        btnDownload.enabled = true
    }
    
    func showUseBtn(){
        btnDownload.setBackgroundImage(UIImage(named: "DLD00102.png"), forState: UIControlState.Normal)
        btnDownload.enabled = true
    }
    
    func hideDownloadBtn(){
        btnDownload.setBackgroundImage(UIImage(named: "DLD00105.png"), forState: UIControlState.Normal)
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
                    self.loadProgress = "DLD001_09".localizedString() + "\(progressTemp)" + " %"
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
                }else{
                    showDownloadBtn()
                }
            }else{
                println("解压失败")
                loadProgress = "DLD001_04".localizedString()
                self.lblProgress.text = "DLD001_03".localizedString()
                showDownloadBtn()
            }
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
            loadProgress = "DLD001_04".localizedString()
            self.lblProgress.text = "DLD001_03".localizedString()
        }
        downloading = false
    }
    
    /**
     * 读取文件
     */
    class func readFile(name:String) -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("/TokyoMetroCache/Resource/Landmark/" + name)//  + ".png"
        println(path)
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
        return items.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var lastUIHeader:UIView? = tableView.viewWithTag(110)
//        if(lastUIHeader != nil){
//            lastUIHeader!.removeFromSuperview()
//        }
        
        var uiHeader:UIView = UIView(frame: CGRect(x:0,y:0,width:tableView.frame.width,height:80))
        uiHeader.tag = 110
        
        if(classType == 0){
            switch section{
            case 1:
                var lblTip = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:80))
                lblTip.numberOfLines = 0
                lblTip.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTip.backgroundColor = UIColor.clearColor()
                lblTip.font = UIFont.systemFontOfSize(14)
                lblTip.textColor = UIColor.blackColor()
                lblTip.text = tipText
                lblTip.textAlignment = NSTextAlignment.Left
                uiHeader.addSubview(lblTip)
                
                return uiHeader
            case 2:
                if(downloading){
                    var lblProgressTemp = UILabel(frame: CGRect(x:0,y:5,width:tableView.frame.width/2,height:80))
                    lblProgressTemp.backgroundColor = UIColor.clearColor()
                    lblProgressTemp.font = UIFont.systemFontOfSize(16)
                    lblProgressTemp.textColor = UIColor.blackColor()
                    lblProgressTemp.text = "DLD001_09".localizedString()
                    lblProgressTemp.textAlignment = NSTextAlignment.Right
                    uiHeader.addSubview(lblProgressTemp)
                }else{
                    if(updateComplete || loadProgress != ""){
                        var lblProgressTemp = UILabel(frame: CGRect(x:0,y:5,width:tableView.frame.width/2,height:80))
                        lblProgressTemp.backgroundColor = UIColor.clearColor()
                        lblProgressTemp.font = UIFont.systemFontOfSize(16)
                        lblProgressTemp.textColor = UIColor.blackColor()
                        lblProgressTemp.text = "DLD001_10".localizedString()
                        lblProgressTemp.textAlignment = NSTextAlignment.Right
                        uiHeader.addSubview(lblProgressTemp)
                    }
                }
                var lblMobileSize = UILabel(frame: CGRect(x:tableView.frame.width/2,y:5,width:tableView.frame.width/2,height:80))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(16)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = loadProgress
                lblMobileSize.textAlignment = NSTextAlignment.Left
                uiHeader.addSubview(lblMobileSize)
                return uiHeader
            default:
                return uiHeader
            }
        }else{
            switch section{
            case 1:
                var lblTip = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:80))
                lblTip.numberOfLines = 0
                lblTip.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblTip.backgroundColor = UIColor.clearColor()
                lblTip.font = UIFont.systemFontOfSize(14)
                lblTip.textColor = UIColor.blackColor()
                lblTip.text = tipText
                lblTip.textAlignment = NSTextAlignment.Left
                uiHeader.addSubview(lblTip)
                
                return uiHeader
            case 2:
                if(downloading){
                    var lblProgressTemp = UILabel(frame: CGRect(x:0,y:5,width:tableView.frame.width/2,height:80))
                    lblProgressTemp.backgroundColor = UIColor.clearColor()
                    lblProgressTemp.font = UIFont.systemFontOfSize(16)
                    lblProgressTemp.textColor = UIColor.blackColor()
                    lblProgressTemp.text = "DLD001_09".localizedString()
                    lblProgressTemp.textAlignment = NSTextAlignment.Right
                    uiHeader.addSubview(lblProgressTemp)
                }else{
                    if(updateComplete || loadProgress != ""){
                        var lblProgressTemp = UILabel(frame: CGRect(x:0,y:5,width:tableView.frame.width/2,height:80))
                        lblProgressTemp.backgroundColor = UIColor.clearColor()
                        lblProgressTemp.font = UIFont.systemFontOfSize(16)
                        lblProgressTemp.textColor = UIColor.blackColor()
                        lblProgressTemp.text = "DLD001_10".localizedString()
                        lblProgressTemp.textAlignment = NSTextAlignment.Right
                        uiHeader.addSubview(lblProgressTemp)
                    }
                }
                var lblMobileSize = UILabel(frame: CGRect(x:tableView.frame.width/2,y:5,width:tableView.frame.width/2,height:80))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(16)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = loadProgress
                lblMobileSize.textAlignment = NSTextAlignment.Left
                uiHeader.addSubview(lblMobileSize)
                return uiHeader
            default:
                return uiHeader
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 1,2:
            return 90
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section][0] as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section][1].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 135
        case 1:
            return 250/4
        default:
            return 43
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        switch classType{
        case 0:
            switch indexPath.section{
            case 0:
                var imgCache = UIImage(named: "DLD00104.png")
                var imageViewCache = UIImageView(frame: CGRectMake(15, 30, 80, 80))
                imageViewCache.image = imgCache
                cell.addSubview(imageViewCache)
                
                var lblCacheVersion = UILabel(frame: CGRect(x:120,y:20,width:tableView.frame.width,height:tableView.frame.height/13))
                lblCacheVersion.backgroundColor = UIColor.clearColor()
                lblCacheVersion.font = UIFont.systemFontOfSize(15)
                lblCacheVersion.textColor = UIColor.blackColor()
                lblCacheVersion.text = "缓存版本: 1.0"
                lblCacheVersion.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheVersion)
                
                var lblCacheSize = UILabel(frame: CGRect(x:120,y:50,width:tableView.frame.width,height:tableView.frame.height/13))
                lblCacheSize.backgroundColor = UIColor.clearColor()
                lblCacheSize.font = UIFont.systemFontOfSize(15)
                lblCacheSize.textColor = UIColor.blackColor()
                lblCacheSize.text = "缓存大小: 83593KB"
                lblCacheSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheSize)
                
                var lblMobileSize = UILabel(frame: CGRect(x:120,y:80,width:tableView.frame.width,height:tableView.frame.height/13))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(15)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = "剩余容量: 10G"
                lblMobileSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblMobileSize)
            case 1:
                if(!updateComplete){
                    var btnDownload:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    btnDownload.frame = CGRect(x:(tableView.frame.width - 250)/2,y:0,width:250,height:250/4)
                    var imgDownload = UIImage(named: "DLD00101.png")
                    btnDownload.setBackgroundImage(imgDownload, forState: UIControlState.Normal)
                    btnDownload.tag = 101
                    
                    btnDownload.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell.backgroundColor = UIColor.clearColor()
                    cell.addSubview(btnDownload)
                }else{
                    var btnUse:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    btnUse.frame = CGRect(x:(tableView.frame.width - 250)/2,y:0,width:250,height:250/4)
                    var imgUse = UIImage(named: "DLD00102.png")
                    btnUse.setBackgroundImage(imgUse, forState: UIControlState.Normal)
                    btnUse.tag = 102
                    btnUse.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell.backgroundColor = UIColor.clearColor()
                    cell.addSubview(btnUse)
                }
                
            case 2:
                cell.backgroundColor = UIColor.clearColor()
            default:
                return cell
            }
        default:
            switch indexPath.section{
            case 0:
                var imgCache = UIImage(named: "DLD00104")
                var imageViewCache = UIImageView(frame: CGRectMake(15, 30, 80, 80))
                imageViewCache.image = imgCache
                cell.addSubview(imageViewCache)
                
                var lblCacheVersion = UILabel(frame: CGRect(x:120,y:20,width:tableView.frame.width,height:tableView.frame.height/13))
                lblCacheVersion.backgroundColor = UIColor.clearColor()
                lblCacheVersion.font = UIFont.systemFontOfSize(15)
                lblCacheVersion.textColor = UIColor.blackColor()
                lblCacheVersion.text = "缓存版本: 1.0"
                lblCacheVersion.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheVersion)
                
                var lblCacheSize = UILabel(frame: CGRect(x:120,y:50,width:tableView.frame.width,height:tableView.frame.height/13))
                lblCacheSize.backgroundColor = UIColor.clearColor()
                lblCacheSize.font = UIFont.systemFontOfSize(15)
                lblCacheSize.textColor = UIColor.blackColor()
                lblCacheSize.text = "缓存大小: 10M"
                lblCacheSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheSize)
                
                var lblMobileSize = UILabel(frame: CGRect(x:120,y:80,width:tableView.frame.width,height:tableView.frame.height/13))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(15)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = "剩余容量: 10G"
                lblMobileSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblMobileSize)
            case 1:
                var btnDownload:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                btnDownload.frame = CGRect(x:(tableView.frame.width - 250)/2,y:0,width:250,height: 250/4)
                var imgDownload = UIImage(named: "DLD00101.png")
                btnDownload.setBackgroundImage(imgDownload, forState: UIControlState.Normal)
                //btnDownload.setTitle("重新下载", forState: UIControlState.Normal)
                btnDownload.tag = 101
                
                btnDownload.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.backgroundColor = UIColor.clearColor()
                cell.addSubview(btnDownload)
            case 2:
                cell.backgroundColor = UIColor.clearColor()
            default:
                return cell
            }
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
        }else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //UIloading = false
    }
}