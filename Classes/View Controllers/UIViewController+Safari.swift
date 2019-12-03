//
//  UIViewController+Safari.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/5/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

    func presentSafari(url: URL) {
        if UserDefaults.standard.shouldOpenExternalLinksInSafari {
            //不能打开
            guard UIApplication.shared.canOpenURL(url) else {
                //失败
                assertionFailure("Can't open url: \(url)")
                return
            }
            UIApplication.shared.open(url)
        } else {
            //do catch:捕获throws
            do {
                let safariViewController = try SFSafariViewController.configured(with: url)
                route_present(to: safariViewController)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func presentProfile(login: String) {
        guard let controller = CreateProfileViewController(login: login) else { return }
        route_present(to: controller)
    }

    func presentCommit(owner: String, repo: String, hash: String) {
        guard let url = URLBuilder.github().add(paths: [owner, repo, "commit", hash]).url else { return }
        presentSafari(url: url)
    }

    func presentRelease(owner: String, repo: String, release: String) {
        guard let url = URLBuilder.github().add(paths: [owner, repo, "releases", "tag", release]).url else { return }
        presentSafari(url: url)
    }

    func presentMilestone(owner: String, repo: String, milestone: Int) {
        guard let url = URLBuilder.github().add(paths: [owner, repo, "milestone", milestone]).url else { return }
        presentSafari(url: url)
    }

}

extension SFSafariViewController {
    //使用throws
	static func configured(with url: URL) throws -> SFSafariViewController {
		let http = "http"
        //注意这里用的是let
		let schemedURL: URL
		// handles http and https
        //可选值所以用==true
		if url.scheme?.hasPrefix(http) == true {
			schemedURL = url
		} else {
            //抛出错误
			guard let u = URL(string: http + "://" + url.absoluteString) else { throw URL.Error.failedToCreateURL }
			schemedURL = u
		}
		let safariViewController = SFSafariViewController(url: schemedURL)
		safariViewController.preferredControlTintColor = Styles.Colors.Blue.medium.color
		return safariViewController
	}
}

extension URL {
    //错误
	enum Error: Swift.Error {
		case failedToCreateURL
	}
}
