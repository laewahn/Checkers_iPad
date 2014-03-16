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

void * ctxStoneFieldObserver = &ctxStoneFieldObserver;
void * ctxStoneSelectedObserver = &ctxStoneSelectedObserver;
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
    StoneLayer* layer = [StoneLayer layerWithSize:CGSizeMake(widthOfAField, heightOfAField) color:[theStone color]];

    [self addStoneLayer:layer];
    
    [stoneLayersIndexedByStoneID setObject:layer forKey:[theStone stoneID]];
    [theStone addObserver:self forKeyPath:@"field" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:ctxStoneFieldObserver];
    [theStone addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:ctxStoneSelectedObserver];
}

-(void) addStoneLayer:(StoneLayer *)theLayer
{
    [[self layer] addSublayer:theLayer];
    
}

-(void) removeStone:(Stone *)theStone
{
    StoneLayer* theLayer = [stoneLayersIndexedByStoneID objectForKey:[theStone stoneID]];
    
    CAAnimation* layerRemoveAnimation = [theLayer createRemoveAnimation];
    [layerRemoveAnimation setDelegate:self];
    [theLayer addAnimation:layerRemoveAnimation forKey:@"remove"];
    
    [stoneLayersIndexedByStoneID removeObjectForKey:[theStone stoneID]];
    [theStone removeObserver:self forKeyPath:@"field"];
    [theStone removeObserver:self forKeyPath:@"selected"];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished) {
        StoneLayer* layerToRemove = [anim valueForKey:@"parentLayer"];
        [layerToRemove removeFromSuperlayer];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ctxStoneFieldObserver) {
        
        Stone* theStone = (Stone *)object;
        StoneLayer* theLayer = [stoneLayersIndexedByStoneID objectForKey:[theStone stoneID]];
        
        CheckersFieldPosition field;
        [[change valueForKey:NSKeyValueChangeNewKey] getValue:&field];
        
        CGPoint newPosition = CGPointMake(field.x * widthOfAField, field.y * heightOfAField);
        [theLayer setPosition:newPosition];
    }
    
    if (context == ctxStoneSelectedObserver) {
        Stone* theStone = (Stone *)object;
        StoneLayer* theLayer = [stoneLayersIndexedByStoneID objectForKey:[theStone stoneID]];
        
        BOOL selected = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        selected ? [theLayer setBorderWidth:5.0] : [theLayer setBorderWidth:0.0];
    }
}


@end
