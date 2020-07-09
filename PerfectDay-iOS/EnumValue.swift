//
//  EnumValue.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/04/04.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Gender {
    case M
    case F
}

public let naverClientIDKey = "7fp6ljv1lv"
public let naverClientSecretKey = "ORrwGerniDoUS3k0Ok7UHMIPspmfCOclGhvORF7r"

public let userDataKey = "userData"
public let locationSnKey = "locationSn"
public let locationDataKey = "locationData"
public let plannerKey = "plannerKey"
public let hotStoreKey = "hotStore"
public let oneDayPickKey = "oneDayPick"

public let developIP = "http://203.252.161.96:8080"
public let OperationIP = "http://203.252.161.219:8080"
public let StoreImageURL = OperationIP + "/images/store/"
public let LandmarkImageURL = OperationIP + "/images/landmark/"

public var locationData = JSON()
public var locationDTO = LocationDTO()
public var selectedLoc : [LocationData] = []
public var landmarkSn:String = ""
public var selectedTag = ""

public let SeoulSn = "01"
public let landmarkInfoDictionary = [
    "01":"강남구", "02":"강동구", "03":"강북구", "04":"강서구", "05":"관악구",
    "06":"광진구", "07":"구로구", "08":"금천구", "09":"노원구", "10":"도봉구",
    "11":"동대문구", "12":"동작구", "13":"마포구", "14":"서대문구", "15":"서초구",
    "16":"성동구", "17":"성북구", "18":"송파구", "19":"양천구", "20":"영등포구",
    "21":"용산구", "22":"은평구", "23":"종로구", "24":"중구", "25":"중랑구",
]

public let eat = ["밥","고기","면","해산물","길거리","분식/피자/버거","기타","기타","기타","기타"]
public let drink = ["커피","차/음료","디저트","맥주","소주","막걸리","칵테일/와인","기타","기타","기타"]
public let play = ["실외엑티비티","실내엑티비티","게임/오락","힐링","VR/방탈출","책방","만들기","기타","기타","기타"]
public let see = ["영화","스포츠","전시","공연","기타","기타","기타","기타","기타","기타"]
public let walk = ["쇼핑","전통시장","공원","테마거리","야경/풍경","기타","기타","기타","기타","기타"]
public let ect = ["기타","기타","기타","기타","기타","기타","기타","기타","기타","기타"]



