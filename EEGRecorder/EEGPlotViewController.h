//
//  EEGPlotViewController.h
//  EEGRecorder
//
//  Created by Valdery Moura Junior on 7/12/14.
//  Copyright (c) 2014 Massachusetts General Hospital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface EEGPlotViewController : UIViewController <CPTPlotDataSource> {

    CPTGraph *graph1;
    
    float xstart;
    float ystart;
    float xrange;
    float yrange;
    
}

- (IBAction)UpdateYRange:(id)sender;
- (void) reloadGraphs:(NSTimer *)plotTimer;

@property (nonatomic)           BOOL graphUpdated;
@property (strong, nonatomic)   NSMutableArray *graphData1;
@property (nonatomic, strong)   CPTGraphHostingView *hostView1;


@end
 

