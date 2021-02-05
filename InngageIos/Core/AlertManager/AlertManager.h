//
//  AlertManager.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertManager : NSObject

- (void)showAlert:(NSString *)title message:(NSString *)message buttonTittle:(NSString *)buttonTitle;
- (void)showAlert:(NSDictionary *)aps buttonTittle:(NSString *)buttonTitle handler:(void (^)(UIAlertAction *action))handler;

@end
