//
//  CreateAcctViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateAcctViewController.h"
#import "Parse/Parse.h"
#import "CMAppDelegate.h"

@implementation CreateAcctViewController

- (IBAction)createAcct:(id)sender
{    
    NSString *emailRegex = @".*@.*";
    NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    // email is not valid. show alert
    if (![emailPred evaluateWithObject:email.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Invalid Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if ([password.text length] < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Password Must Be At Least 5 Characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    // email is valid. try to add user to user db
    else {
        PFUser *user = [[PFUser alloc] init];
        user.username = email.text;
        user.password = password.text;
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // account successfully added. store email of current user for reference
                CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myEmail = email.text;
                
                // display next view
                UITabBarController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                [self presentModalViewController:homeViewController animated:YES];
            }
            
            else {
                // account creation failed. show alert
                if ([error code] == kPFErrorConnectionFailed) {
                    NSLog(@"Could not connect to Parse servers");
                }
                else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }];
    }
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [email resignFirstResponder];
    [password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
