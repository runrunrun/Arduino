//
//  PinSliderCell.h
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@protocol PinSliderDelegate <NSObject>

- (void)pin:(Pin *)pin sliderValue:(NSInteger)value;

@end

@interface PinSliderCell : UITableViewCell

@property (nonatomic, weak) id<PinSliderDelegate> delegate;
@property (nonatomic, weak) Pin *pin;
@property (nonatomic, strong) UILabel *pinLabel;
@property (nonatomic, strong) UISlider *pinSlider;
@property (nonatomic, assign) NSInteger pinIdentifier;


@end
