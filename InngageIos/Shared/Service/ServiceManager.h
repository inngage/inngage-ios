//
//  ServiceManager.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceManager : NSObject<NSURLSessionDataDelegate>

- (void)postDataToAPI:(NSDictionary *)jsonBody apiEndpoint:(NSString *)apiEndpoint apiUrl:(NSString *)apiUrl logsEnabled:(BOOL) logsEnabled;

- (void)downloadDataWithUrl:(NSString *)urlString completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end

