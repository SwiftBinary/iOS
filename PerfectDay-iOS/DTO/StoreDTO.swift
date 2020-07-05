//
//  StoreDTO.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/06/27.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation
import SwiftyJSON

public class StoreDTO {
    // 공통 변수(장소 데이터 요청 시, 항상 오는 DTO 값)
    public var storeSn:String
    public var areaSdCode:String
    public var areaDetailCode:String
    public var areaDetailNm:String
    public var storeNm:String
    public var latitude:Double
    public var longitude:Double
    public var storeScore:Double
    public var storeFavorCount:Int
    public var bAdItem:Bool
    public var ranking:String
    public var prefSn:String
    public var distance:Double
    public var storeAddr:String
    public var storeCostTm:Int
    public var reprMenuPrice:Int
    public var totalCnt:Int
    public var storeImageUrlList:Array<JSON>
    // 리스트형태로 요청 시 받아오는 값
    public var tagList:String = ""
    public var storeDesc:String = ""
    public var storeOpTm:String = ""
    public var storeTel:String = ""
    public var prefData:String = ""
    // 상세페이지 호출 시 받아오는 값
    public var menuList:Array<MenuDTO> = []
//    public var photoList:Array<PhotoDTO> = []
    
//    public var areaSdNm:String
//    public var areaSdNickNm:String

//    public var searchKeyWord:String
//    public var selectedPrefs:String
//    public var distanceLimit:Double
    init(jsonData:JSON){
        self.storeSn = jsonData["storeSn"].stringValue
        self.areaSdCode = jsonData["areaSdCode"].stringValue
        self.areaDetailCode = jsonData["areaDetailCode"].stringValue
        self.areaDetailNm = jsonData["areaDetailNm"].stringValue
        self.storeNm = jsonData["storeNm"].stringValue
        self.latitude = jsonData["latitude"].doubleValue
        self.longitude = jsonData["longitude"].doubleValue
        self.storeScore = jsonData["storeScore"].doubleValue
        self.storeFavorCount = jsonData["storeFavorCount"].intValue
        self.bAdItem = jsonData["bAdItem"].boolValue
        self.ranking = jsonData["ranking"].stringValue
        self.prefSn = jsonData["prefSn"].stringValue
        self.distance = jsonData["distance"].doubleValue
        self.storeAddr = jsonData["storeAddr"].stringValue
        self.storeCostTm = jsonData["storeCostTm"].intValue
        self.reprMenuPrice = jsonData["reprMenuPrice"].intValue
        self.totalCnt = jsonData["totalCnt"].intValue
        self.storeImageUrlList = jsonData["storeImageUrlList"].arrayValue
        
        if jsonData["tagList"].string != nil {
            self.tagList = jsonData["tagList"].stringValue
        }
        if jsonData["storeDesc"].string != nil {
            self.storeDesc = jsonData["storeDesc"].stringValue
        }
        if jsonData["storeOpTm"].string != nil {
            self.storeOpTm = jsonData["storeOpTm"].stringValue
        }
        if jsonData["storeTel"].string != nil {
            self.storeTel = jsonData["storeTel"].stringValue
        }
        if jsonData["prefData"].string != nil {
            self.prefData = jsonData["prefData"].stringValue
        }
        if jsonData["menuList"].array != nil {
            self.menuList = jsonData["menuList"].arrayValue.map{ MenuDTO($0) }
        }
    }
    
    public func getAllData(){
        print(self.storeSn)
        print(self.areaSdCode)
        print(self.areaDetailCode)
        print(self.areaDetailNm)
        print(self.storeNm)
        print(self.latitude)
        print(self.longitude)
        print(self.storeScore)
        print(self.storeFavorCount)
        print(self.bAdItem)
        print(self.ranking)
        print(self.prefSn)
        print(self.distance)
        print(self.storeAddr)
        print(self.storeCostTm)
        print(self.reprMenuPrice)
        print(self.totalCnt)
        print(self.storeImageUrlList)
    
        print(self.tagList)
        print(self.storeDesc)
        print(self.storeOpTm)
        print(self.storeTel)
        print(self.prefData)
        _ = self.menuList.map{ $0.getAllData() }
    }
}

public class MenuDTO {
    public var menuSn:String
    public var storeSn:String
    public var menuNm:String
    public var menuPrice:Int
    public var menuPerPerson:Int
    public var isRepr:String
    
    init(_ jsonData:JSON) {
        self.menuSn = jsonData["menuSn"].stringValue
        self.storeSn = jsonData["storeSn"].stringValue
        self.menuNm = jsonData["menuNm"].stringValue
        self.menuPrice = jsonData["menuPrice"].intValue
        self.menuPerPerson = jsonData["menuPerPerson"].intValue
        self.isRepr = jsonData["isRepr"].stringValue
    }
    public func getAllData(){
        print("menuSn : \(self.menuSn)")
        print("storeSn : \(self.storeSn)")
        print("menuNm : \(self.menuNm)")
        print("menuPrice : \(self.menuPrice)")
        print("menuPerPerson : \(self.menuPerPerson)")
        print("isRepr : \(self.isRepr)")
    }
}

