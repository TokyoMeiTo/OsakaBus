//
//  FacilityList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-23.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class FacilityList: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!

    var facilityArr: NSMutableArray = NSMutableArray.array()
    
    var statId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        odbFacility("0")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func odbFacility(faciLocl: String) {
    
        var table = StaT04FacilityTable()
        
        facilityArr = NSMutableArray.array()
        
        table.statId = statId
        table.faciLocl = faciLocl
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
        
//        if (facilityArr5.count > 0) {
//            facilityArr.addObject(facilityArr5)
//        }

    }
    
    @IBAction func segmentChnaged() {
        if (segment.selectedSegmentIndex == 0) {
            odbFacility("0")
            tableView.reloadData()
        } else {
            odbFacility("1")
            tableView.reloadData()
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

        var labName = cell.viewWithTag(102) as UILabel
        labName.text = faciDesp
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 36)
        view.backgroundColor = UIColor(red: 103/255, green: 188/255, blue: 228/255, alpha: 1)
        
        var key = facilityArr[section][0] as StaT04FacilityTable
        var faciType = key.item(STAT04_FACI_TYPE) as String
        
        var image = UIImageView()
        if (faciType == "1") {
            image.frame = CGRectMake(15, 4, 28, 28)
            image.image = UIImage(named: "escalator_wheelchair")
        } else if (faciType == "2") {
            image.frame = CGRectMake(15, 4, 28, 28)
            image.image = UIImage(named: "escalator")
        }  else if (faciType == "3") {
            image.frame = CGRectMake(15, 4, 28, 28)
            if (segment.selectedSegmentIndex == 0) {
                image.image = UIImage(named: "out_lift")
            } else {
                image.image = UIImage(named: "in_lift")
            }
            
        } else if (faciType == "4") {
            image.frame = CGRectMake(15, 4, 43, 28)
            if (segment.selectedSegmentIndex == 0) {
                image.image = UIImage(named: "out_toilet_wheelchair")
            } else {
                image.image = UIImage(named: "in_toilet_wheelchair")
            }
        } else if (faciType == "0") {

        }
        
        
        var title = UILabel()
        title.frame = CGRectMake(65, 0, 250, 36)
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
