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
    /* landMarks */
    var landMarks:Array<String> = ["东京迪士尼","富士山","银座","日本武道馆","东京巨蛋","秋叶原","南禅寺","浅草寺"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 查询按钮点击事件
        var searchButton:UIBarButtonItem? = self.navigationItem.rightBarButtonItem
        searchButton!.target = self
        searchButton!.action = "buttonAction:"
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
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        var landMarkDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkdetail") as LandMarkDetailController
        landMarkDetailController.title = landMarks[didSelectRowAtIndexPath.row]
        self.navigationController!.pushViewController(landMarkDetailController, animated:true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landMarks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = landMarks[indexPath.row]
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