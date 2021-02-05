//
//  NotificationManager.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "NotificationManager.h"
#import "ServiceManager.h"
#import "MimeType.h"
#import "FileLocation.h"
#import "InngageAnimatedGIF.h"
#import <AVKit/AVKit.h>

@implementation NotificationManager

+ (void)prepareNotificationWithRequest:(UNNotificationRequest *)request
                 andBestAttemptContent:(UNMutableNotificationContent *) bestAttemptContent
                   andCompletionHander:(void (^)(UNNotificationContent *bestAttemptContent))completionHandler {

    __block UNMutableNotificationContent *bestAttemptContentMutable = [request.content mutableCopy];

    NSString *urlString = request.content.userInfo[@"aps"][@"otherCustomURL"];
    if (urlString) {
        [[ServiceManager new] downloadDataWithUrl:urlString completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            FileLocation *fileLocation = [self saveOnTemporaryFileWithLocation:location];

            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:fileLocation.identifier URL:fileLocation.location options:nil error:nil];

            bestAttemptContentMutable.attachments = @[attachment];

            completionHandler(bestAttemptContentMutable);

        }];
    } else {
        completionHandler(bestAttemptContentMutable);
    }
}

+ (void)prepareNotificationContentWithNotification:(UNNotification *)notification
                                 andViewController:(UIViewController *)viewController {
    //                              andCompletionHandler:(void (^)(UIView *view))completionHandler {

    NSString *urlString = notification.request.content.userInfo[@"aps"][@"otherCustomURL"];
    if (urlString) {

        [[ServiceManager new] downloadDataWithUrl:urlString completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            FileLocation *fileLocation = [self saveOnTemporaryFileWithLocation:location];
            if (fileLocation.mimeTypeModel.type == MimeTypeFileTypePng ||  fileLocation.mimeTypeModel.type == MimeTypeFileTypeJpg || fileLocation.mimeTypeModel.type == MimeTypeFileTypeGif) {
                UIImage *image = [InngageAnimatedGIF animatedImageWithAnimatedGIFURL:fileLocation.location];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];

                [imageView setImage:image];

                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.frame = viewController.view.frame;
                    [viewController.view addSubview:imageView];
                });
                //                completionHandler(imageView);
            }
            if (fileLocation.mimeTypeModel.type == MimeTypeFileTypeMp4) {

                UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;


                if (attachment.URL.startAccessingSecurityScopedResource) {
                    AVAsset *asset = [AVAsset assetWithURL:fileLocation.location];
                    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];

                    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
                    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

                    //                completionHandler(playerLayer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    [playerViewController setPlayer:player];
                    playerViewController.view.frame = viewController.view.frame;
                    [viewController.view addSubview:playerViewController.view];
                    [viewController addChildViewController:playerViewController];
                    [playerViewController didMoveToParentViewController:viewController];
                    [player play];


//                        AVAssetTrack *assetTrack = [[player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//                        CGSize videoSize = CGSizeApplyAffineTransform(assetTrack.naturalSize, assetTrack.preferredTransform);
////                        viewController.view.frame = CGRectMake(0, 0, viewController.view.frame.size.width, videoSize.height);
//
//                        float height = (viewController.view.frame.size.width * assetTrack.naturalSize.height)/viewController.view.frame.size.width;
//                        viewController.preferredContentSize = CGSizeMake(viewController.view.frame.size.width, height);
//                        playerLayer.frame = CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height);
//
//                        [viewController.view.layer addSublayer:playerLayer];
//                        [player play];
                    });
                }
            }


        }];
    } //else {
    //        completionHandler(nil);
    //    }
}

+(FileLocation *)saveOnTemporaryFileWithLocation:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *temporaryFolderName = NSProcessInfo.processInfo.globallyUniqueString;
    NSURL *temporaryFolderUrl = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:temporaryFolderName isDirectory:YES];

    [fileManager createDirectoryAtURL:temporaryFolderUrl withIntermediateDirectories:true attributes:nil error:nil];

    MimeTypeModel *mimeTypeModel = [[MimeType sharedInstance] mimeTypeModelWithURL:location];
    NSString *fileIdentifier = [NSUUID.UUID.UUIDString stringByAppendingPathExtension: mimeTypeModel.ext];
    NSURL *fileURL = [temporaryFolderUrl URLByAppendingPathComponent:fileIdentifier];

    [fileManager moveItemAtPath:location.path toPath:fileURL.path error:nil];

    FileLocation *fileLocation = [[FileLocation alloc] initWithIdentifier:fileIdentifier andLocation:fileURL andMimeTypeModel:mimeTypeModel];

    return fileLocation;
}

@end
