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
        
        var allRows: NSArray = table.excuteQuery("select * from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")

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
        btnImg.image = lineStationImage(map.item(MSTT02_STAT_SEQ) as String)
        
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
                line.image = lineImage(arrStation[i])
                
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

        
        self.navigationController?.pushViewController(detail, animated: true)
    }

    
    func lineImage(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_mini_c.png")
        switch (lineNum) {
            
        case "28005":
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
        case "28010":
            image = UIImage(named: "tablecell_lineicon_mini_f.png")
        case "28001":
            image = UIImage(named: "tablecell_lineicon_mini_g.png")
        case "28003":
            image = UIImage(named: "tablecell_lineicon_mini_h.png")
        case "28002":
            image = UIImage(named: "tablecell_lineicon_mini_m.png")
        case "28009":
            image = UIImage(named: "tablecell_lineicon_mini_n.png")
        case "28004":
            image = UIImage(named: "tablecell_lineicon_mini_t.png")
        case "28006":
            image = UIImage(named: "tablecell_lineicon_mini_y.png")
        case "28008":
            image = UIImage(named: "tablecell_lineicon_mini_z.png")
            
        default:
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
            
        }
        
        return image
    }
    
    
    func lineStationImage(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "line_g-01.png")
        switch (lineNum) {
            
        case "G01":
            if (isReverse) {
                image = UIImage(named: "line_g-01d.png")
            } else {
                image = UIImage(named: "line_g-01.png")
            }
        case "G02":
            image = UIImage(named: "line_g-02.png")
        case "G03":
            image = UIImage(named: "line_g-03.png")
        case "G04":
            image = UIImage(named: "line_g-04.png")
        case "G05":
            image = UIImage(named: "line_g-05.png")
        case "G06":
            image = UIImage(named: "line_g-06.png")
        case "G07":
            image = UIImage(named: "line_g-07.png")
        case "G08":
            image = UIImage(named: "line_g-08.png")
        case "G09":
            image = UIImage(named: "line_g-09.png")
        case "G10":
            image = UIImage(named: "line_g-10.png")
        case "G11":
            image = UIImage(named: "line_g-11.png")
        case "G12":
            image = UIImage(named: "line_g-12.png")
        case "G13":
            image = UIImage(named: "line_g-13.png")
        case "G14":
            image = UIImage(named: "line_g-14.png")
        case "G15":
            image = UIImage(named: "line_g-15.png")
        case "G16":
            image = UIImage(named: "line_g-16.png")
        case "G17":
            image = UIImage(named: "line_g-17.png")
        case "G18":
            image = UIImage(named: "line_g-18.png")
        case "G19":
            if (isReverse) {
                image = UIImage(named: "line_g-19d.png")
            } else {
                image = UIImage(named: "line_g-19.png")
            }
        case "Z01":
            if (isReverse) {
                image = UIImage(named: "line_z-01d.png")
            } else {
                image = UIImage(named: "line_z-01.png")
            }
        case "Z02":
            image = UIImage(named: "line_z-02.png")
        case "Z03":
            image = UIImage(named: "line_z-03.png")
        case "Z04":
            image = UIImage(named: "line_z-04.png")
        case "Z05":
            image = UIImage(named: "line_z-05.png")
        case "Z06":
            image = UIImage(named: "line_z-06.png")
        case "Z07":
            image = UIImage(named: "line_z-07.png")
        case "Z08":
            image = UIImage(named: "line_z-08.png")
        case "Z09":
            image = UIImage(named: "line_z-09.png")
        case "Z10":
            image = UIImage(named: "line_z-10.png")
        case "Z11":
            image = UIImage(named: "line_z-11.png")
        case "Z12":
            image = UIImage(named: "line_z-12.png")
        case "Z13":
            image = UIImage(named: "line_z-13.png")
        case "Z14":
            if (isReverse) {
                image = UIImage(named: "line_z-14d.png")
            } else {
                image = UIImage(named: "line_z-14.png")
            }
        case "H01":
            if (isReverse) {
                image = UIImage(named: "line_h-01d.png")
            } else {
                image = UIImage(named: "line_h-01.png")
            }
        case "H02":
            image = UIImage(named: "line_h-02.png")
        case "H03":
            image = UIImage(named: "line_h-03.png")
        case "H04":
            image = UIImage(named: "line_h-04.png")
        case "H05":
            image = UIImage(named: "line_h-05.png")
        case "H06":
            image = UIImage(named: "line_h-06.png")
        case "H07":
            image = UIImage(named: "line_h-07.png")
        case "H08":
            image = UIImage(named: "line_h-08.png")
        case "H09":
            image = UIImage(named: "line_h-09.png")
        case "H10":
            image = UIImage(named: "line_h-10.png")
        case "H11":
            image = UIImage(named: "line_h-11.png")
        case "H12":
            image = UIImage(named: "line_h-12.png")
        case "H13":
            image = UIImage(named: "line_h-13.png")
        case "H14":
            image = UIImage(named: "line_h-14.png")
        case "H15":
            image = UIImage(named: "line_h-15.png")
        case "H16":
            image = UIImage(named: "line_h-16.png")
        case "H17":
            image = UIImage(named: "line_h-17.png")
        case "H18":
            image = UIImage(named: "line_h-18.png")
        case "H19":
            image = UIImage(named: "line_h-19.png")
        case "H20":
            image = UIImage(named: "line_h-20.png")
        case "H21":
            if (isReverse) {
                image = UIImage(named: "line_h-21d.png")
            } else {
                image = UIImage(named: "line_h-21.png")
            }
        case "T01":
            if (isReverse) {
                image = UIImage(named: "line_t-01d.png")
            } else {
                image = UIImage(named: "line_t-01.png")
            }
        case "T02":
            image = UIImage(named: "line_t-02.png")
        case "T03":
            image = UIImage(named: "line_t-03.png")
        case "T04":
            image = UIImage(named: "line_t-04.png")
        case "T05":
            image = UIImage(named: "line_t-05.png")
        case "T06":
            image = UIImage(named: "line_t-06.png")
        case "T07":
            image = UIImage(named: "line_t-07.png")
        case "T08":
            image = UIImage(named: "line_t-08.png")
        case "T09":
            image = UIImage(named: "line_t-09.png")
        case "T10":
            image = UIImage(named: "line_t-10.png")
        case "T11":
            image = UIImage(named: "line_t-11.png")
        case "T12":
            image = UIImage(named: "line_t-12.png")
        case "T13":
            image = UIImage(named: "line_t-13.png")
        case "T14":
            image = UIImage(named: "line_t-14.png")
        case "T15":
            image = UIImage(named: "line_t-15.png")
        case "T16":
            image = UIImage(named: "line_t-16.png")
        case "T17":
            image = UIImage(named: "line_t-17.png")
        case "T18":
            image = UIImage(named: "line_t-18.png")
        case "T19":
            image = UIImage(named: "line_t-19.png")
        case "T20":
            image = UIImage(named: "line_t-20.png")
        case "T21":
            image = UIImage(named: "line_t-21.png")
        case "T22":
            image = UIImage(named: "line_t-22.png")
        case "T23":
            if (isReverse) {
                image = UIImage(named: "line_t-23d.png")
            } else {
                image = UIImage(named: "line_t-23.png")
            }
        case "C01":
            if (isReverse) {
                image = UIImage(named: "line_c-01d.png")
            } else {
                image = UIImage(named: "line_c-01.png")
            }
        case "C02":
            image = UIImage(named: "line_c-02.png")
        case "C03":
            image = UIImage(named: "line_c-03.png")
        case "C04":
            image = UIImage(named: "line_c-04.png")
        case "C05":
            image = UIImage(named: "line_c-05.png")
        case "C06":
            image = UIImage(named: "line_c-06.png")
        case "C07":
            image = UIImage(named: "line_c-07.png")
        case "C08":
            image = UIImage(named: "line_c-08.png")
        case "C09":
            image = UIImage(named: "line_c-09.png")
        case "C10":
            image = UIImage(named: "line_c-10.png")
        case "C11":
            image = UIImage(named: "line_c-11.png")
        case "C12":
            image = UIImage(named: "line_c-12.png")
        case "C13":
            image = UIImage(named: "line_c-13.png")
        case "C14":
            image = UIImage(named: "line_c-14.png")
        case "C15":
            image = UIImage(named: "line_c-15.png")
        case "C16":
            image = UIImage(named: "line_c-16.png")
        case "C17":
            image = UIImage(named: "line_c-17.png")
        case "C18":
            image = UIImage(named: "line_c-18.png")
        case "C19":
            image = UIImage(named: "line_c-19.png")
        case "C20":
            if (isReverse) {
                image = UIImage(named: "line_c-20d.png")
            } else {
                image = UIImage(named: "line_c-20.png")
            }
        case "Y01":
            if (isReverse) {
                image = UIImage(named: "line_y-01d.png")
            } else {
                image = UIImage(named: "line_y-01.png")
            }
        case "Y02":
            image = UIImage(named: "line_y-02.png")
        case "Y03":
            image = UIImage(named: "line_y-03.png")
        case "Y04":
            image = UIImage(named: "line_y-04.png")
        case "Y05":
            image = UIImage(named: "line_y-05.png")
        case "Y06":
            image = UIImage(named: "line_y-06.png")
        case "Y07":
            image = UIImage(named: "line_y-07.png")
        case "Y08":
            image = UIImage(named: "line_y-08.png")
        case "Y09":
            image = UIImage(named: "line_y-09.png")
        case "Y10":
            image = UIImage(named: "line_y-10.png")
        case "Y11":
            image = UIImage(named: "line_y-11.png")
        case "Y12":
            image = UIImage(named: "line_y-12.png")
        case "Y13":
            image = UIImage(named: "line_y-13.png")
        case "Y14":
            image = UIImage(named: "line_y-14.png")
        case "Y15":
            image = UIImage(named: "line_y-15.png")
        case "Y16":
            image = UIImage(named: "line_y-16.png")
        case "Y17":
            image = UIImage(named: "line_y-17.png")
        case "Y18":
            image = UIImage(named: "line_y-18.png")
        case "Y19":
            image = UIImage(named: "line_y-19.png")
        case "Y20":
            image = UIImage(named: "line_y-20.png")
        case "Y21":
            image = UIImage(named: "line_y-21.png")
        case "Y22":
            image = UIImage(named: "line_y-22.png")
        case "Y23":
            image = UIImage(named: "line_y-23.png")
        case "Y24":
            if (isReverse) {
                image = UIImage(named: "line_y-24d.png")
            } else {
                image = UIImage(named: "line_y-24.png")
            }
        case "N01":
            if (isReverse) {
                image = UIImage(named: "line_n-01d.png")
            } else {
                image = UIImage(named: "line_n-01.png")
            }
        case "N02":
            image = UIImage(named: "line_n-02.png")
        case "N03":
            image = UIImage(named: "line_n-03.png")
        case "N04":
            image = UIImage(named: "line_n-04.png")
        case "N05":
            image = UIImage(named: "line_n-05.png")
        case "N06":
            image = UIImage(named: "line_n-06.png")
        case "N07":
            image = UIImage(named: "line_n-07.png")
        case "N08":
            image = UIImage(named: "line_n-08.png")
        case "N09":
            image = UIImage(named: "line_n-09.png")
        case "N10":
            image = UIImage(named: "line_n-10.png")
        case "N11":
            image = UIImage(named: "line_n-11.png")
        case "N12":
            image = UIImage(named: "line_n-12.png")
        case "N13":
            image = UIImage(named: "line_n-13.png")
        case "N14":
            image = UIImage(named: "line_n-14.png")
        case "N15":
            image = UIImage(named: "line_n-15.png")
        case "N16":
            image = UIImage(named: "line_n-16.png")
        case "N17":
            image = UIImage(named: "line_n-17.png")
        case "N18":
            image = UIImage(named: "line_n-18.png")
        case "N19":
            if (isReverse) {
                image = UIImage(named: "line_n-19d.png")
            } else {
                image = UIImage(named: "line_n-19.png")
            }
        case "F01":
            if (isReverse) {
                image = UIImage(named: "line_f-01d.png")
            } else {
                image = UIImage(named: "line_f-01.png")
            }
        case "F02":
            image = UIImage(named: "line_f-02.png")
        case "F03":
            image = UIImage(named: "line_f-03.png")
        case "F04":
            image = UIImage(named: "line_f-04.png")
        case "F05":
            image = UIImage(named: "line_f-05.png")
        case "F06":
            image = UIImage(named: "line_f-06.png")
        case "F07":
            image = UIImage(named: "line_f-07.png")
        case "F08":
            image = UIImage(named: "line_f-08.png")
        case "F09":
            image = UIImage(named: "line_f-09.png")
        case "F10":
            image = UIImage(named: "line_f-10.png")
        case "F11":
            image = UIImage(named: "line_f-11.png")
        case "F12":
            image = UIImage(named: "line_f-12.png")
        case "F13":
            image = UIImage(named: "line_f-13.png")
        case "F14":
            image = UIImage(named: "line_f-14.png")
        case "F15":
            image = UIImage(named: "line_f-15.png")
        case "F16":
            if (isReverse) {
                image = UIImage(named: "line_f-16d.png")
            } else {
                image = UIImage(named: "line_f-16.png")
            }
        case "M01":
            if (isReverse) {
                image = UIImage(named: "line_m-01d.png")
            } else {
                image = UIImage(named: "line_m-01.png")
            }
        case "M02":
            image = UIImage(named: "line_m-02.png")
        case "M03":
            image = UIImage(named: "line_m-03.png")
        case "M04":
            image = UIImage(named: "line_m-04.png")
        case "M05":
            image = UIImage(named: "line_m-05.png")
        case "M06":
            if (isReverse) {
                image = UIImage(named: "line_m-06d.png")
            } else {
                image = UIImage(named: "line_m-06.png")
            }
        case "M07":
            image = UIImage(named: "line_m-07.png")
        case "M08":
            image = UIImage(named: "line_m-08.png")
        case "M09":
            image = UIImage(named: "line_m-09.png")
        case "M10":
            image = UIImage(named: "line_m-10.png")
        case "M11":
            image = UIImage(named: "line_m-11.png")
        case "M12":
            image = UIImage(named: "line_m-12.png")
        case "M13":
            image = UIImage(named: "line_m-13.png")
        case "M14":
            image = UIImage(named: "line_m-14.png")
        case "M15":
            image = UIImage(named: "line_m-15.png")
        case "M16":
            image = UIImage(named: "line_m-16.png")
        case "M17":
            image = UIImage(named: "line_m-17.png")
        case "M18":
            image = UIImage(named: "line_m-18.png")
        case "M19":
            image = UIImage(named: "line_m-19.png")
        case "M20":
            image = UIImage(named: "line_m-20.png")
        case "M21":
            image = UIImage(named: "line_m-21.png")
        case "M22":
            image = UIImage(named: "line_m-22.png")
        case "M23":
            image = UIImage(named: "line_m-23.png")
        case "M24":
            image = UIImage(named: "line_m-24.png")
        case "M25":
            if (isReverse) {
                image = UIImage(named: "line_m-25d.png")
            } else {
                image = UIImage(named: "line_m-25.png")
            }
        case "m03":
            if (isReverse) {
                image = UIImage(named: "line_mm-03d.png")
            } else {
                image = UIImage(named: "line_mm-03.png")
            }
        case "m04":
            image = UIImage(named: "line_mm-04.png")
        case "m05":
            if (isReverse) {
                image = UIImage(named: "line_mm-05d.png")
            } else {
                image = UIImage(named: "line_mm-05.png")
            }

            
        default:
            image = UIImage(named: "line_g-01.png")
            
        }
        
        return image
    }
 
}
