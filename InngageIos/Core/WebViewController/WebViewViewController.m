//
//  WebViewViewController.m
//  PushNotificationManager
//
//  Created by Luis Teodoro on 20/10/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//
#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController {
    
    IBOutlet __weak WKWebView *_webView;
    
    WebViewProgressView *_progressView;
    WebViewProgress *_progressProxy;
    
    IBOutlet UIView *ViewProgress;
}

+ (void)openWebView:(NSString *)url {
    WebViewViewController *webView = [[WebViewViewController alloc] init];

    webView.URL = url;
    webView.modalPresentationStyle = UIModalPresentationFullScreen;

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webView
                                                                                 animated:YES
                                                                               completion:nil];
}

- (id)init {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"InngageLibrary-Resources" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"WebViewViewController" bundle:bundle])) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    CGRect barFrame = CGRectMake(0, 0, self.view.frame.size.width, 3.f);
    _progressView = [[WebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self load];
    
    [ViewProgress addSubview:_progressView];
    
    [_progressView setHidden:YES];
    self.close.layer.cornerRadius= 5.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)load
{
    NSString *urlString = self.URL;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _webView) {
        NSLog(@"%f", _webView.estimatedProgress);
        
        if (_webView.estimatedProgress==1.0) {
               [_loading setHidden:YES];
           }
           [_progressView setHidden:NO];
           [_progressView setProgress:_webView.estimatedProgress animated:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
