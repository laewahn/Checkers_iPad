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

    [theLayer setColor:stoneColor];
    [theLayer setBorderColor:[[UIColor greenColor] CGColor]];
    [theLayer setCornerRadius:20.0];
    [theLayer setNeedsDisplay];
    
    return theLayer;
}

- (id)initWithSize:(CGSize)theSize
{
    self = [super init];
    if (self) {
        CGRect myFrame = CGRectMake(0, 0, theSize.width, theSize.height);
        [self setFrame:myFrame];
        
        CGPoint anchor = CGPointMake(0.0, 0.0);
        [self setAnchorPoint:anchor];

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

-(void)drawInContext:(CGContextRef)ctx
{
    CGRect myFrame = [self frame];
    CGRect frameToDraw = CGRectMake(0, 0, myFrame.size.width, myFrame.size.height);
    
    CGColorRef theCGColor = [[self color] CGColor];
    
    CGContextSetFillColorSpace(ctx, CGColorGetColorSpace(theCGColor));
    CGContextSetFillColor(ctx, CGColorGetComponents(theCGColor));
    CGContextFillEllipseInRect(ctx, frameToDraw);
}

@end
