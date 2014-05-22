//
//  FlickrImageViewController.m
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "FlickrImageViewController.h"

@interface FlickrImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FlickrImageViewController

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
    
    if(self.tempObject){
        // Set up the image view.
        
        self.navigationItem.title = [self.tempObject valueForKey:@"title"];
        
        NSString *photoID = [self.tempObject valueForKey:@"id"];

        
        NSArray *photoSizes = [self.passedAPI photoSizes:photoID];
        NSDictionary *largestPhoto = [photoSizes objectAtIndex:3];
        NSURL *largestPhotoURL = [NSURL URLWithString:[largestPhoto valueForKey:@"source"]];
        
        dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(background, ^{
            
            UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
            
            NSData *imageData = [NSData dataWithContentsOfURL:largestPhotoURL];
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                
                self.imageView.image = image;
                
            });
        });

    }
}


@end
