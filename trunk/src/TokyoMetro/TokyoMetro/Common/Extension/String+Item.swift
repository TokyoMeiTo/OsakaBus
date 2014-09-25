//
//  NSString+Item.swift
//  TokyoMetro
//
//  Created by limc on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

let ITEM_TABLE_NAME = "Localizable"

let ITEM_KEY_STATION = "STATION"
let ITEM_KEY_LINE = "LINE"

extension String {

  func line() -> String{
    return self.itemValue(ITEM_KEY_LINE)
  }

  func line(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_LINE ,defaultValue: defaultValue)
  }


  func itemValue(item:String) -> String{
     return self.itemValue(item, defaultValue:"")
  }

  func itemValue(item:String,defaultValue:String) -> String{
     if(self.isEmpty){
       return defaultValue
     }
     return localizedString("\(item)_\(self)")
  }

  func localizedString(key:String) -> String {
    return NSLocalizedString(key,tableName:ITEM_TABLE_NAME,comment:"")
  }
}
