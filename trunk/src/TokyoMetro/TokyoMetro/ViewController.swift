//
//  ViewController.swift
//  TokyoMetro
//
//  Created by limc on 2014/09/02.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class ViewController: UIViewController,OAPAsyncParserDelegate {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.odbSample();
        testString()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func odbSample(){
        var table = MstT01LineTable()
        
//       // table.select().item(aaaa,"").item().item().update();
//        table.selectTop(1).array()[].key.item(MSTT01_LINE_ID, value: "111").update();
     
//        var rows:NSArray = table.excuteQuery("select LINE_ID from MSTT01_LINE where 1=1")
//    
//        for key in rows {
//            
//           key as MstT01LineTable
//           var id:AnyObject = key.item(MSTT01_LINE_ID)
//            
//            println("\(id)")
//        }

        var tab = UsrT02TrainAlarmTable()
        var row = tab.excuteQuery("select TRAI_ALAM_ID from USRT02_TRAIN_ALARM where 1=1")
        for value in row{
            value as UsrT02TrainAlarmTable
            var id:AnyObject = value.item(USRT02_TRAIN_ALARM_TRAI_ALAM_ID)
            
            println("\(id)")
        }
        
        
        
        
        //table.lineId = "2800"
        
        //table.selectTop(3)
        
        
        //for key in rows {
        
        ///    key as MstT01LineTable
        //    var id:AnyObject = key.item(MSTT01_LINE_ID)
        
        //    println("\(id)")
        //}
//        var id:AnyObject = table.item(MSTT01_LINE_ID)
//         println("\(id)")
        
    }
    
    func testString() {
        var test1: String = ""
        println("blankIsNil:\(test1.blankIsNil())")
        println("blankIsSpace:" + test1.blankIsSpace())
        println("blankIsZero:" + test1.blankIsZero())
        println("blankIs:" + test1.blankIs("test"))
    }
    
    
    func jsonParserSample(){
        var jsonparser = OAPAsyncJSONParser()
        
        // var err = NSError()
        var url:NSURL = NSURL.URLWithString("http://www.weather.com.cn/data/sk/101010100.html")
        
        var data =
        NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingUncached, error: nil)
        
        var jsonStr=NSString(data:data,encoding:NSUTF8StringEncoding)
        
        var testJsonData=jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        jsonparser.objToBeParse = testJsonData
        jsonparser.delegate = self
        jsonparser.asyncParse();
    }
    
    func parseDidFinished(parser:AnyObject){
         println(parser.objParsed)
    }

}

