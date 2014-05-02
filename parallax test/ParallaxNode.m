//
//  Hills.m
//  parallax test
//
//  Created by James Meyer on 4/29/14.
//  Copyright 2014 James Meyer. All rights reserved.
//

#import "ParallaxNode.h"
#import "CCTexture_Private.h"

//#define kMinimumDistanceX 60
//#define kMinimumDistanceY 40
//#define kRangeDistanceX 100
//#define kRangeDistanceY 120
//
//#define kSegmentWidth 1
//
//@implementation ParallaxLayer {
//	
//	NSMutableArray* _drawVertices;
//	int _drawCount;
//	NSMutableArray* _drawTexCoords;
//	
//    CGSize screenSize;
//	
//	int maxControlPoints;
//	CGPoint moveRatio;
//	
//    NSMutableArray* layerControlPoints;
//	
//	int firstNearKeyIndex;
//	int lastNearKeyIndex;
//	
//	float leftBoundary;
//	float rightBoundary;
//	
//	int nDrawVertices;
//}
//
//@synthesize drawVertices = _drawVertices;
//@synthesize drawCount = _drawCount;
//@synthesize drawTexCoords = _drawTexCoords;
//
//-(void)generateHills {
//    
//	float x = leftBoundary-kMinimumDistanceX;
//	float y = screenSize.height / 2;
//	
//	float dy;
//	float sign = -1;
//	
//	for ( int i = 0; i < maxControlPoints; i++ ) {
//		
//		CGPoint key = ccp( x , y );
//		
//		[layerControlPoints addObject:[NSValue valueWithCGPoint:key]];
//		
//		x += arc4random() % kRangeDistanceX + kMinimumDistanceX+40;
//		dy = arc4random() % kRangeDistanceY + kMinimumDistanceY+40;
//		y += dy * sign;
//
//		sign *= -1;
//    }
//}
//
//// need to check that end of line doesnt come on screen on either end
//-(void)translateLayerBy:(CGPoint)transPoint {
//	for (int i = 0; i < maxControlPoints; i++) {
//		CGPoint key = [[layerControlPoints objectAtIndex:i] CGPointValue];
//		
//		key = ccpAdd(key, ccp(transPoint.x * moveRatio.x,transPoint.y * moveRatio.y));
//		[layerControlPoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:key]];
//		
//		if (key.x < leftBoundary) firstNearKeyIndex = i; // should be just left of left boundary
//		if (key.x < rightBoundary) lastNearKeyIndex = i+1; // should be just right of right boundary
//	}
//		
//	CGPoint point0 = CGPointZero;
//	CGPoint point1 = CGPointZero;
//	CGPoint control0 = CGPointZero;
//	CGPoint control1 = CGPointZero;
//	
//	float scrWidth = screenSize.width;
//
//	[_drawVertices removeAllObjects];
//	[_drawTexCoords removeAllObjects];
////	[_drawTexCoords addObject:[NSValue valueWithCGPoint:point0]];
//	
//	_drawCount = 0;
//	
//	for ( int i = firstNearKeyIndex; i < lastNearKeyIndex; i++ ) {
//		control0 = [[layerControlPoints objectAtIndex:i] CGPointValue];
//		control1 = [[layerControlPoints objectAtIndex:i+1] CGPointValue];
//		
//		int hSegments = ceilf( (control1.x - control0.x) / kSegmentWidth );
//		float dx = (control1.x - control0.x) / hSegments;
//		float da = M_PI / hSegments;
//		float ymid = (control0.y + control1.y) / 2;
//		float ampl = (control0.y - control1.y) / 2;
//		
//		point0 = control0;
//		
//		for (int j = 1; j < hSegments+1; j++) {
//			point1.x = control0.x + (dx * j);
//			point1.y = ymid + (ampl * cosf(da * j));
//			
//			[_drawVertices addObject:[NSValue valueWithCGPoint:ccp(point0.x/screenSize.width , point0.y/screenSize.height)]];
//			[_drawVertices addObject:[NSValue valueWithCGPoint:ccp(point0.x/screenSize.width , 0.0f/screenSize.height)]];
//			[_drawVertices addObject:[NSValue valueWithCGPoint:ccp(point1.x/screenSize.width , point1.y/screenSize.height)]];
//			[_drawVertices addObject:[NSValue valueWithCGPoint:ccp(point1.x/screenSize.width , 0.0f/screenSize.height)]];
//			
//			[_drawTexCoords addObject:[NSValue valueWithCGPoint:ccp(point0.x/scrWidth , 1.0f)]];
//			[_drawTexCoords addObject:[NSValue valueWithCGPoint:ccp(point0.x/scrWidth , 0.0f)]];
//			[_drawTexCoords addObject:[NSValue valueWithCGPoint:ccp(point1.x/scrWidth , 1.0f)]];
//			[_drawTexCoords addObject:[NSValue valueWithCGPoint:ccp(point1.x/scrWidth , 0.0f)]];
//
//			_drawCount += 4;
//			
//			point0 = point1;
//		}
//    }
//}
//
//-(id)initWithControlPointCount:(int)ctlPointCount moveMultiplier:(CGPoint)moveMult {
//	self = [super init];
//	if (!self) return nil;
//	
//	maxControlPoints = ctlPointCount;
//	moveRatio = moveMult;
//	
//	layerControlPoints = [NSMutableArray array];
//	
//	screenSize = [[CCDirector sharedDirector] viewSize];
//	
//	leftBoundary = screenSize.width * -0.10;
//	rightBoundary = screenSize.width * 1.10;
//    
//	[self generateHills];
//	
//	[self translateLayerBy:CGPointZero];
//    
//	return self;
//}
//
//@end

