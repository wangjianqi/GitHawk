//
//  SplitPlaceholderNavigationController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/9/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit
//空白页
final class SplitPlaceholderViewController: UIViewController {

    private let imageView = UIImageView(image: UIImage(named: "splash-light"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Styles.Colors.Gray.lighter.color

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

}
