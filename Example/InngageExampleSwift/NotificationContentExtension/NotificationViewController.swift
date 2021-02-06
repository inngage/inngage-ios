//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Augusto Cesar do Nascimento dos Reis on 05/02/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Inngage

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        NotificationManager.prepareNotificationContent(with: notification, andViewController: self)
    }

}
