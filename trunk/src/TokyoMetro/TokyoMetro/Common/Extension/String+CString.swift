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
    
    func getStationIconImage(type: String) -> UIImage {
        
        var image = UIImage(named: "station_icon_\(self)\(type)")
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
     * 获取Resource下的图片
     */
    func image(folderNm:String) -> UIImage {
        let mDocumentFolder = NSHomeDirectory() + "/Library/Caches"
        let path = mDocumentFolder.stringByAppendingPathComponent("TokyoMetroCache/Resource/" +
            folderNm + "/" + self + ".png")
        var fileExists = NSFileManager().fileExistsAtPath(path)
        
        var mDeviceVersion:Double = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
        if(fileExists){
            if(mDeviceVersion >= 7.0 && mDeviceVersion <= 7.9){
                return UIImage(contentsOfFile: path)
            }else{
                return UIImage(named: path)
            }
        }
        return UIImage(named: "inf00214")
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
    * 获取LineGraph下的图片路径
    */
    func getStationInnerComPath() -> String {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent("TokyoMetroCache/Resource/StationInnerCom/" + self + ".png")
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
    
    /**
     * 获取区域
     */
    func getDistrict() -> Array<String> {
        var specialWards:Array<String> = Array<String>()
        for(var i=1;i<24;i++){
            var specialWard = ""
            if(i<10){
                specialWard = "0\(i)"
            }else{
                specialWard = "\(i)"
            }
            specialWards.append(specialWard.specialWard())
        }
        return specialWards
    }
    
    /**
     * 获取本地语言
     */
    func localLanguage() -> String {
        var languages:[AnyObject] = NSLocale.preferredLanguages()
        if(languages.count > 0){
            return "\(languages[0])"
        }else{
            return ""
        }
    }
}