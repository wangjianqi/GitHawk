//
//  AppController+UNUserNotificationCenterDelegate.swift
//  Freetime
//
//  Created by Ryan Nystrom on 10/9/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UserNotifications

extension AppController: UNUserNotificationCenterDelegate {
    //设置代理
    func attachNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: UNUserNotificationCenterDelegate
    //通知
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
        ) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier: break
        case UNNotificationDefaultActionIdentifier:
            //元组解包
            if let (path, params) = response.notification.request.content.routableUserInfo {
                router.handle(path: path, params: params)
            }
        default: print(response.actionIdentifier)
        }
        completionHandler()
    }

}
