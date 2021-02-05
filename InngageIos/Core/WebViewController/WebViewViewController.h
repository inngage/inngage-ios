//
//  WebViewViewController.h
//  PushNotificationManager
//
//  Created by Luis Teodoro on 20/10/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewProgress.h"
#import "WebViewProgressView.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

@interface WebViewViewController : UIViewController<WebViewProgressDelegate, WKUIDelegate, WKNavigationDelegate>

@property IBOutlet UILabel *loading;
@property NSString * URL;
@property (weak, nonatomic) IBOutlet UIButton *close;

+ (void)openWebView:(NSString *)url;
- (IBAction)close:(id)sender;

@end
