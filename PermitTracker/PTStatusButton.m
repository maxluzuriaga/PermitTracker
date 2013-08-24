//
//  PTStatusButton.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/6/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTStatusButton.h"

@interface PTStatusButton ()

@property (nonatomic) PTStatusButtonType type;
@property (nonatomic, strong) UIImageView *animatingImageView;

@end

@implementation PTStatusButton

@synthesize type = _type, active = _active, animatingImageView = _animatingImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *prefix;
        switch (_type) {
            case PTStatusButtonTypeNight:
                prefix = @"night";
                break;
            
            case PTStatusButtonTypeWeather:
                prefix = @"weather";
                break;
                
            default:
                prefix = @"";
                break;
        }
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonInactive", prefix]]];
        [self addSubview:_imageView];
        
        _animatingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonActive", prefix]]];
        [self addSubview:_animatingImageView];
        
        [self addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self setActive:NO animated:NO];
    }
    return self;
}

- (id)initWithType:(PTStatusButtonType)aType atPoint:(CGPoint)point
{
    _type = aType;
    
    self = [self initWithFrame:CGRectMake(point.x, point.y, 60, 44)];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size;
    
    switch (_type) {
        case PTStatusButtonTypeNight:
            size = CGSizeMake(42, 42);
            break;
        
        case PTStatusButtonTypeWeather:
            size = CGSizeMake(36, 41);
            break;
            
        default:
            break;
    }
    
    _imageView.frame = CGRectMake((self.frame.size.width/2)-(size.width/2), (self.frame.size.height/2)-(size.height/2), size.width, size.height);
    _animatingImageView.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y - 44, _imageView.frame.size.width, _imageView.frame.size.height);
}

- (void)tapped
{
    [self setActive:!_active animated:YES];
}

- (void)setActive:(BOOL)active animated:(BOOL)animated
{
    _active = active;
    
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^() {
            CGRect toFrame;
            
            if (!active) {
                toFrame = _animatingImageView.frame;
                
                _animatingImageView.frame = CGRectMake(toFrame.origin.x, toFrame.origin.y - 44, toFrame.size.width, toFrame.size.height);
                _imageView.frame = toFrame;
                
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            } else {
                toFrame = _imageView.frame;
                
                _imageView.frame = CGRectMake(toFrame.origin.x, toFrame.origin.y + 44, toFrame.size.width, toFrame.size.height);
                _animatingImageView.frame = toFrame;
                
                self.backgroundColor = [UIColor clearColor];
            }
        }];
    } else {
        if (!active) {
            _imageView.alpha = 0.3;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } else {
            _imageView.alpha = 1.0;
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
