//
//  EEGPlotViewController.m
//  EEGRecorder
//
//  Created by Valdery Moura Junior on 7/12/14.
//  Copyright (c) 2014 Massachusetts General Hospital. All rights reserved.
//

#import "EEGPlotViewController.h"
#import "globalVar.h"


CGFloat     yMax = 312;                             // should determine dynamically based on max price
CGFloat     yMin = -250;                            // should determine dynamically based on max price
NSInteger   majorIncrement = 125;
NSInteger   minorIncrement = 125;
float       graph_label_offset = 20.0f;

@interface EEGPlotViewController ()

@end

@implementation EEGPlotViewController

@synthesize hostView1 = hostView1_;
#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
}

@synthesize graphData1;
@synthesize graphUpdated;



- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.graphUpdated = NO;
    
}
#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];                // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    // Dispose of any resources that can be recreated.
}

-(void)configureHost {
    self.hostView1 = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(0.0, 55.0, 580, 280)];
    self.hostView1.allowPinchScaling = NO; // also disabled user interaction in the code below
    [self.view addSubview:self.hostView1];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)configureGraph {
    // 1 - Create the graph
    //CPTGraph *graph1 = [[CPTXYGraph alloc] initWithFrame:self.hostView1.bounds];
    graph1 = [[CPTXYGraph alloc] initWithFrame:self.hostView1.bounds];
    [graph1 applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView1.hostedGraph = graph1;
    
    
    // 2 - Set graph title
    //NSString *title = @"include title here";
    //graph1.title = title;
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph1.titleTextStyle = titleStyle;
    graph1.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph1.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    // 4 - Set padding for plot area
    [graph1.plotAreaFrame setPaddingLeft:30.0f];
    [graph1.plotAreaFrame setPaddingBottom:30.0f];   //30.0f];
    
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace1 = (CPTXYPlotSpace *) graph1.defaultPlotSpace;
    plotSpace1.allowsUserInteraction = NO;
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    //CPTGraph *graph1 = self.hostView1.hostedGraph;
    graph1 = self.hostView1.hostedGraph;
    CPTXYPlotSpace *plotSpace1 = (CPTXYPlotSpace *) graph1.defaultPlotSpace;
    
    // 2 - Create the plot
    CPTScatterPlot *randomPlot1 = [[CPTScatterPlot alloc] init];
    randomPlot1.dataSource = self;
    randomPlot1.identifier = @"XPlot";
    CPTColor *randomPlot1Color = [CPTColor redColor];
    [graph1 addPlot:randomPlot1 toPlotSpace:plotSpace1];
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(5, 5); // 2, 2
    randomPlot1.plotSymbol = greenCirclePlotSymbol;
    
    // 3 - Set up plot space
    [plotSpace1 scaleToFitPlots:[NSArray arrayWithObjects:randomPlot1, nil]];
    CPTMutablePlotRange *xRange = [plotSpace1.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace1.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace1.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace1.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *randomPlot1lLineStyle = [randomPlot1.dataLineStyle mutableCopy];
    randomPlot1lLineStyle.lineWidth = 0.75;//2.5;
    randomPlot1lLineStyle.lineColor = randomPlot1Color;
    randomPlot1.dataLineStyle = randomPlot1lLineStyle;
    
    CPTMutableLineStyle *randomSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    randomSymbolLineStyle.lineColor = randomPlot1Color;
    CPTPlotSymbol *randomSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    randomSymbol.fill = [CPTFill fillWithColor:randomPlot1Color];
    randomSymbol.lineStyle = randomPlot1lLineStyle;
    randomSymbol.size = CGSizeMake(0.0f, 0.0f); // reduce the circle size on each data point
    randomPlot1.plotSymbol = randomSymbol;
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView1.hostedGraph.axisSet;
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Time (s)";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 12.0f;//15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    
    
    CGFloat dateCount = 11; // this is the number of major ticks
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (int j=0;j<dateCount;j++) {
        NSString *str = [NSString stringWithFormat:@"%d",j];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:str  textStyle:x.labelTextStyle];
        CGFloat location = i;
        i = i + 256; //404 this indicates how many data points between each major tick
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Voltage (uV)";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -44.0f;//-40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = graph_label_offset;//16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    
    
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = yMin; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    
    
    
    // updates plot space - not really necessary, but keeps format constant
    CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *) graph1.defaultPlotSpace;
    plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) // changed here
                                                     length:CPTDecimalFromFloat(yMax-yMin)];
    [graph1 addPlotSpace:plotSpace2];
    y.plotSpace = plotSpace2;
    // end of updates plot space - not really necessary, but keeps format constant
    
    // start timer to udpate plot
    [NSTimer scheduledTimerWithTimeInterval:(float)0 target:self selector:@selector(reloadGraphs:) userInfo:nil repeats:YES];
    
    
}

