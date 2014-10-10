//
//  FacilityList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class FacilityList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!

    var facilityArr: NSMutableArray = NSMutableArray.array()
    
    var statId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        odbFacility()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbFacility() {
    
        var table = StaT04FacilityTable()
        
        table.statId = statId
        var rows = table.selectAll()
        var facilityArr1: NSMutableArray = NSMutableArray.array()
        var facilityArr2: NSMutableArray = NSMutableArray.array()
        var facilityArr3: NSMutableArray = NSMutableArray.array()
        var facilityArr4: NSMutableArray = NSMutableArray.array()
        var facilityArr5: NSMutableArray = NSMutableArray.array()
        for key in rows {
            key as StaT04FacilityTable
            var faciType = key.item(STAT04_FACI_TYPE) as String
            if (faciType == "1") {
                facilityArr1.addObject(key)
            } else if (faciType == "2") {
                facilityArr2.addObject(key)
            } else if (faciType == "3") {
                facilityArr3.addObject(key)
            } else if (faciType == "4") {
                facilityArr4.addObject(key)
            } else {
                facilityArr5.addObject(key)
            }
            
        }
        
        if (facilityArr1.count > 0) {
            facilityArr.addObject(facilityArr1)
        }
        
        if (facilityArr2.count > 0) {
            facilityArr.addObject(facilityArr2)
        }
        
        if (facilityArr3.count > 0) {
            facilityArr.addObject(facilityArr3)
        }
        
        if (facilityArr4.count > 0) {
            facilityArr.addObject(facilityArr4)
        }
        
        if (facilityArr5.count > 0) {
            facilityArr.addObject(facilityArr5)
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return facilityArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilityArr[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("FacilityListCell", forIndexPath: indexPath) as UITableViewCell
        
        var key = facilityArr[indexPath.section][indexPath.row] as StaT04FacilityTable
        
        var faciDesp = key.item(STAT04_FACI_DESP) as? String
        
//        var imgFacility = UIImageView()
//        
//        if (faciType == "4") {
//            
//            imgFacility.frame = CGRectMake(15, 10, 60, 30)
//            var image: UIImage = UIImage(named: "in_toilet_wheelchair.png")
//            imgFacility.image = image
//        } else if (faciType == "1") {
//            var frame:CGRect = CGRectMake(15, 10, 31, 30)
//            imgFacility.frame = frame
//            imgFacility.image = UIImage(named: "escalator_wheelchair.png")
//        } else if (faciType == "2") {
//            imgFacility.frame = CGRectMake(15, 10, 31, 30)
//            imgFacility.image = UIImage(named: "escalator.png")
//        } else if (faciType == "3") {
//            imgFacility.frame = CGRectMake(15, 10, 31, 30)
//            imgFacility.image = UIImage(named: "in_lift.png")
//        }
//        
//        cell.addSubview(imgFacility)
        
        var labName = cell.viewWithTag(102) as UILabel
        labName.text = faciDesp
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 36)
        view.backgroundColor = UIColor(red: 103/255, green: 188/255, blue: 228/255, alpha: 1)
//        view.backgroundColor = UIColor.blueColor()
        
        var key = facilityArr[section][0] as StaT04FacilityTable
        var faciType = key.item(STAT04_FACI_TYPE) as String
        
        var image = UIImageView()
        image.frame = CGRectMake(15, 4, 28, 28)
        image.image = UIImage(named: "escalator_wheelchair.png")
        
        var title = UILabel()
        title.frame = CGRectMake(55, 0, 250, 36)
        title.backgroundColor = UIColor.clearColor()
        title.text = faciType.facilityType()
        
        view.addSubview(image)
        view.addSubview(title)
                
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
}
