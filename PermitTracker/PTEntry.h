//
//  PTEntry.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/10/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTEntry : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) BOOL night;
@property (nonatomic) BOOL badWeather;

@end