-(void) reloadGraphs:(NSTimer *)plotTimer {
    [graph1 reloadData];
}

#pragma mark - CPTPPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    if ([plot.identifier isEqual: @"XPlot"])
    {
 //       printf("==========================>>>>  Count1 is %d \r\n" ,[self.graphData1 count]);
        return (2561 + xstart +1);
    }
    
    else
        printf("Problem \r\n");
    return 0;
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    //double val = (index/5.0)-5;
    
    NSNumber *num = nil;

    

    switch ( fieldEnum ) {
        case CPTScatterPlotFieldX:
            num = [NSNumber numberWithUnsignedInteger:index];
            break;
            
        case CPTScatterPlotFieldY:
            if (index < (xstart + 1))
                num = 0;
            else
            {
        
                double val = 0;
                if ([plot.identifier isEqual: @"XPlot"]){
                // printf("plot ====================================== \r\n");
                    globalVar *var=[globalVar getInstance];
                    graphData1 = var.EEGplot_global;
                    
                    val = [[self.graphData1 objectAtIndex:(index - xstart - 1)] intValue];
                }
                //printf("Index %d \r\n", index);
                // printf("val %f \r\n", val);
                num = [NSNumber numberWithDouble:val] ;
            }
            
            break;
            
        default:
            break;
    }
    
    
    return num;
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

//- (IBAction)UpdateYRange:(id)sender {
- (IBAction)UpdateYRange:(UIStepper *)sender {
    
    int value = [sender value];
    
    NSMutableString *tmp_sender_value = [NSMutableString string ];
    
    [tmp_sender_value  appendFormat:@"%d", value];
    NSLog(@"%@", tmp_sender_value);
    
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView1.hostedGraph.axisSet;
    CPTAxis *y = axisSet.yAxis;
    

    
    
    CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *) graph1.defaultPlotSpace;
    
    switch (value)
    {
        case 1:
            majorIncrement = 1000;
            minorIncrement = 1000;
            graph_label_offset = 26.0f;
            y.labelOffset = graph_label_offset;
            yMax = 2500;  // should determine dynamically based on max price
            yMin = -2000;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
            
        case 2:
            majorIncrement = 500;
            minorIncrement = 500;
            graph_label_offset = 26.0f;
            y.labelOffset = graph_label_offset;
            yMax = 1250;  // should determine dynamically based on max price
            yMin = -1000;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
        case 3:
            majorIncrement = 250;
            minorIncrement = 250;
            graph_label_offset = 20.0f;
            y.labelOffset = graph_label_offset;
            yMax = 625;  // should determine dynamically based on max price
            yMin = -500;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
        case 4:
            majorIncrement = 125;
            minorIncrement = 125;
            graph_label_offset = 20.0f;
            y.labelOffset = graph_label_offset;
            yMax = 312;  // should determine dynamically based on max price
            yMin = -250;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
        case 5:
            majorIncrement = 50;
            minorIncrement = 50;
            graph_label_offset = 20.0f;
            y.labelOffset = graph_label_offset;
            yMax = 125;  // should determine dynamically based on max price
            yMin = -100;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
        case 6:
            majorIncrement = 25;
            minorIncrement = 25;
            graph_label_offset = 14.0f;
            y.labelOffset = graph_label_offset;
            yMax = 62.5;  // should determine dynamically based on max price
            yMin = -50;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
        case 7:
            majorIncrement = 10;
            minorIncrement = 10;
            graph_label_offset = 14.0f;
            y.labelOffset = graph_label_offset;
            yMax = 25;  // should determine dynamically based on max price
            yMin = -20;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
            
        case 8:
            majorIncrement = 5;
            minorIncrement = 5;
            graph_label_offset = 14.0f;
            y.labelOffset = graph_label_offset;
            yMax = 12.5;  // should determine dynamically based on max price
            yMin = -10;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
            
            
        default:
            majorIncrement = 50;
            minorIncrement = 50;
            yMax = 125;  // should determine dynamically based on max price
            yMin = -100;
            plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                             length:CPTDecimalFromFloat(yMax-yMin)];
            break;
    }
    
    // 4 - Configure y-axis
    
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = yMin; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(0) length:CPTDecimalFromInteger(2000)];
    
    
    [graph1 addPlotSpace:plotSpace2];
    y.plotSpace = plotSpace2;
    
    
}

@end

 
