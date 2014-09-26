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
    
    func indexOf(str:String) -> String{
        return (self as NSString).indexOf(str);
    }
    
    func append(str:String) ->String{
        return (self as NSString).append(str);
    }
    
    func concate(str:String) -> String{
        return (self as NSString).concate(str);
    }
    
    func split(split:String) -> String{
        return (self as NSString).split(split);
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
    
    func trimLeft(trim:String){
        return (self as NSString).trimLeft(trim);
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
        return (self as NSStirng).right(num);
    }
    
    func left(left:UInt,right:UInt) -> String{
        return (self as NSStirng).left(left,right:right);
    }
    
    func right(right:UInt,left:UInt) -> String {
        return (self as NSString).right(right,left:left);
    }
}