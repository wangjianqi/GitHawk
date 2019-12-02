//
//  UIAlertController+AddAction.swift
//  Freetime
//
//  Created by Ivan Magda on 26/09/2017.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

extension UIAlertController {
    //添加action
    func addActions(_ actions: [UIAlertAction?]) {
        for anAction in actions {
            self.add(action: anAction)
        }
    }

    func add(action: UIAlertAction?) {
        if let action = action {
            self.addAction(action)
        }
    }

}
