//
//  QRReaderViewController.m
//  CalimuchoParse
//
//  Created by Michael Gao on 11/8/11.
//  Copyright (c) 2011 Piggyback. All rights reserved.
//

#import "QRReaderViewController.h"
#import "QRCodeReader.h"
#import "Parse/Parse.h"
#import "VendorSingleViewController.h"
#import "Vendor.h"

@interface QRReaderViewController()
@end

@implementation QRReaderViewController
@synthesize resultsView;
@synthesize resultsToDisplay;
@synthesize vendor;
@synthesize referrer;

- (id)initWithCoder:(NSCoder *)inCoder
{
    self = [super initWithCoder:inCoder];
    fromReferralDetail = false;
    referrer = nil;
    NSLog(@"initWithCoder for VendorSingleViewController");
    
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
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
//    VendorSingleViewController *vc = [[VendorSingleViewController alloc] init];
//    // set vc's (unlinked to storyboard) string instance variable to QR code result
//    //                    [vc setVendorName:result];
//    vc.kim = 10;
//    Vendor *v = [[Vendor alloc] init];
//    v.name = @"mgao";
}
*/


- (void)viewDidUnload
{
    resultsView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)scanPressed:(id)sender {
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader, nil];
    
    widController.readers = readers;
    
    // TODO: Add sound confirmation on scan
    
    [self presentModalViewController:widController animated:YES];
}

- (void) getVendorData:(NSString*) vendorName {
    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
    [query whereKey:@"name" equalTo:vendorName];
    NSError *e;
    NSArray* objects = [query findObjects:&e];
    if (!e) {
        vendor = [[Vendor alloc] init];
        PFObject *vendorRow = [objects objectAtIndex:0];
        vendor.vid = [[vendorRow objectForKey:@"vid"] intValue];
        vendor.name = [vendorRow objectForKey:@"name"];
        vendor.address = [vendorRow objectForKey:@"address"];
        vendor.hours = [vendorRow objectForKey:@"hours"];
        vendor.phone = [[vendorRow objectForKey:@"phone"] intValue];
    }
    else {
        NSLog(@"Error occurred in fetching vendor data");
    }

}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    self.resultsToDisplay = result;
    
    // validate qr code with vendor table through parse
    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
    [query whereKey:@"name" equalTo:resultsToDisplay];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"Count request succeeded");
            
            if (self.isViewLoaded) {
                // vendor is in the database
                if (count == 1) {
                    // create new VendorSingleView object
                    VendorSingleViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"singleVendor"];
//                    VendorSingleViewController *vc = [[VendorSingleViewController alloc] init];
                    // set vc's (unlinked to storyboard) string instance variable to QR code result
                    [self getVendorData:result];
                    [vc setVendor:vendor];
                    [vc setFromQRreader:TRUE];
                    if (fromReferralDetail == TRUE) {
                        [vc setFromReferralDetail:TRUE];
                        [vc setReferrer:referrer];
                    }
//                    vc.kim = 10;
//                    Vendor *v = [[Vendor alloc] init];
//                    v.name = @"mgao";
                    // dismiss the QR reader view
                    // bring up the view of the vc object
                    [self.navigationController pushViewController:vc animated:NO];
                    [self dismissModalViewControllerAnimated:NO];
//                    [self presentViewController:vc animated:NO completion:nil];
                } else {
                    // display message in previous view
                    [resultsView setText:[NSString stringWithFormat:@"%@ is NOT in the database", resultsToDisplay]];
                    [self dismissModalViewControllerAnimated:NO];
                }
            }
        } else {
            // The request failed
            NSLog(@"Count request FAILED!");
        }
    }];
    
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setFromReferralDetail:(bool)aBool {
    fromReferralDetail = aBool;
}
-(bool)fromReferralDetail {
    return fromReferralDetail;
}

@end
