//
//  WebsiteViewController.h
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialMediaAccount.h"

@interface WebsiteViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>

@property SocialMediaAccount *passedSocialMedia;
@property NSString *passedWebsiteURL;

@end
