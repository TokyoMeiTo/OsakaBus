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
    
    var segmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineView.hidden = true
        
        if (segmentIndex == 0) {
            segment.selectedSegmentIndex = 0
        } else {
            segment.selectedSegmentIndex = 1
        }

        odbStation()
        odbLine()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

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
        var rows: NSArray = table.excuteQuery("select *, ROWID, count(distinct STAT_NAME_EXT1) from MSTT02_STATION where 1 = 1 and STAT_ID like '280%' group by STAT_NAME_EXT1")
        
        var allRows: NSArray = table.excuteQuery("select *, ROWID from MSTT02_STATION where 1 = 1 and STAT_ID like '280%'")
        
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
    }
    
    func odbLine(){
        var table = MstT01LineTable()
        
        table.lineId = "280"
        var rows: NSArray = table.selectLike()
        
        for key in rows {
            LineArr.addObject(key)

        }
        
    }
    

    
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

                imgLine.image = (lineMap.item(MSTT01_LINE_ID) as String).getLineImage()
                
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
//                    line.image = lineImage(arrStation[i])
                    line.image = arrStation[i].getLineMiniImage()
                    
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
            
            var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            
            self.navigationController?.pushViewController(lineList, animated: true)
        } else {
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
