//
//  StoneLayer.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CheckersDataTypes.h"

@interface StoneLayer : CALayer

+(StoneLayer *)layerWithSize:(CGSize)theSize color:(CheckersStoneColor) color;

-(CAAnimation *)createRemoveAnimation;

@end
