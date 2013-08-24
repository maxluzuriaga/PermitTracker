//
//  PTAlertView.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/21/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTAlertView.h"

#import <QuartzCore/QuartzCore.h>

#define kIndex @"IndexKey"
#define kTitle @"TitleKey"
#define kCompletion @"CompletionKey"

@interface PTAlertView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *popupView;
@property (nonatomic, strong) CAGradientLayer *popupGradientBackground;
@property (nonatomic, strong) NSMutableArray *buttons;

- (CGRect)calculatedFrameForPopup;
- (void)buttonTapped:(id)sender;
- (void)dismiss;

@end

@implementation PTAlertView

@synthesize backgroundImageView = _backgroundImageView, popupView = _popupView, popupGradientBackground = _popupGradientBackground, buttons = _buttons;

- (id)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertViewBigShadow"]];
        
        _popupView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popupBackgroundImage"] stretchableImageWithLeftCapWidth:18 topCapHeight:18]];
        
        _popupGradientBackground = [[CAGradientLayer alloc] init];
        
        CGColorRef whiteColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.5] CGColor];
        CGColorRef clearColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.0] CGColor];
        
        _popupGradientBackground.colors = @[   (__bridge id)(whiteColor),
                                    (__bridge id)(clearColor) ];
        _popupGradientBackground.cornerRadius = 4;
        
        _buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addButtonAtIndex:(NSInteger)index withTitle:(NSString *)title completion:(void (^)(void))completion
{
    NSDictionary *dict = @{ kTitle : title, kCompletion : completion, kIndex : [NSNumber numberWithInteger:index] };
    
    [_buttons addObject:dict];
}

- (void)show
{
    if ([_buttons count] == 0)
        return;
    
    self.frame = CGRectMake(0, 0, 320, 480);
    
    _backgroundImageView.frame = self.frame;
    
    [self addSubview:_backgroundImageView];
    
    _popupView.frame = [self calculatedFrameForPopup];
    
    _popupGradientBackground.frame = CGRectMake(13, 13, _popupView.frame.size.width - 28, _popupView.frame.size.height - 26);
    
    [_popupView.layer addSublayer:_popupGradientBackground];
    
    NSArray *sortedButtons = [_buttons sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        return [(NSNumber *)[a objectForKey:kIndex] compare:(NSNumber *)[b objectForKey:kIndex]];
    }];
    
    UIFont *buttonFont = [UIFont fontWithName:kBoldFont size:21];
    
    NSInteger buttonsAdded = 0;
    for (NSDictionary *dict in sortedButtons) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:(NSString *)[dict objectForKey:kTitle] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[[UIImage imageNamed:@"alertViewButtonBackground"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
        
        button.titleLabel.font = buttonFont;
        button.frame = CGRectMake(20, 20 + (52 * buttonsAdded), 260, 44);
        button.tag = [[dict objectForKey:kIndex] integerValue];
        
        [_popupView addSubview:button];
        
        buttonsAdded++;
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alertViewCancelButtonBackground"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
    
    cancelButton.titleLabel.font = buttonFont;
    cancelButton.frame = CGRectMake(20, 20 + (52 * buttonsAdded) + 16, 260, 44);
    
    [_popupView addSubview:cancelButton];
    
    _popupView.userInteractionEnabled = YES;
    
    [self addSubview:_popupView];
    
    _backgroundImageView.alpha = 0.0;
    _popupView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    _popupView.alpha = 0.0;
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
    
    [UIView animateWithDuration:0.17 animations:^(void) {
        _backgroundImageView.alpha = 1.0;
        _popupView.alpha = 1.0;
        _popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^(void) {
            _popupView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^(void) {
                _popupView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
}

- (void)buttonTapped:(id)sender
{
    NSInteger index = [(UIView *)sender tag];
    
    NSDictionary *buttonInfo;
    
    for (NSDictionary *dict in _buttons) {
        if ([[dict objectForKey:kIndex] integerValue] == index) {
            buttonInfo = dict;
            break;
        }
    }
    
    if (buttonInfo) {
        void (^completion)(void) = [buttonInfo objectForKey:kCompletion];
        
        dispatch_async(dispatch_get_main_queue(), completion);
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        _backgroundImageView.alpha = 0.0;
        _popupView.frame = CGRectMake(_popupView.frame.origin.x, self.frame.size.height + 100, _popupView.frame.size.width, _popupView.frame.size.height);
        _popupView.transform = CGAffineTransformMakeRotation(M_PI/4);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGRect)calculatedFrameForPopup
{
    NSInteger numberOfButtons = [_buttons count] + 1;
    NSInteger spacing = 8;
    
    
    CGFloat width = 300;
    CGFloat height = 12 + (numberOfButtons * 44) + (numberOfButtons * spacing) + (spacing * 3) + 12;
    
    CGFloat x = (320/2) - (width/2);
    CGFloat y = (480/2) - (height/2);
    
    return CGRectMake(x, y, width, height);
}

@end
