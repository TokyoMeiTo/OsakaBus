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

class LandMarkListController: UIViewController, UITableViewDelegate, UITableViewDataSource, GPSDelegate{
    
    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    
    /* 最近站点列表UITableView */
    @IBOutlet weak var tbList: UITableView!
    /* 地图MKMapView */
    @IBOutlet weak var tempView: UIView!
    
    /*******************************************************************************
    * Global
    *******************************************************************************/
    
    /* 起点軽度 */
    let fromLat = 35.672737//31.23312372 // 天地科技广场1号楼
    /* 起点緯度 */
    let fromLon = 139.768898//121.38368547 // 天地科技广场1号楼
    /* GPSHelper */
    let GPShelper:GPSHelper = GPSHelper()
    
    let BTN_SEARCH_TAG:Int = 110
    let BTN_FAV_TAG:Int = 101
    
    let FOLDER_NAME:String = "Landmark"
    
    
    /*******************************************************************************
    * Public Properties
    *******************************************************************************/
    
    /* 类型 */
    var landMarkType:Int = 0
    /* 地区 */
    var landMarkSpecialWard:String? = ""
    /* 距离 */
    var landMarkRange:Int = 100000
    /* 站点 */
    var landMarkStatId:String? = ""
    
    var classType:String?

    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    /* 地标一览 */
    var landMarks:Array<MstT04LandMarkTable>?
    var mLocation:CLLocation?
    
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tempView.hidden = true
        switch landMarkType{
        case 0:
            self.title = "PUBLIC_12".localizedString()
        case 1:
            self.title = "INF002_08".localizedString()
        case 2:
            self.title = "PUBLIC_09".localizedString()
        default:
            println("nothing")
        }
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        tbList.delegate = self
        tbList.dataSource = self
        tbList.separatorColor = UIColor.clearColor()
        tbList.backgroundColor = UIColor(red: 239/255,
            green: 239/255,
            blue: 244/255,
            alpha: 1.0)

