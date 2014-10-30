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

    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/

    var mFilePath:String?
    
    /**
     * 文件路径2Url
     */
    var pathUrl: NSURL{
        if(!(mFilePath == nil)){
            let path = DOCUMENT_FOLDER.stringByAppendingPathComponent(mFilePath!)
            let url:NSURL = NSURL(fileURLWithPath: path)
            return url
        }
        return NSURL()
    }

    
    /*******************************************************************************
    *      Implements Of NSOperation
    *******************************************************************************/
    
    private override init(){
    }
    
    override func start() {
        super.start()
    }
    
    override func main() {
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
        }else if(qzSingle.instance!.finished){
            qzSingle.instance = DownloadThread()
        }
        return qzSingle.instance!
    }
    
    /**
     * 下载压缩文件
     */
    func downloadFile(uri: String,zipFileNm: String,unzipFileNm: String,progress: NSProgress?){
        mFilePath = zipFileNm
        
        var request = NSURLRequest(URL: NSURL(string: uri), cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval:  (30 * 60) * 24)
        let session = AFHTTPSessionManager()
        
        let zipFilePath = DOCUMENT_FOLDER.stringByAppendingPathComponent(zipFileNm)
        
        // 删除原文件
        FILE_MANAGER.removeItemAtPath(unzipFileNm, error:nil)
        // 开始下载
//        var downloadTask = session.downloadTaskWithRequest(request, progress: &progress, destination: {
//                (file, response) in self.pathUrl
//            },
//            completionHandler:{
//                response, localfile, error in
//                if(error == nil){
//                    println("下载成功解压文件")
//                    self.unzipFile(zipFilePath,unzipFileNm: unzipFileNm)
//                }else{
//                    println("下载失败")
//                    println(error)
//                }
//        })
//        downloadTask.resume()
    }
    
    /**
     * 展开压缩文件
     */
    func unzipFile(zipFileNm: String,unzipFileNm: String){
        var unzip:ZipArchive = ZipArchive()
        let zipPath = DOCUMENT_FOLDER.stringByAppendingPathComponent(zipFileNm)
        let unzipPath = DOCUMENT_FOLDER.stringByAppendingPathComponent(unzipFileNm)
        // 删除文件夹
        FILE_MANAGER.removeItemAtPath(unzipPath, error: nil)
        // 创建文件夹
        FILE_MANAGER.createDirectoryAtPath(unzipPath, withIntermediateDirectories:true, attributes:nil, error:nil)
        if(unzip.UnzipOpenFile(zipPath)){
            // 解压文件
            var result = unzip.UnzipFileTo(unzipPath, overWrite:true);
            if(result){
                println("解压成功")
            }else{
                println("解压失败")
            }
            unzip.UnzipCloseFile()
        }else{
            println("解压失败")
        }
    }
    
    
    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}