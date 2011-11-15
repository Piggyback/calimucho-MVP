//
//  VendorSingleViewController.m
//  CalimuchoParse
//
//  Created by Michael Gao on 11/11/11.
//  Copyright (c) 2011 UCLA. All rights reserved.
//

#import "VendorSingleViewController.h"
#import "CMAppDelegate.h"
#import "ReferFriendsViewController.h"

@implementation VendorSingleViewController
@synthesize vendorNameLabel;
//@synthesize vendorNameString;
@synthesize pointsProgressBar;
@synthesize juiceStatus;
@synthesize myEmail;
@synthesize vendor;

//- (id)init
//{
//    if (self = [super init]) {
//    //self = [super init];
//    //if (self) {
//        //[self setKim:1];
//        //[self setFakeKim:2];
//        kim = 5;
//        fakeKim = 7;
//        blah = 100;
//        NSLog(@"init was successful for VendorSingleViewController");
//        NSLog(@"kim: %d fakeKim: %d blah: %d", kim, fakeKim, blah);
//        if (kim == 5) {
//            NSLog(@"Hello");
//        }
//    }
//    return self;
//}


- (id)initWithCoder:(NSCoder *)inCoder
{
    self = [super initWithCoder:inCoder];
    fromQRreader = false;
    NSLog(@"initWithCoder for VendorSingleViewController");
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"initWithNibName successful");
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"referFriendsSegue"]) {
        ReferFriendsViewController *rfvc = [segue destinationViewController];
        rfvc.vendor = vendor;
    }
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
    NSLog(@"from vsvc BEFORE VIEWDIDLOAD: %@", vendorNameLabel.text);
    [super viewDidLoad];
    
    // set label's text to vendor name
    vendorNameLabel.text = vendor.name;
    NSLog(@"from vsvc: %@", vendorNameLabel.text);
    if (fromQRreader == TRUE) {
        NSLog(@"from vsvc: fromQRreader=TRUE");
    } else {
        NSLog(@"from vsvc: fromQRreader=FALSE");
    }
    
    // user progress at specific vendor
    // get user email from app delegate
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    myEmail = appDelegate.myEmail;
    
    // check if user is in Points table
    PFQuery *query = [PFQuery queryWithClassName:@"Points"];
    [query whereKey:@"username" equalTo:myEmail];
    [query whereKey:@"vendorname" equalTo:vendor.name];
    if ([query countObjects] < 1) {
        // add user to Points table
        PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
        [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
        [entry setObject:myEmail forKey:@"username"];
        [entry setObject:vendor.name forKey:@"vendorname"];
        [entry save];
    }
    
    NSArray* userArray = [query findObjects];
    PFObject *userRow = [userArray objectAtIndex:0];
    NSLog(@"Successfully retrieved user:%@ at:%@", [userRow objectForKey:@"username"], [userRow objectForKey:@"vendorname"]);
    
    NSNumber *points = [userRow objectForKey:@"points"];
    
    if (fromQRreader == TRUE) {
        NSNumber *newPoints = [NSNumber numberWithInt:([points intValue] + 1)];
        // save new points back to parse
        [userRow setObject:newPoints forKey:@"points"];
        [userRow save];
        [pointsProgressBar setProgress:([newPoints floatValue]/10.0)];
        juiceStatus.text = [NSString stringWithFormat:@"%i more piggybacks to obtain JUICE", (10-[newPoints intValue])];
    } else {
        //TODO: Add users to points table if they do not exist
        //TODO: Once user reaches 10 points, reset to 0
        [pointsProgressBar setProgress:([points floatValue]/10.0)];
        juiceStatus.text = [NSString stringWithFormat:@"%i more piggybacks to obtain JUICE", (10-[points intValue])];
    }
}


 - (void)viewDidUnload
 {
 vendorNameLabel = nil;
 //vendorNameString = nil;
// pointsProgressBar = nil;
// juiceStatus = nil;
// myEmail = nil;
 [super viewDidUnload];
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setFromQRreader:(bool)aBool {
    fromQRreader = aBool;
}
-(bool)fromQRreader {
    return fromQRreader;
}


//- (int)kim {
//    return kim;
//}
//
//- (int)fakeKim {
//    return fakeKim;
//}
//
//- (void)setKim:(int)temp {
//    kim = temp;
//}
//
//- (void)setFakeKim:(int)temp {
//    fakeKim = temp;
//}

@end
