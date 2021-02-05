//
//  AppDelegate.m
//  PushNotification
//
//  Created by TQI on 20/04/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <Inngage/PushNotificationManager.h>

@interface AppDelegate (){
    PushNotificationManager *manager;
    NSDictionary *userInfoDict;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                             (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    manager = [PushNotificationManager sharedInstance];
    
    manager.inngageAppToken = @"APP_TOKEN";
    manager.inngageApiEndpoint = @"https://api.inngage.com.br/v1";
    manager.defineLogs = YES;
//    manager.enabledShowAlertWithUrl = NO;
//    manager.enabledAlert = YES;
    
    
    NSLog(@"UIApplicationLaunchOptionsLocationKey : %@" , [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]);
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        [manager startMonitoringBackgroundLocation];
    }

    userInfoDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [manager restartMonitoringBackgroundLocation];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [manager startMonitoringBackgroundLocation];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    
    [manager handlePushRegisterForRemoteNotifications:notificationSettings];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSDictionary *jsonBody = @{ @"Nome":@"XXX" };
    
    [manager handlePushRegistration:deviceToken identifier: @"USER_IDENTIFIER" customField:jsonBody];
    
    if (userInfoDict != nil)
    {
        [manager handlePushReceived:userInfoDict messageAlert:YES];
        
    }
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    
    [manager handlePushRegistrationFailure:error];
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [manager handlePushReceived:userInfo messageAlert:YES];
}

@end
