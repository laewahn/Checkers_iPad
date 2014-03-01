//
//  Stone.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "Stone.h"

@implementation Stone


-(NSNumber *)stoneID
{
    return [NSNumber numberWithInt:[self hash]];
}

-(BOOL) isInField:(CheckersFieldPosition) theField
{
    CheckersFieldPosition myField = [self field];
    return myField.x == theField.x && myField.y == theField.y;
}

@end
