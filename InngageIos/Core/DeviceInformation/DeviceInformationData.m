//
//  DeviceInformationData.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "DeviceInformationData.h"

@implementation DeviceInformationData

-(NSDictionary *)dictionaryWithDeviceToken:(NSString *)deviceToken andIdentifier:(NSString *)identifier andCustomField:(NSDictionary *)customField {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{
                                           @"identifier": identifier ? identifier : (self.UUID ? self.UUID : @""),
                                           @"registration": deviceToken ? deviceToken : @"",
                                           @"platform": self.deviceSystemName ? self.deviceSystemName : @"",
                                           @"sdk": @"2",
                                           @"app_token": self.infoPlistAppToken ? self.infoPlistAppToken : @"",
                                           @"device_model": self.hardwareDescription ? self.hardwareDescription : @"",
                                           @"device_manufacturer": @"Apple",
                                           @"os_locale": self.country ? self.country : @"",
                                           @"os_language": self.osLanguage ? self.osLanguage : @"",
                                           @"os_version": self.systemVersion ? self.systemVersion : @"",
                                           @"app_version": self.versionNumber ? self.versionNumber : @"",
                                           @"app_installed_in": self.appInstalledDate ? self.appInstalledDate : @"",
                                           @"app_updated_in": self.appUpdatedDate ? self.appUpdatedDate : @"",
                                           @"uuid": self.UUID ? self.UUID : @""}
                                       ];

    if (deviceToken != nil) {
        [parameters setValue:deviceToken forKey:@"registration"];
    }

    if (identifier != nil) {
        [parameters setValue:identifier forKey:@"identifier"];
    } else {
        [parameters setValue:self.UUID ? self.UUID : @"" forKey:@"identifier"];
    }

    if (customField != nil) {
        [parameters setObject:customField forKey:@"custom_field"];
    }


    return @{@"registerSubscriberRequest":parameters};
}

@end
