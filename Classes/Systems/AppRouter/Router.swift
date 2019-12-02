//
//  Router.swift
//  Freetime
//
//  Created by Ryan Nystrom on 11/1/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation
import GitHawkRoutes
import Crashlytics

//类型  inout修改值
private func register<T: Routable & RoutePerformable>(
    route: T.Type,
    map: inout [String: (Routable & RoutePerformable).Type]
    ) {
    map[T.path] = T.self
}

private var hasSwizzledChildViewController = false

private func logMissingRouter() {
    //异常错误
    let trace = Thread.callStackSymbols.joined(separator: "\n")
    print("ERROR: Router not wired up. Callsite:")
    print(trace)
    //保存
    Answers.logCustomEvent(
        withName: "missing-router",
        customAttributes: ["trace": trace]
    )
}

extension UIViewController {
    //交换方法
    fileprivate class func swizzleChildViewController() {
        // make sure this isn't a subclass
        if self !== UIViewController.self,
            hasSwizzledChildViewController == false {
            return
        }

        let originalSelector = #selector(addChildViewController(_:))
        let swizzledSelector = #selector(swizzle_addChildViewController(_:))

        guard let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            else { return }

        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc func swizzle_addChildViewController(_ controller: UIViewController) {
        self.swizzle_addChildViewController(controller)
        controller.router = router
    }

    //给UIViewController
    private static var RouterAssocObjectKey = "RouterAssocObjectKey"
    var router: Router? {
        get {
            return objc_getAssociatedObject(
                self,
                &UIViewController.RouterAssocObjectKey
            ) as? Router
        }
        set {
            objc_setAssociatedObject(
                self,
                &UIViewController.RouterAssocObjectKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            // recursively set to all VCs
            childViewControllers.forEach { $0.router = newValue }
        }
    }

    func route(_ route: Routable & RoutePerformable) {
        router?.handle(route: route, from: self)
    }

    // MARK: Remove after migration

    func route_push(to controller: UIViewController) {
        if router == nil { logMissingRouter() }
        router?.push(from: self, to: controller)
    }

    func route_detail(to controller: UIViewController) {
        if router == nil { logMissingRouter() }
        router?.detail(controller: controller)
    }

    func route_present(to controller: UIViewController) {
        if router == nil { logMissingRouter() }
        router?.present(from: self, to: controller)
    }

}
//继承class
protocol RouterPropsSource: class {
    func props(for router: Router) -> RoutePerformableProps?
}

final class Router: NSObject {

    private weak var propsSource: RouterPropsSource?
    //满足协议的类型
    private let routes: [String: (Routable & RoutePerformable).Type]
    //构造方法
    init(propsSource: RouterPropsSource) {
        var routes = [String: (Routable & RoutePerformable).Type]()
        register(route: BookmarkShortcutRoute.self, map: &routes)
        register(route: SwitchAccountShortcutRoute.self, map: &routes)
        register(route: SearchShortcutRoute.self, map: &routes)
        register(route: IssueRoute.self, map: &routes)
        register(route: RepoRoute.self, map: &routes)
        self.routes = routes
        self.propsSource = propsSource

        UIViewController.swizzleChildViewController()
    }

    func handle(url: URL) -> RoutePerformableResult {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let host = components.host
            else { return .error }
        var params = [String: String]()
        for item in components.queryItems ?? [] {
            params[item.name] = item.value
        }
        return handle(path: host, params: params)
    }

    //快捷方式
    @discardableResult
    func handle(path: String, params: [String: String]) -> RoutePerformableResult {
        guard let routeType = routes[path],
            let route = routeType.from(params: params)
            else { return .error }
        return handle(route: route)
    }

    // returning .show(controller) displays the controller in the detail view
    //类型
    func handle(route: Routable & RoutePerformable) -> RoutePerformableResult {
        return handle(route: route, from: nil)
    }

    // returning the .show(controller) pushes the controller onto the nav stack
    // if a from controller is present
    //弹出新页面
    @discardableResult
    func handle(
        route: Routable & RoutePerformable,
        from controller: UIViewController?
        ) -> RoutePerformableResult {
        guard let props = propsSource?.props(for: self) else { return .error }
        let result = route.perform(props: props)
        switch result {
        case .custom, .error: break
        case .push(let toController):
            // if trying to push but not given an origin, fallback to detail
            if let controller = controller,
                // do not allow pushing onto the master tab VC
                controller.tabBarController != props.splitViewController.masterTabBarController {
                push(from: controller, to: toController)
            } else {
                detail(controller: toController, split: props.splitViewController)
            }
        case .present(let toController):
            present(from: controller ?? props.splitViewController, to: toController)
        case .setDetail(let toController):
            detail(controller: toController, split: props.splitViewController)
        }
        return result
    }
    //push方法
    func push(from: UIViewController, to: UIViewController) {
        to.router = self
        from.navigationController?.pushViewController(
            to,
            animated: trueUnlessReduceMotionEnabled
        )
    }

    //present
    func present(from: UIViewController, to: UIViewController) {
        to.router = self
        from.present(to, animated: trueUnlessReduceMotionEnabled)
    }

    //详情
    func detail(controller: UIViewController) {
        guard let split = propsSource?.props(for: self)?.splitViewController
            else { return }
        detail(controller: controller, split: split)
    }

    private func detail(controller: UIViewController, split: UISplitViewController) {
        let wrapped: UINavigationController
        if let controller = controller as? UINavigationController {
            wrapped = controller
        } else {
            wrapped = UINavigationController(rootViewController: controller)
        }
        controller.router = self
        split.showDetailViewController(wrapped, sender: nil)
    }

}
