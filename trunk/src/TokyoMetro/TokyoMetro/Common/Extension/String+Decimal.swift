//
//  String+Decimal.swift
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension String {
    
    func decimal() -> String {
        return (self as NSString).decimal();
    }
    
    func zero() -> String {
        return (self as NSString).zero();
    }
    
    func zeroIsBlank() -> String {
        return (self as NSString).zeroIsBlank();
    }
    
    func zeroIsNil() -> String {
        return (self as NSString).zeroIsNil();
    }
    
    func zeroIsSpace() -> String {
        return (self as NSString).zeroIsSpace();
    }
    
    func zeroIS() -> String {
        return (self as NSString).zeroIs();
    }
    
    func zeroIs(replace:String) -> String {
        return (self as NSString).zeroIs(replace);
    }
    
    func currency(code:String) -> String{
        return (self as NSString).currency(code);
    }
    
    func decimal(deci:Int) -> String {
        return (self as NSString).decimal(deci);
    }
    
    func decimalWithSign(deci:Int) -> String {
        return (self as NSString).decimalWithSign(deci);
    }
    
    func decimalWithSign() -> String {
        return (self as NSString).decimalWithSign;
    }
    
    func colorForSign() -> String {
        return (self as NSString).colorForSign();
    }
    
    func colorForCompare(value:String) -> String{
        return (self as NSString).colorForCompare(vlaue);
    }
    
    func colorForCompareDouble(value:String) -> Strting{
        return (self as NSString).colorForCompareDouble(value);
    }
    
    func numberic() -> String {
        return (self as NSString).numberic();
    }
    
    func numberOfDecimal()-> String {
        return (self as NSString).numberOfDecimal();
    }
    
    func doubleValueIsEqualTo(value:String) -> Bool {
        return (self as NSString).doubleValueIsEqualTo(value);
    }
    
    func unitCheck(unit:String) -> Bool {
        return (self as NSString).unitCheck(unit);
    }
    
    func unitPart(unit:String) -> Bool {
        return (self as NSString).unitPart(unit);
    }
}