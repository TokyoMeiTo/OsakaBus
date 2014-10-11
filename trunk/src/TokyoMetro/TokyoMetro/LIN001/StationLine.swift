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
    // 换乘线路
    var changeLineArr: NSMutableArray = NSMutableArray.array()
    // 首末站
    var destArr: NSMutableArray = NSMutableArray.array()
    
    var sectionTitle = ["B","C","D","E","F","G","H","J","L","M","N","P","Q","R","S","T","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineView.hidden = true
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
        var rows: NSArray = table.excuteQuery("select *,count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select * from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
        for key in rows {
            
            stationArr.addObject(key)
            
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            var lineArr = [String]()
            for (var i = 0; i < allRows.count; i++) {
                var map: MstT02StationTable = allRows[i] as MstT02StationTable
                
                if ((map.item(MSTT02_STAT_GROUP_ID) as String) == statGroupId) {
                    lineArr.append(map.item(MSTT02_LINE_ID) as String)
                }
            }
            
            changeLineArr.addObject(lineArr)
        }
        
//        var arrB = [MstT02StationTable]()
//        var arrC = [MstT02StationTable]()
//        var arrD = [MstT02StationTable]()
//        var arrE = [MstT02StationTable]()
//        var arrF = [MstT02StationTable]()
//        var arrG = [MstT02StationTable]()
//        var arrH = [MstT02StationTable]()
//        var arrJ = [MstT02StationTable]()
//        var arrL = [MstT02StationTable]()
//        var arrM = [MstT02StationTable]()
//        var arrN = [MstT02StationTable]()
//        var arrP = [MstT02StationTable]()
//        var arrQ = [MstT02StationTable]()
//        var arrR = [MstT02StationTable]()
//        var arrS = [MstT02StationTable]()
//        var arrT = [MstT02StationTable]()
//        var arrW = [MstT02StationTable]()
//        var arrX = [MstT02StationTable]()
//        var arrY = [MstT02StationTable]()
//        var arrZ = [MstT02StationTable]()
//        
//        for (var i = 0; i < array.count; i++) {
//            var map = array[i] as MstT02StationTable
//            var nameExt:NSString = map.item(MSTT02_STAT_NAME_EXT3) as NSString
//            
//            switch (nameExt.substringToIndex(1)) {
//            case "B":
//                arrB.append(map)
//                
//            case "C":
//                arrC.append(map)
//            case "D":
//                arrD.append(map)
//            case "E":
//                arrE.append(map)
//            case "F":
//                arrF.append(map)
//            case "G":
//                arrG.append(map)
//            case "H":
//                arrH.append(map)
//            case "J":
//                arrJ.append(map)
//            case "L":
//                arrL.append(map)
//            case "M":
//                arrM.append(map)
//            case "N":
//                arrN.append(map)
//            case "P":
//                arrP.append(map)
//            case "Q":
//                arrQ.append(map)
//            case "R":
//                arrR.append(map)
//            case "S":
//                arrS.append(map)
//            case "T":
//                arrT.append(map)
//            case "W":
//                arrW.append(map)
//            case "X":
//                arrX.append(map)
//            case "Y":
//                arrY.append(map)
//            case "Z":
//                arrZ.append(map)
//            default:
////                stationArr.addObject(array[i])
//            
//                var arr = [MstT02StationTable]()
//                arr.append(map)
//            }
//            
//        }
//        
//        stationArr.addObject(arrB)
//        stationArr.addObject(arrC)
//        stationArr.addObject(arrD)
//        stationArr.addObject(arrE)
//        stationArr.addObject(arrF)
//        stationArr.addObject(arrG)
//        stationArr.addObject(arrH)
//        stationArr.addObject(arrJ)
//        stationArr.addObject(arrL)
//        stationArr.addObject(arrM)
//        stationArr.addObject(arrN)
//        stationArr.addObject(arrP)
//        stationArr.addObject(arrQ)
//        stationArr.addObject(arrR)
//        stationArr.addObject(arrS)
//        stationArr.addObject(arrT)
//        stationArr.addObject(arrW)
//        stationArr.addObject(arrX)
//        stationArr.addObject(arrY)
//        stationArr.addObject(arrZ)
        
    }
    
    func odbLine(){
        var table = MstT01LineTable()
        
        table.lineId = "280"
        var rows: NSArray = table.selectLike()
        
        for key in rows {
            LineArr.addObject(key)
            
//            key as MstT01LineTable
//            var lineId = key.item(MSTT01_LINE_ID) as String
//            
//            var mstt02 = MstT02StationTable()
//            
//            if (lineId == "28002") {
//                destArr.addObject(["\(map1.item(MSTT02_STAT_NAME_EXT1)) - \(map1.item(MSTT02_STAT_NAME_EXT2))"])
//            } else {
//                mstt02.lineId = lineId
//                var array = mstt02.selectWithOrder(MSTT02_STAT_SEQ, desc: false)
//                var map1: MstT02StationTable = array[0] as MstT02StationTable
//                var map2: MstT02StationTable = array[array.count - 1] as MstT02StationTable
//                var statName1 = (map1.item(MSTT02_STAT_ID) as String).station()
//                var statName2 = (map2.item(MSTT02_STAT_ID) as String).station()
//                destArr.addObject(["\(map1.item(MSTT02_STAT_ID)) - \(map1.item(MSTT02_STAT_NAME_EXT2))"])
//            }
        }
        
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if (segment.selectedSegmentIndex == 0) {
//            return 1
//        } else {
//            return stationArr.count
//        }
//    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        
//        if (segment.selectedSegmentIndex == 0) {
//            return ""
//        } else {
//            return sectionTitle[section]
//        }
//    }
    
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        
//        if (segment.selectedSegmentIndex == 0) {
//            return nil
//        } else {
//            return sectionTitle
//        }
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (segment.selectedSegmentIndex == 0) {
            return 85
        } else {
            return 55
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segment.selectedSegmentIndex == 0) {
            return LineArr.count
        } else {
            return stationArr.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (segment.selectedSegmentIndex == 0) {
        
            var lineMap: MstT01LineTable = LineArr[indexPath.row] as MstT01LineTable
            
            if ((lineMap.item(MSTT01_LINE_ID) as String) == "28002") {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MLineCell", forIndexPath: indexPath) as UITableViewCell
                
                var lineName = cell.viewWithTag(402) as UILabel
                lineName.text = (lineMap.item(MSTT01_LINE_ID) as String).line()
                
                var lineJPName = cell.viewWithTag(403) as UILabel
                lineJPName.text = (lineMap.item(MSTT01_LINE_NAME) as String) + "（"+(lineMap.item(MSTT01_LINE_NAME_KANA) as String) + "）"
                
                var lineDest1 = cell.viewWithTag(404) as UILabel
                lineDest1.text = "2800228".station() + " - " + "2800201".station()
                
                var lineKana1 = cell.viewWithTag(405) as UILabel
                lineKana1.text = "荻窪" + " - " + "池袋"
                
                var lineDest2 = cell.viewWithTag(406) as UILabel
                lineDest2.text = "2800223".station() + " - " + "2800201".station()
                
                var lineKana2 = cell.viewWithTag(407) as UILabel
                lineKana2.text = "方南町" + " - " + "池袋"
                
                return cell

            } else {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LineListCell", forIndexPath: indexPath) as UITableViewCell
 
                var imgLine = cell.viewWithTag(301) as UIImageView
                imgLine.image = lineImageNormal(lineMap.item(MSTT01_LINE_ID) as String)
                
                var lineName = cell.viewWithTag(302) as UILabel
                lineName.text = (lineMap.item(MSTT01_LINE_ID) as String).line()
            
                var lineJPName = cell.viewWithTag(305) as UILabel
                lineJPName.text = (lineMap.item(MSTT01_LINE_NAME) as String) + "（"+(lineMap.item(MSTT01_LINE_NAME_KANA) as String) + "）"
            
                var lineDest = cell.viewWithTag(304) as UILabel
                lineDest.text = destStatName(lineMap.item(MSTT01_LINE_ID) as String)
                
                var lineKana = cell.viewWithTag(306) as UILabel
                lineKana.text = destStatJPName(lineMap.item(MSTT01_LINE_ID) as String)
                
                return cell
            }

        } else {
        
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StationListCell", forIndexPath: indexPath) as UITableViewCell
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            
            var textName = cell.viewWithTag(201) as UILabel
            textName.text = (map.item(MSTT02_STAT_ID) as String).station()
            
            var textJPName = cell.viewWithTag(203) as UILabel
            textJPName.text = (map.item(MSTT02_STAT_NAME) as String) + "（" + (map.item(MSTT02_STAT_NAME_KANA) as String) + "）"
                        
            var view = cell.viewWithTag(202) as UIView!
            
            if (view != nil) {
                view.removeFromSuperview()
            }
            
            var lineView = UIView()
            lineView.frame = CGRectMake(225, 5, 70, 45)
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
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (segment.selectedSegmentIndex == 0) {
            var lineList: LineStationList = self.storyboard?.instantiateViewControllerWithIdentifier("LineStationList") as LineStationList
            
            let map = LineArr[indexPath.row] as MstT01LineTable
            lineList.line_id = map.item(MSTT01_LINE_ID) as String
            lineList.line_name = (map.item(MSTT01_LINE_ID) as String).line()
            
            self.navigationController?.pushViewController(lineList, animated: true)
        } else {
            var detail: StationDetail = self.storyboard?.instantiateViewControllerWithIdentifier("StationDetail") as StationDetail
            
            var map: MstT02StationTable = stationArr[indexPath.row] as MstT02StationTable
            
            detail.cellJPName = map.item(MSTT02_STAT_NAME) as String
            detail.cellJPNameKana = map.item(MSTT02_STAT_NAME_KANA) as String
            detail.stat_id = map.item(MSTT02_STAT_ID) as String
            detail.statMetroId = map.item(MSTT02_STAT_METRO_ID) as String

            self.navigationController?.pushViewController(detail, animated: true)
        }
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
    
    
    func destStatName(lineId: String) -> String {
    
        var destStat:String = ""
        switch (lineId) {
        case "28001":
            destStat = "2800119".station() + " - " + "2800101".station()
        case "28003":
            destStat = "2800321".station() + " - " + "2800301".station()
        case "28004":
            destStat = "2800423".station() + " - " + "2800401".station()
        case "28005":
            destStat = "2800520".station() + " - " + "2800501".station()
        case "28006":
            destStat = "2800601".station() + " - " + "2800624".station()
        case "28008":
            destStat = "2800801".station() + " - " + "2800814".station()
        case "28009":
            destStat = "2800919".station() + " - " + "2800901".station()
        case "28010":
            destStat = "2801001".station() + " - " + "2801016".station()
            
        default:
            destStat = ""
        }
        
        return destStat
    }
    
    func destStatJPName(lineId: String) -> String {
        
        var destStat:String = ""
        switch (lineId) {
        case "28001":
            destStat = "渋谷" + " - " + "浅草"
        case "28003":
            destStat = "中目黒" + " - " + "北千住"
        case "28004":
            destStat = "西船橋" + " - " + "中野"
        case "28005":
            destStat = "代々木上原" + " - " + "北綾瀬"
        case "28006":
            destStat = "和光市" + " - " + "新木場"
        case "28008":
            destStat = "渋谷" + " - " + "押上〈スカイツリー前〉"
        case "28009":
            destStat = "目黒" + " - " + "赤羽岩淵"
        case "28010":
            destStat = "和光市" + " - " + "渋谷"
            
        default:
            destStat = ""
        }
        
        return destStat
    }

}
