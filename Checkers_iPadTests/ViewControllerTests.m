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

const CheckersMove MOVE_NE = { 1, -1};
const CheckersMove MOVE_SE = { 1,  1};
const CheckersMove MOVE_SW = { -1, 1};
const CheckersMove MOVE_NW = {-1, -1};

@interface ViewControllerTests : XCTestCase {
    ViewController* testViewController;
    
    Stone* blackStone;
	CheckersFieldPosition blackStoneField;
	
    id boardMock;
}
@end

@implementation ViewControllerTests

- (void) setUp
{
    testViewController = [[ViewController alloc] init];
    [testViewController viewDidLoad];
    
//    blackStone = [[Stone alloc] init];

	blackStoneField.x = 1; blackStoneField.y = 1;
//    [blackStone setField:blackStoneField];
//    [blackStone setColor:kStoneColorBlack];
    
    boardMock = [OCMockObject niceMockForClass:[Board class]];
//    [[[boardMock stub] andReturn:blackStone] stoneForField:blackStoneField];
    [testViewController setBoard:boardMock];
	
	blackStone = [self putStoneForPlayer:kStoneColorBlack onField:blackStoneField];
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
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    XCTAssertTrue([blackStone selected]);
}

- (void) testWhenSelectingAFieldWithAStoneTheStoneIsSetAsSelectedStone
{
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    XCTAssertEqualObjects([testViewController selectedStone], blackStone);
}

- (void) testWhenSelectingTheSelectedStoneItGetsUnselected
{
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    
    XCTAssertFalse([blackStone selected]);
    XCTAssertNil([testViewController selectedStone]);
}

- (void) testWhenStoneWasSelectedAndAnotherStoneIsSelectedNextTheFirstStoneIsUnselectedAndTheNewStoneIsSelected
{
    CheckersFieldPosition secondStoneField = {4,7};
    Stone* secondStone = [[Stone alloc] init];
    [secondStone setField:secondStoneField];
    
    [[[boardMock stub] andReturn:secondStone] stoneForField:secondStoneField];
    
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    [testViewController boardViewFieldWasSelected:[secondStone field]];
    
    XCTAssertFalse([blackStone selected]);
    XCTAssertTrue([secondStone selected]);
    
    XCTAssertEqualObjects([testViewController selectedStone], secondStone);
}

- (void) testWhenSelectingStoneAndThenSelectingEmptyFieldTheStoneIsMovedToThatField
{
    CheckersFieldPosition emptyfield = {2, 2};
    [[[boardMock stub] andReturn:nil] stoneForField:emptyfield];
    
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    [testViewController boardViewFieldWasSelected:emptyfield];
    
    XCTAssertTrue([blackStone isInField:emptyfield]);
}

