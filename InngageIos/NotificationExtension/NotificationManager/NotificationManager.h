//
//  NotificationManager.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationManager : NSObject

+ (void)prepareNotificationWithRequest:(UNNotificationRequest *)request
                 andBestAttemptContent:(UNMutableNotificationContent *) bestAttemptContent
                   andCompletionHander:(void (^)(UNNotificationContent *bestAttemptContent))completionHandler;

+ (void)prepareNotificationContentWithNotification:(UNNotification *)notification
                                 andViewController:(UIViewController *)viewController;

@end

