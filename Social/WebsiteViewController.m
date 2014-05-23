//
//  WebsiteViewController.m
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "WebsiteViewController.h"

@interface WebsiteViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebsiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Set up the view controller and load the website when the view is about to appear.
- (void) viewWillAppear:(BOOL)animated
{
    if(![self.passedWebsiteURL isEqualToString: @""]){
        NSURL *websiteURL = [NSURL URLWithString:self.passedWebsiteURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteURL];
        [self.webView loadRequest:urlRequest];
    }
}


#pragma  mark - UIWebView delegate methods

// Following methods take care of the 'networkActivityIndicator' as required.
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}


@end
