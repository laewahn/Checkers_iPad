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
    id boardMock;
}
@end

@implementation ViewControllerTests

- (void) setUp
{
    testViewController = [[ViewController alloc] init];
    [testViewController viewDidLoad];
    
    someStone = [[Stone alloc] init];
    CheckersFieldPosition someStoneField = {1,1};
    [someStone setField:someStoneField];
    [someStone setColor:kStoneColorBlack];
    
    boardMock = [OCMockObject niceMockForClass:[Board class]];
    [[[boardMock stub] andReturn:someStone] stoneForField:someStoneField];
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

- (void) testStoneCanOnlyBeMovedDiagonally
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition invalidNextField = {currentField.x + 1,currentField.y + 0};
    
    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];

    XCTAssertTrue([someStone isInField:currentField]);
}

- (void) testStoneCanOnlyBeMovedDiagonallyOneField
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition invalidNextField = {currentField.x + 2,currentField.y + 2};

    [testViewController boardViewFieldWasSelected:[someStone field]];
    [testViewController boardViewFieldWasSelected:invalidNextField];
    
    XCTAssertTrue([someStone isInField:currentField]);
}

- (void) testStoneCanBeMovedSouthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition opponentsField = {currentField.x + 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x + 2, currentField.y + 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedNorthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition opponentsField = {currentField.x - 1, currentField.y - 1};
    CheckersFieldPosition nextPosition = {currentField.x - 2, currentField.y - 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedSouthWestTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition opponentsField = {currentField.x + 1, currentField.y - 1};
    CheckersFieldPosition nextPosition = {currentField.x + 2, currentField.y - 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) testStoneCanBeMovedNorthEastTwoFieldsIfHeCanCaptureAnOponentStone
{
    CheckersFieldPosition currentField = [someStone field];
    CheckersFieldPosition opponentsField = {currentField.x - 1, currentField.y + 1};
    CheckersFieldPosition nextPosition = {currentField.x - 2, currentField.y + 2};
    
    [self putOpponentStoneOnField:opponentsField];
    
    [testViewController boardViewFieldWasSelected:currentField];
    [testViewController boardViewFieldWasSelected:nextPosition];
    
    XCTAssertTrue([someStone isInField:nextPosition]);
}

- (void) putOpponentStoneOnField: (CheckersFieldPosition) opponentsField
{
    Stone* opponentStone = [[Stone alloc] init];
    [opponentStone setField:opponentsField];
    [opponentStone setColor:kStoneColorWhite];
    [[[boardMock stub] andReturn:opponentStone] stoneForField:opponentsField];
}

@end
