//
//  CMAppDelegate.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CMAppDelegate.h"
#import "Parse/Parse.h"
#import "Vendor.h"
#import "VendorViewController.h"

@implementation CMAppDelegate

@synthesize vendors;
@synthesize myEmail;
@synthesize window = _window;

- (void)getVendorData {
    // fetch vendors from parse and add to Vendor class array
    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {            
            vendors = [NSMutableArray arrayWithCapacity:objects.count];
            for (int i = 0; i < objects.count; i++) {
                Vendor *vendor = [[Vendor alloc] init];
                PFObject *vendorRow = [objects objectAtIndex:i];
                vendor.vid = [[vendorRow objectForKey:@"vid"] intValue];
                vendor.name = [vendorRow objectForKey:@"name"];
                vendor.address = [vendorRow objectForKey:@"address"];
                vendor.hours = [vendorRow objectForKey:@"hours"];
                vendor.phone = [[vendorRow objectForKey:@"phone"] intValue];
                [vendors addObject:vendor];
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self getVendorData];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
