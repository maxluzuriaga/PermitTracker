//
//  PTLog.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/10/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTLog.h"
#import "PTEntry.h"

@implementation PTLog

@synthesize entries = _entries;

- (id)initWithFileURL:(NSURL *)url
{
    if (self = [super initWithFileURL:url]) {
        
    }
    
    return self;
}

- (void)addEntries:(NSSet *)objects
{
    for (PTEntry *entry in objects) {
        [_entries addObject:entry];
    }
    
    [self.undoManager setActionName:@"Addition"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(removeEntries:) object:objects];
}

- (void)removeEntries:(NSSet *)objects
{
    for (PTEntry *entry in objects) {
        [_entries removeObject:entry];
    }

    [self.undoManager setActionName:@"Deletion"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(addEntries:) object:objects];
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:_entries];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{    
    NSData *data = (NSData *)contents;
    
    self.entries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return YES;
}

@end
