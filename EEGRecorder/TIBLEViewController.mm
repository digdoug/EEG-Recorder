//
//  TIBLEViewController.m
//
//  Modified by Valdery Junior on 05/10/2014
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import "TIBLEViewController.h"
#import "EEGPlotViewController.h"
#import "CKoSFTP.h"
#import "globalVar.h"



@implementation TIBLEViewController
@synthesize TIBLEUIAccelXBar;
@synthesize TIBLEUISpinner;
@synthesize TIBLEUIConnBtn;
@synthesize TIBLEUIBytes;
@synthesize TIBLEUIFileCounter;
@synthesize TIBLEUIBytesTotal;
@synthesize TIBLEUIRetry;
@synthesize TIBLEUIUploaded;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Alert !"
                          message:@"LOW MEMORY !!!"
                          delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    
    [alert show];
    return;
}

- (IBAction)forceUpload:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Force Upload Message"
                          message:@"Are you sure you want to force the file upload?"
                          delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil];
    
    [alert show];
    return;
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //t =[[TIBLECBKeyfob alloc] initWithDelegate:CM queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];

    t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    t.delegate = self;                  // Set TIBLECBKeyfob delegate class to point at methods implemented in this class.
    t.TIBLEConnectBtn = self.TIBLEUIConnBtn;
    
    
    
    // *************************************** set variables *************************************************** //
    
    dataToPlot1         = [[NSMutableArray alloc] init];
    data_for_file       = [[NSMutableArray alloc] init];
    localFilePathArray  = [[NSMutableArray alloc] init];
    remoteFilePathArray = [[NSMutableArray alloc] init];

    ssh_connect_flag    = YES;
    fUpload             = YES;
    file_counter        = 1;            // part of the name of the file
    filesToUpdate       = 0;
    fileSize            = (double) 1382400/ 1000000000;  //|1382400-> 1 hr ; 691200-> 30 min; 115200-> 5 min ; 3840 -> 10 sec of data
    checkConnection               = true; // start true, if not false it will be checked immediately

    
    // Initialize dataToPlot to all zeroes, so don't have to wait 10 seconds for the plot
    
    for (NSInteger i = 0; i < 2560; ++i){
        [dataToPlot1 insertObject:[NSNumber numberWithUnsignedInt:0] atIndex:[dataToPlot1 count]];
    }
}

- (void)viewDidUnload
{
    [self setTIBLEUIAccelXBar:nil];
    [self setTIBLEUISpinner:nil];
    [self setTIBLEUIConnBtn:nil];
    [self setTIBLEUIBytes:nil];
    [self setTIBLEUIFileCounter:nil];
    [self setTIBLEUIBytesTotal:nil];
    [self setTIBLEUIRetry:nil];
    [self setTIBLEUIUploaded:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    switch(interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            return NO;
        case UIInterfaceOrientationLandscapeRight:
            return NO;
        default:
            return YES;
    }
}


// *************************************** SCAN BLUETOOTH DEVICES *************************************************** //
UInt8 packet_counter;


- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender {
    if (t.activePeripheral) {
        if(t.activePeripheral.isConnected) {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
            [TIBLEUIConnBtn setTitle:@"Stopped !" forState:UIControlStateNormal];
            t.activePeripheral = nil;
        }
    } else {
        if (t.peripherals) t.peripherals = nil;
        [t findBLEPeripherals:5];   //originally 5
        [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
        [TIBLEUISpinner startAnimating];
        [TIBLEUIConnBtn setTitle:@"Scanning..." forState:UIControlStateNormal];
        NSLog(@"Not connected - trying");
        
    }
    
    // Need to reset variables to make sure that the byte order doesn't get misaligned (using 12 bits)
    
    fileCounter = 0;
    packet_counter = 0;
    
}

/* *************************************  CHECK INTERNET CONN  **********************************************
 **                                                                                                        **
 **            Method from TIBLECBKeyfobDelegate, called when accelerometer values are updated             **
 **                                                                                                        **
 ** ****************************************************************************************************** */

// Grand Central Dispatch to make sure the Wi-Fi check runs independently of the viewcontroller
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"Yayyy, we have the interwebs!");
            if (!checkConnection && filesToUpdate > 0){
                // force upload basically, passing nil, you could technically pass 0 if you want to
                // still push a parameter through
            [self updateDropboxFile:nil];
            }
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            checkConnection = false;
        });
    };
    
    [internetReachableFoo startNotifier];
}

