//
//  Board.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 02/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CheckersDataTypes.h"

@class Stone;

@interface Board : NSObject

- (id)initWithStones:(NSArray *)stones;

- (Stone *) stoneForField:(CheckersFieldPosition) field;

@end
