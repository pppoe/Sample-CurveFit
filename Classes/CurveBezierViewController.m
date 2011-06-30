//
//  CurveBezierViewController.m
//  CurveFit
//
//  Created by hli on 6/30/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "CurveBezierViewController.h"
#import "CurveBezierView.h"

@implementation CurveBezierViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)bezier {
    if (!curveBezierView.curveFit)
    {
        curveBezierView.curveFit = YES;
        self.navigationItem.rightBarButtonItem.title = @"NoBezier";
    }
    else
    {
        curveBezierView.curveFit = NO;
        self.navigationItem.rightBarButtonItem.title = @"Bezier";
    }
    [curveBezierView setNeedsDisplay];        
}

- (void)points {
    curveBezierView.pointCount++;
    [curveBezierView setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *pointsButton = [[UIBarButtonItem alloc] initWithTitle:@"Points"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(points)];
    self.navigationItem.leftBarButtonItem = pointsButton;
    [pointsButton release];
    
    UIBarButtonItem *bezierButton = [[UIBarButtonItem alloc] initWithTitle:@"Bezier"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(bezier)];
    self.navigationItem.rightBarButtonItem = bezierButton;
    [bezierButton release];
    
    curveBezierView = [[CurveBezierView alloc] initWithFrame:self.view.bounds];
    [curveBezierView readPointsFromFileNamed:@"line.txt"];
    [self.view addSubview:curveBezierView];
    [curveBezierView release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
