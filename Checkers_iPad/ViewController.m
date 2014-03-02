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

-(void)boardViewFieldWasSelected:(CheckersFieldPosition)nextField
{
    Stone* stoneForField = [self.board stoneForField:nextField];
    
    if (stoneForField == nil) {
        if ([self moveIsValid:nextField]) {
            [self.selectedStone setField:nextField];
        }
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

-(BOOL)moveIsValid:(CheckersFieldPosition) nextField
{
    CheckersFieldPosition currentField = [self.selectedStone field];
    
    NSInteger moveX = abs(nextField.x - currentField.x);
    NSInteger moveY = abs(nextField.y - currentField.y);
    
    return moveX == moveY && moveY == 1;
}

@end
