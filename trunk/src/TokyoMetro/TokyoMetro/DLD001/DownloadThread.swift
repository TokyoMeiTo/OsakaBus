//
//  DownloadTherd.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/29.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

/**
 * 用于计时线程
 */
class DownloadThread: NSOperation{
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
    let DOCUMENT_FOLDER = NSHomeDirectory() + "/Documents/"
    
    let FILE_MANAGER = NSFileManager()
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/

    var controller:LocalCacheController?
    
    var isRun:Bool?
    
    var progress:NSProgress?
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    
    /*******************************************************************************
    *      Implements Of NSOperation
    *******************************************************************************/
    
    private override init(){
    }
    
    override func start() {
        super.start()
        isRun = true
    }
    
    override func main() {
        downloadFile()
    }
    
    override func cancel() {
        super.cancel()
    }
    
    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     * 创建单例
     */
    class func shareInstance()->DownloadThread{
        struct qzSingle{
            static var predicate:dispatch_once_t = 0;
            static var instance:DownloadThread? = nil
        }
        if(qzSingle.instance == nil){
            qzSingle.instance = DownloadThread()
            qzSingle.instance!.isRun = false
        }else if(qzSingle.instance!.finished){
            qzSingle.instance = DownloadThread()
            qzSingle.instance!.isRun = false
        }
        return qzSingle.instance!
    }
    
    /**
     * 下载压缩文件
     */
    func downloadFile(){
        if(controller == nil){
            return
        }
        
        var request = NSURLRequest(URL: NSURL(string: controller!.uri), cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval:  (30 * 60) * 24)
        
        let session = AFHTTPSessionManager()
        
//        controller!.progress = NSProgress(totalUnitCount: 1)
        
        controller!.downloading = true
        controller!.updateComplete = false
        controller!.lblProgress.text = ""
        
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let unzipPath = folder.stringByAppendingPathComponent(controller!.filePath)
        // 删除文件
        FILE_MANAGER.removeItemAtPath(unzipPath, error: nil)
        
        controller!.load(controller!.gaiLoading)
        
        controller!.showProgress()
        var downloadTask = session.downloadTaskWithRequest(request, progress: &progress, destination: {(file, response) in self.controller!.pathUrl},
            completionHandler:{
                response, localfile, error in
                if(error == nil){
                    println("下载成功解压文件")
                    self.unzipFile()
                }else{
                    println("下载失败")
                    println(error)
                    self.controller!.downloading = false
                    self.controller!.loadProgress = "DLD001_03".localizedString()
                    self.controller!.lblProgress.text = self.controller!.loadProgress
                    self.controller!.showDownloadBtn()
                    self.controller!.disMiss(self.controller!.gaiLoading)
                }
        })
        downloadTask.resume()
        
        self.controller!.hideDownloadBtn()
        
        // 设置这个progress的唯一标示符
        self.controller!.mProgress!.setUserInfoObject("DO SOME", forKey: "11111")
        
        // 给这个progress添加监听任务
        self.controller!.mProgress!.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    }
    
    /**
     * 展开压缩文件
     */
    func unzipFile(){
        var unzip:ZipArchive = ZipArchive()
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let zipPath = folder.stringByAppendingPathComponent(self.controller!.filePath)
        let unzipPath = folder.stringByAppendingPathComponent(self.controller!.unZipPath)
        // 删除文件夹
        FILE_MANAGER.removeItemAtPath(unzipPath, error: nil)
        // 创建文件夹
        FILE_MANAGER.createDirectoryAtPath(unzipPath, withIntermediateDirectories:true, attributes:nil, error:nil)
        if(unzip.UnzipOpenFile(zipPath)){
            // 解压文件
            var result = unzip.UnzipFileTo(unzipPath, overWrite:true);
            if(result){
                println("解压成功")
                controller!.loadProgress = "DLD001_05".localizedString()
                controller!.updateComplete = true
                if(controller!.classType == 0){
                    controller!.showUseBtn()
                }else{
                    controller!.showDownloadBtn()
                }
            }else{
                println("解压失败")
                controller!.loadProgress = "DLD001_07".localizedString()
                controller!.showDownloadBtn()
            }
            controller!.disMiss(controller!.gaiLoading)
            controller!.lblProgress.text = controller!.loadProgress
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
            controller!.loadProgress = "DLD001_07".localizedString()
            controller!.lblProgress.text = controller!.loadProgress
            controller!.showDownloadBtn()
            controller!.disMiss(controller!.gaiLoading)
        }
        controller!.downloading = false
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}