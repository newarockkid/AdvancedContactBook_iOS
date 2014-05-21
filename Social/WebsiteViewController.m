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


- (void) viewWillAppear:(BOOL)animated
{
    if(![self.passedWebsiteURL isEqualToString: @""]){
        NSURL *websiteURL = [NSURL URLWithString:self.passedWebsiteURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteURL];
        [self.webView loadRequest:urlRequest];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
