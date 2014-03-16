//
//  ViewControllerTests.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 02/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "ViewController.h"

#import "Board.h"
#import "Stone.h"

@interface ViewControllerTests : XCTestCase {
    ViewController* testViewController;
    
    Stone* someStone;
	Stone* opponentStone;
	
	CheckersFieldPosition currentField;
	
    id boardMock;
}
@end

@implementation ViewControllerTests

- (void) setUp
{
    testViewController = [[ViewController alloc] init];
    [testViewController viewDidLoad];
    
    someStone = [[Stone alloc] init];

	currentField.x = 1; currentField.y = 1;
    [someStone setField:currentField];
    [someStone setColor:kStoneColorBlack];
    
    boardMock = [OCMockObject niceMockForClass:[Board class]];
    [[[boardMock stub] andReturn:someStone] stoneForField:currentField];
    [testViewController setBoard:boardMock];
}

- (void) testViewControllerKeepsTrackAboutTheSelectedStone
{
    XCTAssertNoThrow([testViewController selectedStone]);
}

- (void) testAfterLoadingTheViewHasABoard
{
    XCTAssertNotNil([testViewController board]);
}

- (void) testAfterLoadingTheViewNoStoneIsSelected
{
    XCTAssertNil([testViewController selectedStone], @"No stone should have been selected yet.");
}

- (void) testWhenSelectingAFieldWithAStoneTheStoneGetsSelected
{
    [testViewController boardViewFieldWasSelected:[someStone field]];
    XCTAssertTrue([someStone selected]);
}

- (void) testWhenSelectingAFieldWithAStoneTheStoneIsSetAsSelectedStone
{
    [testViewController boardViewFieldWasSelected:[someStone field]];
    XCTAssertEqualObjects([testViewController selectedStone], someStone);
}

- (void) testWhenSelectingTheSelectedStoneItGetsUnselected
{
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:[someStone field]];
    
    XCTAssertFalse([someStone selected]);
    XCTAssertNil([testViewController selectedStone]);
}

- (void) testWhenStoneWasSelectedAndAnotherStoneIsSelectedNextTheFirstStoneIsUnselectedAndTheNewStoneIsSelected
{
    CheckersFieldPosition secondStoneField = {4,7};
    Stone* secondStone = [[Stone alloc] init];
    [secondStone setField:secondStoneField];
    
    [[[boardMock stub] andReturn:secondStone] stoneForField:secondStoneField];
    
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:[secondStone field]];
    
    XCTAssertFalse([someStone selected]);
    XCTAssertTrue([secondStone selected]);
    
    XCTAssertEqualObjects([testViewController selectedStone], secondStone);
}

- (void) testWhenSelectingStoneAndThenSelectingEmptyFieldTheStoneIsMovedToThatField
{
    CheckersFieldPosition emptyfield = {2, 2};
    [[[boardMock stub] andReturn:nil] stoneForField:emptyfield];
    
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:emptyfield];
    
    XCTAssertTrue([someStone isInField:emptyfield]);
}

- (void)testWhenMovingStoneTheStoneIsUnselected
{
    CheckersFieldPosition emptyfield = {2, 2};
    [[[boardMock stub] andReturn:nil] stoneForField:emptyfield];
    
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:emptyfield];
    
	XCTAssertNil([testViewController selectedStone]);
}


# pragma mark Allowed movements

//      N
//
// W    + - - > x   E
//      |
//      |
//      |
//      V  y
//
//      S

- (void) testStoneCanOnlyBeMovedDiagonally
{
    CheckersFieldPosition invalidNextField = {currentField.x + 1,currentField.y + 0};
    
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];

    XCTAssertTrue([someStone isInField:currentField]);
}

- (void) testStoneCanOnlyBeMovedDiagonallyOneField
{
    CheckersFieldPosition invalidNextField = {currentField.x + 2,currentField.y + 2};

    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];
    
    XCTAssertTrue([someStone isInField:currentField]);
}

