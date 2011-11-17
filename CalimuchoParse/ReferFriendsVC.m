//
//  ReferFriendsVC.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReferFriendsVC.h"
#import "Parse/Parse.h"
#import "Friend.h"

@implementation ReferFriendsVC

@synthesize friends;
@synthesize myEmail;
@synthesize vendor;
@synthesize tableData;
@synthesize rowCheckArray;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (myEmail == nil) {
            myEmail = [[PFUser currentUser] username];
            friends = [[NSMutableArray alloc] init];
            tableData = [[NSMutableArray alloc] init];
            rowCheckArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)referButton:(id)sender {
    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
    for (int i = 0; i < [rowCheckArray count]; i++) {
        if ([[rowCheckArray objectAtIndex:i] boolValue]) {
            [self addReferral:[unreferredFriendsArr objectAtIndex:i]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) setReferredFriends {
    NSMutableArray *referredFriendsArr = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Referrals"];
    [query whereKey:@"vendorName" equalTo:vendor.name];
    NSError *e;
    NSArray* objects = [query findObjects:&e];
    if (!e) {
        for (int i = 0; i < [objects count]; i++) {
            // if i have already referred to this person, add them to the 'already referred list'
            PFObject *p = [objects objectAtIndex:i];
            if ([[p objectForKey:@"referredBy"] containsObject:myEmail]) {
                NSString *friend = [[NSString alloc] init];
                friend = [p objectForKey:@"referred"];
                [referredFriendsArr addObject:friend];
            }
        }
    }
    else {
        NSLog(@"Error occurred in fetching referral data");
    }
    
    NSDictionary *referredFriendsDict = [NSDictionary dictionaryWithObject:referredFriendsArr forKey:@"Friends"];
    [tableData addObject:referredFriendsDict];
}

- (void) setNotReferredFriends {
    NSMutableArray *notReferredFriendsArr = [[NSMutableArray alloc] init];
    
    NSDictionary *referredFriendsDict = [tableData objectAtIndex:0];
    NSArray *referredFriendsArr = [referredFriendsDict objectForKey:@"Friends"];
    
    for (int i = 0; i < [friends count]; i++) {
        NSString* friend = [[friends objectAtIndex:i] email];
        if (![referredFriendsArr containsObject:friend]) {
            [notReferredFriendsArr addObject:[[friends objectAtIndex:i] email]];
        }
    }
    
    NSDictionary *notReferredFriendsDict = [NSDictionary dictionaryWithObject:notReferredFriendsArr forKey:@"Friends"];
    [tableData insertObject:notReferredFriendsDict atIndex:0];
}

- (void)initCheckArray {
    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
    for (int i = 0; i < [unreferredFriendsArr count]; i++) {
        [rowCheckArray addObject:[NSNumber numberWithBool:NO]];
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
     
     self.title = vendor.name;
     
     [self getFriendData];
     [self setReferredFriends];
     [self setNotReferredFriends];
     [self initCheckArray];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    NSDictionary *dictionary = [tableData objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Friends"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferFriendCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReferFriendCell"];
    }
    
    NSDictionary *dictionary = [tableData objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Friends"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    if ([indexPath section] == 0) {
        if ([[rowCheckArray objectAtIndex:indexPath.row] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if ([indexPath section] == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Select Friends To Refer";
    else
        return @"Friends You've Referred";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        [rowCheckArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![[rowCheckArray objectAtIndex:indexPath.row] boolValue]]];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
    
    // if you have no unreferred friends, then say so
    if ([unreferredFriendsArr count] == 0 && section == 0) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 40.0)];
        
        UILabel *footerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        footerText.text = @"You have referred all of your friends!";
        footerText.lineBreakMode = UILineBreakModeWordWrap;
        footerText.font = [UIFont boldSystemFontOfSize:16];
        footerText.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [footerText sizeToFit];
        
        [v addSubview:footerText];
        
        return v;
    }   
    else 
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
    
    if ([unreferredFriendsArr count] == 0 && section == 0)
        return 40;
    else
        return 0;
}

@end
