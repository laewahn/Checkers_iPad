//
//  CheckersBoardView.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct CheckersFieldPosition {
    NSInteger x;
    NSInteger y;
} CheckersFieldPosition;


@protocol CheckersBoardViewDelegate
-(void)boardViewFieldWasSelected:(CheckersFieldPosition) theField;
@end

@interface CheckersBoardView : UIView

-(void) moveStoneToField:(CheckersFieldPosition) position;

@property(assign) IBOutlet id<CheckersBoardViewDelegate> delegate;

@end
