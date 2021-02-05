//
//  AppManager.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

-(NSString *)appInstalledDate;
-(NSString *)infoPlistAppToken;
-(NSString *)appUpdatedDate;

@end
