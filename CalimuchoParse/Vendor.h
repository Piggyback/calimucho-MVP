//
//  Vendor.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vendor : NSObject

@property (atomic, assign) int vid;
@property (atomic, retain) NSString* name;
@property (atomic, retain) NSString* address;
@property (atomic, retain) NSString* hours;
@property (atomic, assign) int phone;

@end