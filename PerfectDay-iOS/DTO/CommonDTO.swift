//
//  CommonDTO.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/06/27.
//  Copyright © 2020 문종식. All rights reserved.
//

import Foundation

public class CommonDTO {
    public var appVersion:String
    public var result:String
    
    init(_ version: String, result: String) {
        self.appVersion = version
        self.result = result
    }
}
