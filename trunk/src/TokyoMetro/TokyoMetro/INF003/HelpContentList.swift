//
//  HelpContentList.swift
//  TokyoMetro
//
//  Created by caowj on 14-9-19.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class HelpContentList: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    /*******************************************************************************
    * Private Properties
    *******************************************************************************/
    var rescArr: NSMutableArray = NSMutableArray.array()
    
//    var rescType: String = "1"
    
    /*******************************************************************************
    * Overrides From UIViewController
    *******************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "INF003_01".localizedString()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        odbRescure()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*******************************************************************************
    *    Implements Of UITableViewDelegate
    *******************************************************************************/

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 0, 320, 30)
        view.backgroundColor = UIColor(red: 103/255, green: 188/255, blue: 228/255, alpha: 1)
        var title = UILabel()
        title.frame = CGRectMake(15, 0, 250, 30)
        title.text = rescArr[section][0] as? String
        title.textColor = UIColor.whiteColor()
        title.font = UIFont.boldSystemFontOfSize(17)
        
        view.addSubview(title)
        
        var image:UIImageView = UIImageView(frame: CGRectMake(273, 3, 32, 23))
        image.image = UIImage(named: "arrow_down")
        view.addSubview(image)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var helpContentDetail: HelpContentDetail = self.storyboard?.instantiateViewControllerWithIdentifier("HelpContentDetail") as HelpContentDetail
        
        var map: InfT03RescureTable = rescArr[indexPath.section][1][indexPath.row] as InfT03RescureTable
        helpContentDetail.chTtile = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as String
        helpContentDetail.jpTtile = map.item(INFT03_RESCURE_RESC_CONTENT_JP) as String
        helpContentDetail.rowId = map.rowid
        helpContentDetail.favoFlag = map.item(INFT03_RESCURE_FAVO_FLAG) as? String
        
        var backButton = UIBarButtonItem(title: "PUBLIC_05".localizedString(), style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(helpContentDetail, animated: true)
    }

    /*******************************************************************************
    *      Implements Of UITableViewDataSource
    *******************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rescArr[section][1].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return rescArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HelpContentListCell", forIndexPath: indexPath) as UITableViewCell
        
        var map: InfT03RescureTable = rescArr[indexPath.section][1][indexPath.row] as InfT03RescureTable
        
        var textTitle = cell.viewWithTag(201) as UILabel
        textTitle.text = map.item(INFT03_RESCURE_RESC_CONTENT_CN) as? String
        textTitle.numberOfLines = 2
        
        if ((map.item(INFT03_RESCURE_READ_FLAG) as? String) == "1") {
            textTitle.textColor = UIColor.lightGrayColor()
        } else {
            textTitle.textColor = UIColor.blackColor()
        }
        
        var imageView: UIImageView = cell.viewWithTag(202) as UIImageView
        if ((map.item(INFT03_RESCURE_FAVO_FLAG) as? String) == "1") {
            imageView.hidden = false
        } else {
            imageView.hidden = true
        }
        
        return cell

    }

    /*******************************************************************************
    *    Private Methods
    *******************************************************************************/
    
    func odbRescure() {
    
        var table: InfT03RescureTable = InfT03RescureTable()
        
        rescArr = NSMutableArray.array()
        var typeRows = table.excuteQuery("select *, ROWID, COUNT(RESC_TYPE) from INFT03_RESCURE where 1=1 group by RESC_TYPE")
        
        for key in typeRows {
            key as InfT03RescureTable
            var rescType: String! = key.item(INFT03_RESCURE_RESC_TYPE) as String
            table.rescType = rescType
            var rows = table.selectAll()
            rescArr.addObject([rescType, rows])
        }
        
        
    }

    
    func textHeight(value:String) -> CGFloat {
        
        var font:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
        var maxSize = CGSizeMake(290, 2000)
        var size:CGSize = value.boundingRectWithSize(maxSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: font, context: nil).size
        
        return size.height
    }
    
}
