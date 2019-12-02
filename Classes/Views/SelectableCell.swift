//
//  SelectableCell.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/9/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SwipeCellKit

extension UIView {

    func addOverlay() -> UIView {
        let view = UIView()
        view.backgroundColor = Styles.Colors.Gray.alphaLighter
        view.alpha = 0
        view.isUserInteractionEnabled = false
        //添加到View上
        addSubview(view)
        return view
    }
    //复用
    func prepareOverlayForReuse() {
        layer.zPosition = 10_000
    }
    //设置Overlay的frame
    func layoutOverlay() {
        guard let bounds = superview?.bounds else { return }
        frame = bounds
    }
    //是否显示选中样式
    func showOverlay(show: Bool) {
        alpha = show ? 1 : 0
    }

}

class SelectableCell: UICollectionViewCell {

    private lazy var overlay: UIView = {
        return self.contentView.addOverlay()
    }()
    //设置overlay的背景色
    var overlayColor: UIColor? {
        get { return overlay.backgroundColor }
        set { overlay.backgroundColor = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityTraits |= UIAccessibilityTraitButton
        isAccessibilityElement = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //复用
    override func prepareForReuse() {
        super.prepareForReuse()
        overlay.prepareOverlayForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
        overlay.layoutOverlay()
    }

    override var accessibilityLabel: String? {
        get {
            return AccessibilityHelper.generatedLabel(forCell: self)
        }
        set { }
    }
    //重写isSelected和isHighlighted
    override var isSelected: Bool {
        didSet {
            overlay.showOverlay(show: isSelected)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            overlay.showOverlay(show: isHighlighted)
        }
    }

}

class SwipeSelectableCell: SwipeCollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityTraits |= UIAccessibilityTraitButton
        isAccessibilityElement = true
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

    private lazy var overlay: UIView = {
        return self.contentView.addOverlay()
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        overlay.prepareOverlayForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
        overlay.layoutOverlay()
    }

    override var isSelected: Bool {
        didSet {
            overlay.showOverlay(show: isSelected)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            overlay.showOverlay(show: isHighlighted)
        }
    }

    // MARK: Accessibility
    override var accessibilityLabel: String? {
        get {
            return AccessibilityHelper.generatedLabel(forCell: self)
        }
        set { }
    }
}
