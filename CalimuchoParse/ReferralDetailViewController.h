//
//  ReferralDetailViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Referral.h"
#import "QRReaderViewController.h"

@interface ReferralDetailViewController : UITableViewController

@property (nonatomic, strong) Referral *referral;
@property (nonatomic, strong) NSMutableArray *referrers;

@end
