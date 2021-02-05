//
//  AlertManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "AlertManager.h"

#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation AlertManager

- (void)showAlert:(NSString *)title message:(NSString *)message buttonTittle:(NSString *)buttonTitle {
    
    if (IS_IOS_8_OR_LATER) {
        [self alertToLaterIos:title message:message buttonTittle:@"Ok"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)showAlert:(NSDictionary *)aps buttonTittle:(NSString *)buttonTitle handler:(void (^)(UIAlertAction *action))handler {
    
    NSDictionary *alert = aps[@"alert"] ;
    NSString *message = alert[@"body"] ;
    NSString *title = alert[@"title"] ;
    
    if (IS_IOS_8_OR_LATER) {
        
        UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:handler];
        
        [controller addAction:alertAction];
        [viewController presentViewController:controller animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}


- (void)alertToLaterIos:(NSString *)title message:(NSString *)message buttonTittle:(NSString *)buttonTitle {
    
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        
    }];
    [controller addAction:alertAction];
    [viewController presentViewController:controller animated:YES completion:nil];
}

@end
