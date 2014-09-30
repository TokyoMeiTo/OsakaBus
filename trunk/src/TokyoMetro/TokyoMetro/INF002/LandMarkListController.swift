//
//  LandMarkListController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation

class LandMarkListController: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource, GPSDelegate{
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    /* 起点軽度   */
    let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼

    /* GPSHelper */
    let GPShelper:GPSHelper = GPSHelper()
    /* 地标一览 */
    var landMarks:Array<MstT04LandMarkTable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        landMarks = selectLandMarkTable("景点")
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 查询按钮点击事件
//        var searchButton:UIBarButtonItem? = self.navigationItem.rightBarButtonItem
//        searchButton!.target = self
//        searchButton!.action = "buttonAction:"
        self.navigationItem.rightBarButtonItem = nil
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case self.navigationItem.rightBarButtonItem!:
            var landMarkSearchController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarksearch") as LandMarkSearchController
            self.navigationController!.pushViewController(landMarkSearchController, animated:true)
        default:
            println("nothing")
        }
    }
    
    /**
     * 加载当前位置
     */
    func loadLocation(){
        if(GPShelper.delegate == nil){
            GPShelper.delegate = self
        }
        GPShelper.updateLocation()
    }
    
    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation){

    }
    
    /**
     * 从DB查询地标信息
     */
    func selectLandMarkTable(type:String) -> Array<MstT04LandMarkTable>{
        var daoINF002 = INF002Dao()
        landMarks = daoINF002.queryLandMarks(type) as? Array<MstT04LandMarkTable>
        return landMarks!
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        var landMarkDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkdetail") as LandMarkDetailController
        landMarkDetailController.title = "地标详细"
        landMarkDetailController.landMark = landMarks![didSelectRowAtIndexPath.row]
        self.navigationController!.pushViewController(landMarkDetailController, animated:true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landMarks!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            if(subview.isKindOfClass(UILabel)){
                subview.removeFromSuperview()
            }
        }
        // cell显示内容
        var imgLandMark = UIImage(named: "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_IMAG_ID1))")
        if("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" == "皇居"){
            imgLandMark = UIImage(named: "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_IMAG_ID2))")
        }
        
        var imageViewLandMark = UIImageView(frame: CGRectMake(5, 5, tableView.frame.width - 10, 170))
        imageViewLandMark.image = imgLandMark
        cell.addSubview(imageViewLandMark)
        
        var lblLandMark = UILabel(frame: CGRect(x:5,y:150,width:tableView.frame.width - 10,height:25))
        lblLandMark.alpha = 0.5
        lblLandMark.backgroundColor = UIColor.grayColor()
        lblLandMark.font = UIFont.boldSystemFontOfSize(13)
        lblLandMark.textColor = UIColor.whiteColor()
        lblLandMark.text = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
        lblLandMark.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLandMark)
        
//        cell.textLabel?.text = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
        
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
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}