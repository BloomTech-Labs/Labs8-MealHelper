//
//  NotificationController.swift
//  Labs8-MealHelperWatch Extension
//
//  Created by De MicheliStefano on 14.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {

    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
        
        completionHandler(.custom)
    }
}
