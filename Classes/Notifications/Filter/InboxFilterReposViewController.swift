//
//  InboxFilterReposViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 12/2/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit
import Squawk

final class InboxFilterReposViewController: BaseListViewController<String>,
BaseListViewControllerDataSource {

    private let inboxFilterController: InboxFilterController
    private var repos = [RepositoryDetails]()

    init(inboxFilterController: InboxFilterController) {
        self.inboxFilterController = inboxFilterController
        super.init(emptyErrorMessage: NSLocalizedString("Error loading repos", comment: ""))
        //设置代理
        dataSource = self
        title = NSLocalizedString("Watched Repos", comment: "")
        //内容尺寸
        preferredContentSize = Styles.Sizes.contextMenuSize
        feed.collectionView.backgroundColor = Styles.Colors.menuBackgroundColor.color
        feed.collectionView.indicatorStyle = .white
        feed.setLoadingSpinnerColor(to: .white)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //标题
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    override func fetch(page: String?) {
        inboxFilterController.client.fetchSubscriptions { [weak self] result in
            switch result {
            case .error(let error):
                Squawk.show(error: error)
            case .success(let repos):
                self?.repos = repos
                self?.update()
            }
        }
    }

    // MARK: BaseListViewControllerDataSource

    func models(adapter: ListSwiftAdapter) -> [ListSwiftPair] {
        return repos.map { [inboxFilterController] model in
            ListSwiftPair.pair(model, {
                //绑定model和cell
                InboxFilterRepoSectionController(inboxFilterController: inboxFilterController)
            })
        }
    }

}
