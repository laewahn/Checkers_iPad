//
//  CheckersBoardView.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CheckersDataTypes.h"

@class StoneLayer;
@class Stone;

@protocol CheckersBoardViewDelegate
-(void)boardViewFieldWasSelected:(CheckersFieldPosition) theField;
@end

@interface CheckersBoardView : UIView

-(void) addStone:(Stone *)theStone;
-(void) removeStone:(Stone *)theStone;

@property(assign) IBOutlet id<CheckersBoardViewDelegate> delegate;

@end
