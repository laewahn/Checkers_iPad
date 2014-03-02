//
//  Board.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 02/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "Board.h"

#import "Stone.h"

@interface Board () {
    NSArray* allStones;
}

@end

@implementation Board

- (id)initWithStones:(NSArray *)stones
{
    self = [super init];
    if (self) {
        allStones = stones;
    }
    return self;
}

- (Stone *) stoneForField:(CheckersFieldPosition) field
{
    Stone* stoneToReturn = nil;
    
    for (Stone* someStone in allStones) {
        if ([someStone isInField:field]) {
            stoneToReturn = someStone;
            break;
        }
    }
    
    return stoneToReturn;
}

@end
