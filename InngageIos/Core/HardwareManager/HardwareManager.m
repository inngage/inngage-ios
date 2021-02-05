//
//  HardwareManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "HardwareManager.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation HardwareManager

- (NSString *)hardwareDescription {

    NSString *hardware = [self hardwareString];

    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([hardware isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([hardware isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([hardware isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([hardware isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([hardware isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([hardware isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([hardware isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";

    if ([hardware isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([hardware isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([hardware isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([hardware isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:@"iPhone10,3"])    return @"iPhone X (CDMA)";
    if ([hardware isEqualToString:@"iPhone10,6"])    return @"iPhone X (GSM)";
    if ([hardware isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([hardware isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([hardware isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max China";
    if ([hardware isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([hardware isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([hardware isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([hardware isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";

    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([hardware isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([hardware isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([hardware isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([hardware isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([hardware isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([hardware isEqualToString:@"iPad5,4"])      return @"iPad Air 2";

    if ([hardware isEqualToString:@"iPad6,3"])      return @"iPad PRO 12.9";
    if ([hardware isEqualToString:@"iPad6,4"])      return @"iPad PRO 12.9";
    if ([hardware isEqualToString:@"iPad6,4"])      return @"iPad PRO 12.9";

    if ([hardware isEqualToString:@"iPad6,7"])      return @"iPad PRO 9.7";
    if ([hardware isEqualToString:@"iPad6,8"])      return @"iPad PRO 9.7";

    if ([hardware isEqualToString:@"iPad6,11"])      return @"iPad (5th generation)";
    if ([hardware isEqualToString:@"iPad6,12"])      return @"iPad (5th generation)";

    if ([hardware isEqualToString:@"iPad7,1"])      return @"iPad PRO 12.9 (2nd Gen)";
    if ([hardware isEqualToString:@"iPad7,2"])      return @"iPad PRO 12.9 (2nd Gen)";
    if ([hardware isEqualToString:@"iPad7,2"])      return @"iPad PRO 12.9 (2nd Gen)";

    if ([hardware isEqualToString:@"iPad7,3"])      return @"iPad PRO 10.5";
    if ([hardware isEqualToString:@"iPad7,4"])      return @"iPad PRO 10.5";

    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";

    return @"Undefined";
}

- (NSString *)hardwareString {
    size_t size = 100;
    char *hw_machine = malloc(size);
    int name[] = {CTL_HW,HW_MACHINE};
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

@end
