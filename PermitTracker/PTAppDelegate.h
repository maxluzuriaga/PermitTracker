//
//  PTAppDelegate.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/5/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PTRootViewController.h"

@class PTLog;

@interface PTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PTRootViewController *rootViewController;

@property (strong, nonatomic) PTLog *log;
@property (strong, nonatomic) NSMetadataQuery *query;

- (void)queryDidFinish:(NSNotification *)notification;

- (NSURL *)applicationDocumentsDirectory;
- (void)loadInitalData;

- (void)countTime;

@end
