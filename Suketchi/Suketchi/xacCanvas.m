//
//  xacCanvas.m
//  Suketchi
//
//  Created by Xiang 'Anthony' Chen on 4/8/13.
//  Copyright (c) 2013 hotnAny. All rights reserved.
//

#import "xacCanvas.h"
#define MAXTOUCHPOINTS 10
#define FADEOUTTIME 0.5

@implementation xacCanvas

UIColor *brushColor;
BOOL isTouchDown;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // single-stroke
//        _path = [[UIBezierPath alloc] init];
//        _path.lineWidth = 5;
//        _path.miterLimit = -10;
//        _path.lineCapStyle = kCGLineJoinMiter;
        //
        
        // multi-stroke
        _touchPoints = [[NSMutableArray alloc] init];
        _touchAfterEffect = [[NSMutableDictionary alloc] init];
        _drawnPaths = [[NSMutableArray alloc] init];
        _pathMap = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < MAXTOUCHPOINTS; i++) {
            UIBezierPath *tmpPath = [[UIBezierPath alloc] init];
            tmpPath.lineWidth = 5;
            tmpPath.miterLimit = -10;
            tmpPath.lineCapStyle = kCGLineJoinMiter;
        }
        //

        _isTemp = FALSE;
        _toFade = FALSE;
        isTouchDown = FALSE;
        
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(updateCanvas)
                                       userInfo:nil
                                        repeats:YES];
        
        _touchClassifier = [[TouchClassifier alloc] init];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    brushColor = [UIColor colorWithRed: _isTemp ? 255 : 0 green:0 blue:0 alpha:0.85];
    [brushColor setStroke];

    // single-touch
//    [_path strokeWithBlendMode:kCGBlendModeNormal alpha:0.75];
    //
    
    // multi-stroke
    float strokeAlpha = 0.85f;
    if(_toFade) {
        NSArray *tmpTouchPoints = [[NSArray alloc] initWithArray:_touchPoints];
        for(UITouch *touch in tmpTouchPoints) {
            NSString* key = [NSString stringWithFormat:@"%d", [touch hash]];
            UIBezierPath *path = [_pathMap objectForKey:key];
            
                NSNumber *tmpNSNum = [_touchAfterEffect objectForKey:key];
                
                strokeAlpha = [tmpNSNum floatValue];
                strokeAlpha *= 0.8;
                if(strokeAlpha < 0.01) {
                    [_pathMap removeObjectForKey:key];
                    [_drawnPaths removeObject:path];
                    [_touchPoints removeObject:touch];
                }
                
            [_touchAfterEffect setObject:[NSNumber numberWithFloat:strokeAlpha] forKey:key];
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:strokeAlpha];
        }
    }
    else {
        for(UIBezierPath *path in _drawnPaths) {
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:strokeAlpha];
        }
    }

}


- (void) doTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // single-stroke
//    isTouchDown = TRUE;
//    UITouch *touch = [[touches allObjects] objectAtIndex:0];
//    [_path moveToPoint:[touch locationInView:self]];
    //
    
    // multi-stroke
    
    if(_isTemp) [self clearCanvas];
    
    isTouchDown = TRUE;
    for(UITouch *touch in [touches allObjects]) {
        NSString* key = [NSString stringWithFormat:@"%d", [touch hash]];
        [_pathMap removeObjectForKey:key];
        
        if([_pathMap objectForKey: key]== nil) {
            
            [_touchPoints addObject:touch];
            UIBezierPath *tmpPath = [[UIBezierPath alloc] init]; // [_paths lastObject];
            tmpPath.lineWidth = 5;
            tmpPath.miterLimit = -10;
            tmpPath.lineCapStyle = kCGLineJoinMiter;
            
            [_drawnPaths addObject:tmpPath];
            if(_toFade) [_touchAfterEffect setObject:[NSNumber numberWithFloat:1.0f] forKey:key];
            
            if(tmpPath != nil) {
                [tmpPath moveToPoint:[touch locationInView:self]];
                [_pathMap setObject:tmpPath forKey: key];
            }
        }
    }
    //
}

- (void) doTouchMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // single-stroke
//    UITouch *touch=[[touches allObjects] objectAtIndex:0];
//    [_path addLineToPoint:[touch locationInView:self]];
//    if(_isTemp) [self setNeedsDisplay];
    //
    
    // multi-stroke
    for(UITouch *touch in [touches allObjects]) {
        UIBezierPath *tmpPath = [_pathMap objectForKey:[NSString stringWithFormat:@"%d", [touch hash]]];
        [tmpPath addLineToPoint: [touch locationInView:self]];
        
    }
    //
    
    if(_isTemp) [self setNeedsDisplay];
}

- (void) doTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // single-stroke
//    isTouchDown = FALSE;
//    if(_isTemp) [_path removeAllPoints];
//    [self setNeedsDisplay];
    //
    
    // multi-stroke
    isTouchDown = FALSE;
    for(UITouch *touch in [touches allObjects])
    {
        NSString* key = [NSString stringWithFormat:@"%d", [touch hash]];
        UIBezierPath *tmpPath = [_pathMap objectForKey:key];
        
        if(tmpPath != nil) {
            if(_isTemp) [tmpPath removeAllPoints];
        }
        
        if(!_toFade) {
            [_touchPoints removeObject:touch];
        }
        
    }
    //
    
    [self setNeedsDisplay];
}

- (void) mediateTouch: (NSArray*)tds :(int)methods {
    for(xacTouchData* td in tds) {
        int idxClass = [_touchClassifier classify: [td packageData]];
        [self printClassResult:idxClass];
        
        if(methods & PALMREJECTION) {
            if(idxClass == PALM) {
                UIBezierPath *path = [_pathMap objectForKey:td.key];
                [path removeAllPoints];
                [_drawnPaths removeObject:path];
                if(!_isTemp) NSLog(@"%@ eliminated", td.key);
            }
            else {
                NSLog(@"%@ is good", td.key);   
            }
        }
    }
}

- (void) clearCanvas
{
    NSMutableArray *tmpDrawnPaths = [[NSMutableArray alloc] initWithArray:_drawnPaths];
    for(UIBezierPath *tmpPath in tmpDrawnPaths) {
        [tmpPath removeAllPoints];
        [_drawnPaths removeObject:tmpPath];
    }
    NSLog(@"%d paths removed", tmpDrawnPaths.count);
    [self setNeedsDisplay];
}

- (void) updateCanvas {
    if(_toFade) [self setNeedsDisplay];
}

- (void) printClassResult: (int)idx {
    switch (idx) {
        case PEN:
            NSLog(@"Pen");
            break;
        case FINGER:
            NSLog(@"Finger");
            break;
        case PALM:
            NSLog(@"Palm");
            break;
        default:
            break;
    }
}

@end
