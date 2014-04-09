//
//  DoorLockViewController.m
//  DoorLockController
//
//  Created by Hari Kunwar on 4/1/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "DoorLockViewController.h"
#import "BLE.h"

@interface DoorLockViewController () <BLEDelegate>
{
    UISwitch *_lockSwitch;
    
    UIButton *_connectButton;
    
    BLE *_ble;
    NSTimer *_rssiTimer;
    UIActivityIndicatorView *_spinner;
    BOOL _connected;
}
@end

@implementation DoorLockViewController

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
    
    _connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [_connectButton addTarget:self action:@selector(connectBLE) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectButton];
    
    _ble = [BLE new];
    [_ble controlSetup];
    _ble.delegate = self;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_spinner];
    
    _lockSwitch = [UISwitch new];
    [_lockSwitch addTarget:self action:@selector(lockSwitched:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_lockSwitch];
    
    
    [self enableControl:NO];
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
    return YES;
}

- (void)layoutSubviewForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGSize viewSize = [self sizeForInterfaceOrientation:interfaceOrientation];
    
    CGFloat width = _lockSwitch.width, height = _lockSwitch.height, x = viewSize.width/2 - width/2, y = 100.0f;
    _lockSwitch.frame = CGRectMake(x, y, width, height);

    width = 80, height = 50, x = _lockSwitch.midX - width/2, y = _lockSwitch.bottom + 50;
    _connectButton.frame = CGRectMake(x, y, width, height);
    
    x = CGRectGetMidX(self.view.bounds), y = CGRectGetMidY(self.view.bounds);
    _spinner.frame = CGRectMake(x, y, 10, 10);
}

- (CGSize)sizeForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGSize screenSize =  [[UIScreen mainScreen] bounds].size;
    
    CGSize size = CGSizeMake(0, 0);
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        size.width = screenSize.width > screenSize.height ? screenSize.width : screenSize.height;
        size.height = screenSize.width > screenSize.height ? screenSize.height : screenSize.width;
    }
    else {
        size.width = screenSize.width > screenSize.height ? screenSize.height : screenSize.width;
        size.height = screenSize.width > screenSize.height ? screenSize.width : screenSize.height;
    }
    
    return size;
}

#pragma mark - 
#pragma mark - Action

- (void)lockSwitched:(id)sender
{
    if (_lockSwitch.on) {
        NSLog(@"Unlock");
        
        UInt8 buf[3] = {0x00, 0x00, 0x00};
        
        NSData *data = [[NSData alloc] initWithBytes:buf length:3];
        [_ble write:data];
    }
    else {
        NSLog(@"Lock");
        
        UInt8 buf[3] = {0x01, 0x00, 0x00};
        
        NSData *data = [[NSData alloc] initWithBytes:buf length:3];
        [_ble write:data];
    }
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


- (void)enableControl:(BOOL)enable
{
    _lockSwitch.enabled = enable;
}

@end
