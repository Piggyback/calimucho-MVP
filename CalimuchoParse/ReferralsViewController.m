//
//  ReferralsViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReferralsViewController.h"
#import "Parse/Parse.h"
#import "Referral.h"
#import "CMAppDelegate.h"
#import "ReferralDetailViewController.h"

@implementation ReferralsViewController {
    NSUInteger selectedIndex;
}

@synthesize referrals;
@synthesize myEmail;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initwithcoder for referral view controller");
        referrals = [[NSMutableArray alloc] init];
        myEmail = [[NSString alloc] init];
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"refDetailSegue"]) {
        ReferralDetailViewController *rvc = [segue destinationViewController];
        rvc.referral = [referrals objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    }
}

- (void) addReferral {
    PFObject *newR = [[PFObject alloc] initWithClassName:@"Referrals"];
    [newR setObject:myEmail forKey:@"referred"];
    [newR setObject:[NSNumber numberWithInt:2] forKey:@"vid"];
    [newR setObject:@"Standard Cafe" forKey:@"vendorName"];
    NSMutableArray* rArray = [NSMutableArray arrayWithObjects:@"chloesiu@gmail.com",@"jeffkuo@gmail.com",nil];
    NSNumber *num = [NSNumber numberWithInt:[rArray count]];
    [newR setObject:rArray forKey:@"referredBy"];
    [newR setObject:num forKey:@"numReferrals"];
    [newR saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"referral added");
        } else {
            NSLog(@"referral could notb e added");
        }
    }];
}

- (void) getReferralData {
    PFQuery *query = [PFQuery queryWithClassName:@"Referrals"];
    [query whereKey:@"referred" equalTo:myEmail];
    [query orderByDescending:@"numReferrals"];
    NSError *e;
    NSArray* objects = [query findObjects:&e];
    if (!e) {
        referrals = [NSMutableArray arrayWithCapacity:objects.count];
        for (int i = 0; i < objects.count; i++) {
            Referral *r = [[Referral alloc] init];
            PFObject *referralRow = [objects objectAtIndex:i];
            r.referredBy = [referralRow objectForKey:@"referredBy"];
            r.vid = [[referralRow objectForKey:@"vid"] intValue];
            r.vendorName = [referralRow objectForKey:@"vendorName"];
            r.numReferrals = [[referralRow objectForKey:@"numReferrals"] intValue];
            [referrals addObject:r];
        }
    }
    else {
        NSLog(@"Error occurred in fetching referral data");
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    myEmail = appDelegate.myEmail;
    
    //[self addReferral];
    [self getReferralData];
    
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
    // Return the number of rows in the section.
    return [referrals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferralCell"];
	Referral *r = [self.referrals objectAtIndex:indexPath.row];
	cell.textLabel.text = r.vendorName;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Referred by %d friends",r.numReferrals];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
