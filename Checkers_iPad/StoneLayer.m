//
//  StoneLayer.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "StoneLayer.h"

@interface StoneLayer() {
    CGSize size;
}
@end

@implementation StoneLayer

+(StoneLayer *)layerWithSize:(CGSize)theSize color:(CheckersStoneColor) color;
{
    StoneLayer* theLayer = [[StoneLayer alloc] initWithSize:theSize];
    
    UIColor* stoneColor = (color == kStoneColorBlack) ? [UIColor blackColor] : [UIColor orangeColor];
    [theLayer setBackgroundColor:[stoneColor CGColor]];
    
    return theLayer;
}

- (id)initWithSize:(CGSize)theSize
{
    self = [super init];
    if (self) {
        [self setAnchorPoint:CGPointMake(0, 0)];

        size = theSize;
    }
    return self;
}

-(CAAnimation *)createRemoveAnimation
{
    CABasicAnimation* fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOut setFromValue:@1.0];
    [fadeOut setToValue:@0.0];
    [fadeOut setDuration:.5];
    [fadeOut setRemovedOnCompletion:YES];
    [fadeOut setFillMode:kCAFillModeForwards];
    
    [fadeOut setValue:self forKey:@"parentLayer"];
    
    return fadeOut;
}


@end