- (void)testWhenMovingStoneTheStoneIsUnselected
{
    CheckersFieldPosition emptyfield = {2, 2};
    [[[boardMock stub] andReturn:nil] stoneForField:emptyfield];
    
    [testViewController boardViewFieldWasSelected:[blackStone field]];
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
    CheckersFieldPosition invalidNextField = {blackStoneField.x + 1, blackStoneField.y + 0};
    
    [testViewController boardViewFieldWasSelected:[blackStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];

    XCTAssertTrue([blackStone isInField:blackStoneField]);
}

- (void) testStoneCanOnlyBeMovedDiagonallyOneField
{
    CheckersFieldPosition invalidNextField = {blackStoneField.x + 2 * MOVE_SE.x, blackStoneField.y + 2 * MOVE_SE.y};

    [testViewController boardViewFieldWasSelected:[blackStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];
    
    XCTAssertTrue([blackStone isInField:blackStoneField]);
}

- (void)testBlackPlayerCannotMoveStoneBackwards
{
    CheckersFieldPosition invalidMove = {blackStoneField.x + MOVE_NW.x, blackStoneField.y + MOVE_NW.y};
	
	[testViewController boardViewFieldWasSelected:blackStoneField];
	[testViewController boardViewFieldWasSelected:invalidMove];
	
	XCTAssertTrue([blackStone isInField:blackStoneField]);
	XCTAssertFalse([blackStone isInField:invalidMove]);
}

- (void)testWhitePlayerCannotMoveStoneBackward
{
	CheckersFieldPosition whiteStoneField = {5,5};
	Stone* whiteStone = [self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
	
	CheckersFieldPosition invalidMove = {whiteStoneField.x + MOVE_SE.x, whiteStoneField.y + MOVE_SE.y};

	[testViewController setCurrentPlayerColor:kStoneColorWhite];
	[testViewController boardViewFieldWasSelected:whiteStoneField];
	[testViewController boardViewFieldWasSelected:invalidMove];
	
	XCTAssertTrue([whiteStone isInField:whiteStoneField]);
	XCTAssertFalse([blackStone isInField:invalidMove]);
}

- (void) testStoneCanBeMovedSouthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition whitePlayerField = {blackStoneField.x + MOVE_SE.x, blackStoneField.y + MOVE_SE.y};
    CheckersFieldPosition nextPosition = {blackStoneField.x + 2 * MOVE_SE.x, blackStoneField.y + 2 * MOVE_SE.y};
    
    [self putStoneForPlayer:kStoneColorWhite onField:whitePlayerField];
	
    [testViewController boardViewFieldWasSelected:blackStoneField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([blackStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedSouthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition whitePlayerField = {blackStoneField.x - 1, blackStoneField.y + 1};
    CheckersFieldPosition nextPosition = {blackStoneField.x + 2 * MOVE_SW.x, blackStoneField.y + 2 * MOVE_SW.y};
    
	[self putStoneForPlayer:kStoneColorWhite onField:whitePlayerField];
    
    [testViewController boardViewFieldWasSelected:blackStoneField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([blackStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedNorthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition whiteStoneField = {blackStoneField.x + MOVE_SE.x, blackStoneField.y + MOVE_SE.y};
    CheckersFieldPosition nextPosition = {blackStoneField.x + MOVE_NW.x, blackStoneField.y + MOVE_NW.y};
    
	[testViewController setCurrentPlayerColor:kStoneColorWhite];
	Stone* whiteStone = [self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
    
    [testViewController boardViewFieldWasSelected:whiteStoneField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([whiteStone isInField:nextPosition]);
}


- (void) testStoneCanBeMovedNorthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition whiteStoneField = {blackStoneField.x + MOVE_SW.x, blackStoneField.y + MOVE_SW.y};
    CheckersFieldPosition nextPosition = {blackStoneField.x + MOVE_NE.x, blackStoneField.y + MOVE_NE.y};
    
	[testViewController setCurrentPlayerColor:kStoneColorWhite];
	Stone* whiteStone = [self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
    
    [testViewController boardViewFieldWasSelected:whiteStoneField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([whiteStone isInField:nextPosition]);
}

- (void) testWhenOnePlayerMovesStoneHeCannotSelectAnotherStone
{
	CheckersFieldPosition nextField = {blackStoneField.x + MOVE_SW.x, blackStoneField.y + MOVE_SW.y};

	CheckersFieldPosition whiteStoneField = {5,5};
	[self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
	
	[testViewController boardViewFieldWasSelected:blackStoneField];
	[testViewController boardViewFieldWasSelected:nextField];
	[[[boardMock stub] andReturn:blackStone] stoneForField:nextField];
	
	[testViewController boardViewFieldWasSelected:nextField];
	
	XCTAssertNotEqualObjects([testViewController selectedStone], blackStone);
}

- (void)testWhenOnePlayerMovesStoneTheOtherPlayerCanSelectStone
{
	CheckersFieldPosition nextField = {blackStoneField.x + MOVE_SW.x, blackStoneField.y + MOVE_SW.y};
	
	CheckersFieldPosition whiteStoneField = {5,5};
	Stone* whiteStone = [self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
	
	[testViewController boardViewFieldWasSelected:blackStoneField];
	[testViewController boardViewFieldWasSelected:nextField];
	
	[testViewController boardViewFieldWasSelected:whiteStoneField];
	
	XCTAssertNotEqualObjects([testViewController selectedStone], blackStone);
	XCTAssertEqualObjects([testViewController selectedStone], whiteStone);
}

- (void) testWhenCapturingOpponentStoneThatStoneGetsRemoved
{
	id boardViewMock = [OCMockObject mockForClass:[CheckersBoardView class]];
	[testViewController setBoardView:boardViewMock];

	CheckersFieldPosition whiteStoneField = {blackStoneField.x + MOVE_SW.x, blackStoneField.y + MOVE_SW.y};
	CheckersFieldPosition nextPosition = {blackStoneField.x + 2 * MOVE_SW.x, blackStoneField.y + 2* MOVE_SW.y};

	Stone* whiteStone = [self putStoneForPlayer:kStoneColorWhite onField:whiteStoneField];
	
	[[boardViewMock expect] removeStone:whiteStone];
	[[boardMock expect] removeStone:whiteStone];

	[testViewController boardViewFieldWasSelected:blackStoneField];
	[testViewController boardViewFieldWasSelected:nextPosition];
	
	[boardMock verify];
	[boardViewMock verify];
}

# pragma mark Helpers

- (Stone *) putStoneForPlayer:(CheckersStoneColor)playerColor onField:(CheckersFieldPosition)field
{
	Stone* aStone = [[Stone alloc] init];
    [aStone setField:field];
    [aStone setColor:playerColor];
    [[[boardMock stub] andReturn:aStone] stoneForField:field];
	
	return aStone;
}

@end
