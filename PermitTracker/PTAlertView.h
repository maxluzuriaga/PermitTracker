//
//  PTAlertView.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/21/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTAlertView : UIView

- (void)addButtonAtIndex:(NSInteger)index withTitle:(NSString *)title completion:(void (^)(void))completion;
- (void)show;

@end
