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
    
    /* 起点軽度 */
    let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼

    /* GPSHelper */
    let GPShelper:GPSHelper = GPSHelper()
    /* 地标一览 */
    var landMarks:Array<MstT04LandMarkTable>?
    /* 地标类型 */
    var landMarkType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        switch landMarkType{
        case 0:
            self.title = "热门景点"
        case 1:
            self.title = "美食"
        case 2:
            self.title = "购物"
        default:
            println("nothing")
        }
        
        landMarks = selectLandMarkTable(landMarkType)
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 查询按钮点击事件
        var searchButton:UIBarButtonItem? = UIBarButtonItem(title: "查找", style: UIBarButtonItemStyle.Plain, target:self, action: "buttonAction:")
        searchButton!.target = self
        searchButton!.action = "buttonAction:"
        self.navigationItem.rightBarButtonItem = searchButton!
        
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
    func selectLandMarkTable(type:Int) -> Array<MstT04LandMarkTable>{
        var daoINF002 = INF002Dao()
        var landMarkTypeStr:String = ""
        switch type{
        case 0:
            landMarkTypeStr = "景点"
        case 1:
            landMarkTypeStr = "美食"
        case 2:
            landMarkTypeStr = "购物"
        default:
            println("nothing")
        }
        
        landMarks = daoINF002.queryLandMarks(landMarkTypeStr) as? Array<MstT04LandMarkTable>
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
        return 170
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        // cell显示内容
        var imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_IMAG_ID1))"))
        if("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" == "皇居"){
            imgLandMark = UIImage(named: LocalCacheController.readFile("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_IMAG_ID2))"))
        }
        var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, tableView.frame.width, 170))
        imageViewLandMark.image = imgLandMark
        cell.addSubview(imageViewLandMark)
        
        var lblTemp = UILabel(frame: CGRect(x:0,y:135,width:tableView.frame.width,height:35))
        lblTemp.alpha = 0.4
        lblTemp.backgroundColor = UIColor.blackColor()
        cell.addSubview(lblTemp)
        
        var lblLandMark = UILabel(frame: CGRect(x:15,y:130,width:tableView.frame.width,height:40))
        lblLandMark.backgroundColor = UIColor.clearColor()
        lblLandMark.font = UIFont.boldSystemFontOfSize(16)
        lblLandMark.textColor = UIColor.whiteColor()
        lblLandMark.text = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
        lblLandMark.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLandMark)
        
        var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btnFav.frame = CGRect(x:15,y:10,width:40,height:40)
        
        var tableUsrT03:INF002FavDao = INF002FavDao()
        var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_ID))")
        
        var imgFav = UIImage(named: "INF00202.png")
        if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
            imgFav = UIImage(named: "INF00206.png")
        }
        
        btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
        btnFav.tag = 101
        
//        btnFav.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(btnFav)
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