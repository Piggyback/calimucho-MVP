//
//  CreateAcctViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAcctViewController : UIViewController {

    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    IBOutlet UILabel *label;
}

- (IBAction)createAcct:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
