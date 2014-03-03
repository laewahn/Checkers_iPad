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
    
    NSMutableArray* themStones = [NSMutableArray array];
    NSInteger numStones = 20;
    
    for (NSInteger i = 0; i < numStones; i++) {
        
        CheckersFieldPosition initialField = { ((2 * i + 1) % 10 - ( i / 5 % 2)), i / 5};
        Stone* newStone = [[Stone alloc] init];
        [newStone setColor:kStoneColorBlack];
        [newStone setField:initialField];
        
        [self.boardView addStone:newStone];
        [themStones addObject:newStone];
    }
    
    for (NSInteger i = 0; i < numStones; i++) {
        
        CheckersFieldPosition initialField = { ((2 * i + 1) % 10 - (i / 5 % 2)), 6 + i / 5};
        Stone* newStone = [[Stone alloc] init];
        [newStone setColor:kStoneColorWhite];
        [newStone setField:initialField];
        
        [self.boardView addStone:newStone];
        [themStones addObject:newStone];
    }
    
    Board* theBoard = [[Board alloc] initWithStones:themStones];

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
    BOOL moveIsValid = NO;
    
    CheckersFieldPosition currentField = [self.selectedStone field];
    
    NSInteger moveX = abs(nextField.x - currentField.x);
    NSInteger moveY = abs(nextField.y - currentField.y);
    
    moveIsValid |= (moveX == moveY && moveY == 1);

    CheckersFieldPosition nextFieldInDirection = {currentField.x + copysign(1.0, nextField.x - currentField.x), currentField.y + copysign(1.0, nextField.y - currentField.y)};
    
    Stone* stoneInNextFieldInDirection = [self.board stoneForField:nextFieldInDirection];
    
    moveIsValid |= (stoneInNextFieldInDirection != nil && [stoneInNextFieldInDirection color] != [self.selectedStone color] && moveX == moveY && moveX == 2);
    
    return moveIsValid;
}

@end
