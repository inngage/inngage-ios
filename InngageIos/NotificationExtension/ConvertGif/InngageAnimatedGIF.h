//
//  InngageAnimatedGIF.h
//  Extension
//
//  Created by TQI on 30/10/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface InngageAnimatedGIF : NSObject

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)url;

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFName:(NSString * _Nonnull)name;

+ (UIImage * _Nullable)drawText:(NSString * _Nonnull)text inImage:(UIImage * _Nonnull)image atPoint:(CGPoint)point;

@end
