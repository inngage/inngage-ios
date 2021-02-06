//
//  AppDelegate.swift
//  InngageExampleSwift
//
//  Created by Augusto Cesar do Nascimento dos Reis on 05/02/21.
//

import UIKit
import Inngage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pushNotificationManager = PushNotificationManager.sharedInstance()
    var userInfoDictionary: [String: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        pushNotificationManager?.inngageAppToken = "APP_TOKEN"
        pushNotificationManager?.inngageApiEndpoint = "https://api.inngage.com.br/v1"
        pushNotificationManager?.defineLogs = true
        pushNotificationManager?.enabledShowAlertWithUrl = false
        pushNotificationManager?.enabledAlert = false

        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.userInfoDictionary = userInfo
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let userInfo = ["name": "XXX"]

        pushNotificationManager?.handlePushRegistration(deviceToken, identifier: "USER_IDENTIFIER", customField: userInfo)

        if let userInfoDictionary = userInfoDictionary {
            pushNotificationManager?.handlePushReceived(userInfoDictionary, messageAlert: true)
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        pushNotificationManager?.handlePushRegistrationFailure(error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pushNotificationManager?.handlePushReceived(userInfo, messageAlert: true)
    }

}

