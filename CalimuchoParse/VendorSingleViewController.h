//
//  VendorSingleViewController.h
//  CalimuchoParse
//
//  Created by Michael Gao on 11/11/11.
//  Copyright (c) 2011 UCLA. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Vendor.h"

@interface VendorSingleViewController : UIViewController {
    IBOutlet UILabel *vendorNameLabel;
    Vendor* vendor;
    //NSString *vendorNameString;
    IBOutlet UIProgressView *pointsProgressBar;
    IBOutlet UILabel *juiceStatus;
    
    NSString *myEmail;
    bool fromQRreader;
    
//    int kim;
//    int fakeKim;
//    int blah;
}

//- (int)kim;
//- (int)fakeKim;
//- (void)setKim:(int)temp;
//- (void)setFakeKim:(int)temp;

@property (nonatomic, retain) IBOutlet UILabel *vendorNameLabel;
@property (nonatomic, retain) Vendor *vendor;
@property (nonatomic, retain) IBOutlet UIProgressView *pointsProgressBar;
@property (nonatomic, retain) IBOutlet UILabel *juiceStatus;
@property (nonatomic, retain) NSString *myEmail;


// override initWithCoder to display log message (default init for storyboard)
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)setFromQRreader:(bool)aBool;
-(bool)fromQRreader;

@end
