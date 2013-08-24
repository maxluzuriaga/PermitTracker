//
//  PTRootViewController.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/5/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PTRootViewController.h"

#import "PTAppDelegate.h"
#import "PTStatusButton.h"
#import "PTEntriesViewController.h"
#import "PTLog.h"
#import "PTEntry.h"

@interface PTRootViewController ()

@property (strong, nonatomic) UIView *responseView;
@property (strong, nonatomic) UIView *mainResponseView;
@property (strong, nonatomic) UIView *nightResponseView;
@property (strong, nonatomic) UIView *weatherResponseView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) PTStatusButton *nightButton;
@property (strong, nonatomic) PTStatusButton *weatherButton;
@property (strong, nonatomic) UINavigationController *entriesViewController;

+ (NSString *)formattedStringForHours:(NSInteger)hours andMinutes:(NSInteger)minutes;

@end

@implementation PTRootViewController

@synthesize responseView = _responseView, mainResponseView = _mainResponseView, nightResponseView = _nightResponseView, weatherResponseView = _weatherResponseView, pickerView = _pickerView, nightButton = _nightButton, weatherButton = _weatherButton, entriesViewController = _entriesViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _entriesViewController = [[UINavigationController alloc] initWithRootViewController:[[PTEntriesViewController alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _responseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    
    // Total View
    
    _mainResponseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _mainResponseView.backgroundColor = [UIColor redColor];
    
    UIImageView *mainBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    mainBackgroundView.image = [UIImage imageNamed:@"mainResponseBackground"];
    [_mainResponseView addSubview:mainBackgroundView];
    
    _totalCompletedLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 14, 120, 45)];
    _totalCompletedLabel.font = [UIFont fontWithName:kBoldFont size:43];
    _totalCompletedLabel.textColor = [UIColor whiteColor];
    _totalCompletedLabel.backgroundColor = [UIColor clearColor];
    _totalCompletedLabel.textAlignment = NSTextAlignmentRight;
    _totalCompletedLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _totalCompletedLabel.shadowOffset = CGSizeMake(0, -1);
    _totalCompletedLabel.alpha = 0.0;
    
    [_mainResponseView addSubview:_totalCompletedLabel];
    
    _totalRequiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 44, 120, 45)];
    _totalRequiredLabel.text = @"65:00";
    _totalRequiredLabel.font = [UIFont fontWithName:kBoldFont size:43];
    _totalRequiredLabel.textColor = [UIColor whiteColor];
    _totalRequiredLabel.backgroundColor = [UIColor clearColor];
    _totalRequiredLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _totalRequiredLabel.shadowOffset = CGSizeMake(0, -1);
    _totalRequiredLabel.alpha = 0.0;
    
    [_mainResponseView addSubview:_totalRequiredLabel];
    
    _totalPercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 63, 70, 20)];
    _totalPercentageLabel.font = [UIFont fontWithName:kMediumFont size:20];
    _totalPercentageLabel.textColor = [UIColor whiteColor];
    _totalPercentageLabel.backgroundColor = [UIColor clearColor];
    _totalPercentageLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _totalPercentageLabel.shadowOffset = CGSizeMake(0, -1);
    _totalPercentageLabel.alpha = 0.0;
    
    [_mainResponseView addSubview:_totalPercentageLabel];
    
    [_responseView addSubview:_mainResponseView];
    
    // Night View
    
    _nightResponseView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
    _nightResponseView.backgroundColor = [UIColor redColor];
    
    UIImageView *nightBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    nightBackgroundView.image = [UIImage imageNamed:@"nightResponseBackground"];
    [_nightResponseView addSubview:nightBackgroundView];
    
    _nightCompletedLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 13, 70, 26)];
    _nightCompletedLabel.font = [UIFont fontWithName:kBoldFont size:24];
    _nightCompletedLabel.textColor = [UIColor whiteColor];
    _nightCompletedLabel.backgroundColor = [UIColor clearColor];
    _nightCompletedLabel.textAlignment = NSTextAlignmentRight;
    _nightCompletedLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _nightCompletedLabel.shadowOffset = CGSizeMake(0, -1);
    _nightCompletedLabel.alpha = 0.0;
    
    [_nightResponseView addSubview:_nightCompletedLabel];
    
    _nightRequiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 13, 70, 26)];
    _nightRequiredLabel.text = @"10:00";
    _nightRequiredLabel.font = [UIFont fontWithName:kBoldFont size:24];
    _nightRequiredLabel.textColor = [UIColor whiteColor];
    _nightRequiredLabel.backgroundColor = [UIColor clearColor];
    _nightRequiredLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _nightRequiredLabel.shadowOffset = CGSizeMake(0, -1);
    _nightRequiredLabel.alpha = 0.0;
    
    [_nightResponseView addSubview:_nightRequiredLabel];
    
    _nightPercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 13, 45, 26)];
    _nightPercentageLabel.font = [UIFont fontWithName:kMediumFont size:20];
    _nightPercentageLabel.textColor = [UIColor whiteColor];
    _nightPercentageLabel.backgroundColor = [UIColor clearColor];
    _nightPercentageLabel.textAlignment = NSTextAlignmentRight;
    _nightPercentageLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _nightPercentageLabel.shadowOffset = CGSizeMake(0, -1);
    _nightPercentageLabel.alpha = 0.0;
    
    [_nightResponseView addSubview:_nightPercentageLabel];
    
    [_responseView addSubview:_nightResponseView];
    
    // Weather View
    
    _weatherResponseView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 50)];
    _weatherResponseView.backgroundColor = [UIColor redColor];
    
    UIImageView *weatherBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    weatherBackgroundView.image = [UIImage imageNamed:@"badWeatherResponseBackground"];
    [_weatherResponseView addSubview:weatherBackgroundView];
    
    _weatherCompletedLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 13, 70, 26)];
    _weatherCompletedLabel.font = [UIFont fontWithName:kBoldFont size:24];
    _weatherCompletedLabel.textColor = [UIColor whiteColor];
    _weatherCompletedLabel.backgroundColor = [UIColor clearColor];
    _weatherCompletedLabel.textAlignment = NSTextAlignmentRight;
    _weatherCompletedLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _weatherCompletedLabel.shadowOffset = CGSizeMake(0, -1);
    _weatherCompletedLabel.alpha = 0.0;
    
    [_weatherResponseView addSubview:_weatherCompletedLabel];
    
    _weatherRequiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 13, 70, 26)];
    _weatherRequiredLabel.text = @"05:00";
    _weatherRequiredLabel.font = [UIFont fontWithName:kBoldFont size:24];
    _weatherRequiredLabel.textColor = [UIColor whiteColor];
    _weatherRequiredLabel.backgroundColor = [UIColor clearColor];
    _weatherRequiredLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _weatherRequiredLabel.shadowOffset = CGSizeMake(0, -1);
    _weatherRequiredLabel.alpha = 0.0;
    
    [_weatherResponseView addSubview:_weatherRequiredLabel];
    
    _weatherPercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 13, 45, 26)];
    _weatherPercentageLabel.font = [UIFont fontWithName:kMediumFont size:20];
    _weatherPercentageLabel.textColor = [UIColor whiteColor];
    _weatherPercentageLabel.backgroundColor = [UIColor clearColor];
    _weatherPercentageLabel.textAlignment = NSTextAlignmentRight;
    _weatherPercentageLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _weatherPercentageLabel.shadowOffset = CGSizeMake(0, -1);
    _weatherPercentageLabel.alpha = 0.0;
    
    [_weatherResponseView addSubview:_weatherPercentageLabel];
    
    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    flipButton.frame = CGRectMake(273, 0, 46, 46);
    flipButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 10);
    
    [flipButton addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    
    [_responseView addSubview:flipButton];
    
    UIImageView *corner = [[UIImageView alloc] initWithFrame:CGRectMake(312, 0, 8, 8)];
    corner.image = [UIImage imageNamed:@"blackCorner"];
    
    [_responseView addSubview:corner];
    
    [_responseView addSubview:_weatherResponseView];
    
    [self.view addSubview:_responseView];
    
    // Buttons
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 44)];
    buttonView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"buttonDrawerBackground"] stretchableImageWithLeftCapWidth:160 topCapHeight:0]];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(60, 0, 200, 44);
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addButtonBackground"] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:45];
    addButton.titleLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    addButton.titleLabel.layer.shadowRadius = 5;
    addButton.titleLabel.layer.shadowOffset = CGSizeZero;
    addButton.titleLabel.layer.shadowOpacity = 0.7;
    addButton.titleLabel.layer.masksToBounds = NO;
    addButton.titleLabel.textColor = [UIColor whiteColor];
    addButton.titleLabel.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(addEntry) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:addButton];
    
    _nightButton = [[PTStatusButton alloc] initWithType:PTStatusButtonTypeNight atPoint:CGPointMake(0, 0)];
    
    [buttonView addSubview:_nightButton];
    
    _weatherButton = [[PTStatusButton alloc] initWithType:PTStatusButtonTypeWeather atPoint:CGPointMake(260, 0)];
    
    [buttonView addSubview:_weatherButton];
    
    [self.view insertSubview:buttonView belowSubview:_responseView];
    
    // Picker View
    
	_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 244, 320, 216)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    [self.view addSubview:_pickerView];
    
    UIImageView *selectionIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerViewSelector"]];
    selectionIndicator.frame = CGRectMake(61, 314, 198, 81);
    
    [self.view addSubview:selectionIndicator];

