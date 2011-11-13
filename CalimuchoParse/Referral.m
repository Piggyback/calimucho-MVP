//
//  Referral.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Referral.h"

@implementation Referral

@synthesize referred;
@synthesize vid;
@synthesize vendorName;
@synthesize referredBy;
@synthesize numReferrals;

- (id)init {
    self = [super init];
    if (self) {
        referred = [[NSString alloc] init];
        vendorName = [[NSString alloc] init];
        referredBy = [[NSMutableArray alloc] init];
        NSLog(@"init for referral class");
    }
    return self; 
}

@end
