//
//  HelloWorldScene.m
//  color test
//
//  Created by James Meyer on 4/23/14.
//  Copyright James Meyer 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#define NEAR_RATIO 0.50f
#define MID_RATIO 0.20f
#define FAR_RATIO 0.10f

#define NEAR_DEFAULT_Y 400.0
#define MID_DEFAULT_Y 300.0
#define FAR_DEFAULT_Y 200.0


#import "HelloWorldScene.h"
#import "CCNode_Private.h"
#import "CCTexture_Private.h"

@implementation HelloWorldScene {
	CCSprite* background;
	
	CCTexture* staticTexture;
	CCTexture* dynamicTexture;
	
	GLKVector2 layer1Pos;
	GLKVector2 layer2Pos;
	GLKVector2 layer3Pos;
	GLKVector2 scaleRatio;
	
	CGSize samplerSize;
	CGSize screenSize;
}

+ (HelloWorldScene *)scene {
    return [[self alloc] init];
}

-(id)init {
    self = [super init];
    if (!self) return(nil);

	background = [CCSprite spriteWithImageNamed:@"background.png"];
	background.position = ccp(512, 384);
	background.blendMode = [CCBlendMode disabledMode];
	background.texture.antialiased = NO;
	[self addChild:background];
		
	samplerSize = [[CCSprite spriteWithImageNamed:@"mountains2048a.png"] contentSize];
	screenSize = [[CCDirector sharedDirector] viewSize];
	
	scaleRatio = GLKVector2Make(screenSize.width/samplerSize.width/2 , screenSize.height/samplerSize.height/2);
	
	background.shader = [CCShader shaderNamed:@"parallax_test"];

	dynamicTexture = [CCTexture textureWithFile:@"mountains2048a.png"];
	dynamicTexture.antialiased = NO;
	ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_CLAMP_TO_EDGE};
	[dynamicTexture setTexParameters:&params];

	staticTexture = [CCTexture textureWithFile:@"background.png"];

	int maxX = (int)samplerSize.width;
	float randomX1 = arc4random_uniform(maxX);
	float randomX2 = randomX1 + samplerSize.width/3;
	float randomX3 = randomX2 + samplerSize.width/3;

	layer1Pos = GLKVector2Make(randomX1/samplerSize.width , NEAR_DEFAULT_Y/samplerSize.height/2);
	layer2Pos = GLKVector2Make(randomX2/samplerSize.width , MID_DEFAULT_Y/samplerSize.height/2);
	layer3Pos = GLKVector2Make(randomX3/samplerSize.width , FAR_DEFAULT_Y/samplerSize.height/2);

	background.shaderUniforms[@"u_staticTexture"] = staticTexture;
	background.shaderUniforms[@"u_dynamicTexture"] = dynamicTexture;

	background.shaderUniforms[@"u_layer1Coord"] = [NSValue valueWithGLKVector2:layer1Pos];
	background.shaderUniforms[@"u_layer2Coord"] = [NSValue valueWithGLKVector2:layer2Pos];
	background.shaderUniforms[@"u_layer3Coord"] = [NSValue valueWithGLKVector2:layer3Pos];
	background.shaderUniforms[@"u_scaleRatio"] = [NSValue valueWithGLKVector2:scaleRatio];

	background.shaderUniforms[@"u_farColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.3294, 0.4824, 0.6941)];
	background.shaderUniforms[@"u_midColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.4300, 0.5600, 0.7300)];
	background.shaderUniforms[@"u_nearColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.5412, 0.6471, 0.7922)];

//	background.shaderUniforms[@"u_midColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(1.0, 0.0, 0.0)];
//	background.shaderUniforms[@"u_nearColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.0, 1.0, 0.0)];
//	background.shaderUniforms[@"u_farColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.0, 0.0, 1.0)];

	CCLOG(@"scaleRatio: %f , %f",scaleRatio.x,scaleRatio.y);
	CCLOG(@"samplerSize: %f , %f",samplerSize.width,samplerSize.height);
	CCLOG(@"screenSize: %f , %f",screenSize.width,screenSize.height);
	CCLOG(@"layer1Pos:  %f , %f",layer1Pos.x,layer1Pos.y);
	CCLOG(@"layer2Pos:  %f , %f",layer2Pos.x,layer2Pos.y);
	CCLOG(@"layer3Pos:  %f , %f",layer3Pos.x,layer3Pos.y);

	return self;
}

//-(void)fixedUpdate:(CCTime)dt {
//	float newLayer1x = layer1Pos.x + NEAR_RATIO;
//	if (newLayer1x > samplerSize.width) newLayer1x -= samplerSize.width;
//	float newLayer2x = layer2Pos.x + MID_RATIO;
//	if (newLayer2x > samplerSize.width) newLayer2x -= samplerSize.width;
//	float newLayer3x = layer3Pos.x + FAR_RATIO;
//	if (newLayer3x > samplerSize.width) newLayer3x -= samplerSize.width;
//	
//	layer1Pos = ccp(newLayer1x,layer1Pos.y);
//	layer2Pos = ccp(newLayer2x,layer2Pos.y);
//	layer3Pos = ccp(newLayer3x,layer3Pos.y);
//	
//	GLfloat l1p [] = {layer1Pos.x , layer1Pos.y};
//	GLfloat l2p [] = {layer2Pos.x , layer2Pos.y};
//	GLfloat l3p [] = {layer3Pos.x , layer3Pos.y};
//	
//	[background.shaderProgram use];
//	[background.shaderProgram setUniformLocation:layer1PositionLocation with2fv:l1p count:1];
//	[background.shaderProgram setUniformLocation:layer2PositionLocation with2fv:l2p count:1];
//	[background.shaderProgram setUniformLocation:layer3PositionLocation with2fv:l3p count:1];
//
//}

@end
