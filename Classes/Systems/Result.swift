//
//  Result.swift
//  Freetime
//
//  Created by Ryan Nystrom on 8/27/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
//<T>: 泛型
enum Result<T> {
    //支持可选值
    case error(Error?)
    case success(T)
}
