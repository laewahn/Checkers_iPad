//
//  ViewController.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "ViewController.h"

#import "Stone.h"
#import "StoneLayer.h"

@interface ViewController () {
    NSArray* allStones;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Stone* aStone = [[Stone alloc] init];
    [aStone setColor:kStoneColorBlack];
    
    [self.boardView addStone:aStone];
    
    Stone* anotherStone = [[Stone alloc] init];
    [anotherStone setColor:kStoneColorWhite];

    CheckersFieldPosition field = {5,5};
    [anotherStone setField:field];
    
    [self.boardView addStone:anotherStone];
    
    allStones = @[aStone, anotherStone];
}

-(void)boardViewFieldWasSelected:(CheckersFieldPosition)theField
{
    Stone* stoneInField = nil;
    
    for (Stone* aStone in allStones) {
        if ([aStone isInField:theField]) {
            stoneInField = aStone;
        }
    }
    
    [stoneInField setSelected:![stoneInField selected]];
}

@end
