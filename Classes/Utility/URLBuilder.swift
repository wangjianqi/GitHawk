//
//  URLBuilder.swift
//  Freetime
//
//  Created by Ryan Nystrom on 11/10/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation

final class URLBuilder {

    private var components = URLComponents()
    private var pathComponents = [String]()

    init(host: String, scheme: String) {
        //主机
        components.host = host
        components.scheme = scheme
    }
    //便利构造方法：需调用init方法
    convenience init(host: String, https: Bool = true) {
        self.init(host: host, scheme: https ? "https" : "http")
    }

    static func github() -> URLBuilder {
        return URLBuilder(host: "github.com", https: true)
    }

    //注意返回对象本身(self):
    @discardableResult
    func add(path: LosslessStringConvertible) -> URLBuilder {
        pathComponents.append(String(describing: path))
        return self
    }

    //批量添加
    @discardableResult
    func add(paths: [LosslessStringConvertible]) -> URLBuilder {
        paths.forEach { self.add(path: $0) }
        return self
    }

    @discardableResult
    func add(item: String, value: LosslessStringConvertible) -> URLBuilder {
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: item, value: String(describing: value)))
        components.queryItems = items
        return self
    }

    @discardableResult
    func set(fragment: String) -> URLBuilder {
        components.fragment = fragment
        return self
    }
    //
    var url: URL? {
        var components = self.components
        //用/拼接
        if !pathComponents.isEmpty {
            components.path = "/" + pathComponents.joined(separator: "/")
        }
        return components.url
    }

}
