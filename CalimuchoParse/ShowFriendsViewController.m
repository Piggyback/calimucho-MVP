//
//  ShowFriendsViewController.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowFriendsViewController.h"
#import "Parse/Parse.h"
#import "Friend.h"
#import "VendorViewController.h"
#import "CMAppDelegate.h"

@implementation ShowFriendsViewController

@synthesize friends;
@synthesize myEmail;
@synthesize n;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (myEmail == nil) {
            NSLog(@"init with coder for showfriendsviewcontroller");
            condition = [[NSLock alloc] init];
            CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
            myEmail = appDelegate.myEmail;
            friends = [[NSMutableArray alloc] init];
        }
    }
    return self;
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // custom initialization
        NSLog(@"initwithstyle");
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
    
    [self getFriendData];
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"displaying friends table");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    Friend *friend = [self.friends objectAtIndex:indexPath.row];
	cell.textLabel.text = friend.email;
    cell.detailTextLabel.text = friend.email;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
