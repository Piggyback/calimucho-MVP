//
//  CMViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CMViewController.h"
#import "Parse/Parse.h"
#import "CMAppDelegate.h"

@implementation CMViewController

- (IBAction)signIn:(id)sender
{    
    [PFUser logInWithUsernameInBackground:email.text password:password.text
            block:^(PFUser *user, NSError *error) {
                if (user) {
                    // successful login. store email of current user
                    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.myEmail = email.text;
                    
                    // only go to next screen if login is successful
                    UITabBarController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                    [self presentModalViewController:homeViewController animated:YES];
                } else {
                    // failed login. stay on same screen
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Email and password did not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];
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
    
    PFObject *testObject = [[PFObject alloc] initWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:animated];
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
