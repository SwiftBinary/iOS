//
//  LocationDTO.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/07/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation

public class LocationDTO {
    public var address:String
    public var latitude:Double
    public var longitude:Double
    
    init(addr: String, lat: Double, lng:Double) {
        self.address = addr
        self.latitude = lat
        self.longitude = lng
    }
    init() {
        self.address = "건국대학교"
        self.latitude = 37.540399
        self.longitude = 127.069182
    }
    
    public func setLocation(_ addr: String, lat: Double, lng:Double){
        self.address = addr
        self.latitude = lat
        self.longitude = lng
    }
    
    public func printAll(){
        print("주소: " + self.address)
        print("위도: " + String(self.latitude))
        print("경도: " + String(self.longitude))
    }
}
