//
//  DeviceInformation.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "DeviceInformation.h"
#import "HardwareManager.h"
#import "AppManager.h"

@implementation DeviceInformation

- (DeviceInformationData *)deviceInformation {
    HardwareManager *hardwareManager = [HardwareManager new];
    AppManager *appManager = [AppManager new];
    
    UIDevice *device = [UIDevice currentDevice];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    DeviceInformationData *deviceInformationData = [DeviceInformationData new];
    deviceInformationData.deviceSystemName = device.systemName;
    deviceInformationData.UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceInformationData.osLanguage = [locale objectForKey:NSLocaleLanguageCode];
    deviceInformationData.countryCode = countryCode;
    deviceInformationData.country = [locale displayNameForKey:NSLocaleCountryCode value: countryCode];
    deviceInformationData.systemVersion = device.systemVersion;
    deviceInformationData.versionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    deviceInformationData.appInstalledDate = [appManager appInstalledDate];
    deviceInformationData.infoPlistAppToken = [appManager infoPlistAppToken];
    deviceInformationData.hardwareDescription = [hardwareManager hardwareDescription];
    deviceInformationData.appUpdatedDate = [appManager appUpdatedDate];
    
    return deviceInformationData;
}

@end
