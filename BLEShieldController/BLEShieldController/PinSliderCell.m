//
//  PinSliderCell.m
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "PinSliderCell.h"

@implementation PinSliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _pinSlider = [UISlider new];
        _pinSlider.minimumValue = 0;
        _pinSlider.maximumValue = 1023;
        
        [_pinSlider addTarget:self action:@selector(pinSliderValue) forControlEvents:UIControlEventValueChanged];
        
        _pinLabel = [[UILabel alloc] init];
        
        [self addSubview:_pinLabel];
        [self addSubview:_pinSlider];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 20.0f, y = 0.0f, width = self.width/2, height = self.height;
    
    _pinLabel.frame = CGRectMake(x, y, width, height);
    
    width = _pinSlider.width;//default width
    height = _pinSlider.height;//default height
    x = self.width - width - 20.0f;
    y = _pinLabel.midY - height/2;
    _pinSlider.frame = CGRectMake(x, y, width, height);
}

- (void)pinSliderValue
{
    NSNumber *number = [NSNumber numberWithFloat:_pinSlider.value];
    
    [_delegate pin:_pin sliderValue:[number integerValue]];
}

@end
