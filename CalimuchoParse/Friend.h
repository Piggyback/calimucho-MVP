//
//  Friend.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (atomic, retain) NSString *email;

- (id)initWithEmail:(NSString*)newEmail;

@end