//    UIView *daView = [[UIView alloc] initWithFrame:CGRectMake(0, 244, 320, 216)];
//    
//    for (int x = 0; x < 5; x++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (daView.frame.size.height / 5) * x, daView.frame.size.width, daView.frame.size.height / 5)];
//        
//        label.backgroundColor = [PTRootViewController colorForPercentage:0];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont boldSystemFontOfSize:12];
//        label.textAlignment = UITextAlignmentCenter;
//        
//        const CGFloat* components = CGColorGetComponents(label.backgroundColor.CGColor);
//        
//        label.text = [NSString stringWithFormat:@"Red: %f, Green: %f, Blue: %f", components[0], components[1], components[2]];
//        
//        [daView addSubview:label];
//    }
//    
//    [self.view addSubview:daView];
}

- (void)updateUI
{
    [UIView animateWithDuration:1.0 animations:^(){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger percentage;
        NSInteger total;
        
        float p;
        
        // Total
        
        total = [defaults integerForKey:@"TotalMinutes"];
        
        _totalCompletedLabel.text = [PTRootViewController formattedStringForMinutes:total];
        _totalCompletedLabel.alpha = 1.0;
        
        percentage = floor(((float)total/3900.0f)*100.0f);
        _totalPercentageLabel.text = [NSString stringWithFormat:@"%i%%", percentage];
        _totalPercentageLabel.alpha = 1.0;
        
        _totalRequiredLabel.alpha = 1.0;
        
        p = ((float)total/3900.0f);
        _mainResponseView.backgroundColor = [PTRootViewController colorForPercentage:p];
        
        // Night
        
        total = [defaults integerForKey:@"NightMinutes"];
        
        _nightCompletedLabel.text = [PTRootViewController formattedStringForMinutes:total];
        _nightCompletedLabel.alpha = 1.0;
        
        percentage = floor(((float)total/600.0f)*100.0f);
        _nightPercentageLabel.text = [NSString stringWithFormat:@"%i%%", percentage];
        _nightPercentageLabel.alpha = 1.0;
        
        _nightRequiredLabel.alpha = 1.0;
        
        p = ((float)total/600.0f);
        _nightResponseView.backgroundColor = [PTRootViewController colorForPercentage:p];
        
        // Weather
        
        total = [defaults integerForKey:@"BadWeatherMinutes"];
        
        _weatherCompletedLabel.text = [PTRootViewController formattedStringForMinutes:total];
        _weatherCompletedLabel.alpha = 1.0;
        
        percentage = floor(((float)total/300.0f)*100.0f);
        _weatherPercentageLabel.text = [NSString stringWithFormat:@"%i%%", percentage];
        _weatherPercentageLabel.alpha = 1.0;
        
        _weatherRequiredLabel.alpha = 1.0;
        
        p = ((float)total/300.0f);
        _weatherResponseView.backgroundColor = [PTRootViewController colorForPercentage:p];
    }];
}

