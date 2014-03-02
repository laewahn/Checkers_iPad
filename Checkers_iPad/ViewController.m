//
//  ViewController.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "ViewController.h"

#import "Stone.h"
#import "Board.h"

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
    Board* theBoard = [[Board alloc] initWithStones:allStones];

    [self setBoard:theBoard];
}

-(void)boardViewFieldWasSelected:(CheckersFieldPosition)theField
{
    Stone* stoneForField = [self.board stoneForField:theField];
    
    if (stoneForField == nil) {
        [self.selectedStone setField:theField];
    }
    
    if (stoneForField == [self selectedStone]) {
        [self setSelectedStone:nil];
    } else {
        [self setSelectedStone:stoneForField];
    }
}

-(void)setSelectedStone:(Stone *)selectedStone
{
    [_selectedStone setSelected:NO];
    _selectedStone = selectedStone;
    [_selectedStone setSelected:YES];
}

@end
