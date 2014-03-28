//
//  RootViewController.m
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "RootViewController.h"
#import "PinSwitchCell.h"
#import "PinSliderCell.h"
#import "Pin.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, PinSwitchDelegate, PinSliderDelegate>
{
    UITableView *_tableView;
    NSArray *_digitalPinArray;
    NSArray *_analogPinArray;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView = [UITableView new];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.allowsSelection = NO;
    
    _digitalPinArray = [Pin digitalPins];
    _analogPinArray = [Pin analogPins];
    
    [self.view addSubview:_tableView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 1;
    
    if (section == 0) {
        numberOfRows = [_analogPinArray count];
    }
    else if (section == 1) {
        numberOfRows = [_digitalPinArray count];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *tableCell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    Pin *pin = nil;
    
    if (section == 0) {
        pin = [_analogPinArray objectAtIndex:row];
    }
    else if (section == 1){
        pin = [_digitalPinArray objectAtIndex:row];
    }
    
    if (pin.type == kPinDigital) {
        NSString *cellIdentifier = @"pinSwitchCell";
        PinSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[PinSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.pinLabel.text = pin.name;
        cell.pinSwitch.on = pin.state;
        cell.pin = pin;
        cell.delegate = self;
        tableCell = cell;
    }
    else if (pin.type == kPinAnalog) {
        //create analog cell with sliders
        NSString *cellIdentifier = @"pinSliderCell";
        PinSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[PinSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.pinLabel.text = pin.name;
        cell.pinSlider.value = pin.value;
        cell.pin = pin;
        cell.delegate = self;
        tableCell = cell;
    }
    
    return tableCell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) {
        title = @"Analog Pins";
    }
    else if (section == 1) {
        title = @"Digital Pins";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


#pragma mark - PinSwitchDelegate
#pragma mark -

- (void)pin:(Pin *)pin switchedOn:(BOOL)switchedOn
{
    pin.state = switchedOn ? kHigh : kLow;
}

#pragma mark - PinSliderDelegate
#pragma mark -

- (void)pin:(Pin *)pin sliderValue:(NSInteger)value
{
    pin.value = value;
}


@end
