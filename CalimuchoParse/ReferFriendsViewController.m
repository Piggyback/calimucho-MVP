//
//  ReferFriendsViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReferFriendsViewController.h"
#import "Parse/Parse.h"
#import "Friend.h"

@implementation ReferFriendsViewController

@synthesize friends;
@synthesize myEmail;
@synthesize vendor;
@synthesize friendsToRefer;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (myEmail == nil) {
            myEmail = [[PFUser currentUser] username];
            friends = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)referButton:(id)sender {
    for (int i = 0; i < [friends count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [self addReferral:cell.textLabel.text];
        }
    }
}

- (void)getFriendData {
    // fetch friends from parse and add to Friend class array
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"uid1" equalTo:myEmail];
    NSError *e;
    NSArray* objects = [query findObjects:&e];
    if (!e) {
        for (int i = 0; i < objects.count; i++) {
            Friend *friend = [[Friend alloc] init];
            PFObject *friendRow = [objects objectAtIndex:i];
            friend.email = [friendRow objectForKey:@"uid2"];
            [friends addObject:friend];
        }
    }
    else {
        NSLog(@"Error occurred in fetching friend data");
    }
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Friends"];
    [query2 whereKey:@"uid2" equalTo:myEmail];
    NSError *e2;
    objects = [query2 findObjects:&e2];
    if (!e2) {
        for (int i = 0; i < objects.count; i++) {
            Friend *friend = [[Friend alloc] init];
            PFObject *friendRow = [objects objectAtIndex:i];
            friend.email = [friendRow objectForKey:@"uid1"];
            [friends addObject:friend];
        }
    }
    else {
        NSLog(@"Error occurred in fetching friend data");
    }
    
}

- (void) addReferral:(NSString*)referredTo {
    PFQuery *query = [PFQuery queryWithClassName:@"Referrals"];
    [query whereKey:@"referred" equalTo:referredTo];
    [query whereKey:@"vendorName" equalTo:vendor.name];
    
    if ([query countObjects] == 0) {
        // if nobody referred that person to this place yet
        PFObject *newR = [[PFObject alloc] initWithClassName:@"Referrals"];
        [newR setObject:referredTo forKey:@"referred"];
        [newR setObject:[NSNumber numberWithInt:vendor.vid] forKey:@"vid"];
        [newR setObject:vendor.name forKey:@"vendorName"];
        NSMutableArray* rArray = [[NSMutableArray alloc] initWithObjects:myEmail,nil];
        NSNumber *num = [NSNumber numberWithInt:[rArray count]];
        [newR setObject:rArray forKey:@"referredBy"];
        [newR setObject:num forKey:@"numReferrals"];
        [newR saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"referral added: you were first to refer!");
            } else {
                NSLog(@"referral could not be added");
            }
        }];
    }
    else {
        // if referrals to this place already exist
        NSError *e;
        NSArray* objects = [query findObjects:&e];
        if (!e) {
            PFObject *existingReferrals = [objects objectAtIndex:0];
            NSMutableArray* existingReferrers = [existingReferrals objectForKey:@"referredBy"];
            if (![existingReferrers containsObject:myEmail]) {
                [existingReferrers addObject:myEmail];
                NSNumber *newNum = [NSNumber numberWithInt:[existingReferrers count]];
                
                [existingReferrals setObject:existingReferrers forKey:@"referredBy"];
                [existingReferrals setObject:newNum forKey:@"numReferrals"];
                [existingReferrals saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"referral added: you were not first to refer!");
                    } else {
                        NSLog(@"referral could not be added");
                    }
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Add Referral" message:@"You have already referred this person to this place" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            NSLog(@"Error occurred in fetching referral data");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getFriendData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferFriendCell"];
    Friend *friend = [self.friends objectAtIndex:indexPath.row];
	cell.textLabel.text = friend.email;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if(footerView == nil) {
//        footerView  = [[UIView alloc] init];
//
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button setFrame:CGRectMake(10, 3, 300, 200)];
//
//        [button setTitle:@"Refer!" forState:UIControlStateNormal];
//
//        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//        [button addTarget:self action:@selector(deleteThing:) forControlEvents:UIControlEventTouchUpInside];
//
//        [footerView addSubview:button];
//        tableView.tableFooterView = footerView;
//    }
//    return footerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 200;
//}

@end
