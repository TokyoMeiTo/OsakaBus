//
//  StationLine.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit


class StationLine: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lineView: UIView!
    
    // 存储车站信息数组
    var stationArr: NSMutableArray = NSMutableArray.arrayWithCapacity(26)
    // 存储地铁信息数组
    var LineArr: NSMutableArray  = NSMutableArray.array()
    
    var sectionTitle = ["B","C","D","E","F","G","H","J","L","M","N","P","Q","R","S","T","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.hidden = true
        odbStation()
        odbLine()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func segmentChangedLinster(sender: UISegmentedControl) {
    
        if (sender.selectedSegmentIndex == 1) {
            
            table.hidden = false
            lineView.hidden = true
            table.reloadData()
        } else {
        
            table.hidden = false
            lineView.hidden = true
            table.reloadData()
//            lineView.hidden = false
//            table.hidden = true
        }
    }
    
    
    func odbStation(){
        var table = MstT02StationTable()
        var array: NSMutableArray = NSMutableArray.array()
        
        var rows: NSArray = table.excuteQuery("select *,count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 group by STAT_NAME_EXT1")
        
        for key in rows {
            
            array.addObject(key)
                    
        }
        
        var arrB = [MstT02StationTable]()
        var arrC = [MstT02StationTable]()
        var arrD = [MstT02StationTable]()
        var arrE = [MstT02StationTable]()
        var arrF = [MstT02StationTable]()
        var arrG = [MstT02StationTable]()
        var arrH = [MstT02StationTable]()
        var arrJ = [MstT02StationTable]()
        var arrL = [MstT02StationTable]()
        var arrM = [MstT02StationTable]()
        var arrN = [MstT02StationTable]()
        var arrP = [MstT02StationTable]()
        var arrQ = [MstT02StationTable]()
        var arrR = [MstT02StationTable]()
        var arrS = [MstT02StationTable]()
        var arrT = [MstT02StationTable]()
        var arrW = [MstT02StationTable]()
        var arrX = [MstT02StationTable]()
        var arrY = [MstT02StationTable]()
        var arrZ = [MstT02StationTable]()
        
        for (var i = 0; i < array.count; i++) {
            var map = array[i] as MstT02StationTable
            var nameExt:NSString = map.item(MSTT02_STAT_NAME_EXT3) as NSString
            
            switch (nameExt.substringToIndex(1)) {
            case "B":
                arrB.append(map)
                
            case "C":
                arrC.append(map)
            case "D":
                arrD.append(map)
            case "E":
                arrE.append(map)
            case "F":
                arrF.append(map)
            case "G":
                arrG.append(map)
            case "H":
                arrH.append(map)
            case "J":
                arrJ.append(map)
            case "L":
                arrL.append(map)
            case "M":
                arrM.append(map)
            case "N":
                arrN.append(map)
            case "P":
                arrP.append(map)
            case "Q":
                arrQ.append(map)
            case "R":
                arrR.append(map)
            case "S":
                arrS.append(map)
            case "T":
                arrT.append(map)
            case "W":
                arrW.append(map)
            case "X":
                arrX.append(map)
            case "Y":
                arrY.append(map)
            case "Z":
                arrZ.append(map)
            default:
//                stationArr.addObject(array[i])
            
                var arr = [MstT02StationTable]()
                arr.append(map)
            }
            
        }
        
        stationArr.addObject(arrB)
        stationArr.addObject(arrC)
        stationArr.addObject(arrD)
        stationArr.addObject(arrE)
        stationArr.addObject(arrF)
        stationArr.addObject(arrG)
        stationArr.addObject(arrH)
        stationArr.addObject(arrJ)
        stationArr.addObject(arrL)
        stationArr.addObject(arrM)
        stationArr.addObject(arrN)
        stationArr.addObject(arrP)
        stationArr.addObject(arrQ)
        stationArr.addObject(arrR)
        stationArr.addObject(arrS)
        stationArr.addObject(arrT)
        stationArr.addObject(arrW)
        stationArr.addObject(arrX)
        stationArr.addObject(arrY)
        stationArr.addObject(arrZ)
        
    }
    
    func odbLine(){
        var table = MstT01LineTable()
        
        table.lineId = "280"
        var rows: NSArray = table.selectLike()
        
        for key in rows {
            
            LineArr.addObject(key)
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (segment.selectedSegmentIndex == 0) {
            return 1
        } else {
            return stationArr.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        
        if (segment.selectedSegmentIndex == 0) {
            return ""
        } else {
            return sectionTitle[section]
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        if (segment.selectedSegmentIndex == 0) {
            return nil
        } else {
            return sectionTitle
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (segment.selectedSegmentIndex == 0) {
            return 55
        } else {
            return 43
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segment.selectedSegmentIndex == 0) {
            return LineArr.count
        } else {
            return stationArr[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 0) {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineListCell", forIndexPath: indexPath) as UITableViewCell
            
            var lineMap: MstT01LineTable = LineArr[indexPath.row] as MstT01LineTable
            
            var lineName = cell.viewWithTag(302) as UILabel
            lineName.text = (lineMap.item(MSTT01_LINE_ID) as String).line()
            
            var lineJPName = cell.viewWithTag(303) as UILabel
            lineJPName.text = lineMap.item(MSTT01_LINE_NAME) as? String
            
            var imgLine = cell.viewWithTag(301) as UIImageView
            imgLine.image = lineImageNormal(lineMap.item(MSTT01_LINE_ID) as String)
            
            return cell
        } else {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StationListCell", forIndexPath: indexPath) as UITableViewCell
            
            var map: MstT02StationTable = stationArr[indexPath.section][indexPath.row] as MstT02StationTable
            
            var textName = cell.viewWithTag(201) as UILabel
            textName.text = map.item(MSTT02_STAT_NAME_EXT1) as? String
            
            var view = cell.viewWithTag(202) as UIView!
            
            var arrStation = ["M", "C", "Z"]
            
            for (var i = 0; i < arrStation.count; i++) {
                var line: UIImageView = UIImageView()
                line.frame = CGRectMake(CGFloat(110 - (i+1)*18 - i * 5), 12.5, 18, 18)
                line.image = lineImage(arrStation[i])
                
                
                view.addSubview(line)
            }
            
            return cell
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (segment.selectedSegmentIndex == 0) {
            var lineList: LineStationList = self.storyboard?.instantiateViewControllerWithIdentifier("LineStationList") as LineStationList
            
            let map = LineArr[indexPath.row] as MstT01LineTable
            lineList.line_id = map.item(MSTT01_LINE_ID) as String
            lineList.line_name = map.item(MSTT01_LINE_NAME) as String
            
            self.navigationController?.pushViewController(lineList, animated: true)
        } else {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: MstT02StationTable = stationArr[indexPath.section][indexPath.row] as MstT02StationTable
            
            detail.cellName = map.item(MSTT02_STAT_NAME_EXT1) as String
            detail.cellJPName = map.item(MSTT02_STAT_NAME) as String
//            detail.cellJPNameKana = map.item(MSTT02_STAT_NAME_KANA) as String
            detail.stat_id = map.item(MSTT02_STAT_ID) as String
            detail.statMetroId = map.item(MSTT02_STAT_METRO_ID) as String
            detail.cellClose = "涩谷,浅草"
            detail.cellJapanTime = "05:18/24:22,05:17/24:28"
            detail.cellChinaTime = "06:18/01:22,06:17/01:28"
            detail.cellChinaWETime = "06:18/01:13,06:17/01:22"
            detail.cellJapanWETime = "05:18/24:13,05:17/24:22"
            
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    
    func lineImage(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_mini_c.png")
        switch (lineNum) {
            
        case "C":
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
        case "F":
            image = UIImage(named: "tablecell_lineicon_mini_f.png")
        case "G":
            image = UIImage(named: "tablecell_lineicon_mini_g.png")
        case "H":
            image = UIImage(named: "tablecell_lineicon_mini_h.png")
        case "M":
            image = UIImage(named: "tablecell_lineicon_mini_m.png")
        case "N":
            image = UIImage(named: "tablecell_lineicon_mini_n.png")
        case "T":
            image = UIImage(named: "tablecell_lineicon_mini_t.png")
        case "Y":
            image = UIImage(named: "tablecell_lineicon_mini_y.png")
        case "Z":
            image = UIImage(named: "tablecell_lineicon_mini_z.png")
            
        default:
            image = UIImage(named: "tablecell_lineicon_mini_c.png")
            
        }
        
        return image
    }
    
    func lineImageNormal(lineNum: String) -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_g.png")
        switch (lineNum) {
            
        case "28001":
            image = UIImage(named: "tablecell_lineicon_g.png")
        case "28002":
            image = UIImage(named: "tablecell_lineicon_m.png")
        case "28003":
            image = UIImage(named: "tablecell_lineicon_h.png")
        case "28004":
            image = UIImage(named: "tablecell_lineicon_t.png")
        case "28005":
            image = UIImage(named: "tablecell_lineicon_c.png")
        case "28006":
            image = UIImage(named: "tablecell_lineicon_y.png")
        case "28008":
            image = UIImage(named: "tablecell_lineicon_z.png")
        case "28009":
            image = UIImage(named: "tablecell_lineicon_n.png")
        case "28010":
            image = UIImage(named: "tablecell_lineicon_f.png")
            
        default:
            image = UIImage(named: "tablecell_lineicon_g.png")
            
        }
        
        return image
    }
    
}
