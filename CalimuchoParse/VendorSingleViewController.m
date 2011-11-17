//
//  VendorSingleViewController.m
//  CalimuchoParse
//
//  Created by Michael Gao on 11/11/11.
//  Copyright (c) 2011 UCLA. All rights reserved.
//

// **************************************************************************************
// DONE: User rankings on VerndorSingle page
// TODO: Create tier of users
// **************************************************************************************

#import "VendorSingleViewController.h"
#import "CMAppDelegate.h"
#import "ReferFriendsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation VendorSingleViewController

@synthesize vendorNameLabel;
@synthesize pointsProgressBar;
@synthesize juiceStatus;
@synthesize myEmail;
@synthesize vendor;
@synthesize referrer;
@synthesize leaderboardArray;

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
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, 322, 320, 45)];
    //redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 200, 22)];
    redeemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    redeemButton.frame = CGRectMake(60,5,200,45);
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // check if user is in Points table
    PFQuery *query = [PFQuery queryWithClassName:@"Points"];
    [query whereKey:@"username" equalTo:myEmail];
    [query whereKey:@"vendorname" equalTo:vendor.name];
    NSArray* userArray = [query findObjects];
    PFObject *userRow;
    
    if ([userArray count] < 1) {
        // add user to Points table
        PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
        [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
        [entry setObject:myEmail forKey:@"username"];
        [entry setObject:vendor.name forKey:@"vendorname"];
        [entry save];
        userRow = entry;
    } else {
        userRow = [userArray objectAtIndex:0];
    }
    
    NSLog(@"Successfully retrieved user:%@ at:%@", [userRow objectForKey:@"username"], [userRow objectForKey:@"vendorname"]);
    
    NSNumber *freebies = [userRow objectForKey:@"freebies"];
    if ([freebies intValue] > 0) {
//        footer = [[UIView alloc] initWithFrame:CGRectMake(0, 322, 400, 45)];
        //        footer.backgroundColor = [UIColor blackColor];
        footer.tag = 1;
        [footer setBackgroundColor:[UIColor grayColor]];
//        redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 200, 22)];
        NSString *redeemButtonTitle = [NSString stringWithFormat:@"Redeem freebie! (%i left)", [freebies intValue]];
        [redeemButton setTitle:redeemButtonTitle forState:UIControlStateNormal];
        [redeemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [redeemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [redeemButton addTarget:self action:@selector(redeemPressed:) forControlEvents:UIControlEventTouchUpInside];
        //        redeemButton.backgroundColor = [UIColor whiteColor];
        NSLog(@"Subview count: %i", [[footer subviews] count]);
        for(UIView *subview in [footer subviews]) {
            NSLog(@"ATTEMPTING TO REMOVE FOOTER SUBVIEWS");
            [subview removeFromSuperview];
        }
        [footer addSubview:redeemButton];
        [self.view addSubview:footer];
        NSLog(@"Footer added for freebie redemption: %i left", [freebies intValue]);
    } else {
        [footer removeFromSuperview];
    }

}


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
    NSArray* userArray = [query findObjects];
    PFObject *userRow;
    
    if ([userArray count] < 1) {
        // add user to Points table
        PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
        [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
        [entry setObject:myEmail forKey:@"username"];
        [entry setObject:vendor.name forKey:@"vendorname"];
        [entry save];
        userRow = entry;
    } else {
        userRow = [userArray objectAtIndex:0];
    }
    
    NSLog(@"Successfully retrieved user:%@ at:%@", [userRow objectForKey:@"username"], [userRow objectForKey:@"vendorname"]);
    
    NSNumber *points = [userRow objectForKey:@"points"];
    NSNumber *freebies = [userRow objectForKey:@"freebies"];
//    if ([freebies intValue] > 0) {
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 322, 400, 45)];
////        footer.backgroundColor = [UIColor blackColor];
//        footer.tag = 1;
//        UIButton *redeemButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 200, 22)];
//        NSString *redeemButtonTitle = [NSString stringWithFormat:@"Redeem freebie! (%i left)", [freebies intValue]];
//        [redeemButton setTitle:redeemButtonTitle forState:UIControlStateNormal];
//        [redeemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [redeemButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [redeemButton addTarget:self action:@selector(redeemPressed:) forControlEvents:UIControlEventTouchUpInside];
////        redeemButton.backgroundColor = [UIColor whiteColor];
//        [footer addSubview:redeemButton];
//        [self.view addSubview:footer];
//        NSLog(@"Footer added for freebie redemption: %i left", [freebies intValue]);
//    }
    
    if (fromQRreader == TRUE) {
        points = [NSNumber numberWithInt:([points intValue] + 1)];
        // check if user gets a freebie
        if ([points intValue]%10 == 0) {
            freebies = [NSNumber numberWithInt:([freebies intValue] +1)];
            [userRow setObject:freebies forKey:@"freebies"];
        }
        // save new points back to parse
        [userRow setObject:points forKey:@"points"];
        
//        [userRow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            [NSThread sleepForTimeInterval:2.0];
//            if (!error) {
//                NSLog(@"The updated points for user was saved successfully");
//            } else {
//                NSLog(@"THE UPDATED POINTS FOR USER FAILED TO SAVE");
//            }
//        }];
        [userRow save];
        float pointsFloat = [points intValue]%10;
        [pointsProgressBar setProgress:pointsFloat/10.0];
        juiceStatus.text = [NSString stringWithFormat:@"%i more piggybacks to a freebie!", (10-([points intValue]%10))];
        
        // check if user was referred by a friend
        if (fromReferralDetail == TRUE) {
            // check if friend is in points table
            PFQuery *query2 = [PFQuery queryWithClassName:@"Points"];
            [query2 whereKey:@"username" equalTo:referrer];
            [query2 whereKey:@"vendorname" equalTo:vendor.name];
//            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    // The find succeeded.
//                    NSLog(@"Successfully retrieved %d friends.", objects.count);
//                    PFObject *userRow2;
//                    
//                    if ([objects count] < 1) {
//                        // add user to Points table
//                        PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
//                        [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
//                        [entry setObject:referrer forKey:@"username"];
//                        [entry setObject:vendor.name forKey:@"vendorname"];
//                        [entry save];
//                        userRow2 = entry;
//                    } else {
//                        userRow2 = [objects objectAtIndex:0];
//                    }
//                    
//                    NSNumber *points2 = [userRow2 objectForKey:@"points"];
//                    points2 = [NSNumber numberWithInt:([points2 intValue] + 1 )];
//                    
//                    [userRow2 setObject:points2 forKey:@"points"];
////                    [userRow2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////                        [NSThread sleepForTimeInterval:1.0];
////                        if (!error) {
////                            NSLog(@"The updated points for friend was saved successfully");
////                        } else {
////                            NSLog(@"THE UPDATED POINTS FOR FRIEND FAILED TO SAVE");
////                        }
////                    }];
//                    [userRow2 save];
//
//                } else {
//                    // Log details of the failure
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
            
            
            
            NSArray* friendArray = [query2 findObjects];
            PFObject *userRow2;
            
            if ([friendArray count] < 1) {
                // add user to Points table
                PFObject *entry = [[PFObject alloc] initWithClassName:@"Points"];
                [entry setObject:[NSNumber numberWithInt:0] forKey:@"points"];
                [entry setObject:referrer forKey:@"username"];
                [entry setObject:vendor.name forKey:@"vendorname"];
                [entry save];
                userRow2 = entry;
            } else {
                userRow2 = [friendArray objectAtIndex:0];
            }
            
            NSNumber *points2 = [userRow2 objectForKey:@"points"];
            points2 = [NSNumber numberWithInt:([points2 intValue] + 1 )];
            
            // check if friend gets a freebie
            if ([points2 intValue]%10 == 0) {
                NSNumber *freebies2 = [userRow2 objectForKey:@"freebies"];
                freebies2 = [NSNumber numberWithInt:([freebies intValue] +1)];
                [userRow2 setObject:freebies2 forKey:@"freebies"];
            }
            
            [userRow2 setObject:points2 forKey:@"points"];
            [userRow2 save];

        }
    } else {
        float pointsFloat = [points intValue]%10;
        [pointsProgressBar setProgress:pointsFloat/10.0];
        juiceStatus.text = [NSString stringWithFormat:@"%i more piggybacks to a freebie!", (10-([points intValue]%10))];
    }
    
    // display leaderboard
    // TODO: Optimize query calls by calling one query to retrieve all users per vendor in one call
    
    // draw border
    leaderboard.layer.borderWidth = 2.0f;
    leaderboard.layer.borderColor = [[UIColor blackColor] CGColor];
    
    PFQuery *queryLeaderboard = [PFQuery queryWithClassName:@"Points"];
    [queryLeaderboard whereKey:@"vendorname" equalTo:vendor.name];
    [queryLeaderboard orderByDescending:@"points"];
    leaderboardArray = [queryLeaderboard findObjects];
    NSLog(@"leaderboardArray count inside viewDidLoad: %i", [leaderboardArray count]);
    
//    [leaderboard numberOfRowsInSection:[leaderboardArray count]];
    
}


