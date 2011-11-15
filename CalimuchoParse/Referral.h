//
//  Referral.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Referral : NSObject

@property (nonatomic, strong) NSString* referred;
@property (nonatomic, assign) int vid;
@property (nonatomic, strong) NSString* vendorName;
@property (nonatomic, strong) NSMutableArray* referredBy;
@property (nonatomic, assign) int numReferrals;

@end
