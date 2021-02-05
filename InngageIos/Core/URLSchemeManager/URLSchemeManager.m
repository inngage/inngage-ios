//
//  URLSchemeManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 02/02/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "URLSchemeManager.h"

@implementation URLSchemeManager


-(void)openUrlScheme:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
