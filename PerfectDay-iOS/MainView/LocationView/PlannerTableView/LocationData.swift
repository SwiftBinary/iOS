//
//  PlannerData.swift
//  PerfectDay-iOS
//
//  Created by NewRun on 2020/07/02.
//  Copyright © 2020 문종식, 강고운. All rights reserved.
//

import Foundation
import UIKit

public class LocationData {
    var locationImage: String!
    var latitude: Double!
    var longitude: Double!
    var prefData: String!
    var prefSn: String!
    var reprMenuPrice: Int!
    var storeAddr: String!
    var storeNm: String!
    var storeSn: String!
    var storeCostTm: Int!
}

public func initLocationData(LocationData: LocationData, locationImage: String, latitude: Double, longitude: Double, prefData: String, prefSn: String, reprMenuPrice: Int, storeAddr: String, storeNm: String, storeSn: String, storeCostTm: Int ) {
    LocationData.locationImage = locationImage
    LocationData.latitude = latitude
    LocationData.longitude = longitude
    LocationData.prefData = prefData
    LocationData.prefSn = prefSn
    LocationData.reprMenuPrice = reprMenuPrice
    LocationData.storeAddr = storeAddr
    LocationData.storeNm = storeNm
    LocationData.storeSn = storeSn
    LocationData.storeCostTm = storeCostTm
}
