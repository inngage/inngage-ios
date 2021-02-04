//
//  PushNotificationManager.m
//  PushNotificationManager
//
//  Created by Luis Teodoro on 20/10/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PushNotificationManager.h"
#import "WebViewViewController.h"
#import "DeviceInformation.h"
#import "AppManager.h"
#import "ServiceManager.h"
#import "AlertManager.h"
#import "URLSchemeManager.h"

#define MIN_MINUTES_TO_READ_NEW_POSITION 1
#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface PushNotificationManager ()<CLLocationManagerDelegate>{
    
    BOOL _isGettingSingleLocation;
    BOOL _isSendingSingleLocation;

    NSUserDefaults *standardDefaults;
    
}
@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
@property (nonatomic) NSMutableDictionary *myLocationDictInPlist;
@property (nonatomic) NSMutableArray *myLocationArrayInPlist;
@property (nonatomic) CLLocationManager *locationManagerApp;

@end

@implementation PushNotificationManager

static  NSString *appToken = @"8c4c8a09a1b22ae18034b35f0cd8a18c";
static  NSString *apiEndpoint = @"https://apid.inngage.com.br/v1/";
static  NSString *subscription = @"https://apid.inngage.com.br/v1/subscription/";
static  NSString *notificationCallBack = @"https://apid.inngage.com.br/v1/notification/";
static  NSString *geolocation = @"https://apid.inngage.com.br/v1/geolocation/";

static CLLocationManager *foregroundLocationManager;
static CLLocationManager *backgroundLocationManager;
static CLLocationManager *updateLocationManager;

static NSDate *lastPositionReadDate;

static BOOL alreadyShowedBackgroundRefreshDisabledAlert;

+ (instancetype)sharedInstance
{
    static PushNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PushNotificationManager alloc] init];
        
        foregroundLocationManager = [[CLLocationManager alloc] init];
        
        if([foregroundLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [foregroundLocationManager requestAlwaysAuthorization];
        }
        
        if([foregroundLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [foregroundLocationManager requestWhenInUseAuthorization];
        }
        
    });

    return sharedInstance;
}

- (NSString *)convertDeviceTokenToString:(NSData *)deviceToken {
    
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }

    NSLog(@"Novo Token: %@", hexString);
    return [hexString copy];
}


