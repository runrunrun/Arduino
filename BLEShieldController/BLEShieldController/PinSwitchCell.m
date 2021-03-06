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
        _pinSwitch = [UISwitch new];
        _pinSwitch.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [_pinSwitch addTarget:self action:@selector(pinSwitched) forControlEvents:UIControlEventValueChanged];
        
        _pinLabel = [[UILabel alloc] init];
        
        [self addSubview:_pinLabel];
        [self addSubview:_pinSwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 20.0f, y = 0.0f, width = self.width/2, height = self.height;
    
    _pinLabel.frame = CGRectMake(x, y, width, height);
    
    width = _pinSwitch.width;//default width
    height = _pinSwitch.height;//default height
    x = self.width - width - 20.0f;
    y = _pinLabel.midY - height/2;
    _pinSwitch.frame = CGRectMake(x, y, width, height);
    
}

- (void)pinSwitched
{
    [_delegate pin:_pin switchedOn:_pinSwitch.isOn];
}

@end