/* *************************************  PREPARE DATA TO PLOT **********************************************
 **                                                                                                        **
 **            Method from TIBLECBKeyfobDelegate, called when accelerometer values are updated             **
 **                                                                                                        **
 ** ****************************************************************************************************** */

-(void) accelerometerValuesUpdated:(float)x{
    
    if ([dataToPlot1 count] > 2560)             // 4040 - this should be 256 samples per second ; for 10 second window -> 2560
    {
        [dataToPlot1 removeObjectAtIndex:0];    // removes object at index 0 and shifts all indexes down by 1
    }
    
    //    [dataToPlot1 insertObject:[NSNumber numberWithFloat:x] atIndex:[dataToPlot1 count]];

   // int count;
    
    //if (count == 0){
        [dataToPlot1 insertObject:[NSNumber numberWithFloat:x] atIndex:[dataToPlot1 count]];
    //    count = 1;
    //}
   /* else{
        [dataToPlot1 insertObject:[NSNumber numberWithFloat:0] atIndex:[dataToPlot1 count]];
        count = 0;
    }*/

    globalVar *var=[globalVar getInstance];
    var.EEGplot_global = dataToPlot1;
}


//
/* settings for changing password

- (IBAction)settings:(UIButton *)sender {
    
    
}*/



/* ******************************** TRANSFER FILES TO MGH SERVER *******************************************
 **                                                                                                        **
 **            Method from TIBLECBKeyfobDelegate, called when accelerometer values are updated             **
 **                                                                                                        **
 ** ****************************************************************************************************** */

BOOL wasDisconnected;

