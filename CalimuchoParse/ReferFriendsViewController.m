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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = vendor.name;
    
    [self getFriendData];
    [self setReferredFriends];
    [self setNotReferredFriends];
    [self initCheckArray];

    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Select Friends To Refer";
    else
        return @"Friends You've Referred";
}

//- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
//    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
//    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
//    if (section == 0 && [unreferredFriendsArr count] == 0) {
//        UILabel *footerText = [[UILabel alloc] init];
//        footerText.text = @"You have already referred all of your friends!";
//        return (NSString*)footerText;
//        //return @"You have already referred all of your friends!";
//    }
//    else
//        return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        [rowCheckArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![[rowCheckArray objectAtIndex:indexPath.row] boolValue]]];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }    
    
//    if ([indexPath section] == 0) { 
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.accessoryType == UITableViewCellAccessoryNone) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
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
    
    // if you have unreferred friends, add a button for referring
    else if (section == 0) {
        if(footerView == nil) {
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 40.0)];
            
            // create the button object
            UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            b.frame = CGRectMake(70.0, 0.0, 180, 40.0);
            [b setTitle:@"Refer Friends!" forState:UIControlStateNormal];
            // this sets up the callback for when the user hits the button
            [b addTarget:self action:@selector(referButton:) forControlEvents:UIControlEventTouchUpInside];
            
            // add the button to the parent view
            [v addSubview:b];
            
            return v;
        }
    }
    
    // otherwise, you should have no footer
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary *unreferredFriendsDict = [tableData objectAtIndex:0];
    NSArray *unreferredFriendsArr = [unreferredFriendsDict objectForKey:@"Friends"];
    
    if ([unreferredFriendsArr count] == 0 && section == 0)
        return 40;
    else if (section == 0)
        return 65;
    else
        return 0;
}

@end
