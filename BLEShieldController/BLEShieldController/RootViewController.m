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
#import "BLE.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, PinSwitchDelegate, PinSliderDelegate, BLEDelegate>
{
    UITableView *_tableView;
    NSArray *_digitalPinArray;
    NSArray *_analogPinArray;
    BLE *_ble;
    NSTimer *_rssiTimer;
    UIActivityIndicatorView *_spinner;
    UIButton *_connectButton;
    BOOL _connected;
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
    
    _ble = [BLE new];
    [_ble controlSetup];
    _ble.delegate = self;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 1;
    
    if (section == 1) {
        numberOfRows = [_digitalPinArray count];
    }
    else if (section == 2) {
        numberOfRows = [_analogPinArray count];
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
        //add connect button
        NSString *cellIdentifier = @"buttonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            _connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_connectButton addTarget:self action:@selector(connectBLE) forControlEvents:UIControlEventTouchUpInside];
            _connectButton.frame = cell.bounds;
            [cell addSubview:_connectButton];
        }
        
        NSString *title = _connected ? @"Disconnect" : @"Connect";
        [_connectButton setTitle:title forState:UIControlStateNormal];
        
        tableCell = cell;
    }
    else if (section == 1) {
        pin = [_digitalPinArray objectAtIndex:row];
        NSString *cellIdentifier = @"pinSwitchCell";
        PinSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[PinSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.pinLabel.text = pin.name;
        cell.pinSwitch.on = pin.state;
        cell.pinSwitch.enabled = _connected;
        cell.pin = pin;
        cell.delegate = self;
        tableCell = cell;
    }
    else if (section == 2){
        pin = [_analogPinArray objectAtIndex:row];
        //create analog cell with sliders
        NSString *cellIdentifier = @"pinSliderCell";
        PinSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[PinSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        cell.pinLabel.text = pin.name;
        cell.pinSlider.value = pin.value;
        cell.pinSlider.enabled = _connected;
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
    if (section == 1) {
        title = @"Digital Pins";
    }
    else if (section == 2) {
        title = @"Analog Pins";
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    UInt8 n = (UInt8) pin.identifier;//Convert from decimal to hexadecimal number
    
    UInt8 buf[3] = {n, 0x00, 0x00};
    
    if (switchedOn)
        buf[1] = 0x01;//High
    else
        buf[1] = 0x00;//Low
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

#pragma mark - PinSliderDelegate
#pragma mark -

- (void)pin:(Pin *)pin sliderValue:(NSInteger)value
{
    pin.value = value;
}

- (void)connectBLE
{
    if (_ble.activePeripheral)
        if(_ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[_ble CM] cancelPeripheralConnection:[_ble activePeripheral]];
            _connected = NO;
            return;
        }
    
    if (_ble.peripherals)
        _ble.peripherals = nil;
    
    _connectButton.enabled = NO;
    
    [_ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [_spinner startAnimating];
}

-(void)connectionTimer:(NSTimer *)timer
{
    _connectButton.enabled = YES;
    [_connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (_ble.peripherals.count > 0)
    {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [_spinner stopAnimating];
    }
}

#pragma mark - 
#pragma mark - BLEDelegate

-(void)bleDidConnect
{
    NSLog(@"->Connected");
    
    _connected = YES;
    
    [_spinner stopAnimating];
    
    [_tableView reloadData];
    
    // send reset
    UInt8 buf[] = {0x08, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
    
    // Schedule to read RSSI every 1 sec.
    _rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

-(void) bleDidDisconnect
{
    [_spinner stopAnimating];

    _connected = NO;
    [_tableView reloadData];

    
    [_rssiTimer invalidate];
}

-(void)bleDidUpdateRSSI:(NSNumber *) rssi
{
//    lblRSSI.text = rssi.stringValue;
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [_ble readRSSI];
}

-(void) bleDidReceiveData:(unsigned char *) data length:(int) length
{
    NSLog(@"Length: %d", length);
}

@end
