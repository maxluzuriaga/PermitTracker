//
//  PTEntry.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/10/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTEntry.h"

@implementation PTEntry

@synthesize date = _date, minutes = _minutes, night = _night, badWeather = _badWeather;

#define kDateKey @"Date"
#define kMinutesKey @"Minutes"
#define kNightKey @"Night"
#define kBadWeatherKey @"BadWeather"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_date forKey:kDateKey];
    [aCoder encodeInteger:_minutes forKey:kMinutesKey];
    [aCoder encodeBool:_night forKey:kNightKey];
    [aCoder encodeBool:_badWeather forKey:kBadWeatherKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.date = (NSDate *)[aDecoder decodeObjectForKey:kDateKey];
    self.minutes = [aDecoder decodeIntegerForKey:kMinutesKey];
    self.night = [aDecoder decodeBoolForKey:kNightKey];
    self.badWeather = [aDecoder decodeBoolForKey:kBadWeatherKey];
    
    return self;
}

@end
