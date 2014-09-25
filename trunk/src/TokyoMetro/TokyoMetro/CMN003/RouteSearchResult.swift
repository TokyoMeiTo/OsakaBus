//
//  searchResult.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
class RouteSearchResult : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var items : NSArray!
    var routeStart : String = ""
    var routeEnd : String = ""
    
    @IBOutlet weak var tbSResult: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["银座", "大手町", "东京", "日本桥" ]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SResultCell", forIndexPath: indexPath) as UITableViewCell!
        var stationTime = cell.viewWithTag(1000) as UILabel
        var stationPosition = cell.viewWithTag(1001) as UILabel
        var stationName = cell.viewWithTag(1002) as UILabel
        
        if (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1) == 1{
            stationPosition.text = "起点"
            stationTime.text = "0分钟"
        } else if (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1) == 2 {
            stationPosition.text = (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1).description
            stationTime.text = "10分钟"
        } else if (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1) == 3 {
            stationPosition.text = (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1).description
            stationTime.text = "21分钟"
        } else if (self.items!.indexOfObject(self.items!.objectAtIndex(indexPath.row))+1) == 4 {
            stationPosition.text = "终点"
            stationTime.text = "32分钟"
        }
        
        stationName.text = self.items!.objectAtIndex(indexPath.row) as String
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}