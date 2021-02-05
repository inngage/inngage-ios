//
//  ServiceManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 28/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "ServiceManager.h"

@implementation ServiceManager

- (void)postDataToAPI:(NSDictionary *)jsonBody apiEndpoint:(NSString *)apiEndpoint apiUrl:(NSString *)apiUrl logsEnabled:(BOOL) logsEnabled {

    NSString *apiPath;

    if([apiEndpoint isEqualToString:@"subscription"]) {
        apiPath = @"/subscription/";
        apiEndpoint = [apiUrl stringByAppendingString:apiPath];
    }

    if([apiEndpoint isEqualToString:@"notification"]) {
        apiPath = @"/notification/";
        apiEndpoint = [apiUrl stringByAppendingString:apiPath];
    }

    if([apiEndpoint isEqualToString:@"geolocation"]) {
        apiPath = @"/geolocation/";
        apiEndpoint = [apiUrl stringByAppendingString:apiPath];
    }

    NSLog(@"Request body %@", jsonBody);

    [self requestPost:apiEndpoint dictionaryDados:jsonBody logsEnabled: logsEnabled success:^ (NSDictionary *responseDict) {
        if (logsEnabled) {
            NSLog(@"%@",responseDict);
        }
    } failure:^(NSError *error) {
        if (logsEnabled){
            NSLog(@"%@", error);
        }
    }];
}

- (void)requestPost:(NSString *)urlString dictionaryDados:(NSDictionary*)dictionaryDados logsEnabled:(BOOL) logsEnabled success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *error))failure {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSError *error;

    NSData *postData = [NSJSONSerialization  dataWithJSONObject:dictionaryDados options:0 error:&error];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (logsEnabled) {
            NSLog(@"Response: %ld",(long)[httpResponse statusCode]);
        }

        if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] < 300 && data != nil) {

            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success(jsonDict);

        } else {
            failure(error);
        }
    }]resume];
}

- (void)downloadDataWithUrl:(NSString *)urlString completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(location, response, error);
    }] resume];
}

@end
