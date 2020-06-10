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

public let userDataKey = "userData"
public let locationSnKey = "locationSn"
public let locationDataKey = "locationData"
public let developIP = "http://203.252.161.96:8080"
public let OperationIP = "http://203.252.161.219:8080"
public let ImageURL = OperationIP + "/images/store/"

public var locationData = JSON()

public let SeoulSn = "01"
public let landmarkInfoDictionary = [
    "01":"강남구", "02":"강동구", "03":"강북구", "04":"강서구", "05":"관악구",
    "06":"광진구", "07":"구로구", "08":"금천구", "09":"노원구", "10":"도봉구",
    "11":"동대문구", "12":"동작구", "13":"마포구", "14":"서대문구", "15":"서초구",
    "16":"성동구", "17":"성북구", "18":"송파구", "19":"양천구", "20":"영등포구",
    "21":"용산구", "22":"은평구", "23":"종로구", "24":"중구", "25":"중랑구",
]


