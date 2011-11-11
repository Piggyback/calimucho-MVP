//
//  Friend.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize email;

- (id)init {
    return [self initWithEmail:nil];
}

- (id)initWithEmail:(NSString*)newEmail {
    self = [super init];
    if (self) {
        NSLog(@"init for friend class");
        email = newEmail;
    }
    return self;
}

@end
