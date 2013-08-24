//
//  PTEntriesViewController.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/6/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTEntriesViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "PTAppDelegate.h"
#import "PTRootViewController.h"
#import "PTSettingsViewController.h"
#import "PTAlertView.h"
#import "PTLog.h"
#import "PTEntry.h"

@interface PTEntriesViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) PTSettingsViewController *settingsViewController;

- (void)dismiss;
- (void)showSettings;
- (void)sortData;

@end

@implementation PTEntriesViewController

@synthesize titleLabel = _titleLabel, tableView = _tableView, dates = _dates, data = _data, settingsViewController = _settingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
        
        [self.view addSubview:_tableView];
        
        _settingsViewController = [[PTSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        _animating = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self sortData];
    
    [_tableView reloadData];
}

- (void)sortData
{
    PTAppDelegate *delegate = (PTAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    _dates = [[NSMutableArray alloc] init];
    _data = [[NSMutableArray alloc] init];
    
    NSArray *sortedEntries = [delegate.log.entries sortedArrayUsingComparator:^NSComparisonResult(PTEntry *a, PTEntry *b) {
        return [a.date compare:b.date];
    }];
    
    for (PTEntry *entry in sortedEntries) {
        NSString *dateIdentifier = [dateFormatter stringFromDate:entry.date];
     
        if (![_dates containsObject:dateIdentifier]) {
            [_dates addObject:dateIdentifier];
            
            [_data addObject:[[NSMutableArray alloc] init]];
        }
        
        [(NSMutableArray *)[_data lastObject] addObject:entry];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        PTAlertView *alert = [[PTAlertView alloc] init];
        
        PTAppDelegate *delegate = (PTAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSUndoManager *undoManager = delegate.log.undoManager;
        
        NSString *undoTitle = ([undoManager canUndo]) ? [NSString stringWithFormat:@"Undo %@", undoManager.undoActionName] : nil;
        NSString *redoTitle = ([undoManager canRedo]) ? @"Redo" : nil;
        
        if (undoTitle) {
            [alert addButtonAtIndex:0 withTitle:undoTitle completion:^(void) {
                [undoManager undo];
                
                [delegate countTime];
                
                [self viewWillAppear:NO];
            }];
        }
        
        if (redoTitle) {
            [alert addButtonAtIndex:1 withTitle:redoTitle completion:^(void) {
                [undoManager redo];
                
                [delegate countTime];
                
                [self viewWillAppear:NO];
            }];
        }
        
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Entries";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showSettings
{
    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:_settingsViewController] animated:YES];
//    if (_animating)
//        return;
//    
//    _animating = YES;
//    
//    if (!_settingsView.superview) {
//        // Showing settings
//        
//        self.title = @"Settings";
//        
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//        self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"entriesListIcon"];
//        
//        [self.view insertSubview:_settingsView belowSubview:_tableView];
//        
//        _tableView.userInteractionEnabled = NO;
//        
//        [UIView animateWithDuration:0.3 animations:^() {
//            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y + _tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height);
//        } completion:^(BOOL finished) {
//            _settingsView.userInteractionEnabled = YES;
//            
//            _animating = NO;
//        }];
//    } else {
//        // Hiding Settings
//        
//        self.title = @"Entries";
//        
//        self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"settingsIcon"];
//        
//        [_settingsView.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//        _settingsView.userInteractionEnabled = NO;
//        
//        [UIView animateWithDuration:0.3 animations:^() {
//            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y - _tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height);
//            _tableView.userInteractionEnabled = YES;
//        } completion:^(BOOL finished) {
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//            
//            [_settingsView removeFromSuperview];
//            
//            _animating = NO;
//        }];
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    section = [self numberOfSectionsInTableView:tableView] - section - 1;
    return (NSString *)[_dates objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    section = [self numberOfSectionsInTableView:tableView] - section - 1;
    return [(NSMutableArray *)[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *nightIcon;
    UIImageView *weatherIcon;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        nightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 23, 42, 42)];
        nightIcon.image = [UIImage imageNamed:@"nightButtonActive"];
        nightIcon.tag = 1;
        [cell.contentView addSubview:nightIcon];
        
        weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(320-25-36, 24, 36, 41)];
        weatherIcon.image = [UIImage imageNamed:@"weatherButtonActive"];
        weatherIcon.tag = 2;
        [cell.contentView addSubview:weatherIcon];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        background.image = [UIImage imageNamed:@"entryCellBackground"];
        
        cell.backgroundView = background;
    } else {
        nightIcon = (UIImageView *)[cell viewWithTag:1];
        weatherIcon = (UIImageView *)[cell viewWithTag:2];
    }
    
    NSInteger section = [self numberOfSectionsInTableView:tableView] - indexPath.section - 1;
    NSInteger index = [self tableView:tableView numberOfRowsInSection:indexPath.section] - indexPath.row - 1;
    
    PTEntry *entry = (PTEntry *)[(NSMutableArray *)[_data objectAtIndex:section] objectAtIndex:index];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    cell.textLabel.shadowOffset = CGSizeMake(0,1);
    cell.textLabel.text = [NSString stringWithFormat:@"       %@", [PTRootViewController formattedStringForMinutes:entry.minutes]];
    cell.textLabel.font = [UIFont fontWithName:kBoldFont size:45];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BOOL night = entry.night;
    BOOL badWeather = entry.badWeather;
    
    nightIcon.alpha = (night) ? 1 : 0;
    weatherIcon.alpha = (badWeather) ? 1 : 0;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section])];
    
    NSInteger actualSection = [self numberOfSectionsInTableView:tableView] - section - 1;
    NSInteger total = 0;
    
    for (NSInteger x = 0; x <= actualSection; x++) {
        for (PTEntry *entry in (NSArray *)[_data objectAtIndex:x]) {
            total += entry.minutes;
        }
    }
    
    float p = ((float)total/3900.0f);
    
    titleView.backgroundColor = [[PTRootViewController colorForPercentage:p] colorWithAlphaComponent:0.9];
    
    CAGradientLayer *shadow = [[CAGradientLayer alloc] init];
        
    shadow.frame = titleView.frame;
    
    CGColorRef highlightColor = [[[UIColor whiteColor] colorWithAlphaComponent:.607843137] CGColor];
    CGColorRef lightColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.0] CGColor];
    CGColorRef darkColor = [[[UIColor blackColor] colorWithAlphaComponent:.070588235] CGColor];
    CGColorRef borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.45] CGColor];
    
    shadow.colors = @[  (__bridge id)(highlightColor),
                        (__bridge id)(lightColor),
                        (__bridge id)(darkColor),
                        (__bridge id)(borderColor) ];
    shadow.locations =  @[  @0.0f,
                            @0.035714286f,
                            @0.964285714f,
                            @1.0f ];
    
    [titleView.layer addSublayer:shadow];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 308, 20)];
    titleLabel.font = [UIFont fontWithName:kMediumFont size:16];
    titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [titleView addSubview:titleLabel];
    
    NSInteger today = 0;
    
    for (PTEntry *entry in (NSArray *)[_data objectAtIndex:actualSection]) {
        today += entry.minutes;
    }
    
    UILabel *thatDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 4, 160-8, 20)];
    thatDayLabel.font = [UIFont fontWithName:kMediumFont size:16];
    thatDayLabel.textAlignment = NSTextAlignmentRight;
    thatDayLabel.text = [PTRootViewController formattedStringForMinutes:today];
    thatDayLabel.backgroundColor = [UIColor clearColor];
    thatDayLabel.textColor = [UIColor whiteColor];
    thatDayLabel.shadowOffset = CGSizeMake(0, -1);
    thatDayLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [titleView addSubview:thatDayLabel];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        
        NSInteger section = [self numberOfSectionsInTableView:tableView] - indexPath.section - 1;
        NSInteger index = [self tableView:tableView numberOfRowsInSection:indexPath.section] - indexPath.row - 1;
        
        PTEntry *entry = (PTEntry *)[(NSMutableArray *)[_data objectAtIndex:section] objectAtIndex:index];
        [(NSMutableArray *)[_data objectAtIndex:section] removeObject:entry];
        
        if ([(NSMutableArray *)[_data objectAtIndex:section] count] == 0) {
            [_dates removeObjectAtIndex:section];
            [_data removeObjectAtIndex:section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        PTAppDelegate *delegate = (PTAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [delegate.log removeEntries:[NSSet setWithObject:entry]];
        [delegate countTime];
        
        [tableView endUpdates];
        
        // Reloading section header views
        
        [tableView beginUpdates];
        
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_dates count])];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
    }
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

@end
