//
//  StationDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class StationDetail: UIViewController, UIAlertViewDelegate {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellJPNmaeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var weSegment: UISegmentedControl!
    @IBOutlet weak var chaSegment: UISegmentedControl!
    
    //Receiving variable assigned to MainVC's var "items"
    var cellName:String = ""
    var cellDesc:String = ""
    var cellClose = ""
    var cellJapanTime = ""
    var cellJapanWETime = ""
    var cellChinaTime = ""
    var cellChinaWETime = ""
    var cellStation = ""
    var arrClose = [String]()
    var arrTime = [String]()
    var size: CGSize!
    
    // 查询该条线的线路id
    var stat_id = ""
    
    var statSeqArr: NSArray = NSArray.array()
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign your UILabel text to your String
        cellNameLabel.text = cellName

        cellJPNmaeLabel.text = "銀座(ぎんざ)"
        //Assign String var to NavBar title
        self.title = cellName
        
        odbStation()
        
        size = UIScreen.mainScreen().bounds.size
        
        
        addLineView()
        
        addLineTime()
        
        
        scrollView.contentSize = CGSizeMake(320, 600)
        
    }
    
    func odbStation(){
        var table = MstT02StationTable()
        // 存储丸之内线m段车站
        var mStationArr: NSMutableArray = NSMutableArray.array()
        
        table.statId = stat_id
        var rows: NSArray = table.selectAll()
        
        for key in rows {
            
            key as MstT02StationTable
            
            var statGroupId = key.item(MSTT02_STAT_GROUP_ID) as String
            statSeqArr = table.excuteQuery("select STAT_SEQ from MSTT02_STATION where 1 = 1 and STAT_GROUP_ID = \(statGroupId)")
        }
    }
    
    
    @IBAction func addSubway() {
    
        var date: String = NSDate.date().description.yyyyMMddHHmmss()
        
        println(date)
    }
    
    
    @IBAction func cellectSubway() {
        
        var sureBtn: UIAlertView = UIAlertView(title: "", message: "你确定要收藏吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        
        sureBtn.show()
        
        
    }
    
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        if (buttonIndex == 1) {
//            var name: String = cellName
//            var description: String = cellStation
//            taskMgr.addTask(name, desc: description)
        }
    }
    
    func addLineView() {
        
        for (var i = 0; i < statSeqArr.count; i++) {
            
            var lineImage: UIImageView = UIImageView()
            lineImage.frame = CGRectMake(CGFloat(20 + i * 35), 85, 30, 30)
            lineImage.image = UIImage(named: "station_icon_g-19.png")
            
            self.scrollView.addSubview(lineImage)
        }
        
    }

    
    
    @IBAction func chinaSegmentChanged(sender: UISegmentedControl) {
    
        if (sender.selectedSegmentIndex == 0) {
        
            if (weSegment.selectedSegmentIndex == 0) {
                arrTime = cellChinaTime.componentsSeparatedByString(",")
            } else {
                arrTime = cellChinaWETime.componentsSeparatedByString(",")
            }
            
            for (var i = 0; i < arrTime.count; i++) {
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = arrTime[i]
            }
        } else {
        
            if (weSegment.selectedSegmentIndex == 0) {
                arrTime = cellJapanTime.componentsSeparatedByString(",")
            } else {
                arrTime = cellJapanWETime.componentsSeparatedByString(",")
            }
            
            for (var i = 0; i < arrTime.count; i++) {
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = arrTime[i]
            }
        }
    }
    
    @IBAction func weekendSegmentChanged(sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            
            if (chaSegment.selectedSegmentIndex == 0) {
                arrTime = cellChinaTime.componentsSeparatedByString(",")
            } else {
                arrTime = cellJapanTime.componentsSeparatedByString(",")
            }
            
            for (var i = 0; i < arrTime.count; i++) {
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = arrTime[i]
            }
        } else {
            
            if (chaSegment.selectedSegmentIndex == 0) {
                arrTime = cellChinaWETime.componentsSeparatedByString(",")
            } else {
                arrTime = cellJapanWETime.componentsSeparatedByString(",")
            }
            
            for (var i = 0; i < arrTime.count; i++) {
                (self.scrollView.viewWithTag(300 + i) as UILabel).text = arrTime[i]
            }
        }
    }
    
    func addLineTime() {
        
        if(cellClose.isEmpty) {
            return
        }
        
        arrClose = cellClose.componentsSeparatedByString(",")
        arrTime = cellChinaTime.componentsSeparatedByString(",")
        
        for (var i = 0; i < arrClose.count; i++) {
            
            var time1: UIView = UIView()
            time1.frame = CGRectMake(20, CGFloat(220 + i * 35), 280, 35)
            
            var icon: UIImageView = UIImageView()
            icon.frame = CGRectMake(0, 8.5, 18, 18)
            icon.image = UIImage(named: "tablecell_lineicon_mini_g.png")
            time1.addSubview(icon)
            
            var open1: UILabel = UILabel()
            open1.frame = CGRectMake(25, 0, 155, 35)
            open1.text = "开往\(arrClose[i])："
            open1.font = UIFont.boldSystemFontOfSize(18)
            time1.addSubview(open1)
            
            var open2: UILabel = UILabel()
            open2.frame = CGRectMake(180, 0, 100, 35)
            open2.text = arrTime[i]
            open2.font = UIFont.boldSystemFontOfSize(18)
            open2.textColor = UIColor.grayColor()
            open2.tag = 300 + i
            time1.addSubview(open2)
            
            self.scrollView.addSubview(time1)
            
        }
        
        var btnTime: UIButton = UIButton()
        btnTime.frame = CGRectMake(20, CGFloat(220 + arrClose.count * 35 + 15), 280, 35)
        btnTime.backgroundColor = UIColor.whiteColor()
        btnTime.setTitle("地铁时刻表", forState: UIControlState.Normal)
        btnTime.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnTime.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        btnTime.layer.borderWidth = 1
        btnTime.layer.cornerRadius = 4
        
        btnTime.addTarget(self, action: "showTime", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView.addSubview(btnTime)
        
        var btnFacility: UIButton = UIButton()
        btnFacility.frame = CGRectMake(20, btnTime.frame.origin.y + 50, 280, 35)
        btnFacility.setTitle("站内设施", forState: UIControlState.Normal)
        
        btnFacility.addTarget(self, action: "showFacility", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView.addSubview(btnFacility)
  
    }
    
    func showTime() {
    
        var detail: TimeTable = self.storyboard?.instantiateViewControllerWithIdentifier("TimeTable") as TimeTable
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func showFacility() {
    
        var facilityList: FacilityList = self.storyboard?.instantiateViewControllerWithIdentifier("FacilityList") as FacilityList
        
        self.navigationController?.pushViewController(facilityList, animated: true)
    }
    
    
    func lineColor(lineNum: String) -> UIColor {
        
        var color = UIColor.whiteColor()
        switch (lineNum) {
            
        case "1":
            color = UIColor.redColor()
        case "2":
            color = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
        case "3":
            color = UIColor.yellowColor()
        case "4":
            color = UIColor(red: 102/255.0, green: 0, blue: 102/255.0, alpha: 1)
        case "5":
            color = UIColor(red: 204/255.0, green: 0, blue: 204/255.0, alpha: 1)
        case "6":
            color = UIColor(red: 1, green: 50/255.0, blue: 101/255.0, alpha: 1)
        case "7":
            color = UIColor.orangeColor()
        case "8":
            color = UIColor.blueColor()
        case "9":
            color = UIColor(red: 149/255.0, green: 211/255.0, blue: 219/255.0, alpha: 1)
        case "10":
            color = UIColor(red: 201/255.0, green: 167/255.0, blue: 213/255.0, alpha: 1)
        case "11":
            color = UIColor(red: 128/255.0, green: 0, blue: 0, alpha: 1)
        case "12":
            color = UIColor(red: 12/255.0, green: 120/255.0, blue: 94/255.0, alpha: 1)
        case "13":
            color = UIColor(red: 231/255.0, green: 150/255.0, blue: 193/255.0, alpha: 1)
            
        default:
            color = UIColor.redColor()
            
        }
        
        return color
    }
    
    
    func stationIcon(statSeq: String) -> UIImage {
        var image = UIImage(named: "station_icon_c-01.png")
        
        switch(statSeq) {
        case "C01":
            image = UIImage(named: "station_icon_c-01.png")
        case "C02":
            image = UIImage(named: "station_icon_c-02.png")
        case "C03":
            image = UIImage(named: "station_icon_c-03.png")
        case "C04":
            image = UIImage(named: "station_icon_c-04.png")
        case "C05":
            image = UIImage(named: "station_icon_c-05.png")
        case "C06":
            image = UIImage(named: "station_icon_c-06.png")
        case "C07":
            image = UIImage(named: "station_icon_c-07.png")
        case "C08":
            image = UIImage(named: "station_icon_c-08.png")
        case "C09":
            image = UIImage(named: "station_icon_c-09.png")
        case "C10":
            image = UIImage(named: "station_icon_c-10.png")
        case "C11":
            image = UIImage(named: "station_icon_c-11.png")
        case "C12":
            image = UIImage(named: "station_icon_c-12.png")
        case "C13":
            image = UIImage(named: "station_icon_c-13.png")
        case "C14":
            image = UIImage(named: "station_icon_c-14.png")
        case "C15":
            image = UIImage(named: "station_icon_c-15.png")
        case "C16":
            image = UIImage(named: "station_icon_c-16.png")
        case "C17":
            image = UIImage(named: "station_icon_c-17.png")
        case "C18":
            image = UIImage(named: "station_icon_c-18.png")
        case "C19":
            image = UIImage(named: "station_icon_c-19.png")
        case "C20":
            image = UIImage(named: "station_icon_c-20.png")
        case "F01":
            image = UIImage(named: "station_icon_f-01.png")
        case "F02":
            image = UIImage(named: "station_icon_f-02.png")
        case "F03":
            image = UIImage(named: "station_icon_f-03.png")
        case "F04":
            image = UIImage(named: "station_icon_f-04.png")
        case "F05":
            image = UIImage(named: "station_icon_f-05.png")
        case "F06":
            image = UIImage(named: "station_icon_f-06.png")
        case "F07":
            image = UIImage(named: "station_icon_f-07.png")
        case "F08":
            image = UIImage(named: "station_icon_f-08.png")
        case "F09":
            image = UIImage(named: "station_icon_f-09.png")
        case "F10":
            image = UIImage(named: "station_icon_f-10.png")
        case "F11":
            image = UIImage(named: "station_icon_f-11.png")
        case "F12":
            image = UIImage(named: "station_icon_f-12.png")
        case "F13":
            image = UIImage(named: "station_icon_f-13.png")
        case "F14":
            image = UIImage(named: "station_icon_f-14.png")
        case "F15":
            image = UIImage(named: "station_icon_f-15.png")
        case "F16":
            image = UIImage(named: "station_icon_f-16.png")
            
        default:
            image = UIImage(named: "station_icon_c-01.png")
        }
        
        return image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
