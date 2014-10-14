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
        
        if (facilities?.count > 0) {
            tbList.delegate = self
            tbList.dataSource = self
            tbList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        } else {
            tbList.hidden = true
        }
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
//        var comercialInsideDetail: ComercialInsideDetail = self.storyboard?.instantiateViewControllerWithIdentifier("ComercialInsideDetail") as ComercialInsideDetail
//        comercialInsideDetail.comeInsiTable = facilities![indexPath.row]
//        
//        self.navigationController?.pushViewController(comercialInsideDetail, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        // cell显示内容
//        var imgLandMark: UIImage = UIImage(named: (facilities![indexPath.row].item(STAT03_COME_INSI_IMAGE) as String).getStationInnerComPath())
//        var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, tableView.frame.width, 170))
//        imageViewLandMark.image = imgLandMark
//        cell.addSubview(imageViewLandMark)
//        
//        var lblTemp = UILabel(frame: CGRect(x:0,y:135,width:tableView.frame.width,height:35))
//        lblTemp.alpha = 0.4
//        lblTemp.backgroundColor = UIColor.blackColor()
//        cell.addSubview(lblTemp)
//        
//        var lblLandMark = UILabel(frame: CGRect(x:15,y:130,width:tableView.frame.width,height:40))
//        lblLandMark.backgroundColor = UIColor.clearColor()
//        lblLandMark.font = UIFont.boldSystemFontOfSize(16)
//        lblLandMark.textColor = UIColor.whiteColor()
//        lblLandMark.text = "\(facilities![indexPath.row].item(STAT03_COME_INSI_NAME))"
//        lblLandMark.textAlignment = NSTextAlignment.Left
//        cell.addSubview(lblLandMark)
        
        var imgCompiner: UIImageView = UIImageView(frame: CGRectMake(5, 8, 100, 100))
        imgCompiner.image = UIImage(named: (facilities![indexPath.row].item(STAT03_COME_INSI_IMAGE) as String).getStationInnerComPath())
        
        cell.addSubview(imgCompiner)
        
        var strName = facilities![indexPath.row].item(STAT03_COME_INSI_NAME) as String
        var lblName = UILabel(frame: CGRectMake(115, 5, 200, 21))
        lblName.adjustsFontSizeToFitWidth = true
        lblName.font = UIFont.boldSystemFontOfSize(16)
        lblName.text = strName
        cell.addSubview(lblName)
        
        var imageTime: UIImageView = UIImageView(frame: CGRectMake(115, 33, 14, 14))
        cell.addSubview(imageTime)
        
        var strTime = (facilities![indexPath.row].item(STAT03_COME_INSI_BISI_HOUR) as String).relpaceAll("\\n", target: "\n")
        var lblTime = UILabel(frame: CGRectMake(135, 31, 180, textHeight(strTime, width: 180, size: 14)))
        lblTime.font = UIFont.systemFontOfSize(14)
        lblTime.numberOfLines = 0
        lblTime.text = strTime
        cell.addSubview(lblTime)

        var strPrice = facilities![indexPath.row].item(STAT03_COME_INSI_PRICE) as? String
        if (strPrice != nil) {
            
            var imagePrc: UIImageView = UIImageView(frame: CGRectMake(115, CGFloat(lblTime.frame.height + 8 + lblTime.frame.origin.y), 14, 14))
            cell.addSubview(imagePrc)
            
            var lblPrice = UILabel(frame: CGRectMake(135, CGFloat(lblTime.frame.height + 5 + lblTime.frame.origin.y), 180, textHeight(strPrice!, width: 180, size: 14)))
            lblPrice.font = UIFont.systemFontOfSize(14)
            lblPrice.numberOfLines = 0
            
            lblPrice.text = strPrice
            cell.addSubview(lblPrice)
            
            var strAddress = facilities![indexPath.row].item(STAT03_COME_INSI_LOCA_CH) as String
            var lblAddress = UILabel(frame: CGRectMake(135, CGFloat(lblPrice.frame.height + 8 + lblPrice.frame.origin.y), 180, textHeight(strAddress, width: 180, size: 14)))
            lblAddress.font = UIFont.systemFontOfSize(14)
            lblAddress.adjustsFontSizeToFitWidth = true
            lblAddress.numberOfLines = 0
            lblAddress.text = strAddress
            cell.addSubview(lblAddress)
        } else {
            var strAddress = facilities![indexPath.row].item(STAT03_COME_INSI_LOCA_CH) as String
            var lblAddress = UILabel(frame: CGRectMake(135, CGFloat(lblTime.frame.height + 5 + lblTime.frame.origin.y), 180, textHeight(strAddress, width: 180, size: 14)))
            lblAddress.font = UIFont.systemFontOfSize(14)
            lblAddress.adjustsFontSizeToFitWidth = true
            lblAddress.numberOfLines = 0
            lblAddress.text = strAddress
            cell.addSubview(lblAddress)
        }
        
        var lblLine = UILabel(frame: CGRectMake(0, 114, 320, 14))
        lblLine.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(lblLine)
        
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
    
    
    func textHeight(value:String, width: CGFloat, size: CGFloat) -> CGFloat {
        
        var font:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(size)]
        var maxSize = CGSizeMake(width, 2000)
        var size:CGSize = value.boundingRectWithSize(maxSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: font, context: nil).size
        
        return size.height
    }
    
}
