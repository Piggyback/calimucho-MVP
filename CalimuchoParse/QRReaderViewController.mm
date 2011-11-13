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
#import "TestViewController.h"

@interface QRReaderViewController()
@end

@implementation QRReaderViewController
@synthesize resultsView;
@synthesize resultsToDisplay;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    self.resultsToDisplay = result;
    
    // validate qr code with vendor table through parse
//    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
//    [query whereKey:@"name" equalTo:resultsToDisplay];
//    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
//        if (!error) {
//            // The count request succeeded. Log the count
//            NSLog(@"Count request succeeded");
//            
//            if (self.isViewLoaded) {
//                if (count == 1) {
//                    TestViewController *tc = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
//                    [tc setVendorName:result];
//                }
//            }
//            [self dismissModalViewControllerAnimated:NO];
//        } else {
//            // The request failed
//            NSLog(@"Count request FAILED!");
//        }
//    }];
    NSString *s = @"hello";
    TestViewController *tc = [self.storyboard instantiateViewControllerWithIdentifier:@"test"];
    [tc setVendorName:s];
    
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