- (void)handlePushRegistration:(NSData *)deviceToken {

    NSString *token = [self convertDeviceTokenToString:deviceToken];
    
    NSDictionary *jsonBody = [self registerSubscriberRequest:token identifier:nil customField:nil];

    [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"subscription" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
}

- (void)handlePushRegistration:(NSData *)deviceToken identifier:(NSString *)identifier {

    NSString *token = [self convertDeviceTokenToString:deviceToken];
    
    NSDictionary *jsonBody = [self registerSubscriberRequest:token identifier:identifier customField:nil];
    
    [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"subscription" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
}

- (void)handlePushRegistration:(NSData *)deviceToken customField:(NSDictionary *)customField  {

    NSString *token = [self convertDeviceTokenToString:deviceToken];
    
    NSDictionary *jsonBody = [self registerSubscriberRequest:token identifier:nil customField:customField ];
    
    [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"subscription" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
}

- (void)handlePushRegistration:(NSData *)deviceToken identifier:(NSString *)identifier customField:(NSDictionary *)customField{

    NSString *token = [self convertDeviceTokenToString:deviceToken];
    
    NSDictionary *jsonBody = [self registerSubscriberRequest:token identifier:identifier customField:customField];
    
    [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"subscription" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
}

- (void)handlePushRegistrationFailure:(NSError *)error {

    if (self.defineLogs){
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)handlePushRegisterForRemoteNotifications:(UIUserNotificationSettings *)notificationSettings {
    [[UIApplication sharedApplication]registerForRemoteNotifications];
}

- (NSDictionary *)registerSubscriberRequest:(NSString *)deviceToken identifier:(NSString *)identifier customField:(NSDictionary *)customField {

    DeviceInformationData *deviceInformationData = [[DeviceInformation new] deviceInformation];

    if (self.defineLogs){
        NSLog(@"%@", deviceInformationData);

        NSLog(@"Mode self.defineLogs %d ", self.defineLogs);
    }

    return [deviceInformationData dictionaryWithDeviceToken:deviceToken andIdentifier:identifier andCustomField:customField];
}

- (NSDictionary*)notificationCallbackRequest:(NSString *)notificationId {

    NSString *infoPlistAppToken = [[AppManager new] infoPlistAppToken];

    NSDictionary *parameters = @{@"notificationRequest":
                                     @{@"id": notificationId,
                                       @"app_token": infoPlistAppToken
                                     }};
    if (self.defineLogs){
        NSLog(@"%@", parameters);
    }
    
    return parameters;
}

- (NSDictionary*)registerGeolocationRequest:(NSString *)uuid latitude:(NSString *)latitude longitude:(NSString *)longitude{

    NSString *infoPlistAppToken = [[AppManager new] infoPlistAppToken];
    
    NSDictionary *parameters = @{@"registerGeolocationRequest":
                                     @{@"uuid": uuid,
                                       @"app_token": infoPlistAppToken ? infoPlistAppToken : @"",
                                       @"lat": latitude,
                                       @"lon": longitude}};
    
    if (self.defineLogs){
        NSLog(@"%@", parameters);
    }
    
    return parameters;
    
}

- (void)handlePushReceived:(NSDictionary *)userInfo messageAlert:(BOOL)messageAlert {
    if (userInfo[@"aps"]) {
        
        NSMutableDictionary *aps = [userInfo[@"aps"] mutableCopy];
        if (self.defineLogs){
            NSLog(@"APS: %@",aps);
        }
        
        if (aps[@"alert"]) {
            NSDictionary *alert = aps[@"alert"];
            NSString *url = aps[@"url"];

            if (alert[@"body"] && alert[@"title"]) {
                NSString *message = alert[@"body"] ;
                NSString *title = alert[@"title"] ;
                NSString *urlType = aps[@"url_type"];

                if (messageAlert && self.enabledAlert == YES) {
                    if (url) {
                        if (self.enabledShowAlertWithUrl == YES) {
                            if ([title length] > 0) {
                                [[AlertManager new] showAlert:aps buttonTittle:@"Ok" handler:^(UIAlertAction *action) {
                                    if (url) {
                                        [self handleUrlType:urlType andUrl:url];
                                    }
                                }];
                            } else {
                                [[AlertManager new] showAlert:@"Nova Mensagem" message:message buttonTittle:@"Ok"];
                            }
                        } else {
                            [self handleUrlType:urlType andUrl:url];
                        }
                    } else {
                        if ([title length] > 0) {
                            [[AlertManager new] showAlert:aps buttonTittle:@"Ok" handler: nil];
                        } else {
                            [[AlertManager new] showAlert:@"Nova Mensagem" message:message buttonTittle:@"Ok"];
                        }
                    }
                } else {
                    if (url) {
                        [self handleUrlType:urlType andUrl:url];
                    }
                }
                
                NSString *notificationId = aps[@"id"] ? aps[@"id"] : @"";
                
                if (self.defineLogs) {
                    NSLog(@"PushNotificationManager: function called handlePushReceived()");
                    NSLog(@"NotificationId: %@",notificationId);
                }
                
                NSDictionary *jsonBody = [self notificationCallbackRequest:notificationId];

                [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"notification" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
            }
        }
    }
}

-(void)handleUrlType:(NSString *)urlType andUrl:(NSString *)url {
    NSLog(@"Pass here now %@", urlType);
    if ([urlType isEqualToString:@"inapp"]) {
        [WebViewViewController openWebView:url];
    } else if ([urlType isEqualToString:@"deep"]) {
        [[URLSchemeManager new] openUrlScheme:url];
    }
}

- (void)handleUpdateLocations:(CLLocationManager *)locations{

    NSString *iPhoneUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary *jsonBody= [self registerGeolocationRequest:iPhoneUUID
                                                    latitude:[NSString stringWithFormat:@"%.04f", locations.location.coordinate.latitude]
                                                   longitude:[NSString stringWithFormat:@"%.04f", locations.location.coordinate.longitude] ];
    
    
    if (self.defineLogs) {
        NSLog(@"PushNotificationManager: function called handleUpdateLocations()");
        NSLog(@"%@",jsonBody);
    }
    [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"geolocation" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
}

#pragma mark - CLLocationManager Delegate

- (BOOL) canReadUserLocation
{
    return YES;
}

#pragma mark FOREGROUND LOCATION

- (BOOL) itsTimeToReadNewLocation
{
    if(!lastPositionReadDate)
        return YES;
    else
    {
        NSDate *date1 = lastPositionReadDate;
        NSDate *date2 = [NSDate date];
        NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
        double secondsInAnMinute = 60;
        NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAnMinute;
        if (self.defineLogs){
            NSLog(@"Minutes passed from last position read: %ld",(long)minutesBetweenDates);
        }
        if(minutesBetweenDates >= MIN_MINUTES_TO_READ_NEW_POSITION)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (void) getSingleLocationAndUpload
{
    if([self canReadUserLocation] && [self itsTimeToReadNewLocation])
    {
        if(!_isGettingSingleLocation)
        {
            _isGettingSingleLocation = YES;
            
            foregroundLocationManager = [[CLLocationManager alloc] init];
            foregroundLocationManager.delegate = self;
            foregroundLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
            

            
            [foregroundLocationManager startUpdatingLocation];
        }
    }
}

- (void)foregroundLocationManagerDidUpdateToLocation:(CLLocation *)newLocation
{
    [foregroundLocationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = newLocation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.defineLogs){
            NSLog(@"New Location: %f/%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
            NSLog(@"PushNotificationManager: function called handleUpdateLocations()");
        }
        NSString *iPhoneUUID =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *jsonBody= [self registerGeolocationRequest:iPhoneUUID latitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] ];
        if (self.defineLogs){
            NSLog(@"%@",jsonBody);
        }
        [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"geolocation" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
    });
    
    _isGettingSingleLocation = NO;
    lastPositionReadDate = [NSDate date];
}



#pragma mark BACKGROUND LOCATION

- (BOOL) verifySystemPermissionsWithAlertView
{
    UIAlertView *alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        if(!alreadyShowedBackgroundRefreshDisabledAlert)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"BackgroundAppRefreshDisabled", nil)
                                             delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"Done", nil)
                                    otherButtonTitles:nil, nil];
            [alert show];
            alreadyShowedBackgroundRefreshDisabledAlert = YES;
        }
        return false;
    }
    else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        if(!alreadyShowedBackgroundRefreshDisabledAlert)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"BackgroundAppRefreshRestricted", nil)
                                             delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"Done", nil)                                    otherButtonTitles:nil, nil];
            alreadyShowedBackgroundRefreshDisabledAlert = YES;
            [alert show];
        }
    }
    return true;
}

