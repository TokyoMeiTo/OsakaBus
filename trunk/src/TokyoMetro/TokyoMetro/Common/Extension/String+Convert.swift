//
//  File.swift
//  TokyoMetro
//
//  Created by limc on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

extension String {
    func blankIsNil() -> String{
       return (self as NSString).blankIsNil();
    }

    func blankIsSpace() -> String{
        return (self as NSString).blankIsSpace();
    }

    func blankIsZero() -> String{
        return (self as NSString).blankIsZero();
    }

    func blankIs(replace: String) -> String{
        return (self as NSString).blankIs(replace);
    }

    func spaceIsNil() -> String{
       return (self as NSString).spaceIsNil();
    }

    func spaceIsBlank() -> String{
       return (self as NSString).spaceIsBlank();
    }

    func spaceIsZero() -> String{
       return (self as NSString).spaceIsZero();
    }

    func spaceIs(replace: String) -> String{
       return (self as NSString).spaceIs(replace);
    }
}
