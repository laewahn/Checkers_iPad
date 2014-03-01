//
//  CheckersBoardView.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "CheckersBoardView.h"

#import "StoneLayer.h"
#import "Stone.h"

const CGFloat kNumberOfRows = 10.0;

const CGFloat kBlackFieldColor[] = {0.5, 0.5, 0.5, 1.0};
const CGFloat kWhiteFieldColor[] = {1.0, 1.0, 1.0, 1.0};

@interface CheckersBoardView() {
    
    CGFloat widthOfAField;
    CGFloat heightOfAField;
    
    NSMutableDictionary* stoneLayersIndexedByStoneID;
}

@end

@implementation CheckersBoardView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        CGRect frame = [super frame];
        
        widthOfAField = frame.size.width / kNumberOfRows;
        heightOfAField = frame.size.height / kNumberOfRows;
        
        stoneLayersIndexedByStoneID = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBoard:context];
    
    CGRect myFrame = [self frame];
    CGContextSetStrokeColor(context, kBlackFieldColor);
    CGContextStrokeRect(context, CGRectMake(0.0, 0.0, myFrame.size.width, myFrame.size.height));

}

-(void) drawBoard:(CGContextRef) context
{
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    for (NSInteger row = 0; row < kNumberOfRows; row++) {
        for (NSInteger column = 0; column < kNumberOfRows; column++) {
            const CGFloat* colorComponents = ((column + row) % 2 == 0) ? kWhiteFieldColor : kBlackFieldColor;
            CGContextSetFillColor(context, colorComponents);
            
            CGRect theField = CGRectMake(widthOfAField * column, heightOfAField * row, widthOfAField, heightOfAField);
            CGContextFillRect(context, theField);
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch* aTouch = [touches anyObject];
        CGPoint touchPosition = [aTouch locationInView:self];
        
        NSInteger touchedColumn = touchPosition.x / widthOfAField;
        NSInteger touchedRow = touchPosition.y / heightOfAField;
        
        CheckersFieldPosition newPosition = {touchedColumn, touchedRow};
        [self.delegate boardViewFieldWasSelected:newPosition];
    }

}


-(void) addStone:(Stone *)theStone
{
    StoneLayer* layer = [StoneLayer layerForStone:theStone size:CGSizeMake(widthOfAField, heightOfAField)];
    [self addStoneLayer:layer];
    
    [stoneLayersIndexedByStoneID setObject:layer forKey:[theStone stoneID]];
}

-(void) addStoneLayer:(StoneLayer *)theLayer
{
    CGPoint layerPosition = [theLayer position];
    CGRect defaultStoneFrame = CGRectMake(layerPosition.x, layerPosition.y, widthOfAField, heightOfAField);
    [theLayer setFrame:defaultStoneFrame];

    [[self layer] addSublayer:theLayer];
    
}

-(void) removeStone:(Stone *)theStone
{
    StoneLayer* theLayer = [stoneLayersIndexedByStoneID objectForKey:[theStone stoneID]];
    
    CAAnimation* layerRemoveAnimation = [theLayer createRemoveAnimation];
    [layerRemoveAnimation setDelegate:self];
    [theLayer addAnimation:layerRemoveAnimation forKey:@"remove"];
    
    [stoneLayersIndexedByStoneID removeObjectForKey:[theStone stoneID]];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished) {
        StoneLayer* layerToRemove = [anim valueForKey:@"parentLayer"];
        [layerToRemove removeFromSuperlayer];
    }
}

@end
