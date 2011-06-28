//
//  CurveView.h
//  CurveFit
//
//  Created by li haoxiang on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveView : UIView {
    NSMutableArray *_points;
    BOOL curveFit;
}

@property (nonatomic, assign) BOOL curveFit;

- (void)readPointsFromFileNamed:(NSString *)fileName;

@end
