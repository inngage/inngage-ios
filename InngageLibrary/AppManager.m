//
//  AppManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "AppManager.h"
#import "PushNotificationManager.h"

#define DATE [NSString stringWithUTF8String:__DATE__]
#define TIME [NSString stringWithUTF8String:__TIME__]

@implementation AppManager

- (NSString *)appInstalledDate {

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL* urlToDocumentsFolder = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    __autoreleasing NSError *error;
    NSDate *installDate = [[fileManager attributesOfItemAtPath:urlToDocumentsFolder.path
                                                         error:&error]
                           objectForKey:NSFileCreationDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString *installedDateFormatted = [dateFormatter stringFromDate: installDate];

    return installedDateFormatted;
}

- (NSString *)infoPlistAppToken {

    NSString * appToken =  [PushNotificationManager sharedInstance].inngageAppToken ? [PushNotificationManager sharedInstance].inngageAppToken : @"";

    return appToken;
}

- (NSString *)appUpdatedDate {
    NSString *buildDate;

    // Get build date and time, format to 'yyMMddHHmm'
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@", DATE , TIME ];

    // Convert to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLL d yyyy HH:mm:ss"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    NSDate *date = [dateFormat dateFromString:dateStr];

    // Set output format and convert to string
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    buildDate = [dateFormat stringFromDate:date];

    return buildDate;
}

@end
