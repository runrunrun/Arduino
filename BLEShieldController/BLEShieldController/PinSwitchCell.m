//
//  PinSwitchCell.m
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "PinSwitchCell.h"

@implementation PinSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _pinSwitch = [[UISwitch alloc] init];
        _pinLabel = [[UILabel alloc] init];
        
        [self addSubview:_pinLabel];
        [self addSubview:_pinSwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 0.0f, y = 0.0f, width = self.width/2, height = self.height;
    
    _pinLabel.frame = CGRectMake(x, y, width, height);
    
    x = _pinLabel.right;
    _pinSwitch.frame = CGRectMake(x, y, width, height);
    
}

@end