-(void) updateDropboxFile:(UInt8)original_data {
    
    // this way if it was disconnected no additional information will be added
    if (ssh_connect_flag == YES && !wasDisconnected)
    {
        ssh_connect_flag = NO;
        
        // ******************************* >>> CONNECT TO MGH SSH SERVER <<< *******************************
        
        
        sftp = [[CkoSFtp alloc] init];
        success = [sftp UnlockComponent: @"Anything for 30-day trial"];
        
        //  Set some timeouts, in milliseconds:
        sftp.ConnectTimeoutMs   = [NSNumber numberWithInt:15000];
        sftp.IdleTimeoutMs      = [NSNumber numberWithInt:15000];
        
        //  Connect to the SSH server.
        int port = 22;
        NSString *hostname;
        hostname = @"ssh.research.partners.org";
        success = [sftp Connect: hostname port: [NSNumber numberWithInt: port]];        //  Connect to the SSH server.
        
        
        // this password apparently changes every 90 days
        // create a variable for the password
        
        servPassword = @"Q3vXTvEj";
        
        success = [sftp AuthenticatePw: @"iua" password: servPassword];                  //  Authenticate with the SSH server.
        
        // UI alert
        
        success = [sftp InitializeSftp];                                                //  Initialize SFTP subsystem.
        
        
        // ********************** >>> CREATE NEW REMOTE DIRECTORY AND LOCAL FILE <<< *************************
        
        // Get and format current date and time
        NSDate* now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YY.MM.dd.HH.mm"];
        dateString = [dateFormatter stringFromDate:now];
        
        NSLog(@"Today date is: %@",dateString);
        
        success = [sftp CreateDir: dateString];                                          // Create a new remote directory
        if (success != YES) {
            ssh_connect_flag = YES;                                                      // Reset flag to try again later
            UIAlertView *alert = [[UIAlertView alloc]
                                  
                                  initWithTitle:@"Alert !"
                                  message:@"It was not possible to create the remote destination folder, check your WI-FI connection and try again!"
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
            
            [alert show];
            return;
        } else {
            self.plotButton.hidden = NO;                    // unhidde plot button
        }
            
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);   // Get local path info
        documentsDirectory = [paths objectAtIndex:0];
        fullPath = [documentsDirectory stringByAppendingPathComponent:
                   [NSString stringWithFormat:@"%@.csv", @"data001"]];                                      // Add file to the path
        
        [fileManager createFileAtPath:fullPath contents:nil attributes:nil];                                // Create a local file to store the data
        
        printf("Document Dir: %s\r\n",[documentsDirectory UTF8String]);
        printf("FullPath: %s \r\n",[fullPath UTF8String]);

    }
    
    // *************************** >>> APPEND RECEIVED DATA INTO ARRAY <<< *******************************
    
    // Appends 60 minutes of data to the file |1382400-> 1 hr ; 691200-> 30 min; 115200-> 5 min ; 3840 -> 10 sec of data
    
        
    [data_for_file insertObject:[NSNumber numberWithInteger:original_data] atIndex:[data_for_file count]];
    

    fileBytes = (double)[data_for_file count] / 1000000000;// / 1000000000;
    fileTotalBytes += (double)1/1000000000; // gigs will be easier and there will be no crashes due to size of int32_t
    
    TIBLEUIBytes.text           = [NSString stringWithFormat: @"%.02f", fileBytes];
    TIBLEUIBytesTotal.text      = [NSString stringWithFormat: @"%.02f", fileTotalBytes];
    TIBLEUIAccelXBar.progress   = (double)(fileBytes -1/1000000000 ) / fileSize;
    
    alive++;
    if(alive == 1840){
        NSLog(@"Still alive !! - %lld - %f/%f", fileUploaded, fileBytes,fileTotalBytes);
        alive=0;
    }


    // somehow determine here if the app just disconnected
    if((double)[data_for_file count]/1000000000 > fileSize || wasDisconnected == true || !checkConnection)
    {
        // ***** >>> CONNECT TO MGH SSH SERVER <<< *****
        
        sftp    = [[CkoSFtp alloc] init];
        success = [sftp UnlockComponent: @"Anything for 30-day trial"];
        
        sftp.ConnectTimeoutMs   = [NSNumber numberWithInt:15000];
        sftp.IdleTimeoutMs      = [NSNumber numberWithInt:15000];
        
        
        int port    = 22;
        NSString    *hostname;
        hostname    = @"ssh.research.partners.org";
        success     = [sftp Connect: hostname port: [NSNumber numberWithInt: port]];        //  Connect to the SSH server.
        success     = [sftp AuthenticatePw: @"iua" password: servPassword];                  //  Authenticate with the SSH server.
        success     = [sftp InitializeSftp];                                                //  Initialize SFTP subsystem.
        
        
        // MOVE DATA RECEIVED TO A STRING
        
        NSString *csvString = [data_for_file componentsJoinedByString:@","];                // separate variables with commas
        csvString           = [csvString stringByAppendingString:@","];                     // add a comma to the last index for appending
        [data_for_file removeAllObjects];                                                   // delete old data from array
        
        // APPEND the file with more data
        
        NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:fullPath];
        fh = [NSFileHandle fileHandleForWritingAtPath:fullPath];
        [fh seekToEndOfFile];
        [fh writeData:[csvString dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
        
        NSLog(@"%@",fullPath);
        
        // PREPARE UPLOAD PATH
        NSString *remoteFilePath;
        remoteFilePath = @"/home/iua/";
        remoteFilePath = [remoteFilePath stringByAppendingString:dateString];
        remoteFilePath = [remoteFilePath stringByAppendingString:@"/data"];
        remoteFilePath = [remoteFilePath stringByAppendingString:[NSString stringWithFormat:@"%03d", file_counter]];
        remoteFilePath = [remoteFilePath stringByAppendingString:@".csv"];
        NSString *localFilePath;
        localFilePath = fullPath;
        

        [localFilePathArray  addObject:localFilePath];
        [remoteFilePathArray addObject:remoteFilePath];
        filesToUpdate = localFilePathArray.count;

        NSLog(@"%@",remoteFilePath);
        
        // UPLOAD FROM LOCAL FILE TO SSH SERVER
        

        for(int i=0; i < localFilePathArray.count; i++) {
            
            NSLog(@"\n Index: %d - RPath: %@",i, remoteFilePathArray[i]);
            
            success = [sftp UploadFileByName: remoteFilePathArray[i] localFilePath: localFilePathArray[i]];
            if (success == YES) {
                fileUploaded++;
                TIBLEUIUploaded.text = [NSString stringWithFormat: @"%lld",fileUploaded ];
                
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager  removeItemAtPath:localFilePathArray[i] error:nil];    //delete local file after upload
                
                [localFilePathArray   removeObjectAtIndex:i];
                [remoteFilePathArray  removeObjectAtIndex:i];
                
                if (localFilePathArray.count>0) {
                    i--;
                    // when the file gets to
                    /*if (fileTotalBytes > ){
                        
                    }*/
                }
                
            }
            else{
                // could do a dispatch queue here
            }
            fileRetryUpload = localFilePathArray.count;
            TIBLEUIRetry.text = [NSString stringWithFormat: @"%lld",fileRetryUpload ];
        }

        wasDisconnected = false;

        
        fileBytes = (double)0;
        TIBLEUIBytes.text           = [NSString stringWithFormat: @"%f", fileBytes];
        TIBLEUIFileCounter.text     = [NSString stringWithFormat: @"%d", file_counter];
        
        TIBLEUIAccelXBar.progress   = (double)(fileBytes -1 /1000000000 ) / 3840 /1000000000;
        
        
        file_counter++;
        
        // CREATE THE NEXT FILE
        fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"data"]]; // add file to the path
        fullPath = [fullPath stringByAppendingString:[NSString stringWithFormat:@"%d", file_counter]];      // add a comma to the last index
        fullPath = [fullPath stringByAppendingString:@".csv"];
        [[NSFileManager defaultManager] createFileAtPath:fullPath contents:nil attributes:nil];
        
        
        
        
        // plot.ly to connect to visualize in real-time patient data
        
        // These code snippets use an open-source library. http://unirest.io/objective-c
        /* NSDictionary *headers = @{@"X-Mashape-Key": @"XfNkPokUdLmshrG63dJowTUPN9PIp1YqFqujsnFC0qwlHPCSoj", @"Content-Type": @"application/x-www-form-urlencoded", @"Accept": @"text/plain"};
        NSDictionary *parameters = @{@"api_key": @"9rxhnndgtl", @"args": @"[{"x": [0, 1, 2], "y": [3, 1, 6], "name": "Experimental", "marker": {"symbol": "square", "color": "purple"}}, {"x": [1, 2, 3], "y": [3, 4, 5], "name": "Control"}]", @"kwargs": @"kwargs={     "filename": "plot from api",     "fileopt": "overwrite",     "style": {         "type": "bar"     },     "traces": [0,3,5],     "layout": {         "title": "experimental data"     },     "world_readable": true }", @"origin": @"plot", @"platform": @"python", @"un": @"anna.lyst", @"version": @"0.2"};
        UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
            [request setUrl:@"https://plotly-plotly.p.mashape.com/"];
            [request setHeaders:headers];
            [request setParameters:parameters];
        }] asundefinedAsync:^(UNIHTTPundefinedResponse *response, NSError *error) {
            NSInteger code = response.code;
            NSDictionary *responseHeaders = response.headers;
            UNIJsonNode *body = response.body;
            NSData *rawBody = response.rawBody;
        }]; */
    }
    
}

/* ************************************ KEYFOB VALUES UPDATED ***********************************************
 **                                                                                                        **
 ** Method from TIBLECBKeyfobDelegate, called when keyfob has been found and all services discovere        **
 **                                                                                                        **
 ** ****************************************************************************************************** */


-(void) keyfobReady {
    [TIBLEUIConnBtn setTitle:@"Ready..." forState:UIControlStateNormal];

    [t enableAccelerometer:[t activePeripheral]];    // Enable accelerometer
    [TIBLEUISpinner stopAnimating];
}

/* ************************************** CONNECTION TIMER **************************************************
 **                                                                                                        **
 ** Method from TIBLECBKeyfobDelegate, Called when scan period is over to connect to the peripheral        **
 **                                                                                                        ** 
     this won't get called on a reconnect because there won't be a second scan
 ** ****************************************************************************************************** */

-(void) connectionTimer:(NSTimer *)timer {

    if(t.activePeripheral.isConnected) {
        [TIBLEUIConnBtn setTitle:@"Connected" forState:UIControlStateNormal];
    } else {
        [TIBLEUIConnBtn setTitle:@"Not Connected - Click here to try again" forState:UIControlStateNormal];
    }
    
    [TIBLEUISpinner stopAnimating];
    
}


@end
