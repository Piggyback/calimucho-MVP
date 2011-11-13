//
//  TestViewController.h
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UITableViewController {
    NSString *vendorName;
    NSString *fakeVendorName;
}

@property (nonatomic, retain) NSString *vendorName;
@property (nonatomic, retain) NSString *fakeVendorName;

@end