        // 查询按钮点击事件
        var searchButtonTemp:UIButton? = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        searchButtonTemp!.frame = CGRect(x:0,y:0,width:25,height:25)
        var imgLandMark = UIImage(named: "inf00219")
        searchButtonTemp!.setBackgroundImage(imgLandMark, forState: UIControlState.Normal)
        searchButtonTemp!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButtonTemp!.tag = BTN_SEARCH_TAG
        var searchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButtonTemp!)
        self.navigationItem.rightBarButtonItem = searchButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if(landMarks == nil){
            landMarks = selectLandMarkTable(landMarkType)
        }
        if(landMarks == nil || landMarks!.count < 1){
            tbList.hidden = true
            tempView.hidden = false
        }
        tbList.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    func tableView(tableView: UITableView, didSelectRowAtIndexPath: NSIndexPath){
        var landMarkDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkdetail") as LandMarkDetailController
        
        landMarkDetailController.title = landMarks![didSelectRowAtIndexPath.row].lmakName
        landMarkDetailController.landMark = landMarks![didSelectRowAtIndexPath.row]
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController!.pushViewController(landMarkDetailController, animated:true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 171
    }

    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landMarks!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:String = "LandMarkListCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell

        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier:cellIdentifier)
        }
        
        for subview in cell!.contentView.subviews{
            subview.removeFromSuperview()
        }
        // cell显示内容
        var imgLandMark = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_IMAG_ID1))".image(FOLDER_NAME)
        var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, tableView.frame.width, 170))
        imageViewLandMark.image = imgLandMark
        cell!.contentView.addSubview(imageViewLandMark)
        
        var lblTemp = UILabel(frame: CGRect(x:0,y:140,width:tableView.frame.width,height:30))
        lblTemp.alpha = 0.4
        lblTemp.backgroundColor = UIColor.blackColor()
        cell!.contentView.addSubview(lblTemp)
        
        var lblLandMark = UILabel(frame: CGRect(x:15,y:135,width:tableView.frame.width,height:40))
        lblLandMark.backgroundColor = UIColor.clearColor()
        lblLandMark.font = UIFont.boldSystemFontOfSize(16)
        lblLandMark.textColor = UIColor.whiteColor()
        lblLandMark.text = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_NAME))"
        lblLandMark.textAlignment = NSTextAlignment.Left
        cell!.contentView.addSubview(lblLandMark)
        
        var lblLandMarkWard = UILabel(frame: CGRect(x:tableView.frame.width - 85,y:10,width:70,height:40))
        lblLandMarkWard.backgroundColor = UIColor.clearColor()
        lblLandMarkWard.font = UIFont.boldSystemFontOfSize(16)
        lblLandMarkWard.textColor = UIColor.whiteColor()
        lblLandMarkWard.text = "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_WARD))".specialWard()
        lblLandMarkWard.textAlignment = NSTextAlignment.Right
        cell!.contentView.addSubview(lblLandMarkWard)
        
        var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btnFav.frame = CGRect(x:15,y:10,width:40,height:40)
        
        var mINF002Model:INF002Model = INF002Model()
        
        var mINF002Data:UsrT03FavoriteTableData = mINF002Model.findFav("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_LMAK_ID))")
        
        var imgFav = UIImage(named: "INF00202")
        if(mINF002Data.ext4 != ""){
            imgFav = UIImage(named: "INF00206")
        }
        
        btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
        btnFav.tag = BTN_FAV_TAG + indexPath.row
        
        btnFav.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell!.contentView.addSubview(btnFav)
        
        if(landMarks![indexPath.row].item(MSTT04_LANDMARK_RANK) != nil && "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_RANK))" != ""){
            lblTemp.frame = CGRect(x:0,y:125,width:tableView.frame.width,height:45)
            var mLandMarkRank:Int = ("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_RANK))" as NSString).integerValue
            var mIntRank = mLandMarkRank/100
            var xFloat:CGFloat = 15
            for(var i=0;i < mIntRank; i++){
                xFloat = 15
                for(var j=0;j<i;j++){
                    xFloat = xFloat + 20
                }
                
                var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 130, 15, 15))
                var imageStar = UIImage(named: "INF00209")
                imageViewStar.image = imageStar
                cell!.contentView.addSubview(imageViewStar)
            }
            
            var mSurplus:Int = ("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_RANK))" as NSString).integerValue % 100
            var mSurplusRank:Double = ("\(mSurplus)" as NSString).doubleValue/100.0
            if(mSurplusRank > 0.5){
                xFloat = xFloat + 20
                var imageViewHalfStar = UIImageView(frame: CGRectMake(xFloat, 130, 15, 15))
                imageViewHalfStar.image = UIImage(named: "INF00210")
                cell!.contentView.addSubview(imageViewHalfStar)
            }
        }
        
        if(landMarks![indexPath.row].item(MSTT04_LANDMARK_MICI_RANK) != nil && "\(landMarks![indexPath.row].item(MSTT04_LANDMARK_MICI_RANK))" != ""){
            for(var i=0;i<("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_MICI_RANK))" as NSString).integerValue; i++){
                var xFloat:CGFloat = 60
                
                for(var j=0;j<i;j++){
                    xFloat = xFloat + 20
                }
                
                var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 20, 20, 20))
                var imageStar = UIImage(named: "INF00211")
                imageViewStar.image = imageStar
                cell!.contentView.addSubview(imageViewStar)
            }
        }
        
        if("\(landMarks![indexPath.row].item(MSTT04_LANDMARK_OLIMPIC_FLAG))" == "1"){
            var imageViewOlimpic = UIImageView(frame: CGRectMake(65, 15, 30, 30))
            var imageOlimpic = UIImage(named: "inf00213")
            imageViewOlimpic.image = imageOlimpic
            cell!.contentView.addSubview(imageViewOlimpic)
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    /*******************************************************************************
    *      Implements Of GPSDelegate
    *******************************************************************************/

    /**
     * 位置定位完成
     */
    func locationUpdateComplete(location: CLLocation){
        mLocation = location
    }

    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender.tag{
        case BTN_SEARCH_TAG:
            var landMarkSearchController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarksearch") as LandMarkSearchController
            landMarkSearchController.fromLat = self.fromLat
            landMarkSearchController.fromLon = self.fromLon
            landMarkSearchController.landMarkType = self.landMarkType
            landMarkSearchController.landMarkSpecialWard = self.landMarkSpecialWard
            landMarkSearchController.landMarkRange = self.landMarkRange
            landMarkSearchController.landMarkStatId = self.landMarkStatId
            landMarkSearchController.classType = self.classType
            
            if(!(classType == nil)){
                landMarkSearchController.landMarkSpecialWard = "\(landMarks![0].item(MSTT04_LANDMARK_WARD))"
                landMarkSearchController.landMarkShowSpecialWard = "\(landMarks![0].item(MSTT04_LANDMARK_WARD))"
            }
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton

            self.navigationController!.pushViewController(landMarkSearchController, animated:true)
        default:
            var mINF002Model:INF002Model = INF002Model()
            
            var mINF002Data:UsrT03FavoriteTableData = mINF002Model.findFav("\(landMarks![sender.tag - BTN_FAV_TAG].item(MSTT04_LANDMARK_LMAK_ID))")
            //
            if(mINF002Data.ext4 != ""){
                mINF002Model.deleteFav(mINF002Data)
                tbList.reloadData()
            }else{
                var lmkFavAdd:UsrT03FavoriteTableData = UsrT03FavoriteTableData()
                lmkFavAdd.lmakId = "\(landMarks![sender.tag - BTN_FAV_TAG].item(MSTT04_LANDMARK_LMAK_ID))"
                lmkFavAdd.favoType = "03"
                lmkFavAdd.favoTime = RemindDetailController.convertDate2LocalTime(NSDate.date())
                lmkFavAdd.statId = "\(landMarks![sender.tag - BTN_FAV_TAG].item(MSTT04_LANDMARK_STAT_ID))"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ruteId = "0"
                lmkFavAdd.statExitId = "0"
                lmkFavAdd.ext4 = "\(landMarks![sender.tag - BTN_FAV_TAG].item(MSTT04_LANDMARK_LMAK_TYPE))"
                mINF002Model.insertFav(lmkFavAdd)
                tbList.reloadData()
            }

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
     * 从DB查询地标信息
     */
    func selectLandMarkTable(type:Int) -> Array<MstT04LandMarkTable>{
        //var daoINF002 = INF002Dao()
        var mstT04Table:MstT04LandMarkTable = MstT04LandMarkTable()
        var landMarkTypeStr:String = ""
        switch type{
        case 0:
            landMarkTypeStr = "1"
        case 1:
            landMarkTypeStr = "2"
        case 2:
            landMarkTypeStr = "3"
        default:
            println("nothing")
        }
        
        landMarks = mstT04Table.queryLandMarksFilter(landMarkTypeStr,lon: 0, lat: 0, distance: 0, sataId: landMarkStatId!, specialWard: landMarkSpecialWard!) as? Array<MstT04LandMarkTable>//.queryLandMarks(landMarkTypeStr) as? Array<MstT04LandMarkTable>
        return landMarks!
    }
    

    /*******************************************************************************
    *    Unused Codes
    *******************************************************************************/

}