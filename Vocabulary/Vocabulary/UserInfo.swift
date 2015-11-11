//
//  UserInfo.swift
//  Vocabulary
//
//  Created by qihaijun on 11/11/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    // 单例
    static let currentUser = UserInfo()
    
    let appKey = "bd27e55888601ce34bb8"
    let appSecret = "71210b79824d29a2c4c9c440267410a53fde11ca"
    let redirectURL = "https://victorchee.github.io/"
    
    var accessToken: String?
    var tokenType: String?
    var tokenExpires: String?
    var tokenScope: String?
    
    var username: String?
    var nickname: String?
    
}
