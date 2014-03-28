//
//  Pin.h
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PinType {
    kPinDigital,
    kPinAnalog
}PinType;

typedef enum PinState {
    kLow,
    kHigh
}PinState;

@interface Pin : NSObject

@property (nonatomic, assign) PinType  type;
@property (nonatomic, assign) PinState state;//Digital State
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger value;//Analog value


+ (NSArray *)standardPins;
+ (NSArray *)digitalPins;
+ (NSArray *)analogPins;

@end
