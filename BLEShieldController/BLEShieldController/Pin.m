//
//  Pin.m
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "Pin.h"

@implementation Pin

+ (NSArray *)standardPins
{
    NSMutableArray *pinArray = [NSMutableArray new];
    
    NSArray *digitalPins = [self digitalPins];
    NSArray *analogPins = [self analogPins];
    
    [pinArray addObjectsFromArray:digitalPins];
    [pinArray addObjectsFromArray:analogPins];

    return [pinArray copy];
}

+ (NSArray *)digitalPins
{
    NSMutableArray *pinArray = [NSMutableArray new];
    
    //Digital Pins
    for (int i = 0; i < 8; i++) {
        Pin *pin = [Pin new];
        pin.name = [NSString stringWithFormat:@"Digital Pin %d", i];
        pin.identifier = pin.name;
        pin.type = kPinDigital;
        pin.state = kLow;
        [pinArray addObject:pin];
    }
    
    return [pinArray copy];
}

+ (NSArray *)analogPins
{
    NSMutableArray *pinArray = [NSMutableArray new];
    
    //Analog Pins
    for (int i = 0; i < 6; i++) {
        Pin *pin = [Pin new];
        pin.name = [NSString stringWithFormat:@"Analog Pin %d", i];
        pin.type = kPinAnalog;
        pin.value = 0;
        [pinArray addObject:pin];
    }
    
    return [pinArray copy];
}


@end
