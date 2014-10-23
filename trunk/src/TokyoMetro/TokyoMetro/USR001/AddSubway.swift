//
//  AddSubway.swift
//  TableViewTest
//
//  Created by caowj on 14-9-9.
//  Copyright (c) 2014年 rhinoIO. All rights reserved.
//

import UIKit

class AddSubway: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /*******************************************************************************
    * IBOutlets
    *******************************************************************************/
    @IBOutlet var table: UITableView!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var vNoData: UIView!
    
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    
    var stationArr: NSMutableArray = NSMutableArray.array()
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()
    // 站点日文名与假名
    var statJPNameArr: NSMutableArray = NSMutableArray.array()
    // 收藏的路径
    var ruteArr: NSMutableArray = NSMutableArray.array()
    
    var detailArr: NSMutableArray = NSMutableArray.array()
    // 收藏路线的rowid
    var ruteRowIdArr: NSMutableArray = NSMutableArray.array()
    
    /* 地标一览 */
    var landMarks: NSMutableArray = NSMutableArray.array()
    
    /* 地标rowId*/
    var landMarkRwoIdArr: NSMutableArray = NSMutableArray.array()
    // 存放地标id
    var landMarkIdStr: String = ""
    // tableview的选中行
    var selectIndexPath: NSIndexPath?
    
    var model: Usr001AddSubwayModel?
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "USR001_01".localizedString()
        
        model = Usr001AddSubwayModel()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (selectIndexPath != nil) {
            table.deselectRowAtIndexPath(selectIndexPath!, animated: true)
        }
        
        // 返回刷新页面
        if (segment.selectedSegmentIndex == 1) {
            odbRoute()
        } else if (segment.selectedSegmentIndex == 2 || segment.selectedSegmentIndex == 3 || segment.selectedSegmentIndex == 4) {
            selectLandMarkId(segment.selectedSegmentIndex)
        } else {
            odbStation()
        }
    }
    
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectIndexPath = indexPath
        if (segment.selectedSegmentIndex == 0) {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: UsrT03FavoriteTable = stationArr[indexPath.row] as UsrT03FavoriteTable
            detail.cellJPName = detailArr[indexPath.row][0] as String
            detail.cellJPNameKana = detailArr[indexPath.row][1] as String
            detail.stat_id = map.item(USRT03_STAT_ID) as String
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController?.pushViewController(detail, animated: true)
        } else if (segment.selectedSegmentIndex == 1) {
            var routeSearch: RouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("RouteSearch") as RouteSearch
            
            var key = ruteArr[indexPath.row] as LinT04RouteTable
            routeSearch.startStationText = key.item(LINT04_ROUTE_START_STAT_ID) as String
            routeSearch.endStationText = key.item(LINT04_ROUTE_TERM_STAT_ID) as String
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(routeSearch, animated: true)
        } else {
            var landMarkDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkdetail") as LandMarkDetailController
            switch segment.selectedSegmentIndex {
            case 2:
                landMarkDetailController.title = "PUBLIC_12".localizedString()
            case 3:
                landMarkDetailController.title = "PUBLIC_13".localizedString()
            case 4:
                landMarkDetailController.title = "PUBLIC_14".localizedString()
            default:
                println("nothing")
            }
            
            landMarkDetailController.landMark = landMarks[indexPath.row] as? MstT04LandMarkTable
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController!.pushViewController(landMarkDetailController, animated:true)
            
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (segment.selectedSegmentIndex == 0) {
            return 55
        } else if (segment.selectedSegmentIndex == 1) {
            return 55
        } else {
            return 170
        }
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segment.selectedSegmentIndex == 0) {
            return stationArr.count
        } else if (segment.selectedSegmentIndex == 1) {
            return ruteArr.count
        } else {
            
            return landMarks.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 0) {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CollectCell", forIndexPath: indexPath) as UITableViewCell
            
            var map: UsrT03FavoriteTable = stationArr[indexPath.row] as UsrT03FavoriteTable
            
            var textName = cell.viewWithTag(201) as UILabel
            textName.text = (map.item(USRT03_STAT_ID) as String).station()
            
            var textJPName = cell.viewWithTag(203) as UILabel
            textJPName.text = statJPNameArr[indexPath.row] as? String
            
            var view = cell.viewWithTag(202) as UIView!
            
            if (view != nil) {
                view.removeFromSuperview()
            }
            
            var lineView = UIView()
            lineView.frame = CGRectMake(185, 5, 105, 45)
            lineView.tag = 202
            
            var arrStation: [String] = changeLineArr[indexPath.row] as [String]
            
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(105 - (i+1)*18 - i * 4), 14, 18, 18)
                line.image = arrStation[i].getLineMiniImage()
                
                lineView.addSubview(line)
            }
            
            cell.addSubview(lineView)
            
            return cell
        } else if (segment.selectedSegmentIndex == 1) {
            
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath) as UITableViewCell
            
            var key = ruteArr[indexPath.row] as LinT04RouteTable
            
            var openStation =  cell.viewWithTag(301) as UILabel
            var closeStation =  cell.viewWithTag(302) as UILabel
            
            openStation.text = "PUBLIC_01".localizedString() + "：" + (key.item(LINT04_ROUTE_START_STAT_ID) as String).station()
            
            closeStation.text = "PUBLIC_02".localizedString() + "：" + (key.item(LINT04_ROUTE_TERM_STAT_ID) as String).station()
            
            return cell
        } else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("LnadMarkCell", forIndexPath: indexPath) as UITableViewCell
            for subview in cell.subviews{
                subview.removeFromSuperview()
            }
            
            var key = landMarks[indexPath.row] as MstT04LandMarkTable
            // cell显示内容
            var imgLandMark = UIImage(named: LocalCacheController.readFile("\(key.item(MSTT04_LANDMARK_IMAG_ID1))"))
            if("\(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))" == "皇居"){
                imgLandMark = UIImage(named: LocalCacheController.readFile("\(key.item(MSTT04_LANDMARK_IMAG_ID2))"))
            }
            var imageViewLandMark = UIImageView(frame: CGRectMake(0, 0, tableView.frame.width, 170))
            imageViewLandMark.image = imgLandMark
            cell.addSubview(imageViewLandMark)
            
            var lblTemp = UILabel(frame: CGRect(x:0,y:140,width:tableView.frame.width,height:30))
            lblTemp.alpha = 0.4
            lblTemp.backgroundColor = UIColor.blackColor()
            cell.addSubview(lblTemp)
            
            var lblLandMark = UILabel(frame: CGRect(x:15,y:135,width:tableView.frame.width,height:40))
            lblLandMark.backgroundColor = UIColor.clearColor()
            lblLandMark.font = UIFont.boldSystemFontOfSize(16)
            lblLandMark.textColor = UIColor.whiteColor()
            lblLandMark.text = "\(key.item(MSTT04_LANDMARK_LMAK_NAME_EXT1))"
            lblLandMark.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblLandMark)
            
            var lblLandMarkWard = UILabel(frame: CGRect(x:tableView.frame.width - 70,y:10,width:70,height:40))
            lblLandMarkWard.backgroundColor = UIColor.clearColor()
            lblLandMarkWard.font = UIFont.boldSystemFontOfSize(16)
            lblLandMarkWard.textColor = UIColor.whiteColor()
            lblLandMarkWard.text = "\(key.item(MSTT04_LANDMARK_WARD))".specialWard()
            lblLandMarkWard.textAlignment = NSTextAlignment.Left
            cell.addSubview(lblLandMarkWard)
            
            var btnFav:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            btnFav.frame = CGRect(x:15,y:10,width:40,height:40)
            
            var tableUsrT03:INF002FavDao = INF002FavDao()
            var lmkFav:UsrT03FavoriteTable? = tableUsrT03.queryFav("\(key.item(MSTT04_LANDMARK_LMAK_ID))")
            
            var imgFav = UIImage(named: "INF00202")
            if(lmkFav!.rowid != nil && lmkFav!.rowid != ""){
                imgFav = UIImage(named: "INF00206")
            }
            
            btnFav.setBackgroundImage(imgFav, forState: UIControlState.Normal)
            btnFav.tag = 101
            
            cell.addSubview(btnFav)
            
            if(key.item(MSTT04_LANDMARK_MICI_RANK) != nil && "\(key.item(MSTT04_LANDMARK_MICI_RANK))" != ""){
                lblTemp.frame = CGRect(x:0,y:125,width:tableView.frame.width,height:45)
                
                for(var i=0;i<("\(key.item(MSTT04_LANDMARK_MICI_RANK))" as NSString).integerValue; i++){
                    var xFloat:CGFloat = 15//100
                    
                    for(var j=0;j<i;j++){
                        xFloat = xFloat + 20
                    }
                    
                    var imageViewStar = UIImageView(frame: CGRectMake(xFloat, 130, 15, 15))
                    var imageStar = UIImage(named: "INF00209")
                    imageViewStar.image = imageStar
                    cell.addSubview(imageViewStar)
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
            
        }
    }
    
    func tableView(tableView:UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath:NSIndexPath!){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            if (segment.selectedSegmentIndex == 0) {
                if (model!.removeCollection((stationArr[indexPath.row] as UsrT03FavoriteTable).rowid)) {

                    odbStation()
                }
            } else if (segment.selectedSegmentIndex == 1) {
                if (model!.removeCollection(ruteRowIdArr[indexPath.row] as? String)) {

                    odbRoute()
                }
            } else {
                if (model!.removeCollection((landMarkRwoIdArr[indexPath.row] as UsrT03FavoriteTable).rowid)) {

                    selectLandMarkId(segment.selectedSegmentIndex)
                }
            }
            
        }
        
    }

    /*******************************************************************************
    *      IBActions
    *******************************************************************************/
    
    @IBAction func segmentChangedLinster(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            
            odbStation()

        } else if (sender.selectedSegmentIndex == 1) {
            
            odbRoute()
 
        } else {
            selectLandMarkId(sender.selectedSegmentIndex)
        }
    }
    
    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    func odbStation(){
        var table = UsrT03FavoriteTable()
        var stationTable = MstT02StationTable()
        
        stationArr = NSMutableArray.array()
        detailArr = NSMutableArray.array()
        statJPNameArr = NSMutableArray.array()
        changeLineArr = NSMutableArray.array()
        
        table.favoType = "01"
        var rows: NSArray = table.selectAll()
        
        var allRows: NSArray = stationTable.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            
            key as UsrT03FavoriteTable
            stationArr.addObject(key)
            
            // 取各站的lineId
            var statGroupId = key.item(USRT03_STAT_ID) as String
            var lineArr = [String]()
            var statJPName = ""
            var array: [String] = [String]()
            for (var i = 0; i < allRows.count; i++) {
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId || (map.item(MSTT02_STAT_ID) as String) == statGroupId) {
                    
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                    if (statJPName == "") {
                        statJPName = (map.item(MSTT02_STAT_NAME) as String) + "（" + (map.item(MSTT02_STAT_NAME_KANA) as String) + "）"
                        array.append(map.item(MSTT02_STAT_NAME) as String)
                        array.append(map.item(MSTT02_STAT_NAME_KANA) as String)
                    }
                }
            }
            
            detailArr.addObject(array)
            statJPNameArr.addObject(statJPName)
            changeLineArr.addObject(lineArr)
        }
        
        if (stationArr.count == 0) {
            self.table.hidden = true
        } else {
            self.table.hidden = false
        }
        self.table.reloadData()
    }
    
    
    func odbRoute() {
        var table = UsrT03FavoriteTable()
        var routeTable = LinT04RouteTable()
        
        ruteArr = NSMutableArray.array()
        ruteRowIdArr = NSMutableArray.array()
        
        table.favoType = "04"
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            key as UsrT03FavoriteTable
            
            var ruteId = key.item(USRT03_RUTE_ID) as String
            routeTable.ruteId = ruteId
            var ruteRows = routeTable.selectAll()
            if (ruteRows.count > 0) {
                ruteArr.addObject(ruteRows[0])
                ruteRowIdArr.addObject(key.rowid)
            }
        }
        
        if (ruteArr.count == 0) {
            self.table.hidden = true
        } else {
            self.table.hidden = false
        }
        self.table.reloadData()
    }
    
    
    func selectLandMarkId(type: Int) {
        
        var landMarkTypeStr:String = ""
        landMarkIdStr = ""
        switch type{
        case 2:
            landMarkTypeStr = "景点"
        case 3:
            landMarkTypeStr = "美食"
        case 4:
            landMarkTypeStr = "购物"
        default:
            println("nothing")
        }
        
        landMarkRwoIdArr = NSMutableArray.array()
        
        var table = UsrT03FavoriteTable()

        var rows: NSArray = table.excuteQuery("select *, ROWID, count(LMAK_ID) from USRT03_FAVORITE where FAVO_TYPE = '03' and EXT4 = '\(landMarkTypeStr)' group by LMAK_ID")
        for key in rows {
            key as UsrT03FavoriteTable
            landMarkRwoIdArr.addObject(key)
            if (landMarkIdStr == "") {
                landMarkIdStr = key.item(USRT03_LMAK_ID) as String
            } else {
                landMarkIdStr = landMarkIdStr + "," + (key.item(USRT03_LMAK_ID) as String)
            }
        }
        
        landMarks = NSMutableArray.array()
        if (rows.count > 0) {
            self.table.hidden = false
            landMarks = model!.selectLandMarkTable(type, landMarkId: landMarkIdStr)
            
            self.table.reloadData()
        } else {
            self.table.hidden = true
            self.table.reloadData()
        }
    }
    
   


}