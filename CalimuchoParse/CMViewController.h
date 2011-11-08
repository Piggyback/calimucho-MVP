//
//  CMViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController {

    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    IBOutlet UILabel *label;
}

- (IBAction)signIn:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
