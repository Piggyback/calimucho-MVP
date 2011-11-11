//
//  ShowFriendsViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFriendsViewController : UITableViewController {
    NSLock *condition;
}

@property (nonatomic) int n;
@property (nonatomic, copy) NSMutableArray *friends;
@property (nonatomic, strong) NSString *myEmail;

@end
