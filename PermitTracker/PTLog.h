//
//  PTLog.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/10/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTLog : UIDocument

@property (strong, nonatomic) NSMutableArray *entries;

- (void)addEntries:(NSSet *)objects;
- (void)removeEntries:(NSSet *)objects;

@end
