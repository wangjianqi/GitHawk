//
//  Defaults+ExternalLinks.swift
//  Freetime
//
//  Created by Ivan Smetanin on 08/12/2018.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation

extension UserDefaults {

    private static let defaultKey = "com.whoisryannystrom.freetime.should-open-external-links-in-safari"
    //注意命名：shouldOpen
    var shouldOpenExternalLinksInSafari: Bool {
        get {
            //取值
            return bool(forKey: UserDefaults.defaultKey)
        }
        set {
            //存值
            set(newValue, forKey: UserDefaults.defaultKey)
        }
    }

}
