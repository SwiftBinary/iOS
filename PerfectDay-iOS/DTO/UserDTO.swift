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
    public var jsonData:JSON
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
    
    public func setPreferInfo(_ eatPref:String,_ drinkPref:String,_ playPref:String,_ watchPref:String,_ walkPref:String){
        self.eatPref = eatPref
        self.drinkPref = drinkPref
        self.playPref = playPref
        self.watchPref = watchPref
        self.walkPref = walkPref
        self.jsonData["eatPref"].stringValue = self.eatPref
        self.jsonData["drinkPref"].stringValue = self.drinkPref
        self.jsonData["playPref"].stringValue = self.playPref
        self.jsonData["watchPref"].stringValue = self.watchPref
        self.jsonData["walkPref"].stringValue = self.walkPref
        UserDefaults.standard.set(self.jsonData.rawString(), forKey: userDataKey)
    }
    
    public func printAll(){
        print(self.jsonData)
        print(self.userSn)
        print(self.birthDt)
        print(self.userEmail)
        print(self.userType)
        print(self.userRealName)
        print(self.userName)
        print(self.userGender)
        print(self.userAvgBudget)
        print(self.loginType)
        print(self.eatPref)
        print(self.drinkPref)
        print(self.playPref)
        print(self.watchPref)
        print(self.walkPref)
        print(self.setting)
    }
}
