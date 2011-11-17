//
//  ReferFriendsViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vendor.h"

@interface ReferFriendsViewController : UITableViewController {
    UIView *footerView;
}

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSString *myEmail;
@property (nonatomic, strong) Vendor *vendor;
@property (nonatomic, strong) NSMutableArray *friendsToRefer;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *rowCheckArray;

- (IBAction)referButton:(id)sender;
- (void)getFriendData;
- (void) addReferral:(NSString*)referredTo;
- (void) initCheckArray;
@end
