//
//  StoneLayer.h
//  Checkers_iPad
//
//  Created by Dennis Lewandowski on 01/03/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class Stone;

@interface StoneLayer : CALayer

+(StoneLayer *)layerForStone:(Stone *)aStone size:(CGSize)size;

-(CAAnimation *)createRemoveAnimation;

@end
