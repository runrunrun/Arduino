//
//  PinSwitchCell.h
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@protocol PinSwitchDelegate <NSObject>

- (void)pin:(Pin *)pin switchedOn:(BOOL)switchedOn;

@end

@interface PinSwitchCell : UITableViewCell

@property (nonatomic, weak) id<PinSwitchDelegate> delegate;
@property (nonatomic, weak) Pin *pin;
@property (nonatomic, strong) UILabel *pinLabel;
@property (nonatomic, strong) UISwitch *pinSwitch;
@property (nonatomic, assign) NSInteger pinIdentifier;

@end
