//
//  Vendor.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Vendor.h"

@implementation Vendor

@synthesize vid;
@synthesize name;
@synthesize address;
@synthesize hours;
@synthesize phone;

- (id)init {
    self = [super init];
    if (self) {
        name = [[NSString alloc] init];
        address = [[NSString alloc] init];
        hours = [[NSString alloc] init];
        NSLog(@"init for vendor class");
    }
    return self; 
}

@end