- (void)addEntry
{
    PTAppDelegate *delegate = (PTAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInteger totalMinutes = ([_pickerView selectedRowInComponent:0]*60)+([_pickerView selectedRowInComponent:1]*5);
    
    if (totalMinutes == 0) return;
    
    PTEntry *entry = [[PTEntry alloc] init];
    entry.date = [NSDate date];
    entry.minutes = totalMinutes;
    entry.night = _nightButton.active;
    entry.badWeather = _weatherButton.active;
    
    [delegate.log addEntries:[NSSet setWithObject:entry]];
    
    NSTimeInterval firstInterval = 0.5;
    NSTimeInterval bounceInterval = 0.1;
    
    UILabel *totalAnimatingLabel = [[UILabel alloc] init];
    totalAnimatingLabel.text = [PTRootViewController formattedStringForMinutes:totalMinutes];
    totalAnimatingLabel.font = [UIFont boldSystemFontOfSize:55];
    totalAnimatingLabel.textAlignment = NSTextAlignmentCenter;
    totalAnimatingLabel.frame = CGRectMake(81, 315, [totalAnimatingLabel.text sizeWithFont:totalAnimatingLabel.font].width + 20, 75);
    totalAnimatingLabel.backgroundColor = [UIColor clearColor];
    totalAnimatingLabel.textColor = [UIColor whiteColor];
    totalAnimatingLabel.alpha = 0.7;
    
    [self.view addSubview:totalAnimatingLabel];
    
    if (entry.night) {
        UILabel *nightAnimatingLabel = [[UILabel alloc] initWithFrame:totalAnimatingLabel.frame];
        nightAnimatingLabel.text = totalAnimatingLabel.text;
        nightAnimatingLabel.font = totalAnimatingLabel.font;
        nightAnimatingLabel.textAlignment = totalAnimatingLabel.textAlignment;
        nightAnimatingLabel.backgroundColor = totalAnimatingLabel.backgroundColor;
        nightAnimatingLabel.textColor = totalAnimatingLabel.textColor;
        nightAnimatingLabel.alpha = totalAnimatingLabel.alpha;
        
        [self.view addSubview:nightAnimatingLabel];
        
        [UIView animateWithDuration:firstInterval animations:^() {
            CGRect targetFrame = CGRectMake(_nightCompletedLabel.frame.origin.x + _nightCompletedLabel.superview.frame.origin.x, _nightCompletedLabel.frame.origin.y + _nightCompletedLabel.superview.frame.origin.y, _nightCompletedLabel.frame.size.width, _nightCompletedLabel.frame.size.height);
            
            nightAnimatingLabel.frame = CGRectMake(targetFrame.origin.x - 40, targetFrame.origin.y - 40, targetFrame.size.width + 80, targetFrame.size.height + 80);
            nightAnimatingLabel.alpha = 0.3;
            nightAnimatingLabel.transform = CGAffineTransformMakeScale(0.4, 0.4);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:bounceInterval animations:^() {
                nightAnimatingLabel.alpha = 0.0;
                nightAnimatingLabel.transform = CGAffineTransformMakeScale(0.05, 0.05);
                _nightCompletedLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                [nightAnimatingLabel removeFromSuperview];
                
                [UIView animateWithDuration:bounceInterval animations:^(void) {
                    _nightCompletedLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:(bounceInterval * 2) animations:^(void) {
                        _nightCompletedLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }];
            }];
        }];
    }
    
    if (entry.badWeather) {
        UILabel *weatherAnimatingLabel = [[UILabel alloc] initWithFrame:totalAnimatingLabel.frame];
        weatherAnimatingLabel.text = totalAnimatingLabel.text;
        weatherAnimatingLabel.font = totalAnimatingLabel.font;
        weatherAnimatingLabel.textAlignment = totalAnimatingLabel.textAlignment;
        weatherAnimatingLabel.backgroundColor = totalAnimatingLabel.backgroundColor;
        weatherAnimatingLabel.textColor = totalAnimatingLabel.textColor;
        weatherAnimatingLabel.alpha = totalAnimatingLabel.alpha;
        
        [self.view addSubview:weatherAnimatingLabel];
        
        [UIView animateWithDuration:firstInterval animations:^() {
            CGRect targetFrame = CGRectMake(_weatherCompletedLabel.frame.origin.x + _weatherCompletedLabel.superview.frame.origin.x, _weatherCompletedLabel.frame.origin.y + _weatherCompletedLabel.superview.frame.origin.y, _weatherCompletedLabel.frame.size.width, _weatherCompletedLabel.frame.size.height);
            
            weatherAnimatingLabel.frame = CGRectMake(targetFrame.origin.x - 40, targetFrame.origin.y - 40, targetFrame.size.width + 80, targetFrame.size.height + 80);
            weatherAnimatingLabel.alpha = 0.3;
            weatherAnimatingLabel.transform = CGAffineTransformMakeScale(0.4, 0.4);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:bounceInterval animations:^() {
                weatherAnimatingLabel.alpha = 0.0;
                weatherAnimatingLabel.transform = CGAffineTransformMakeScale(0.05, 0.05);
                _weatherCompletedLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:bounceInterval animations:^(void) {
                    _weatherCompletedLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:(bounceInterval * 2) animations:^(void) {
                        _weatherCompletedLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }];
            }];
        }];
    }
    
    [UIView animateWithDuration:firstInterval animations:^() {
        totalAnimatingLabel.frame = CGRectMake(_totalCompletedLabel.frame.origin.x - 30, _totalCompletedLabel.frame.origin.y - 30, _totalCompletedLabel.frame.size.width + 60, _totalCompletedLabel.frame.size.height + 60);
        totalAnimatingLabel.alpha = 0.3;
        totalAnimatingLabel.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:bounceInterval animations:^() {
            totalAnimatingLabel.alpha = 0.0;
            totalAnimatingLabel.transform = CGAffineTransformMakeScale(0.05, 0.05);
            _totalCompletedLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [totalAnimatingLabel removeFromSuperview];
            
            [delegate countTime];
            
            [UIView animateWithDuration:bounceInterval animations:^(void) {
                _totalCompletedLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:(bounceInterval * 2) animations:^(void) {
                    _totalCompletedLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }];
        }];
    }];
}

