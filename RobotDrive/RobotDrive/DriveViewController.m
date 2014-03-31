//
//  DriveViewController.m
//  RobotDrive
//
//  Created by Hari Kunwar on 3/29/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "DriveViewController.h"
#import "BLE.h"

typedef enum Direction{
    kDirectionUp,
    kDirectionDown,
    kDirectionLeft,
    kDirectionRight
}Direction;

@interface DriveViewController () <BLEDelegate>
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIButton *_upButton;
    UIButton *_downButton;
    UIButton *_stopButton;
    
    UIButton *_connectButton;

    BLE *_ble;
    NSTimer *_rssiTimer;
    UIActivityIndicatorView *_spinner;
    BOOL _connected;
}

@end

@implementation DriveViewController

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
    
    _upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _upButton.tag = kDirectionUp;
    [_upButton showLayoutBorder];
    [_upButton setTitle:@"UP" forState:UIControlStateNormal];
    [_upButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_upButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];

    _downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _downButton.tag = kDirectionDown;
    [_downButton showLayoutBorder];
    [_downButton setTitle:@"DOWN" forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_downButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leftButton.tag = kDirectionLeft;
    [_leftButton showLayoutBorder];
    [_leftButton setTitle:@"LEFT" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_leftButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightButton.tag = kDirectionRight;
    [_rightButton showLayoutBorder];
    [_rightButton setTitle:@"RIGHT" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_rightButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_leftButton];
    [self.view addSubview:_rightButton];
    [self.view addSubview:_upButton];
    [self.view addSubview:_downButton];
    
    [self enableControl:NO];

    _connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_connectButton showLayoutBorder];
    [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [_connectButton addTarget:self action:@selector(connectBLE) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectButton];
    
    _ble = [BLE new];
    [_ble controlSetup];
    _ble.delegate = self;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_spinner];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    [self layoutSubviewForInterfaceOrientation:orientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutSubviewForInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    //Block orientation change
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    BOOL autoRotate = orientation == UIDeviceOrientationPortrait;
    return YES;
}

- (void)layoutSubviewForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGFloat viewWidth = interfaceOrientation == UIInterfaceOrientationPortrait ? 320 : 568;
    
    CGFloat width = 80.0f, height = 50.0f, x = viewWidth/2 - width/2, y = 100.0f;
    _upButton.frame = CGRectMake(x, y, width, height);
    
    x = _upButton.left, y = _upButton.bottom + 30.0f;
    _downButton.frame = CGRectMake(x, y, width, height);
    
    x = _downButton.left - width - 30.0f;
    _leftButton.frame = CGRectMake(x, y, width, height);
    
    x = _downButton.right + 30.0f;
    _rightButton.frame = CGRectMake(x, y, width, height);
    
    x = _upButton.left, y = _downButton.bottom + 50.0f;
    _connectButton.frame = CGRectMake(x, y, width, height);
    
    x = CGRectGetMidX(self.view.bounds), y = CGRectGetMidY(self.view.bounds);
    _spinner.frame = CGRectMake(x, y, 10, 10);
}

- (UInt8)uintForDirection:(Direction)direction
{
    UInt8 directionValue = 0x01;
    
    switch (direction) {
        case kDirectionUp:
            directionValue = 0x01;
            break;
        case kDirectionDown:
            directionValue = 0x02;
            break;
        case kDirectionLeft:
            directionValue = 0x03;
            break;
        case kDirectionRight:
            directionValue = 0x04;
            break;
        default:
            break;
    }
    
    return directionValue;
}

- (void)enableControl:(BOOL)enable
{
    _upButton.enabled = enable;
    _downButton.enabled = enable;
    _leftButton.enabled = enable;
    _rightButton.enabled = enable;
}

#pragma mark - 
#pragma mark - Button actions

- (void)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%@ Pressed", [button titleForState:UIControlStateNormal]);

    UInt8 uintDirection = [self uintForDirection:(Direction)button.tag];
    
    UInt8 buf[3] = {uintDirection, 0x01, 0x00};

    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

- (void)buttonReleased:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%@ Released", [button titleForState:UIControlStateNormal]);
    
    UInt8 directionValue = [self uintForDirection:(Direction)button.tag];
    
    UInt8 buf[3] = {directionValue, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

#pragma mark - 
#pragma mark - Connect to BLE

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
    
    [_ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [_spinner startAnimating];
}

-(void)connectionTimer:(NSTimer *)timer
{
    if (_ble.peripherals.count > 0)
    {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
    }
    else
    {
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
    
    // send reset
    UInt8 buf[] = {0x08, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
    
    // Schedule to read RSSI every 1 sec.
    _rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
    
    [self enableControl:YES];
}

-(void) bleDidDisconnect
{
    [_spinner stopAnimating];
    
    _connected = NO;
    
    [_rssiTimer invalidate];
    
    [self enableControl:NO];
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
