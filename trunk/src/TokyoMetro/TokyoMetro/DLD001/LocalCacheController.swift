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
    @IBOutlet weak var tbList: UITableView!

    var classType:Int = 0
    
    let uri:String = "http://192.168.1.84/Resource.zip"
    let filePath:String = "Resource.zip"
    let unZipPath:String = "TokyoMetroCache"
    var lblMobileSize = UILabel(frame: CGRect(x:15,y:5,width:290,height:80))
    
    /* NSFileManager */
    let fileManager = NSFileManager()
    var progress:NSProgress?
    var updateComplete:Bool = false
    var canUpdate:Bool = false
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    var downloading:Bool = false
    var loadProgress:String = "正在下载：20KB/10KB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intitValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func intitValue(){
        loadItems()
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbList.reloadData()
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
        default:
            println("nothing")
        }
    }
    
//    func download (uri:String){
//        // 定义一个progress指针
//        var progress:NSProgress?
//        
//        // 创建一个URL链接
//       // NSURL *url = [NSURL URLWithString:\
//        //@"http://wallpapers.wallbase.cc/rozne/wallpaper-3020771.jpg"];
//        
//        // 初始化一个请求
//        var request:NSURLRequest = NSURLRequest(URL: NSURL(string: uri))
//        
//        // 获取一个Session管理器
//       let session = AFHTTPSessionManager()
//        
//        // 开始下载任务
////        var downloadTask:NSURLSessionDownloadTask = session.downloadTaskWithRequest(request, progress:&progress, destination:{(file, response) in self.pathUrl}, completionHandler:{
////            response, localfile, error in
////            if(error == nil){
////                println("下载成功解压文件")
////                self.unzipFile()
////            }else{
////                println("下载失败")
////                self.downloading = false
////            }
////            });
//        
//         var downloadTask:NSURLSessionDownloadTask  = session.downloadTaskWithRequest(request, progress: &progress, destination: {
//            (file, response) in
//            
//            var documentsDirectoryURL:NSURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory , inDomain:.UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
//            
//           // var documentsDirectoryURL:NSURL = [NSFileManager.defaultManager.URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            
//            
//            
//            // 根据网址信息拼接成一个完整的文件存储路径并返回给block
//            return documentsDirectoryURL.URLByAppendingPathComponent(response.suggestedFilename!);
//            
//            
//            },
//            completionHandler:
//            {
//                response, localfile, error in
//                if(error == nil){
//                    println("下载成功解压文件")
//                    self.unzipFile()
//                }else{
//                    println("下载失败")
//                    self.downloading = false
//                }
//                
//                progress?.removeObserver(self, forKeyPath: "fractionCompleted", context: nil)
//                // 结束后移除掉这个progress
////                progress removeObserver:self
////                    forKeyPath:@"fractionCompleted"
////                context:NULL];
//                
//        })
//        
//        // 设置这个progress的唯一标示符
//        //[progress setUserInfoObject:@"someThing" forKey:@"Y.X."];
//        progress?.setUserInfoObject("DO SOME", forKey: "11111")
//        downloadTask.resume()
//        
//        // 给这个progress添加监听任务
//        progress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
//    }
    
    /**
     * 下载压缩文件
     */
    func downloadCompressFile(uri: String){
        var request = NSURLRequest(URL: NSURL(string: uri))
        
        let session = AFHTTPSessionManager()
        
        progress = NSProgress(totalUnitCount: 1)

        downloading = true
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let unzipPath = folder.stringByAppendingPathComponent(unZipPath)
        // 删除文件夹
        fileManager.removeItemAtPath(unzipPath, error: nil)
        // 创建文件夹
        fileManager.createDirectoryAtPath(unzipPath, withIntermediateDirectories:true, attributes:nil, error:nil)
        var downloadTask = session.downloadTaskWithRequest(request, progress: &progress, destination: {(file, response) in self.pathUrl},
            completionHandler:
            {
                response, localfile, error in
                if(error == nil){
                    println("下载成功解压文件")
                    self.unzipFile()
                }else{
                    println("下载失败")
                    self.downloading = false
                }
        })
        downloadTask.resume()
        
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
            //println(progress.fractionCompleted);
            loadProgress = "正在下载:\(progress.fractionCompleted * 100)%"
            lblMobileSize.text = loadProgress
        }

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
                updateComplete = true
                tbList.reloadData()
            }else{
                println("解压失败")
            }
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
        }
        downloading = false
    }
    
    /**
     * 读取文件
     */
    class func readFile(name:String) -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("/TokyoMetroCache/Resource/Landmark/" + name + ".png")
        println(path)
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        if(didSelectRowAtIndexPath.section == 0){
            var cell = tableView.cellForRowAtIndexPath(didSelectRowAtIndexPath)
            cell!.selected = false
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var UIHeader:UIView = UIView(frame: CGRect(x:0,y:0,width:tableView.frame.width,height:80))
        switch classType{
        case 0:
            switch section{
            case 1:
                var lblText = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:80))
                lblText.numberOfLines = 0
                lblText.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblText.textColor = UIColor.lightGrayColor()
                lblText.font = UIFont.systemFontOfSize(14)
                lblText.text = "本应用的地标功能中将用到一定的缓存图片,点击'下载数据'或'重新下载'按钮, 将下载功能所需图片等数据,如不下载可能会影响到本应用的使用。"
                lblText.textAlignment = NSTextAlignment.Left
                UIHeader.addSubview(lblText)
                return UIHeader
            case 2:
                var lblMobileSize = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:80))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(16)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = loadProgress
                lblMobileSize.textAlignment = NSTextAlignment.Center
                UIHeader.addSubview(lblMobileSize)
                return UIHeader
            default:
                return UIHeader
            }
        default:
            switch section{
            case 1:
                var lblText = UILabel(frame: CGRect(x:15,y:5,width:tableView.frame.width - 30,height:80))
                lblText.numberOfLines = 0
                lblText.lineBreakMode = NSLineBreakMode.ByCharWrapping
                lblText.textColor = UIColor.lightGrayColor()
                lblText.font = UIFont.systemFontOfSize(14)
                lblText.text = "本应用的地标功能中将用到一定的缓存图片,点击'下载数据'或'重新下载'按钮, 将下载功能所需图片等数据,如不下载可能会影响到本应用的使用。"
                lblText.textAlignment = NSTextAlignment.Left
                UIHeader.addSubview(lblText)
                return UIHeader
            case 2:
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(16)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = loadProgress
                lblMobileSize.textAlignment = NSTextAlignment.Center
                UIHeader.addSubview(lblMobileSize)
                return UIHeader
            default:
                return UIHeader
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 1:
            return 90
        case 2:
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
        default:
            return 50
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
                
                var lblCacheVersion = UILabel(frame: CGRect(x:120,y:20,width:tableView.frame.width,height:40))
                lblCacheVersion.backgroundColor = UIColor.clearColor()
                lblCacheVersion.font = UIFont.systemFontOfSize(15)
                lblCacheVersion.textColor = UIColor.blackColor()
                lblCacheVersion.text = "缓存版本: 1.0"
                lblCacheVersion.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheVersion)
                
                var lblCacheSize = UILabel(frame: CGRect(x:120,y:50,width:tableView.frame.width,height:40))
                lblCacheSize.backgroundColor = UIColor.clearColor()
                lblCacheSize.font = UIFont.systemFontOfSize(15)
                lblCacheSize.textColor = UIColor.blackColor()
                lblCacheSize.text = "缓存大小: 10M"
                lblCacheSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheSize)
                
                var lblMobileSize = UILabel(frame: CGRect(x:120,y:80,width:tableView.frame.width,height:40))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(15)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = "剩余容量: 10G"
                lblMobileSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblMobileSize)
            case 1:
                if(!updateComplete){
                    var btnDownload:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    btnDownload.frame = CGRect(x:(tableView.frame.width - 220)/2,y:5,width:220,height:50)
                    var imgDownload = UIImage(named: "DLD00101.png")
                    btnDownload.setBackgroundImage(imgDownload, forState: UIControlState.Normal)
                    //btnDownload.setTitle("开始下载", forState: UIControlState.Normal)
                    btnDownload.tag = 101
                    
                    btnDownload.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell.backgroundColor = UIColor.clearColor()
                    cell.addSubview(btnDownload)
                }else{
                    var btnUse:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    btnUse.frame = CGRect(x:(tableView.frame.width - 220)/2,y:5,width:220,height:50)
                    var imgUse = UIImage(named: "DLD00102.png")
                    btnUse.setBackgroundImage(imgUse, forState: UIControlState.Normal)
                    //btnUse.setTitle("立即使用", forState: UIControlState.Normal)
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
                
                var lblCacheVersion = UILabel(frame: CGRect(x:120,y:20,width:tableView.frame.width,height:40))
                lblCacheVersion.backgroundColor = UIColor.clearColor()
                lblCacheVersion.font = UIFont.systemFontOfSize(15)
                lblCacheVersion.textColor = UIColor.blackColor()
                lblCacheVersion.text = "缓存版本: 1.0"
                lblCacheVersion.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheVersion)
                
                var lblCacheSize = UILabel(frame: CGRect(x:120,y:50,width:tableView.frame.width,height:40))
                lblCacheSize.backgroundColor = UIColor.clearColor()
                lblCacheSize.font = UIFont.systemFontOfSize(15)
                lblCacheSize.textColor = UIColor.blackColor()
                lblCacheSize.text = "缓存大小: 10M"
                lblCacheSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblCacheSize)
                
                var lblMobileSize = UILabel(frame: CGRect(x:120,y:80,width:tableView.frame.width,height:40))
                lblMobileSize.backgroundColor = UIColor.clearColor()
                lblMobileSize.font = UIFont.systemFontOfSize(15)
                lblMobileSize.textColor = UIColor.blackColor()
                lblMobileSize.text = "剩余容量: 10G"
                lblMobileSize.textAlignment = NSTextAlignment.Left
                cell.addSubview(lblMobileSize)
            case 1:
                var btnDownload:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                btnDownload.frame = CGRect(x:(tableView.frame.width - 220)/2,y:5,width:220,height:50)
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
    return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.section == 0){
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            cell!.selected = false
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //items.removeObjectAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}