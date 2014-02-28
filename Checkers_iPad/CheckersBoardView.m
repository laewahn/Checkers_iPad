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

@implementation CheckersBoardView

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

    CGRect myFrame = [self frame];
    CGFloat fieldSize = myFrame.size.width/kNumberOfRows;
    
    for (NSInteger row = 0; row < kNumberOfRows; row++) {
        for (NSInteger column = 0; column < kNumberOfRows; column++) {
            const CGFloat* colorComponents = ((column + row) % 2 == 0) ? kWhiteFieldColor : kBlackFieldColor;
            CGContextSetFillColor(context, colorComponents);
            
            CGRect theField = CGRectMake(fieldSize * column, fieldSize * row, fieldSize, fieldSize);
            CGContextFillRect(context, theField);
        }
    }
    
}

@end
