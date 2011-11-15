//
//  QRReaderViewController.h
//  CalimuchoParse
//
//  Created by Michael Gao on 11/8/11.
//  Copyright (c) 2011 Piggyback. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "Vendor.h"

@interface QRReaderViewController : UIViewController <ZXingDelegate> {
    IBOutlet UITextView *resultsView;
    NSString *resultsToDisplay;
    Vendor *vendor;
}

@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;
@property (nonatomic, strong) Vendor *vendor;

- (IBAction)scanPressed:(id)sender;
- (void)getVendorData:(NSString*) vendorName;
@end