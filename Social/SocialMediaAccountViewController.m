//
//  SocialMediaAccountViewController.m
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "SocialMediaAccountViewController.h"

#import "SocialMediaAccount.h"

@interface SocialMediaAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *flickrField;
@property (weak, nonatomic) IBOutlet UITextField *twitterField;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;


@property NSEntityDescription *entity;

@end

@implementation SocialMediaAccountViewController

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
    
    // Initialise the managedObjectContext and SocialMediaAccount objects.
}


- (IBAction)addAccountsButtonPressed:(id)sender {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SocialMediaAccount" inManagedObjectContext:self.context];
    
    Contact *contact = self.passedContact;
    
    
    SocialMediaAccount *flickr = [[SocialMediaAccount alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
    flickr.accountType = @"Flickr";
    flickr.identifier = self.flickrField.text;
    
    SocialMediaAccount *twitter = [[SocialMediaAccount alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
    twitter.accountType = @"Twitter";
    twitter.identifier = self.twitterField.text;
    
    SocialMediaAccount *website = [[SocialMediaAccount alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
    website.accountType = @"Website";
    website.identifier = self.websiteField.text;
    
    NSMutableSet *mutableSites = [[NSMutableSet alloc] init];
    
    if(![self.flickrField.text isEqualToString:@""]){
        [mutableSites addObject:flickr];
    }
    if(![self.twitterField.text isEqualToString:@""]){
        [mutableSites addObject:twitter];
    }
    if(![self.websiteField.text isEqualToString:@""]){
        [mutableSites addObject:website];
    }
    
    [contact addSites:mutableSites];
    
    NSError *error;
    [self.context save:&error];
}



- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
