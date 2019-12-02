//
//  Routable.swift
//  Freetime
//
//  Created by Ryan Nystrom on 10/7/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation

public protocol Routable {
    //返回Self
    static func from(params: [String: String]) -> Self?
    var encoded: [String: String] { get }
}

public extension Routable {
    //key
    public static var path: String {
        return String(describing: self)
    }
    //实现encoded方法
    public var encoded: [String: String] { return [:] }

}
