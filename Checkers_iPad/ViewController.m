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

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	_currentPlayerColor = kStoneColorBlack;
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
	
	if ([self selectedStone] || stoneForField.color == [self currentPlayerColor]) {
		
		if (stoneForField == nil) {
			if ([self moveIsValid:nextField]) {
				[self.selectedStone setField:nextField];
				[self switchPlayers];
			}
		}
		
		if (stoneForField == [self selectedStone]) {
			stoneForField = nil;
		}
		
		[self setSelectedStone:stoneForField];
	}
}

-(void)switchPlayers
{
	CheckersStoneColor nextPlayerColor = ([self currentPlayerColor] == kStoneColorBlack) ? kStoneColorWhite : kStoneColorBlack;
	[self setCurrentPlayerColor:nextPlayerColor];
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
	moveIsValid |= [self moveIsNormalMove:nextField];
	
	if (moveIsValid) {
		return moveIsValid;
	}
	
    CheckersFieldPosition nextFieldInDirection = {currentField.x + copysign(1.0, nextField.x - currentField.x), currentField.y + copysign(1.0, nextField.y - currentField.y)};
    Stone* stoneInNextFieldInDirection = [self.board stoneForField:nextFieldInDirection];
	moveIsValid |= [self moveIsCaptureMove:nextField];
    
	if (moveIsValid) {
		[self.board removeStone:stoneInNextFieldInDirection];
		[self.boardView removeStone:stoneInNextFieldInDirection];
		return moveIsValid;
	}
	
	return NO;
}

-(BOOL)moveIsNormalMove:(CheckersFieldPosition) nextField
{
	CheckersFieldPosition currentField = [self.selectedStone field];
    
    NSInteger moveX = nextField.x - currentField.x;
    NSInteger moveY = nextField.y - currentField.y;
    
    return ((abs(moveX) == abs(moveY) && moveY == 1 && [self currentPlayerColor] == kStoneColorBlack) ||
			(abs(moveX) == abs(moveY) && moveY == -1 && [self currentPlayerColor] == kStoneColorWhite) );
	
}

-(BOOL)moveIsCaptureMove:(CheckersFieldPosition) nextField
{
	CheckersFieldPosition currentField = [self.selectedStone field];
	
	NSInteger moveX = nextField.x - currentField.x;
    NSInteger moveY = nextField.y - currentField.y;
	
	CheckersFieldPosition nextFieldInDirection = {currentField.x + copysign(1.0, nextField.x - currentField.x), currentField.y + copysign(1.0, nextField.y - currentField.y)};
    
    Stone* stoneInNextFieldInDirection = [self.board stoneForField:nextFieldInDirection];
    
	BOOL canCaptureOpponentStone = stoneInNextFieldInDirection != nil && [stoneInNextFieldInDirection color] != [self.selectedStone color];
	BOOL captureMoveIsValid =	(abs(moveX) == abs(moveY) && moveY == 2 && [self currentPlayerColor] == kStoneColorBlack) ||
								(abs(moveX) == abs(moveY) && moveY == -2 && [self currentPlayerColor] == kStoneColorWhite);
	
	return canCaptureOpponentStone && captureMoveIsValid;
}

@end
