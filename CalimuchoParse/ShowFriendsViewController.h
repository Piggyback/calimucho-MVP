//
//  ShowFriendsViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFriendsViewController : UITableViewController {
    NSCondition *condition;
}

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSString *myEmail;

@end
