//
//  CurveView.m
//  CurveFit
//
//  Created by li haoxiang on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurveView.h"

@implementation CurveView
@synthesize curveFit;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.backgroundColor = [UIColor whiteColor];
        self.curveFit = NO;
    }
    return self;
}

- (void)drawCubicSpline:(CGRect)rect inContext:(CGContextRef)context {
    //< 3 Spline
    const int len = [_points count];
    float x[len];
    float y[len];
    for (int i = 0; i < len; i++)
    {
        CGPoint p = [[_points objectAtIndex:i] CGPointValue];
        x[i] = p.x;
        y[i] = p.y;
    }
    
    printf("x:\t");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", x[i]);
    }
    
    printf("\ny:\t");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", y[i]);
    }
    
    float h[len];
    float u[len];
    float lam[len];
    for (int i = 0; i < len-1; i++)
    {
        h[i] = x[i+1] - x[i];
    }    
    
    u[0] = 0;
    lam[0] = 1;
    for (int i = 1; i < (len - 1); i++)
    {
        u[i] = h[i-1]/(h[i] + h[i-1]);
        lam[i] = h[i]/(h[i] + h[i-1]);
    }
    
    float a[len];
    float b[len];
    float c[len];
    
    float m[len][len];
    for (int i = 0; i < len; i++)
    {
        for (int j = 0; j < len; j++)
        {
            m[i][j] = 0;
        }
        if (i == 0)
        {
            m[i][0] = 2;
            m[i][1] = 1;
            
            b[0] = 2;
            c[0] = 1;
        }
        else if (i == (len - 1))
        {
            m[i][len - 2] = 1;
            m[i][len - 1] = 2;
            
            a[len-1] = 1;
            b[len-1] = 2;
        }
        else
        {
            m[i][i-1] = lam[i];
            m[i][i] = 2;
            m[i][i+1] = u[i];
            
            a[i] = lam[i];
            b[i] = 2;
            c[i] = u[i];
        }
    }
    
    float g[len];
    g[0] = 3 * (y[1] - y[0])/h[0];
    g[len-1] = 3 * (y[len - 1] - y[len - 2])/h[len - 2];
    for (int i = 1; i < len - 1; i++)
    {
        g[i] = 3 * ((lam[i] * (y[i] - y[i-1])/h[i-1]) + u[i] * (y[i+1] - y[i])/h[i]);
    }
    
    for (int i = 0; i < len; i++)
    {
        printf("a[%d]: %.3f\n", i, a[i]);
    }
    for (int i = 0; i < len; i++)
    {
        printf("b[%d]: %.3f\n", i, b[i]);
    }
    for (int i = 0; i < len; i++)
    {
        printf("c[%d]: %.3f\n", i, c[i]);
    }
    
    //< Solve the Equations
    float p[len];
    float q[len];
    
    p[0] = b[0];
    for (int i = 0; i < len - 1; i++)
    {
        q[i] = c[i]/p[i];
    }
    
    for (int i = 1; i < len; i++)
    {
        p[i] = b[i] - a[i]*q[i-1];
    }
    
    float su[len];
    float sq[len];
    float sx[len];
    
    su[0] = c[0]/b[0];
    sq[0] = g[0]/b[0];
    for (int i = 1; i < len - 1; i++)
    {
        su[i] = c[i]/(b[i] - su[i-1]*a[i]);
    }
    
    for (int i = 1; i < len; i++)
    {
        sq[i] = (g[i] - sq[i-1]*a[i])/(b[i] - su[i-1]*a[i]);
    }
    
    sx[len-1] = sq[len-1];
    for (int i = len - 2; i >= 0; i--)
    {
        sx[i] = sq[i] - su[i]*sx[i+1];
    }
    
    for (int i = 0; i < len; i++)
    {
        printf("|\t");
        for (int j = 0; j < len; j++)
        {
            printf("%3.3f\t", m[i][j]);
        }   
        printf("\t|");
        printf("\t|%3.3f", sx[i]);
        printf("\t\t|%3.3f|", g[i]);
        printf("\n");
    }
    
    float *ph = h;
    float *px = x;
    float *psx = sx;
    float *py = y;
    
    printf("h:");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", ph[i]);
    }
    printf("\n");
    
    printf("x:");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", px[i]);
    }
    printf("\n");
    
    printf("y:");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", py[i]);
    }
    printf("\n");
    
    printf("sx:");
    for (int i = 0; i < len; i++)
    {
        printf("%.3f\t", psx[i]);
    }
    printf("\n");
    
    double (^func)(int k, float vX) = ^(int k, float vX) {
        double p1 =  (ph[k] + 2.0 * (vX - px[k])) * ((vX - px[k+1]) * (vX - px[k+1])) * py[k] / (ph[k] *ph[k] * ph[k]);
        double p2 =  (ph[k] - 2 * (vX - px[k+1])) * powf((vX - px[k]), 2.0f) * py[k+1] / powf(ph[k], 3.0f);
        double p3 =  (vX - px[k]) * powf((vX - px[k+1]), 2.0f) * psx[k] / powf(ph[k], 2.0f);
        double p4 =  (vX - px[k+1]) * powf((vX - px[k]), 2.0f) * psx[k+1] / powf(ph[k], 2.0f);
        return p1 + p2 + p3 + p4;
    };
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0; i < [_points count]; i++)
    {
        CGPoint pt = [[_points objectAtIndex:i] CGPointValue];
        if (i == 0)
        {
            CGPathMoveToPoint(path, NULL, pt.x, pt.y);
        }
        else
        {
            CGPoint curP = [[_points objectAtIndex:i-1] CGPointValue];
            float delta = 1.0f;
            for (float pointX = curP.x; fabs(pointX - pt.x) > 1e-5f; pointX += delta)
            {
                float pointY = func(i-1, pointX);
                CGPathAddLineToPoint(path, NULL, pointX, pointY);
            }
        }
    }
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGPathRelease(path);
}

- (void)drawLinear:(CGRect)rect inContext:(CGContextRef)context {
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0; i < [_points count]; i++)
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
        [self drawCubicSpline:rect inContext:context];
    }
    else
    {
        [self drawLinear:rect inContext:context];
    }
}

- (void)dealloc {
    [super dealloc];
}

- (void)readPointsFromFileNamed:(NSString *)fileName {
    
    if (!_points)
    {
        _points = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_points removeAllObjects];
    
    NSString *fileContentStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]
                                                         encoding:NSUTF8StringEncoding 
                                                            error:nil];
    NSArray *lines = [fileContentStr componentsSeparatedByString:@"\n"];
    for (NSString *line in lines)
    {
        NSArray *comps = [line componentsSeparatedByString:@" "];
        if ([comps count] == 2)
        {
            [_points addObject:
             [NSValue valueWithCGPoint:
              CGPointMake([[comps objectAtIndex:0] floatValue], 
                          [[comps objectAtIndex:1] floatValue])]];
        }
    }

}

@end
