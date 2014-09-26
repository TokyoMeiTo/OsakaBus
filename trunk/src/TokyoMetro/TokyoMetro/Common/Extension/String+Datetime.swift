//
//  String+Datetime.swift
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension String{
    
    func dateWithFormat(source:String,target:String) -> String {
        return (self as NSString).dateWithFormat(source, target: target);
    }
    
    func plainDate() -> String{
        return (self as NSString).plainDAte();
    }
    
    func yyyyMMddHHmmss() -> String{
        return (self as NSString).yyyyMMddHHmmss();
    }
    
    func yyyyMMddmm() ->String{
        return (self as NSString).yyyyMMddHHmm();
    }
    
    func yyyyMMdd() ->String{
        return (self as NSString).yyyyMMdd();
    }
    
    func yyMMdd() -> String {
        return (self as NSString).yyMMdd();
    }
    
    func MMdd() -> String{
        return (self as NSString).MMdd();
    }
    
    func HHmmss() -> String{
        return (self as NSString).HHmmss();
    }
    
    func HHmm() -> String{
        return (self as NSString).HHmm();
    }
    
    func yyyyMMddHHmm(split:String) -> String{
        return (self as NSString).yyyyMMddHHmm(split);
    }
    
    func yyyyMMddHHmmss(split:String) -> String{
        return (self as NSString).yyyyMMddHHmmss(split);
    }
    
    func yyyyMMdd(split:String) ->String {
        return (self as NSString).yyyyMMdd(split);
    }
    
    func yyMMdd(split:String) -> String{
        return (self as NSString).yyMMdd(split);
    }
    
    func MMdd(split:String) -> String {
        return (self as NSString).MMdd(split);
    }
    
}