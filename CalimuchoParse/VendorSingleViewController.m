//
//  VendorSingleViewController.m
//  CalimuchoParse
//
//  Created by Michael Gao on 11/11/11.
//  Copyright (c) 2011 UCLA. All rights reserved.
//

#import "VendorSingleViewController.h"
#import "CMAppDelegate.h"

@implementation VendorSingleViewController
@synthesize vendorNameLabel;
@synthesize vendorNameString;
@synthesize pointsProgressBar;
@synthesize juiceStatus;
@synthesize myEmail;
@synthesize referrer;

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
    referrer = nil;
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
    vendorNameLabel.text = vendorNameString;
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
    [query whereKey:@"vendorname" equalTo:vendorNameString];
    NSArray* userArray = [query findObjects];
    PFObject *userRow;
    
    if ([userArray count] < 1) {
        // add user to Points table
        PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
        [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
        [entry setObject:myEmail forKey:@"username"];
        [entry setObject:vendorNameString forKey:@"vendorname"];
        [entry save];
        userRow = entry;
    } else {
            userRow = [userArray objectAtIndex:0];
    }
    
    NSLog(@"Successfully retrieved user:%@ at:%@", [userRow objectForKey:@"username"], [userRow objectForKey:@"vendorname"]);
    
    NSNumber *points = [userRow objectForKey:@"points"];
    
    if (fromQRreader == TRUE) {
        if ([points intValue] == 9) {
            points = [NSNumber numberWithInt:0];
        }
        else {
            points = [NSNumber numberWithInt:([points intValue] + 1)];
        }
        // save new points back to parse
        [userRow setObject:points forKey:@"points"];
        [userRow save];
        [pointsProgressBar setProgress:([points floatValue]/10.0)];
        juiceStatus.text = [NSString stringWithFormat:@"%i more piggybacks to obtain JUICE", (10-[points intValue])];
        
        // check if user was referred by a friend
        if (fromReferralDetail == TRUE) {
            // check if friend is in points table
            PFQuery *query2 = [PFQuery queryWithClassName:@"Points"];
            [query2 whereKey:@"username" equalTo:referrer];
            [query2 whereKey:@"vendorname" equalTo:vendorNameString];
            NSArray* userArray2 = [query2 findObjects];
            PFObject *userRow2;
            
            if ([userArray2 count] < 1) {
                // add user to Points table
                PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
                [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
                [entry setObject:referrer forKey:@"username"];
                [entry setObject:vendorNameString forKey:@"vendorname"];
                [entry save];
                userRow2 = entry;
            } else {
                userRow2 = [userArray2 objectAtIndex:0];
            }
            
            
            NSNumber *points2 = [userRow2 objectForKey:@"points"];
            if ([points2 intValue] == 9) {
                points2 = [NSNumber numberWithInt:0];
            } else {
                points2 = [NSNumber numberWithInt:([points2 intValue] + 1 )];
            }
            
            [userRow2 setObject:points2 forKey:@"points"];
            [userRow2 save];
        }
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
 vendorNameString = nil;
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

-(void)setFromReferralDetail:(bool)aBool {
    fromReferralDetail = aBool;
}
-(bool)fromReferralDetail {
    return fromReferralDetail;
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
