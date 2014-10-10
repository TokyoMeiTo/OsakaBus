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
//    /* 更新缓存 */
//    @IBOutlet weak var btnUpdateCache: UIButton!
//    /* 更新进度 */
//    @IBOutlet weak var pvProgress: UIProgressView!

    let uri:String = "http://www.sa.is/media/1039/example.pdf"
    let filePath:String = "test.pdf"
    
    /* TableView条目 */
    var items: NSMutableArray = NSMutableArray.array()
    
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
        downloadCompressFile(uri)
    }
    
    func loadItems(){
        items = NSMutableArray.array()
        items.addObject(["",[""]])
        items.addObject(["",[""]])
        items.addObject(["",[""]])
    }
    
    /**
     * 下载压缩文件
     */
    func downloadCompressFile(uri: String){
        var request = NSURLRequest(URL: NSURL(string: uri))
        
        let session = AFHTTPSessionManager()
        
        var progress: NSProgress?
//        pvProgress.progress = progress
        
        var downloadTask = session.downloadTaskWithRequest(request, progress: &progress, destination: {(file, response) in self.pathUrl},
            completionHandler:
            {
                response, localfile, error in
                println("response \(response)")
                println("localfile \(localfile)")
                println("error \(error)")
        })
        downloadTask.resume()
    }
    
    var pathUrl: NSURL
        {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let path = folder.stringByAppendingPathComponent(filePath)
            let url = NSURL(fileURLWithPath: path)
            return url
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
            lblMobileSize.text = "正在下载：20KB/10KB"
            lblMobileSize.textAlignment = NSTextAlignment.Center
            UIHeader.addSubview(lblMobileSize)
            return UIHeader
        default:
            return UIHeader
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 1:
            return 90
        case 2:
            return 90
        default:
            return 25
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
            return 43
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        switch indexPath.section{
        case 0:
            var imgCache = UIImage(named: "INF00206")
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
            btnDownload.frame = CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30)
            btnDownload.setTitle("开始下载", forState: UIControlState.Normal)
            btnDownload.tag = 101
            
            //cell.backgroundColor = UIColor.clearColor()
            cell.addSubview(btnDownload)
        case 2:
            var btnUse:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnUse.frame = CGRect(x:15,y:5,width:tableView.frame.width - 30,height:30)
            btnUse.setTitle("立即使用", forState: UIControlState.Normal)
            btnUse.tag = 101
            
            //cell.backgroundColor = UIColor.clearColor()
            cell.addSubview(btnUse)
        default:
            return cell
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