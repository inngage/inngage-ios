//
//  PushNotificationManager.h
//  PushNotificationManager
//
//  Created by Luis Teodoro on 20/10/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <CoreLocation/CoreLocation.h>


@interface PushNotificationManager :NSObject<NSURLSessionDataDelegate>

/*CLLocationAccuracy -> The accuracy of a coordinate value, measured in meters.
 default:kCLLocationAccuracyBestType
*/
typedef NS_ENUM(NSInteger, CLLocationAccuracyType) {
    kCLLocationAccuracyBestForNavigationType,
    kCLLocationAccuracyBestType,
    kCLLocationAccuracyNearestTenMetersType,
    kCLLocationAccuracyHundredMetersType,
    kCLLocationAccuracyKilometerType,
    kCLLocationAccuracyThreeKilometersType
};

@property NSString * inngageAppToken;
@property NSString * inngageApiEndpoint;

/// If you want show logs on console.
/// Default value is NO (false - Swift).
@property BOOL defineLogs;

/// Show alert default when has a URL on Push Notification.
/// If you want show the alert, set the value YES (true - Swift).
/// Default value is NO (false - Swift).
@property BOOL enabledShowAlertWithUrl;

/// If want show the alert all time when push notification was pressed,
/// set this property with YES (true - Swift) value.
/// In this case, the property `enabledShowAlertWithUrl`is disabled too, if the value is false.
/// Default value is NO (false - Swift).
@property BOOL enabledAlert;

+ (instancetype)sharedInstance;

- (void)handlePushRegistration:(NSData *)deviceToken;
- (void)handlePushRegistration:(NSData *)deviceToken identifier:(NSString *)identifier;
- (void)handlePushRegistration:(NSData *)deviceToken customField:(NSDictionary *)customField;
- (void)handlePushRegistration:(NSData *)deviceToken identifier:(NSString *)identifier customField:(NSDictionary *)customField;
- (void)handlePushRegistration:(NSData *)deviceToken identifier:(NSString *)identifier email:(NSString *)email phoneNumber:(NSString *)phoneNumber customField:(NSDictionary *)customField;
- (void)handleSendEvent:(NSData *)deviceToken
             identifier:(NSString *)identifier
              eventName:(NSString *)eventName
        conversionValue:(NSString *)conversionValue
           registration:(NSString *)registration
        conversionEvent:(BOOL)conversionEvent
        conversionNotId:(NSString *)conversionNotId
            eventValues:(NSDictionary *)eventValues;
- (void)handlePushRegisterForRemoteNotifications:(UIUserNotificationSettings *)notificationSettings;
- (void)handlePushRegistrationFailure:(NSError *)error;
- (void)handlePushReceived:(NSDictionary *)userInfo messageAlert:(BOOL)messageAlert;
- (void)handleUpdateLocations:(CLLocationManager *)locations;
- (void)openWebView:(NSString *)url;
- (void)startMonitoringBackgroundLocation;
- (void)restartMonitoringBackgroundLocation;


@end
