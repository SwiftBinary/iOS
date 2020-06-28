//
//  UserDTO.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/06/26.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserDTO {
    private var jsonData:JSON
    public var userSn:String
    public var birthDt:String
    public var userEmail:String
    public var userType:String
    public var userRealName:String
    public var userName:String
    public var userGender:String
    public var userAvgBudget:String
    public var loginType:String
    public var eatPref:String
    public var drinkPref:String
    public var playPref:String
    public var watchPref:String
    public var walkPref:String
    public var setting:String
    
    init(jsonData:JSON) {
        self.jsonData = jsonData
        self.userSn = jsonData["userSn"].stringValue
        self.birthDt = jsonData["birthDt"].stringValue
        self.userEmail = jsonData["userEmail"].stringValue
        self.userType = jsonData["userType"].stringValue
        self.userRealName = jsonData["userRealName"].stringValue
        self.userName = jsonData["userName"].stringValue
        self.userGender = jsonData["userGender"].stringValue
        self.userAvgBudget = jsonData["userAvgBudget"].stringValue
        self.loginType = jsonData["loginType"].stringValue
        self.eatPref = jsonData["eatPref"].stringValue
        self.drinkPref = jsonData["drinkPref"].stringValue
        self.playPref = jsonData["playPref"].stringValue
        self.watchPref = jsonData["watchPref"].stringValue
        self.walkPref = jsonData["walkPref"].stringValue
        self.setting = jsonData["setting"].stringValue
    }
}
