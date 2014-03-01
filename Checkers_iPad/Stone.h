//
//  Stone.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CheckersDataTypes.h"

@interface Stone : NSObject

@property CheckersStoneColor color;
@property CheckersFieldPosition field;

-(NSNumber *)stoneID;
-(BOOL) isInField:(CheckersFieldPosition) theField;

@end
