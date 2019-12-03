//
//  StyledTableCell.swift
//  Freetime
//
//  Created by Ryan Nystrom on 8/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

class StyledTableCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    private func configure() {
        textLabel?.font = Styles.Text.body.preferredFont
        //背景色
        let background = UIView()
        background.backgroundColor = Styles.Colors.Gray.alphaLighter
        //选中背景
        selectedBackgroundView = background
    }

}
