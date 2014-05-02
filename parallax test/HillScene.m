//
//  HillScene.m
//  parallax test
//
//  Created by James Meyer on 4/30/14.
//  Copyright 2014 James Meyer. All rights reserved.
//

#import "HillScene.h"
#import "ParallaxNode.h"

@implementation HillScene {
    ParallaxNode* hillNode;
	
	CGPoint lastPosition;
	
	CGSize screenSize;
}

+(HillScene*)scene {
    return [[self alloc] init];
}

-(id)init {
    self = [super init];
    if (!self) return nil;
	
	self.userInteractionEnabled = YES;
	
	screenSize = [[CCDirector sharedDirector] viewSize];
    
    hillNode = [[ParallaxNode alloc] initWithImageNamed:@"background.png"];
	[self addChild:hillNode];
	
    
    return self;
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	lastPosition = [touch locationInNode:self];
	
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchLoc = [touch locationInNode:self];
	CGPoint translation = ccpSub(touchLoc,lastPosition);
	GLKVector2 transPoint = GLKVector2Make(translation.x/screenSize.width, translation.y/screenSize.height);
	lastPosition = touchLoc;
	
	[hillNode translateNodeBy:transPoint];
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	lastPosition = CGPointZero;
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	[self touchEnded:touch withEvent:event];
}

@end
