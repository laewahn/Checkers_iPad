//
//  StoneLayer.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "StoneLayer.h"

#import "Stone.h"

@interface StoneLayer() {
    Stone* _stone;
    CGSize size;
}
@end

void * fieldObserverContext = &fieldObserverContext;

@implementation StoneLayer

+(StoneLayer *)layerForStone:(Stone *)theStone size:(CGSize)theSize;
{
    StoneLayer* theLayer = [[StoneLayer alloc] initWithStone:theStone size:theSize];
    
    UIColor* stoneColor = ([theStone color] == kStoneColorBlack) ? [UIColor blackColor] : [UIColor orangeColor];
    [theLayer setBackgroundColor:[stoneColor CGColor]];
    
    return theLayer;
}

- (id)initWithStone:(Stone *)theStone size:(CGSize)theSize
{
    self = [super init];
    if (self) {
        [self setAnchorPoint:CGPointMake(0, 0)];

        size = theSize;
        _stone = theStone;
        [_stone addObserver:self forKeyPath:@"field" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:fieldObserverContext];
    }
    return self;
}

-(void)dealloc
{
    [_stone removeObserver:self forKeyPath:@"field"];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == fieldObserverContext) {
        
        CheckersFieldPosition field;
        [[change valueForKey:NSKeyValueChangeNewKey] getValue:&field];
        
        CGPoint newPosition = CGPointMake(field.x * size.width, field.y * size.height);
        [self setPosition:newPosition];
    }
}

@end
