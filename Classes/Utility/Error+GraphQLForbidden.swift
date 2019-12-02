//
//  Error+GraphQLForbidden.swift
//  Freetime
//
//  Created by Ryan Nystrom on 12/29/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation
import Apollo

extension Error {
    //错误
    var isGraphQLForbidden: Bool {
        guard let error = self as? Apollo.GraphQLError else { return false }
        return (error["type"] as? String)?.uppercased() == "FORBIDDEN"
    }

}
