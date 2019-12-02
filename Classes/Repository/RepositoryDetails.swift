//
//  RepositoryDetails.swift
//  Freetime
//
//  Created by Ryan Nystrom on 9/22/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
//相当于model
struct RepositoryDetails: Codable, Equatable {
    let owner: String
    let name: String
}
