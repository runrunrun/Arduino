//
//  UIView+Additions.m
//  BLEShieldController
//
//  Created by Hari Kunwar on 3/27/14.
//  Copyright (c) 2014 Hari Kunwar. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)


- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)top
{
    return CGRectGetMinY(self.frame);
}
- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)midX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY
{
    return CGRectGetMidY(self.frame);
}

- (void)showLayoutBorder
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor redColor] CGColor];
}


@end
