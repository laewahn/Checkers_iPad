//
//  BoardTests.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 02/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Board.h"
#import "Stone.h"

@interface BoardTests : XCTestCase {
    Stone* aStone;
    Stone* anotherStone;
    
    Board* testBoard;
}
@end

@implementation BoardTests

- (void) setUp
{
    aStone = [[Stone alloc] init];
    CheckersFieldPosition aStoneField = {1, 5};
    [aStone setField:aStoneField];
    
    anotherStone = [[Stone alloc] init];
    CheckersFieldPosition anotherStoneField = {0,6};
    [anotherStone setField:anotherStoneField];
    
    NSArray* stones = @[aStone, anotherStone];
    testBoard = [[Board alloc] initWithStones:stones];
}

- (void) testBoardCanBeInitializedWithStones
{
    NSArray* stones = @[aStone, anotherStone];
    XCTAssertNoThrow(testBoard = [[Board alloc] initWithStones:stones]);
}

- (void) testRequestingStoneForAFieldWithAStoneReturnsTheStone
{
    XCTAssertEqualObjects([testBoard stoneForField:[aStone field]], aStone);
    XCTAssertEqualObjects([testBoard stoneForField:[anotherStone field]], anotherStone);
}

- (void) testRequestingStoneForFieldWithNoStoneReturnsNil
{
    CheckersFieldPosition noStoneField = {3,3};
    XCTAssertNil([testBoard stoneForField:noStoneField]);
}

@end
