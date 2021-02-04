//
//  WebViewProgressView.h
//
//  Created by Luis Teodoro on 15/03/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewProgressView : UIView

@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
