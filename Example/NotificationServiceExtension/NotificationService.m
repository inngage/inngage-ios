//
//  NotificationService.m
//  NotificationServiceExtension
//
//  Created by Augusto Cesar do Nascimento dos Reis on 04/02/21.
//  Copyright © 2021 Luis Teodoro. All rights reserved.
//

#import "NotificationService.h"
#import <Inngage/NotificationManager.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService


- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    [NotificationManager prepareNotificationWithRequest:request andBestAttemptContent: self.bestAttemptContent andCompletionHander:^(UNNotificationContent *bestAttemptContent) {
        self.contentHandler(bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
