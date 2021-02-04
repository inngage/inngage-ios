//
//  ImageUtils.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];

    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
    }
    return nil;
}

@end
