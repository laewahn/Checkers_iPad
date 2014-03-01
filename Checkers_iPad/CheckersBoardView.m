//
//  CheckersBoardView.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "CheckersBoardView.h"

const CGFloat kNumberOfRows = 10.0;

const CGFloat kBlackFieldColor[] = {0.5, 0.5, 0.5, 1.0};
const CGFloat kWhiteFieldColor[] = {1.0, 1.0, 1.0, 1.0};

@interface CheckersBoardView() {
    CALayer* stoneLayer;
    
    CGFloat widthOfAField;
    CGFloat heightOfAField;
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
        
        CGRect stoneFrame = CGRectMake(0.0, 0.0, widthOfAField, heightOfAField);

        stoneLayer = [CALayer layer];
        [stoneLayer setAnchorPoint:CGPointMake(0, 0)];
        [stoneLayer setFrame:stoneFrame];
        [stoneLayer setBackgroundColor:[[UIColor orangeColor] CGColor]];

        [[self layer] addSublayer:stoneLayer];
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

//        CABasicAnimation* fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        [fadeOut setFromValue:@1.0];
//        [fadeOut setToValue:@0.0];
//        [fadeOut setDuration:2];
//        [fadeOut setRemovedOnCompletion:YES];
//        [fadeOut setFillMode:kCAFillModeForwards];
//        [fadeOut setDelegate:self];
//        [fadeOut setValue:stoneLayer forKey:@"parentLayer"];
//        [stoneLayer addAnimation:fadeOut forKey:@"opacity"];
        
    }

}

-(void) moveStoneToField:(CheckersFieldPosition) position
{
    CGPoint fieldPosition = CGPointMake(position.x * widthOfAField, position.y * heightOfAField);
    [stoneLayer setPosition:fieldPosition];
}

//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if (flag) {
//        [stoneLayer removeFromSuperlayer];
//    }
//}

@end
