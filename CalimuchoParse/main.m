//
//  main.m
//  CalimuchoParse
//
//  Created by Kimberly Hsiao on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMAppDelegate.h"
#import "Parse/Parse.h"

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"efWU0grTuEZB5H8hzzNhPczvAXcPgyqrV58Dln2I" 
                  clientKey:@"Dqp44qTa6Qo0flNiahAhWHM4DEokD22MAHlzNyWY"];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CMAppDelegate class]));
    }
}
