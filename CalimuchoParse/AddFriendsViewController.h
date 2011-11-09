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
    NSString *myEmail;
}

- (IBAction)addFriend:(id)sender;

@end
