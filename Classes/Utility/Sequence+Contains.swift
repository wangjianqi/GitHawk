//
//  Sequence+Contains.swift
//  Freetime
//
//  Created by Bas Broek on 03/03/2018.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation

extension Sequence where Element: Equatable {

    /// Returns a Boolean value indicating whether every element of the sequence
    /// is equal to the given element.
    //集合里的元素都等于element
    func containsOnly(_ element: Element) -> Bool {
        var iterator = self.makeIterator()
        //如果是空的，返回false
        guard iterator.next() != nil else { return false }
        //不等于element的元素不存在，就是全部等于
        return first(where: { $0 != element }) == nil
    }

    /// Returns a Boolean value indicating whether every element of the sequence
    /// does not equal to the given element.
    func containsNone(_ element: Element) -> Bool {
        //登录element的元素不存在，也就是一个都不包含
        return first(where: { $0 == element }) == nil
    }
}

extension Sequence {

    /// Returns a Boolean value indicating whether every element of the sequence
    /// satisfies the given predicate.
    //集合类型
    func containsOnly(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        //迭代器
        var iterator = self.makeIterator()
        var isNotEmpty = false

        while let element = iterator.next() {
            isNotEmpty = true
            //因为是throws所以用try
            if try !predicate(element) {
                //如果不满足，返回false
                return false
            }
        }
        return isNotEmpty
    }

    /// Returns a Boolean value indicating whether every element of the sequence
    /// does not satisfies the given predicate.
    func containsNone(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        var iterator = self.makeIterator()

        while let element = iterator.next() {
            //predicate（bool）条件成立，返回false
            if try predicate(element) {
                return false
            }
        }
        return true
    }
}