//*****************************************************************************************

#define NEAR_RATIO 0.80f
#define MID_RATIO 0.30f
#define FAR_RATIO 0.05f

#define NEAR_DEFAULT_Y 300.0
#define MID_DEFAULT_Y 100.0
#define FAR_DEFAULT_Y -100.0

@implementation ParallaxNode {
	CCTexture* staticTexture;
	CCTexture* dynamicTexture;
	
	GLKVector2 layer1Pos;
	GLKVector2 layer2Pos;
	GLKVector2 layer3Pos;
	GLKVector2 scaleRatio;
	
	CGSize samplerSize;
	CGSize screenSize;
}

-(id)initWithImageNamed:(NSString *)imageName {
	self = [super initWithImageNamed:imageName];
	if (!self) return nil;
	
	self.position = ccp(512, 384);
	self.blendMode = [CCBlendMode disabledMode];
	self.texture.antialiased = NO;
	
	samplerSize = [[CCSprite spriteWithImageNamed:@"mountains2048a.png"] contentSize];
	screenSize = [[CCDirector sharedDirector] viewSize];
	
	scaleRatio = GLKVector2Make(screenSize.width/samplerSize.width/2 , screenSize.height/samplerSize.height/2);
	
	self.shader = [CCShader shaderNamed:@"parallax_test"];
	
	dynamicTexture = [CCTexture textureWithFile:@"mountains2048a.png"];
	dynamicTexture.antialiased = NO;
	ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_CLAMP_TO_EDGE};
	[dynamicTexture setTexParameters:&params];
	
	staticTexture = [CCTexture textureWithFile:@"background.png"];
	
	int maxX = (int)samplerSize.width;
	float randomX1 = arc4random_uniform(maxX);
	float randomX2 = randomX1 + samplerSize.width/2;
	float randomX3 = randomX2 + samplerSize.width/4;
	
	layer1Pos = GLKVector2Make(randomX1/samplerSize.width , NEAR_DEFAULT_Y/samplerSize.height/2);
	layer2Pos = GLKVector2Make(randomX2/samplerSize.width , MID_DEFAULT_Y/samplerSize.height/2);
	layer3Pos = GLKVector2Make(randomX3/samplerSize.width , FAR_DEFAULT_Y/samplerSize.height/2);
	
	self.shaderUniforms[@"u_staticTexture"] = staticTexture;
	self.shaderUniforms[@"u_dynamicTexture"] = dynamicTexture;
	
	self.shaderUniforms[@"u_layer1Coord"] = [NSValue valueWithGLKVector2:layer1Pos];
	self.shaderUniforms[@"u_layer2Coord"] = [NSValue valueWithGLKVector2:layer2Pos];
	self.shaderUniforms[@"u_layer3Coord"] = [NSValue valueWithGLKVector2:layer3Pos];
	self.shaderUniforms[@"u_scaleRatio"] = [NSValue valueWithGLKVector2:scaleRatio];
	
	self.shaderUniforms[@"u_nearColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.5412, 0.6471, 0.7922)];
	self.shaderUniforms[@"u_midColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.4300, 0.5600, 0.7300)];
	self.shaderUniforms[@"u_farColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.3294, 0.4824, 0.6941)];
	
//	self.shaderUniforms[@"u_nearColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.0, 1.0, 0.0)];
//	self.shaderUniforms[@"u_midColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(1.0, 0.0, 0.0)];
//	self.shaderUniforms[@"u_farColor"] = [NSValue valueWithGLKVector3:GLKVector3Make(0.0, 0.0, 1.0)];
	
	CCLOG(@"scaleRatio: %f , %f",scaleRatio.x,scaleRatio.y);
	CCLOG(@"samplerSize: %f , %f",samplerSize.width,samplerSize.height);
	CCLOG(@"screenSize: %f , %f",screenSize.width,screenSize.height);
	CCLOG(@"layer1Pos:  %f , %f",layer1Pos.x,layer1Pos.y);
	CCLOG(@"layer2Pos:  %f , %f",layer2Pos.x,layer2Pos.y);
	CCLOG(@"layer3Pos:  %f , %f",layer3Pos.x,layer3Pos.y);
	
	return self;
}

-(void)translateNodeBy:(GLKVector2)transPoint {
	layer1Pos = GLKVector2Add(layer1Pos, GLKVector2MultiplyScalar(transPoint, -NEAR_RATIO));
	layer2Pos = GLKVector2Add(layer2Pos, GLKVector2MultiplyScalar(transPoint, -MID_RATIO));
	layer3Pos = GLKVector2Add(layer3Pos, GLKVector2MultiplyScalar(transPoint, -FAR_RATIO));
	
	self.shaderUniforms[@"u_layer1Coord"] = [NSValue valueWithGLKVector2:layer1Pos];
	self.shaderUniforms[@"u_layer2Coord"] = [NSValue valueWithGLKVector2:layer2Pos];
	self.shaderUniforms[@"u_layer3Coord"] = [NSValue valueWithGLKVector2:layer3Pos];
}

@end
