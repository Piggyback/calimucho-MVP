//
//  AddFriendsViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "Parse/Parse.h"
#import "CMAppDelegate.h"

@implementation AddFriendsViewController

- (IBAction)addFriend:(id)sender {    
    PFObject *newFriend = [[PFObject alloc] initWithClassName:@"Friends"];
    [newFriend setObject:myEmail forKey:@"uid1"];
    [newFriend setObject:friendEmail.text forKey:@"uid2"];
    [newFriend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            label.text = @"Friend added!";
        } else {
            label.text = @"Error";
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    myEmail = appDelegate.myEmail;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
