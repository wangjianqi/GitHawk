//
//  UNNotificationContent+Routable.swift
//  Freetime
//
//  Created by Ryan Nystrom on 10/9/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UserNotifications

extension UNNotificationContent {
    //get方法：返回元组
    var routableUserInfo: (path: String, params: [String: String])? {
        guard let path = userInfo[UNNotificationContentRoutePathKey] as? String else { return nil }
        var params = [String: String]()
        userInfo.forEach {
            guard let key = $0 as? String,
                let value = $1 as? String,
                value != UNNotificationContentRoutePathKey
                else { return }
            params[key] = value
        }
        return (path, params)
    }

}