- (void)startMonitoringBackgroundLocation
{
    if([self canReadUserLocation])
    {
        if (backgroundLocationManager){
            [backgroundLocationManager stopMonitoringSignificantLocationChanges];
        }else{
            
            backgroundLocationManager = [[CLLocationManager alloc]init];
            backgroundLocationManager.delegate = self;
            backgroundLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
            backgroundLocationManager.activityType = CLActivityTypeOtherNavigation;
        }

        if([self verifySystemPermissionsWithAlertView])
            [backgroundLocationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)restartMonitoringBackgroundLocation
{
    if([self canReadUserLocation])
    {
        if (backgroundLocationManager){
            [backgroundLocationManager stopMonitoringSignificantLocationChanges];
        }else{
            
            backgroundLocationManager = [[CLLocationManager alloc]init];
            backgroundLocationManager.delegate = self;
            backgroundLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
            backgroundLocationManager.activityType = CLActivityTypeOtherNavigation;
        }

        if([self verifySystemPermissionsWithAlertView])
            [backgroundLocationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)backgroundLocationManagerDidUpdateToLocation:(CLLocation *)newLocation
{
    CLLocation *currentLocation = newLocation;
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
    self.myLocation = theLocation;
    self.myLocationAccuracy = theAccuracy;
    
    [foregroundLocationManager stopUpdatingLocation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.defineLogs){
            NSLog(@"New Location: %f/%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
            NSLog(@"PushNotificationManager: function called handleUpdateLocations()");
        }
        NSString *iPhoneUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *jsonBody = [self registerGeolocationRequest:iPhoneUUID
                                                         latitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude]
                                                        longitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] ];
        if (self.defineLogs){
            NSLog(@"%@",jsonBody);
        }
        [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"geolocation" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
    });
    
    _isGettingSingleLocation = NO;
    lastPositionReadDate = [NSDate date];
    
    [self addLocationToPlist:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = [error localizedDescription];
    
    if (self.defineLogs){
        NSLog(@"Failed to Get Your Location: %@", errorMsg);
    }
    
    if(manager == foregroundLocationManager)
        _isGettingSingleLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if(locations && locations.count>0)
    {
        CLLocation *lastLocation = [locations lastObject];
        if(lastLocation && lastLocation.coordinate.latitude != 0 && lastLocation.coordinate.longitude != 0)
        {
            if(manager == foregroundLocationManager)
            {
                [self foregroundLocationManagerDidUpdateToLocation:lastLocation];
            }
            else if(manager == backgroundLocationManager)
            {
                [self backgroundLocationManagerDidUpdateToLocation:lastLocation];
            }else if(manager == updateLocationManager){
                [self updateLocationManagerDidUpdateLocation:lastLocation];
            }
        }
    }
}

#pragma mark - Plist helper methods

- (NSString *)appState {
    UIApplication *application = [UIApplication sharedApplication];
    
    NSString *appState;
    if([application applicationState]==UIApplicationStateActive)
        appState = @"UIApplicationStateActive";
    if([application applicationState]==UIApplicationStateBackground)
        appState = @"UIApplicationStateBackground";
    if([application applicationState]==UIApplicationStateInactive)
        appState = @"UIApplicationStateInactive";
    
    return appState;
}

- (void)addResumeLocationToPlist {
    if (self.defineLogs){
        NSLog(@"addResumeLocationToPList");
    }
}

- (void)addLocationToPlist:(BOOL)fromResume {
    if (self.defineLogs){
        NSLog(@"addLocationToPList");
    }
}

- (void)addApplicationStatusToPlist:(NSString*)applicationStatus {
    if (self.defineLogs){
        NSLog(@"addApplicationStatusToPList");
    }
}

- (void)saveLocationsToPlist {
    
}

- (void)startLocationManager
{
    self.locationManagerApp = [[CLLocationManager alloc] init];
    self.locationManagerApp.delegate = self;
    self.locationManagerApp.distanceFilter = kCLDistanceFilterNone;
    self.locationManagerApp.desiredAccuracy = kCLLocationAccuracyBest;
    
}
- (void)updateLocation {
    updateLocationManager = [[CLLocationManager alloc]init];
    updateLocationManager.delegate = self;
    updateLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [updateLocationManager startUpdatingLocation];
}

- (void) updateLocationManagerDidUpdateLocation:(CLLocation *)newLocation {
    [updateLocationManager stopUpdatingLocation];
    
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
    self.myLocation = theLocation;
    self.myLocationAccuracy = theAccuracy;
    
    [foregroundLocationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = newLocation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.defineLogs){
            NSLog(@"New Location: %f/%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
            NSLog(@"PushNotificationManager: function called handleUpdateLocations()");
        }
        NSString *iPhoneUUID =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *jsonBody= [self registerGeolocationRequest:iPhoneUUID latitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] ];
        if (self.defineLogs){
            NSLog(@"%@",jsonBody);
        }
        [[ServiceManager new] postDataToAPI:jsonBody apiEndpoint:@"geolocation" apiUrl:self.inngageApiEndpoint logsEnabled:self.defineLogs];
    });
    
    _isGettingSingleLocation = NO;
    lastPositionReadDate = [NSDate date];
    
}

@end

