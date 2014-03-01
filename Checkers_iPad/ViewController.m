//
//  ViewController.m
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import "ViewController.h"

#import "Stone.h"
#import "StoneLayer.h"

@interface ViewController () {
    Stone* aStone;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aStone = [[Stone alloc] init];
    [aStone setColor:kStoneColorBlack];
    
    [self.boardView addStone:aStone];
    
    Stone* anotherStone = [[Stone alloc] init];
    [anotherStone setColor:kStoneColorWhite];

    CheckersFieldPosition field = {5,5};
    [anotherStone setField:field];
    
    [self.boardView addStone:anotherStone];

}

-(void)boardViewFieldWasSelected:(CheckersFieldPosition)theField
{
    if ([aStone isInField:theField]) {
        [self.boardView removeStone:aStone];
    } else {
        [aStone setField:theField];
    }
}

@end
