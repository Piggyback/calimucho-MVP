//
//  AddFriendsViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController {
    IBOutlet UILabel *label;
    IBOutlet UITextField *friendEmail;
}

@property (strong, nonatomic) NSString *myEmail;
@property (strong, nonatomic) NSMutableArray *existingFriends;

- (IBAction)addFriend:(id)sender;
- (BOOL)doesFriendshipExistAlready:(NSString*)friendEmail;
- (BOOL)doesUserExist:(NSString*)friendsEmail;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
