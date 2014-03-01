//
//  ViewController.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CheckersBoardView.h"

@interface ViewController : UIViewController<CheckersBoardViewDelegate>

@property (weak, nonatomic) IBOutlet CheckersBoardView *boardView;

@end
