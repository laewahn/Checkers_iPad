//
//  Stone.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CheckersStoneColor {
    kStoneColorWhite,
    kStoneColorBlack
} CheckersStoneColor;

@interface Stone : NSObject

@property CheckersStoneColor color;

@end
