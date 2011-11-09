//
//  QRReaderViewController.h
//  CalimuchoParse
//
//  Created by Michael Gao on 11/8/11.
//  Copyright (c) 2011 Piggyback. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@interface QRReaderViewController : UIViewController <ZXingDelegate> {
    IBOutlet UITextView *resultsView;
    NSString *resultsToDisplay;
}

@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;


- (IBAction)scanPressed:(id)sender;
@end