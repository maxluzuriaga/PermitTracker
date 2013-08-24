//
//  PTAppDelegate.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/5/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTAppDelegate.h"
#import "PTEntry.h"
#import "PTLog.h"

#define kFilename @"log.permitlog"

@implementation PTAppDelegate

@synthesize rootViewController = _rootViewController, log = _log, query = _query;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [TestFlight takeOff:@"0cd60b261c62e2e4d37837b888f1bd52_MjQ5MTMyMDEyLTA4LTEzIDE5OjIyOjE3Ljg0MjExMw"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _rootViewController = [[PTRootViewController alloc] init];
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        _query = [[NSMetadataQuery alloc] init];
        [_query setSearchScopes:@[ NSMetadataQueryUbiquitousDocumentsScope ]];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, kFilename];
        [_query setPredicate:pred];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinish:) name:NSMetadataQueryDidFinishGatheringNotification object:_query];
        
        [_query startQuery];
    } else {
        NSURL *url = [NSURL fileURLWithPath:[[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:kFilename]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            _log = [[PTLog alloc] initWithFileURL:url];
            
            [_log openWithCompletionHandler:^(BOOL success) {
                [self countTime];
            }];
        } else {
            _log = [[PTLog alloc] initWithFileURL:url];
            
            [_log saveToURL:[_log fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                [self loadInitalData];
            }];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    self.window.rootViewController = _rootViewController;
    
    NSInteger minutes = [[NSUserDefaults standardUserDefaults] integerForKey:@"TotalMinutes"];
    
    if ((minutes) && (minutes != 0))
        [_rootViewController updateUI];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                    UITextAttributeFont : [UIFont fontWithName:kBoldFont size:21],
                               UITextAttributeTextColor : [UIColor whiteColor],
                         UITextAttributeTextShadowColor : [[UIColor blackColor] colorWithAlphaComponent:0.2],
                        UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, -1)] }];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"barButtonBackground"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                    UITextAttributeFont : [UIFont fontWithName:kMediumFont size:16],
                               UITextAttributeTextColor : [UIColor whiteColor],
                         UITextAttributeTextShadowColor : [[UIColor blackColor] colorWithAlphaComponent:0.2],
                        UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, -1)] }
                                                forState:UIControlStateNormal];
    
    return YES;
}

- (void)queryDidFinish:(NSNotification *)notification
{
    NSMetadataQuery *query = (NSMetadataQuery *)[notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    
    if ([query resultCount] == 1) {
        NSMetadataItem *item = [query resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        
        _log = [[PTLog alloc] initWithFileURL:url];
        
        [_log openWithCompletionHandler:^(BOOL success) {
            [self countTime];
        }];
    } else {
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kFilename];
        
//        NSURL *sourceURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"log" ofType:@"permitlog"]];
//        NSURL *docsURL = [NSURL fileURLWithPath:[[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"logtemp.permitlog"] path]];
//        
//        NSError *error = nil;
//        
//        [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:docsURL error:&error];
//        
//        NSLog(@"error: %@", [error localizedDescription]);
//        
//        error = nil;
//        
//        [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:docsURL destinationURL:ubiquitousPackage error:&error];
//        
//        NSLog(@"error: %@", [error localizedDescription]);
//        
//        _log = [[PTLog alloc] initWithFileURL:ubiquitousPackage];
//        
//        [_log openWithCompletionHandler:^(BOOL success) {
//            [self countTime];
//        }];
        
        _log = [[PTLog alloc] initWithFileURL:ubiquitousPackage];
        
        [_log saveToURL:[_log fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self loadInitalData];
        }];
    }
}

- (void)loadInitalData
{
    _log.entries = [[NSMutableArray alloc] init];
    
    [_log saveToURL:[_log fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        [self countTime];
    }];
}

- (void)countTime
{
    if (_log != nil) {
        dispatch_queue_t countingQueue = dispatch_queue_create("com.maxluzuriaga.PermitTracker.documentCountingQueue", NULL);
        
        dispatch_async(countingQueue, ^{
            NSInteger totalMinutes = 0;
            NSInteger nightMinutes = 0;
            NSInteger weatherMinutes = 0;
            
            for (PTEntry *entry in _log.entries) {
                totalMinutes += entry.minutes;
                
                if (entry.night)
                    nightMinutes += entry.minutes;
                
                if (entry.badWeather)
                    weatherMinutes += entry.minutes;
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:totalMinutes forKey:@"TotalMinutes"];
            [defaults setInteger:nightMinutes forKey:@"NightMinutes"];
            [defaults setInteger:weatherMinutes forKey:@"BadWeatherMinutes"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_rootViewController updateUI];
            });
        });
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSURL URLWithString:[paths objectAtIndex:0]];
}

@end