- (void)viewDidUnload {
     vendorNameLabel = nil;
     //vendorNameString = nil;
    // pointsProgressBar = nil;
    // juiceStatus = nil;
    // myEmail = nil;
    leaderboard = nil;
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

// UITableViewDataSource required methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userLeaderboard"];
    cell.textLabel.text = [[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    
    // TODO: Must optmize this hack
    // Hack: Add +1 point to user and/or friend if scan/referral    
//    if (fromQRreader && [cell.textLabel.text isEqualToString:myEmail]) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"points"] intValue]+1];
//    } 
//    
//    else if (fromReferralDetail && [cell.textLabel.text isEqualToString:referrer]) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"points"] intValue]+1];
//    }
//    
//    else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"points"] intValue]];
//    }
    // add MVP icon to top leader
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"pig_nose5.png"];
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"leaderboardArray count in numberOfRowsInSection: %i", [leaderboardArray count]);
    return [leaderboardArray count];
}

// Freebie redemption slider
- (IBAction)redeemPressed:(id)sender {
    NSLog(@"User successfully clicked redeem freebie button");
    // check if user is in Points table
    PFQuery *query = [PFQuery queryWithClassName:@"Points"];
    [query whereKey:@"username" equalTo:myEmail];
    [query whereKey:@"vendorname" equalTo:vendor.name];
    NSArray* userArray = [query findObjects];
    PFObject *userRow;

    userRow = [userArray objectAtIndex:0];
    
    NSNumber *freebies = [userRow objectForKey:@"freebies"];
    freebies = [NSNumber numberWithInt:([freebies intValue]-1)];
    
    [userRow setObject:freebies forKey:@"freebies"];
    [userRow save];
    
    RedeemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"redeemView"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
