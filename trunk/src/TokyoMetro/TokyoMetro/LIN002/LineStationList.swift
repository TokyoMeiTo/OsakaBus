//
//  LineStationList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class LineStationList: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var table: UITableView!
    
    // 查询该条线的线路id
    var line_id: String = ""
    // 查询该条线的线路名
    var line_name: String = ""
    // 该条线的车站信息数据
    var stationArr: NSMutableArray = NSMutableArray.array()
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()
    // 判断是否反向设置线路
    var isReverse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = line_name
        odbStation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        // 存储丸之内线m段车站
        var mStationArr: NSMutableArray = NSMutableArray.array()
        
        table.lineId = line_id
        var rows: NSArray = table.selectWithOrder(MSTT02_STAT_SEQ, desc: false)
        
        var allRows: NSArray = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")

        for key in rows {
            
            key as MstT02StationTable
            // statSeq 判断车站是否在m段
            var statSeq = key.item(MSTT02_STAT_SEQ) as String
            if (statSeq == "m03" || statSeq == "m04" || statSeq == "m05") {
                mStationArr.addObject(key)
            } else {
                stationArr.addObject(key)
                
                var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
                var statId = key.item(MSTT02_STAT_ID) as String
                var lineArr = [String]()
                for (var i = 0; i < allRows.count; i++) {
                    var map: MstT02StationTable = allRows[i] as MstT02StationTable
                    
                    if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId && (map.item(MSTT02_STAT_ID) as String) != statId) {
                        lineArr.append(map.item(MSTT02_LINE_ID) as String)
                    }
                }
                
                if (lineArr.count < 1) {
                    changeLineArr.addObject(["self"])
                } else {
                    changeLineArr.addObject(lineArr)
                }
                
            }
        }
        
        // 把m段车站加到丸之内线最前
        if (line_id == "28002") {
            for (var i = mStationArr.count; i > 0; i--) {
                stationArr.insertObject(mStationArr[i - 1], atIndex: 0)
                changeLineArr.insertObject(["self"], atIndex: 0)
            }
        }

    }
    
    
    @IBAction func reverseLine() {
    
        var array = stationArr.reverseObjectEnumerator().allObjects as NSArray
        var array2 = changeLineArr.reverseObjectEnumerator().allObjects as NSArray
        
        stationArr.removeAllObjects()
        changeLineArr.removeAllObjects()
        for (var i = 0; i < array.count; i++) {
            stationArr.addObject(array[i])
            changeLineArr.addObject(array2[i])
        }
        
        isReverse = !isReverse
        
        table.reloadData()
        
        self.table.setContentOffset(CGPointMake(0, -64), animated: true)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineStationListCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
        
        var textName = cell.viewWithTag(201) as UILabel
        textName.text = (map.item(MSTT02_STAT_ID) as String).station()
        
        var textJPName = cell.viewWithTag(204) as UILabel
        textJPName.text = (map.item(MSTT02_STAT_NAME) as String) + "（" + (map.item(MSTT02_STAT_NAME_KANA) as String) + "）"
        
        var btnImg: UIImageView = cell.viewWithTag(203) as UIImageView
        btnImg.image = lineStationImage(map.item(MSTT02_STAT_ID) as String)
        
        var view = cell.viewWithTag(202) as UIView!
        
        if (view != nil) {
            view.removeFromSuperview()
        }
        
        var lineView = UIView()
        lineView.frame = CGRectMake(225, 0, 70, 45)
        lineView.tag = 202
        
        var arrStation: [String] = changeLineArr[indexPath.row] as [String]
        if (arrStation != ["self"]) {
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(66 - (i+1)*18 - i * 4), 13, 18, 18)
                line.image = arrStation[i].getLineMiniImage()
                
                lineView.addSubview(line)
            }
        }

        cell.addSubview(lineView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
        
        var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
        detail.cellJPName = map.item(MSTT02_STAT_NAME) as String
        detail.cellJPNameKana = map.item(MSTT02_STAT_NAME_KANA) as String
        detail.stat_id = map.item(MSTT02_STAT_ID) as String
        detail.statMetroId = map.item(MSTT02_STAT_METRO_ID) as String

        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.pushViewController(detail, animated: true)
    }

    
    func lineStationImage(lineNum: String) -> UIImage {
        
        var image = UIImage()
        
        if (isReverse) {
            
            image = lineNum.getStationIconImage("d")
            println(image.size.height)
            if (image.size.height > 0) {
            
            } else {
                image = lineNum.getStationIconImage()
            }
        } else {
            image = lineNum.getStationIconImage()
        }
        return image
    }
 
}
