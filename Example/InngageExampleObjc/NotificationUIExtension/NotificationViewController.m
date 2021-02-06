//
//  NotificationViewController.m
//  NotificationUIExtension
//
//  Created by Augusto Cesar do Nascimento dos Reis on 04/02/21.
//  Copyright © 2021 Luis Teodoro. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <Inngage/NotificationManager.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    [NotificationManager prepareNotificationContentWithNotification:notification andViewController:self];
}

@end
