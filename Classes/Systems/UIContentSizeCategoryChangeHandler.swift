//
//  UIContentSizeCategoryChangeHandler.swift
//  Freetime
//
//  Created by Ivan Smetanin on 08/05/2018.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

final class UIContentSizeCategoryChangeHandler {

    public static let shared = UIContentSizeCategoryChangeHandler()

    private init() {}

    func setup() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: .UIContentSizeCategoryDidChange,
            object: nil
        )
    }

    // MARK: Private API
    //退出
    @objc private func contentSizeCategoryDidChange() {
        // Force restart to avoid a mix-matched UI
        exit(0)
    }

}
