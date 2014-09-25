//
//  NSString+Item.swift
//  TokyoMetro
//
//  Created by limc on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

let ITEM_TABLE_NAME = "Localizable"

// 站点
let ITEM_KEY_STATION = "STATION"
// 线路
let ITEM_KEY_LINE = "LINE"
// 换乘站点
let ITEM_KEY_STATION_GROUP = "STATION_GROUP"
// 出入口
let ITEM_KEY_STATION_EXIT = "STATION_EXIT"
// 都道府县
let ITEM_KEY_PREFECTURE = "PREFECTURE"
// 东京23区
let ITEM_KEY_SPECIAL_WARD = "SPECIAL_WARD"
// 运营会社
let ITEM_KEY_LINE_COMPANY = "LINE_COMPANY"
// 费用
let ITEM_KEY_TRAIN_FARE = "TRAIN_FARE"
// 收藏标志
let ITEM_KEY_IS_FAVORITE = "IS_FAVORITE"
// 已读标志
let ITEM_KEY_IS_READ = "IS_READ"
// 首末班车区分
let ITEM_KEY_FIRST_OR_LASR = "FIRST_OR_LASR"
// 上行下行区分
let ITEM_KEY_UP_OR_DOWN = "UP_OR_DOWN"
// 改札区分
let ITEM_KEY_PAY_AREA = "PAY_AREA"
// 设施类型区分
let ITEM_KEY_FACILITY_TYPE = "FACILITY_TYPE"
// 换乘标志
let ITEM_KEY_EXCHANGE_TYPE = "EXCHANGE_TYPE"
// 出入口区分
let ITEM_KEY_EXIT_TYPE = "EXIT_TYPE"
// 期间区分
let ITEM_KEY_PEROID_TYPE = "PEROID_TYPE"
// 列车类型
let ITEM_KEY_TRAIN_TYPE = "TRAIN_TYPE"


extension String {

  func line() -> String{
     return self.itemValue(ITEM_KEY_LINE)
  }

  func line(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_LINE ,defaultValue: defaultValue)
  }

  func station() -> String{
     return self.itemValue(ITEM_KEY_STATION)
  }

  func station(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_STATION, defaultValue: defaultValue)
  }

  func stationGroup() -> String{
     return self.itemValue(ITEM_KEY_STATION_GROUP)
  }

  func stationGroup(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_STATION_GROUP, defaultValue: defaultValue)
  }

  func stationExit() -> String{
     return self.itemValue(ITEM_KEY_STATION_EXIT)
  }

  func stationExit(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_STATION_EXIT, defaultValue: defaultValue)
  }

  func prefecture() -> String{
     return self.itemValue(ITEM_KEY_PREFECTURE)
  }

  func prefecture(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_PREFECTURE, defaultValue: defaultValue)
  }

  func specialWard() -> String{
     return self.itemValue(ITEM_KEY_SPECIAL_WARD)
  }

  func specialWard(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_SPECIAL_WARD, defaultValue: defaultValue)
  }

  func lineCompany() -> String{
     return self.itemValue(ITEM_KEY_LINE_COMPANY)
  }

  func lineCompany(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_LINE_COMPANY, defaultValue: defaultValue)
  }

  func trainFare() -> String{
     return self.itemValue(ITEM_KEY_TRAIN_FARE)
  }

  func trainFare(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_TRAIN_FARE, defaultValue: defaultValue)
  }

  func isFavorite() -> String{
     return self.itemValue(ITEM_KEY_IS_FAVORITE)
  }

  func isFavorite(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_IS_FAVORITE, defaultValue: defaultValue)
  }

  func isRead() -> String{
     return self.itemValue(ITEM_KEY_IS_READ)
  }

  func isRead(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_IS_READ, defaultValue: defaultValue)
  }

  func firstOrLast() -> String{
     return self.itemValue(ITEM_KEY_FIRST_OR_LASR)
  }

  func firstOrLast(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_FIRST_OR_LASR, defaultValue: defaultValue)
  }

  func upOrDown() -> String{
     return self.itemValue(ITEM_KEY_UP_OR_DOWN)
  }

  func upOrDown(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_UP_OR_DOWN, defaultValue: defaultValue)
  }

  func payArea() -> String{
     return self.itemValue(ITEM_KEY_PAY_AREA)
  }

  func payArea(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_PAY_AREA, defaultValue: defaultValue)
  }

  func facilityType() -> String{
     return self.itemValue(ITEM_KEY_FACILITY_TYPE)
  }

  func facilityType(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_FACILITY_TYPE, defaultValue: defaultValue)
  }

  func exchangeType() -> String{
     return self.itemValue(ITEM_KEY_EXCHANGE_TYPE)
  }

  func exchangeType(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_EXCHANGE_TYPE, defaultValue: defaultValue)
  }

  func exitType() -> String{
     return self.itemValue(ITEM_KEY_EXIT_TYPE)
  }

  func exitType(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_EXIT_TYPE, defaultValue: defaultValue)
  }

  func peroidType() -> String{
     return self.itemValue(ITEM_KEY_PEROID_TYPE)
  }

  func peroidType(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_PEROID_TYPE, defaultValue: defaultValue)
  }

  func trainType() -> String{
     return self.itemValue(ITEM_KEY_TRAIN_TYPE)
  }

  func trainType(defaultValue:String) -> String{
     return self.itemValue(ITEM_KEY_TRAIN_TYPE, defaultValue: defaultValue)
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
