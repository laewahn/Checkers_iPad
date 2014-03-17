//
//  CheckersDataTypes.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

typedef struct CheckersFieldPosition {
    NSInteger x;
    NSInteger y;
} CheckersFieldPosition;

typedef CheckersFieldPosition CheckersMove;

typedef enum CheckersStoneColor {
    kStoneColorWhite,
    kStoneColorBlack
} CheckersStoneColor;