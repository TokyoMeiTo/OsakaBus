//
//  String+CString.swift
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation



extension String {
    
    func relpaceAll(str:String,target:String) -> String{
        return (self as NSString).replaceAll(str, target: target);
        
    }
    
    func insertAt(str:String,post:UInt) ->String{
        return (self as NSString).insertAt(str, post: post);
    }
    
    func indexOf(str:String) -> UInt{
        return (self as NSString).indexOf(str)
    }
    
    func append(str:String) ->String{
        return (self as NSString).append(str);
    }
    
    func concate(str:String) -> String{
        return (self as NSString).concate(str);
    }
    
    func split(split:String) -> AnyObject{
        return (self as NSString).split(split)
    }
    
    func trim() -> String{
        return (self as NSString).trim();
    }
    
    func trim(trim:String) -> String{
        return (self as NSString).trim(trim);
    }
    
    func trimLeft() -> String{
        return (self as NSString).trimLeft();
    }
    
    func trimLeft(trim:String) -> String{
        return (self as NSString).trimLeft()
    }
    
    func trimRight() -> String{
        return (self as NSString).trimRight();
    }
    
    func trimRight(trim:String) -> String{
        return (self as NSString).trimRight(trim);
    }
    
    func left(num:UInt) -> String{
        return (self as NSString).left(num);
    }
    
    func right(num:UInt) -> String{
        return (self as NSString).right(num)
    }
    
    func left(left:UInt,right:UInt) -> String{
        return (self as NSString).left(left,right:right);
    }
    
    func right(right:UInt,left:UInt) -> String {
        return (self as NSString).right(right,left:left);
    }
    
    func getLineStatImage() -> UIImage {
        
        var image = UIImage(named: "line_stat_\(self)")
        return image
    }
    
    func getLineStatImage(type: String) -> UIImage {
        
        var image = UIImage(named: "line_stat_\(self)\(type)")
        return image
    }
    
    func getStationIconImage() -> UIImage {
        
        var image = UIImage(named: "station_icon_\(self)")
        return image
    }
    
    func getLineImage() -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_\(self)")
        return image
    }
    
    func getLineMiniImage() -> UIImage {
        
        var image = UIImage(named: "tablecell_lineicon_mini_\(self)")
        return image
    }
    
    func getImage() -> UIImage {
        
        var image = UIImage(named: "\(self)")
        return image
    }
    
    
    /**
    * 获取StationInnerMap下的图片路径
    */
    func getStationInnerMapImagePath() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache/Resource/StationInnerMap/" + self + ".png")
        println(path)
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
    /**
    * 获取Landmark下的图片路径
    */
    func getLandmarkImagePath() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache/Resource/Landmark/" + self + ".png")
        println(path)
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
    /**
    * 获取LineGraph下的图片路径
    */
    func getLineGraphImagePath() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache/Resource/LineGraph/" + self + ".png")
        println(path)
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
    /**
    * 获取攻略PDF路径
    */
    func getStrategyPDFPath() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache/Resource/Strategy/" + self + ".pdf")
        println(path)
        var fileExists = NSFileManager().fileExistsAtPath(path)
        var file:UnsafeMutablePointer<FILE>?
        if(fileExists){
            file = fopen(path, "")
        }
        return path
    }
    
}