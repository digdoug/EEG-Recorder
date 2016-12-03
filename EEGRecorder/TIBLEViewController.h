//
//  TIBLEViewController.h
//
//  Created by Valdery Moura Junior on 5/29/14.
//  Copyright (c) 2014 Massachusetts General Hospital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"
#import "EEGPlotViewController.h"
#import "CKoSFTP.h"
#import "Reachability.h"

extern NSString *servPassword;

@interface TIBLEViewController : UIViewController <TIBLECBKeyfobDelegate> {
    
    TIBLECBKeyfob *t;                               //TI keyfob class (private)
    
    NSMutableArray          *dataToPlot1;
    NSMutableArray          *data_for_file;
    NSMutableArray          *localFilePathArray;
    NSMutableArray          *remoteFilePathArray;

    //global
    BOOL        success;                // used in the sftp lines
    BOOL        ssh_connect_flag;       // if it equals zero, then it needs to connect to the server
    BOOL        fUpload;
    
    
    int64_t     fileCounter;
    double       fileBytes;
    double       fileTotalBytes;
    int64_t     fileRetryUpload;
    int64_t     fileUploaded;
    int64_t     filesToUpdate;
    int64_t     alive;
    double       fileSize;
    BOOL     checkConnection;

    UInt16      file_counter;           // this is used as the file counter to name the file
    NSString    *fullPath;              // path of the sftp file
    NSString    *dateString;            // day and time that will be used to create the directory
    NSString    *documentsDirectory;

    CkoSFtp     *sftp;
    Reachability *internetReachableFoo;
    //NSString    statPassword;
    // servPassword = Q3vXTvEj
    //TIBLECBKeyfob t = [[TIBLECBKeyfob alloc] init];
    //int32_t     check;
    // used in sftp
  //  extern UInt8 packet_counter;

}



// UI elements actions
- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender;

// UI elements outlets
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelXBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *TIBLEUISpinner;
@property (weak, nonatomic) IBOutlet UIButton *TIBLEUIConnBtn;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIFileCounter;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIBytes;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIBytesTotal;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIRetry;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIUploaded;
@property (weak, nonatomic) IBOutlet UIButton *plotButton;
@property (weak, nonatomic) IBOutlet UIButton *forceUpload;
// settings button
@property (weak, nonatomic) IBOutlet UIButton *settings;
//@property (weak, nonatomic)



//Timer methods
- (void) connectionTimer:(NSTimer *)timer;

@end
