//
//  DetailViewController.h
//  Social
//
//  Created by Nishant Shrestha on 18/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id detailItem;

@end
