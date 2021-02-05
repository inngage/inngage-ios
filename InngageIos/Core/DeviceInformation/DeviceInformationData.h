//
//  DeviceInformationData.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DeviceInformationData : NSObject

@property(nonatomic) NSString *deviceSystemName;
@property(nonatomic) NSString *UUID;
@property(nonatomic) NSString *osLanguage;
@property(nonatomic) NSString *countryCode;
@property(nonatomic) NSString *country;
@property(nonatomic) NSString *systemVersion;
@property(nonatomic) NSString *versionNumber;
@property(nonatomic) NSString *appInstalledDate;
@property(nonatomic) NSString *infoPlistAppToken;
@property(nonatomic) NSString *hardwareDescription;
@property(nonatomic) NSString *appUpdatedDate;

-(NSDictionary *)dictionaryWithDeviceToken:(NSString *)deviceToken andIdentifier:(NSString *)identifier andCustomField:(NSDictionary *)customField;

@end
