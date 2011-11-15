//
//  ReferralsViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferralsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *referrals;
@property (nonatomic, strong) NSString *myEmail;

- (void)getReferralData;
- (void)addReferral;

@end
