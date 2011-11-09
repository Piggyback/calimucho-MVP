//
//  CMAppDelegate.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSMutableArray *vendors;
@property (strong, nonatomic) NSString *myEmail;
@property (strong, nonatomic) UIWindow *window;

- (void)getVendorData;

@end
