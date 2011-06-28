    //
//  CurveViewController.m
//  CurveFit
//
//  Created by li haoxiang on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurveViewController.h"
#import "CurveView.h"

@implementation CurveViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)noCurveFit {
    curveView.curveFit = NO;
    [curveView setNeedsDisplay];
}

- (void)doCurveFit {
    curveView.curveFit = YES;
    [curveView setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *noFitButton = [[UIBarButtonItem alloc] initWithTitle:@"NoFit"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(noCurveFit)];
    self.navigationItem.leftBarButtonItem = noFitButton;
    [noFitButton release];

    UIBarButtonItem *doFitButton = [[UIBarButtonItem alloc] initWithTitle:@"DoFit"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doCurveFit)];
    self.navigationItem.rightBarButtonItem = doFitButton;
    [doFitButton release];
    
    curveView = [[CurveView alloc] initWithFrame:self.view.bounds];
    [curveView readPointsFromFileNamed:@"line.txt"];
    [self.view addSubview:curveView];
    [curveView release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
