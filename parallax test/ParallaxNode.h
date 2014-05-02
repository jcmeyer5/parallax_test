//
//  Hills.h
//  parallax test
//
//  Created by James Meyer on 4/29/14.
//  Copyright 2014 James Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//@interface ParallaxLayer : NSObject {}
//
//@property NSMutableArray* drawVertices;
//@property int drawCount;
//@property NSMutableArray* drawTexCoords;
//
//
//-(id)initWithControlPointCount:(int)ctlPointCount moveMultiplier:(CGPoint)moveMult;
//
//-(void)translateLayerBy:(CGPoint)transPoint;
//
//@end
//
//*********************************************************************

@interface ParallaxNode : CCSprite {}

-(void)translateNodeBy:(GLKVector2)transPoint;

@end
