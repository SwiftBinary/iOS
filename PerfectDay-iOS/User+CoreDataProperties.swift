//
//  User+CoreDataProperties.swift
//  
//
//  Created by 문종식 on 2020/04/08.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userSn: String?
    @NSManaged public var userRealName: String?
    @NSManaged public var userName: String?
    @NSManaged public var userEmail: String?
    @NSManaged public var userPw: String?
    @NSManaged public var userGender: String?
    @NSManaged public var birthDt: String?
    @NSManaged public var userAvgBudget: String?
    @NSManaged public var playPref: String?
    @NSManaged public var watchPref: String?
    @NSManaged public var walkPref: String?
    @NSManaged public var eatPref: String?
    @NSManaged public var drinkPref: String?

}
