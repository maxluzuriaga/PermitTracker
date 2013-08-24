//
//  PTSettingsView.m
//  PermitTracker
//
//  Created by Max Luzuriaga on 8/17/12.
//  Copyright (c) 2012 Max Luzuriaga. All rights reserved.
//

#import "PTSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PTSettingsViewController ()

@property (nonatomic, strong) NSDictionary *areas;

- (void)dismiss;

@end

@implementation PTSettingsViewController

@synthesize areas = _areas;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
        _areas = [[NSDictionary alloc] initWithContentsOfFile:path];
        
//        for (int x = 0; x < 2; x++) {
//            BOOL top = x == 0;
//            
//            CAGradientLayer *shadow = [[CAGradientLayer alloc] init];
//            
//            float y = top ? 0 : 401;
//            CGRect shadowFrame = CGRectMake(0, y, 320, 15);
//            
//            shadow.frame = shadowFrame;
//            
//            CGColorRef darkColor = [[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor];
//            CGColorRef transparentColor = [[[UIColor blackColor] colorWithAlphaComponent:0.0] CGColor];
//            
//            shadow.colors = @[  (__bridge id)(top ? darkColor : transparentColor),
//                                (__bridge id)(top ? transparentColor : darkColor) ];
//            
//            shadow.opacity = 0.4;
//            
//            [self.layer insertSublayer:shadow atIndex:2];
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"HaveSelectedArea"])
        self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_areas count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"    %@", [[_areas allKeys] objectAtIndex:section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[[_areas allValues] objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:kBoldFont size:18];
    label.textColor = [UIColor whiteColor];
    
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *area = [[[_areas allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [area objectForKey:@"Name"];
    cell.textLabel.font = [UIFont fontWithName:kMediumFont size:18];
    cell.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ((indexPath.section == [defaults integerForKey:@"SelectedAreaSection"]) && (indexPath.row == [defaults integerForKey:@"SelectedAreaRow"])) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[defaults integerForKey:@"SelectedAreaRow"] inSection:[defaults integerForKey:@"SelectedAreaSection"]]].accessoryType = UITableViewCellAccessoryNone;
    
    [defaults setInteger:indexPath.section forKey:@"SelectedAreaSection"];
    [defaults setInteger:indexPath.row forKey:@"SelectedAreaRow"];
    
    [defaults setBool:YES forKey:@"HaveSelectedArea"];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