- (void)flipView
{
    _entriesViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:_entriesViewController animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 25;
            break;
        
        case 1:
            return 12;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%@%i", (row < 10) ? @"0" : @"", row];
            break;
            
        case 1:
            return [NSString stringWithFormat:@"%@%i", (row < 2) ? @"0" : @"", (row)*5];
            break;
            
        default:
            return @"";
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 75;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 98;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 60)];
    label.font = [UIFont boldSystemFontOfSize:55];
    label.backgroundColor = [UIColor clearColor];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (NSString *)formattedStringForMinutes:(NSInteger)minutes
{
    NSInteger hours = floor(minutes/60);
    NSInteger newMinutes = minutes - (hours * 60);
    return [PTRootViewController formattedStringForHours:hours andMinutes:newMinutes];
}

+ (NSString *)formattedStringForHours:(NSInteger)hours andMinutes:(NSInteger)minutes
{
    NSString *hoursString;
    NSString *minutesString;
    
    if (hours == 0)
        hoursString = @"00";
    else if (hours < 10)
        hoursString = [NSString stringWithFormat:@"0%i", hours];
    else
        hoursString = [NSString stringWithFormat:@"%i", hours];
    
    if (minutes == 0)
        minutesString = @"00";
    else if (minutes < 10)
        minutesString = [NSString stringWithFormat:@"0%i", minutes];
    else
        minutesString = [NSString stringWithFormat:@"%i", minutes];
    
    return [NSString stringWithFormat:@"%@:%@", hoursString, minutesString];
}

+ (UIColor *)colorForPercentage:(float)percent
{
    percent = (percent > 1.0) ? 1.0 : percent;
    float greenValue = percent * 2;
    float redValue = 1 - ((percent*2) - 1.0);
    
    return [UIColor colorWithRed:redValue green:greenValue blue:0 alpha:1.0];
}

@end
