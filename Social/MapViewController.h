//
//  MapViewController.h
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface MapViewController : UIViewController <UITextFieldDelegate>

@property NSManagedObjectContext *context;
@property Contact *passedContact;

@end
