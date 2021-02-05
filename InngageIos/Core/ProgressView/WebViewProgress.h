//
//  WebViewProgress.h
//
//  Created by Luis Teodoro on 15/03/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef _weak
#if __has_feature(objc_arc_weak)
#define _weak weak
#else
#define _weak unsafe_unretained
#endif

extern const float InitialProgressValue;
extern const float InteractiveProgressValue;
extern const float FinalProgressValue;

typedef void (^WebViewProgressBlock)(float progress);
@protocol WebViewProgressDelegate;
@interface WebViewProgress : NSObject

@property (nonatomic, _weak) id<WebViewProgressDelegate>progressDelegate;
@property (nonatomic, _weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) WebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol WebViewProgressDelegate <NSObject>
- (void)webViewProgress:(WebViewProgress *)webViewProgress updateProgress:(float)progress;

@end
