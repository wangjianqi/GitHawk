//
//  InboxFilterRepoSectionController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 12/2/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import IGListKit

final class InboxFilterRepoSectionController: ListSwiftSectionController<RepositoryDetails> {

    private let inboxFilterController: InboxFilterController

    init(inboxFilterController: InboxFilterController) {
        self.inboxFilterController = inboxFilterController
        super.init()
    }
    //绑定
    override func createBinders(from value: RepositoryDetails) -> [ListBinder] {
        return [
            binder(
                value,
                cellType: ListCellType.class(InboxFilterRepoCell.self),
                size: {
                    //高度
                    return $0.collection.cellSize(with: Styles.Sizes.tableCellHeight)
            }, configure: {
                $0.configure(
                    owner: $1.value.owner,
                    name: $1.value.name
                )
            }, didSelect: { [weak self] context in
                self?.didSelect(value: context.value)
            })
        ]
    }
    //选中
    private func didSelect(value: RepositoryDetails) {
        //控制器
        viewController?.dismiss(animated: trueUnlessReduceMotionEnabled)
        inboxFilterController.update(selection: InboxFilterModel(
            type: .repo(owner: value.owner, name: value.name))
        )
    }

}
