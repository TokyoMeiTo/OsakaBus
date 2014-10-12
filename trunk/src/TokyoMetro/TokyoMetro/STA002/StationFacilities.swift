//
//  StationFacilities.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/10/12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class StationFacilities: UIViewController, UITableViewDelegate, NSObjectProtocol, UIScrollViewDelegate, UITableViewDataSource{
    /* UITableView */
    @IBOutlet weak var tbList: UITableView!
    
    /* 设施一览 */
    var facilities:Array<StaT03ComervialInsideTable>?
    
    var statId:String = "2800101"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        facilities = selectStaT03Table(statId)
        
        tbList.delegate = self
        tbList.dataSource = self
        tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
    * 从DB查询地标信息
    */
    func selectStaT03Table(statId:String) -> Array<StaT03ComervialInsideTable>{
        var staT03Table:StaT03ComervialInsideTable = StaT03ComervialInsideTable()
//        let QUERY_FACILITLES = "select * , ROWID from STAT03_COMERCIAL_INSIDE where LINE_ID LIKE '?%%'"
        
//        facilities = staT03Table.excuteQuery( QUERY_FACILITLES, withArgumentsInArray:[statId]) as? Array<StaT03ComervialInsideTable>
        
        staT03Table.comeInsiId = statId
        facilities = staT03Table.selectLike() as? Array<StaT03ComervialInsideTable>
        return facilities!
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var comercialInsideDetail: ComercialInsideDetail = self.storyboard?.instantiateViewControllerWithIdentifier("ComercialInsideDetail") as ComercialInsideDetail
//        comercialInsideDetail.statId = group_id
        comercialInsideDetail.comeInsiTable = facilities![indexPath.row]
        
        self.navigationController?.pushViewController(comercialInsideDetail, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities!.count
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
        var imgLandMark = UIImage(named: LocalCacheController.readFile("\(facilities![indexPath.row].item(STAT03_COME_INSI_IMAGE))"))
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
        lblLandMark.text = "\(facilities![indexPath.row].item(STAT03_COME_INSI_NAME))"
        lblLandMark.textAlignment = NSTextAlignment.Left
        cell.addSubview(lblLandMark)
        
//        var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        btnFav.frame = CGRect(x:15,y:10,width:40,height:40)
//        
//        var tableUsrT03:INF002FavDao = INF002FavDao()
//        var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_ID))")
//        
//        var imgFav = UIImage(named: "INF00202.png")
//        if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
//            imgFav = UIImage(named: "INF00206.png")
//        }
//        
//        btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
//        btnFav.tag = 101
//        
//        btnFav.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        cell.addSubview(btnFav)
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
