//
//  CurveBezierView.m
//  CurveFit
//
//  Created by hli on 6/30/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "CurveBezierView.h"


@implementation CurveBezierView
@synthesize pointCount;

- (void)drawBezier:(CGRect)rect inContext:(CGContextRef)context {
    UIBezierPath *path = [UIBezierPath bezierPath];

    //< Start and End Point
    if (self.pointCount < 2)
    {
        return;
    }
    
    CGPoint startPt = [[_points objectAtIndex:0] CGPointValue];
    CGPoint endPt = [[_points objectAtIndex:(self.pointCount - 1)] CGPointValue];
    
    float amount = endPt.x - startPt.x;
    
    int (^factorial)(int k) = ^(int k) {
        if (k == 0)
        {
            return 1;
        }
        int m = 1;
        for (int i = 1; i <= k; i++)
        {
            m *= i;
        }
        return m;
    };
    

    //< Curve Equation
    float (^bezierSpline)(int rank, float ux) = ^(int rank, float ux) {
        
        float p = 0.0f;
        
        for (int i = 0; i < rank; i++)
        {
            CGPoint pt = [[_points objectAtIndex:i] CGPointValue];
            
            p += pt.y * powf((1 - ux), (rank - i - 1)) * powf(ux, i) * (factorial(rank - 1) / (factorial(i) * factorial(rank - i - 1)));
        }
        
        return p;
    };

//    for (int i = 0; i < MIN(self.pointCount, [_points count]); i++)
//    {
//        
//        CGPoint pt = [[_points objectAtIndex:i] CGPointValue];
//        
//        float u = (pt.x - startPt.x) / amount;
//        
//        if (i == 0)
//        {
//            [path moveToPoint:pt];
//        }
//        else
//        {
//            [path addLineToPoint:CGPointMake(pt.x, bezierSpline(self.pointCount, u))];
//            if (i < ([_points count] - 1))
//            {
//                CGPoint prevPt = [[_points objectAtIndex:(i-1)] CGPointValue];
//                CGPoint nextPt = [[_points objectAtIndex:(i+1)] CGPointValue];
//                [path addCurveToPoint:pt controlPoint1:prevPt controlPoint2:nextPt];
//            }
//            else
//            {
//                [path addLineToPoint:pt];
//            }
//        }
//    }

    [path moveToPoint:startPt];
    
    for (float curX = startPt.x; (curX - endPt.x) < 1e-5; curX += 1.0f)
    {
        float u = (curX - startPt.x) / amount;
        [path addLineToPoint:CGPointMake(curX, bezierSpline(self.pointCount, u))];
    }
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}


- (void)drawLinear:(CGRect)rect inContext:(CGContextRef)context {
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0; i < MIN(self.pointCount, [_points count]); i++)
    {
        CGPoint pt = [[_points objectAtIndex:i] CGPointValue];
        if (i == 0)
        {
            CGPathMoveToPoint(path, NULL, pt.x, pt.y);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, pt.x, pt.y);
        }
    }
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGPathRelease(path);
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.curveFit)
    {
        [self drawBezier:rect inContext:context];
    }
    else
    {
        [self drawLinear:rect inContext:context];
    }
}

- (void)setPointCount:(int)thePointCount {
    if (thePointCount >= [_points count])
    {
        thePointCount = 2;
    }
    pointCount = thePointCount;
}

- (void)readPointsFromFileNamed:(NSString *)fileName {

    [super readPointsFromFileNamed:fileName];
    
    self.pointCount = 2;
}

@end
