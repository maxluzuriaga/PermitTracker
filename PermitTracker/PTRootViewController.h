//
//  PTRootViewController.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/5/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTRootViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UILabel *_totalCompletedLabel;
    UILabel *_totalRequiredLabel;
    UILabel *_totalPercentageLabel;
    
    UILabel *_nightCompletedLabel;
    UILabel *_nightRequiredLabel;
    UILabel *_nightPercentageLabel;
    
    UILabel *_weatherCompletedLabel;
    UILabel *_weatherRequiredLabel;
    UILabel *_weatherPercentageLabel;
}

- (void)updateUI;
- (void)addEntry;
- (void)flipView;

+ (NSString *)formattedStringForMinutes:(NSInteger)minutes;
+ (UIColor *)colorForPercentage:(float)percent;

@end
