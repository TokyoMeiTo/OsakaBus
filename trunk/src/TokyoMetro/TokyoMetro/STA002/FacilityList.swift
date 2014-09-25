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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facilityArr.addObject(["1","电梯"])
        facilityArr.addObject(["2","手扶梯"])
        facilityArr.addObject(["3","楼梯升降机"])
        facilityArr.addObject(["4","厕所"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilityArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("FacilityListCell", forIndexPath: indexPath) as UITableViewCell
        
        var imgFacility = UIImageView()
        
        if (facilityArr[indexPath.row][0] as String == "4") {
            
            imgFacility.frame = CGRectMake(15, 10, 60, 30)
            var image: UIImage = UIImage(named: "in_toilet_wheelchair.png")
            imgFacility.image = image
        } else if (facilityArr[indexPath.row][0] as String == "1") {
            var frame:CGRect = CGRectMake(15, 10, 31, 30)
            imgFacility.frame = frame
            imgFacility.image = UIImage(named: "escalator_wheelchair.png")
        } else if (facilityArr[indexPath.row][0] as String == "2") {
            imgFacility.frame = CGRectMake(15, 10, 31, 30)
            imgFacility.image = UIImage(named: "escalator.png")
        } else if (facilityArr[indexPath.row][0] as String == "3") {
            imgFacility.frame = CGRectMake(15, 10, 31, 30)
            imgFacility.image = UIImage(named: "in_lift.png")
        }
        
        cell.addSubview(imgFacility)
        
        var labName = cell.viewWithTag(102) as UILabel
        labName.text = facilityArr[indexPath.row][1] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
}
