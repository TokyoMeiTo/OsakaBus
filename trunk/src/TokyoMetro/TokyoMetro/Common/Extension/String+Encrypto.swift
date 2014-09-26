//
//  String+Encrypto.swift
//  TokyoMetro
//
//  Created by lusy on 2014/09/26.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension String{
    
    func md5() -> String {
        return (self as NSString).md5();
    }
    
    func sha1() -> String {
        return (self as NSString).sha1();
    }
    
    func sha224() -> String {
        return (self as NSString).sha224();
    }
    
    func sha256() -> String {
        return (self as NSString).sha256();
    }
    
    func sha384() -> String {
        return (self as NSString).sha384();
    }
    
    func sha512() -> String {
        return (self as NSString).sha512();
    }
    
    func sha1_base64() -> String {
        return (self as NSString).sha1_base64();
    }
    
    func md5_base64() -> String {
        return (self as NSString).md5_base64();
    }
    
    func base64() -> String {
        return (self as NSString).base64();
    }
}