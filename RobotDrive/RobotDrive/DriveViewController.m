//
//  DriveViewController.m
//  RobotDrive
//
//  Created by Hari Kunwar on 3/29/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "DriveViewController.h"

@interface DriveViewController ()
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIButton *_forwardButton;
    UIButton *_backButton;
    UIButton *_stopButton;
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
    
    _forwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_forwardButton showLayoutBorder];
    [_forwardButton setTitle:@"UP" forState:UIControlStateNormal];
    [_forwardButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_forwardButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];

    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_backButton showLayoutBorder];
    [_backButton setTitle:@"DOWN" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_backButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_leftButton showLayoutBorder];
    [_leftButton setTitle:@"LEFT" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_leftButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_rightButton showLayoutBorder];
    [_rightButton setTitle:@"RIGHT" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_rightButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_leftButton];
    [self.view addSubview:_rightButton];
    [self.view addSubview:_forwardButton];
    [self.view addSubview:_backButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat width = 80.0f, height = 50.0f, x = self.view.width/2 - width/2, y = 100.0f;
    _forwardButton.frame = CGRectMake(x, y, width, height);
    
    x = _forwardButton.left, y = _forwardButton.bottom + 30.0f;
    _backButton.frame = CGRectMake(x, y, width, height);

    x = _backButton.left - width - 30.0f;
    _leftButton.frame = CGRectMake(x, y, width, height);
    
    x = _backButton.right + 30.0f;
    _rightButton.frame = CGRectMake(x, y, width, height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Button actions

- (void)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"%@ Pressed", [button titleForState:UIControlStateNormal]);
}

- (void)buttonReleased:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"%@ Released", [button titleForState:UIControlStateNormal]);
}

@end
