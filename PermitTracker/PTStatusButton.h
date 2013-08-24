//
//  PTStatusButton.h
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/6/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

typedef enum {
    PTStatusButtonTypeNight,
    PTStatusButtonTypeWeather
} PTStatusButtonType;

#import <UIKit/UIKit.h>

@interface PTStatusButton : UIControl {
    UIImageView *_imageView;
}

@property (nonatomic) BOOL active;

- (id)initWithType:(PTStatusButtonType)aType atPoint:(CGPoint)point;
- (void)setActive:(BOOL)active animated:(BOOL)animated;

@end