- (void)testBlackPlayerCannotMoveStoneBackwards
{
    CheckersFieldPosition invalidMove = {currentField.x - 1, currentField.y - 1};
	
	[testViewController boardViewFieldWasSelected:currentField];
	[testViewController boardViewFieldWasSelected:invalidMove];
	
	XCTAssertTrue([someStone isInField:currentField]);
	XCTAssertFalse([someStone isInField:invalidMove]);
}

- (void)testWhitePlayerCannotMoveStoneBackward
{
	CheckersFieldPosition opponentField = {5,5};
	[self putOpponentStoneOnField:opponentField];
	
	CheckersFieldPosition invalidMove = {opponentField.x + 1, opponentField.y + 1};

	[testViewController setCurrentPlayerColor:kStoneColorWhite];
	[testViewController boardViewFieldWasSelected:opponentField];
	[testViewController boardViewFieldWasSelected:invalidMove];
	
	XCTAssertTrue([opponentStone isInField:opponentField]);
	XCTAssertFalse([someStone isInField:invalidMove]);
}

- (void) testStoneCanBeMovedSouthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition opponentsField = {currentField.x + 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x + 2, currentField.y + 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedSouthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition opponentsField = {currentField.x - 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x - 2, currentField.y + 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedNorthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition opponentsField = {currentField.x + 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x - 1, currentField.y - 1};
    
	[testViewController setCurrentPlayerColor:kStoneColorWhite];
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:opponentsField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([opponentStone isInField:nextPosition]);
}


- (void) testStoneCanBeMovedNorthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition opponentsField = {currentField.x - 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x + 1, currentField.y - 1};
    
	[testViewController setCurrentPlayerColor:kStoneColorWhite];
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:opponentsField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([opponentStone isInField:nextPosition]);
}

- (void) testWhenOnePlayerMovesStoneHeCannotSelectAnotherStone
{
	CheckersFieldPosition nextField = {currentField.x + 1, currentField.y + 1};

	CheckersFieldPosition opponentsField = {5,5};
	[self putOpponentStoneOnField:opponentsField];
	
	[testViewController boardViewFieldWasSelected:currentField];
	[testViewController boardViewFieldWasSelected:nextField];
	[[[boardMock stub] andReturn:someStone] stoneForField:nextField];
	
	[testViewController boardViewFieldWasSelected:nextField];
	
	XCTAssertNotEqualObjects([testViewController selectedStone], someStone);
}

- (void)testWhenOnePlayerMovesStoneTheOtherPlayerCanSelectStone
{
	CheckersFieldPosition nextField = {currentField.x + 1, currentField.y + 1};
	
	CheckersFieldPosition opponentsField = {5,5};
	[self putOpponentStoneOnField:opponentsField];
	
	[testViewController boardViewFieldWasSelected:currentField];
	[testViewController boardViewFieldWasSelected:nextField];
	
	[testViewController boardViewFieldWasSelected:opponentsField];
	
	XCTAssertNotEqualObjects([testViewController selectedStone], someStone);
	XCTAssertEqualObjects([testViewController selectedStone], opponentStone);
}

- (void) testWhenCapturingOpponentStoneThatStoneGetsRemoved
{
	id boardViewMock = [OCMockObject mockForClass:[CheckersBoardView class]];
	[testViewController setBoardView:boardViewMock];

	CheckersFieldPosition opponentsField = {currentField.x + 1, currentField.y + 1};
	CheckersFieldPosition nextPosition = {currentField.x + 2, currentField.y + 2};

	[self putOpponentStoneOnField:opponentsField];

	[[boardViewMock expect] removeStone:opponentStone];
	[[boardMock expect] removeStone:opponentStone];

	[testViewController boardViewFieldWasSelected:currentField];
	[testViewController boardViewFieldWasSelected:nextPosition];
	
	[boardMock verify];
	[boardViewMock verify];
}

# pragma mark Helpers

- (void) putOpponentStoneOnField: (CheckersFieldPosition) opponentsField
{
    opponentStone = [[Stone alloc] init];
    [opponentStone setField:opponentsField];
    [opponentStone setColor:kStoneColorWhite];
    [[[boardMock stub] andReturn:opponentStone] stoneForField:opponentsField];
}

@end
