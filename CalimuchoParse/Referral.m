//
//  Referral.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Referral.h"

@implementation Referral

@synthesize referrer;
@synthesize referred;
@synthesize vid;
@synthesize completed;

- (id)init {
    self = [super init];
    if (self) {
        referrer = [[NSString alloc] init];
        referred = [[NSString alloc] init];
        NSLog(@"init for referral class");
    }
    return self; 
}

@end
