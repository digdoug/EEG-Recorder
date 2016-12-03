//
//  SetViewController.m
//  EEGRecorder
//
//  Created by Lucas Pinto on 7/22/15.
//  Copyright (c) 2015 Massachusetts General Hospital. All rights reserved.
//

#import "SetViewController.h"


@implementation SetViewController 


@synthesize currentPassword;
@synthesize currServPasswordBttn;
@synthesize serverPassword;


//@interface SetViewController ()

//@end


//class Set

- (void)viewDidLoad {
    [super viewDidLoad];
    currPassword = @"MGHEEG";
    // Do any additional setup after loading the view.
    currServPasswordBttn.hidden = YES;
    serverPassword.hidden = YES;
    
}




- (IBAction)currentPassword:(UITextField *)sender {
    
    if (sender.text == currPassword){
        // unide currServ
        currServPasswordBttn.hidden = NO;
        serverPassword.hidden = NO;
    }
    
}


NSString *servPassword;
- (IBAction)currServ:(UITextField *)sender {
    
    z = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [z controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    z.delegate = self;                  // Set TIBLECBKeyfob delegate class to point at methods implemented in this class.
    //t.TIBLEConnectBtn = self.TIBLEUIConnBtn;
    servPassword = sender.text;
    
}


- (void)didReceiveMemoryWarning {


    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    currServPasswordBttn.hidden = YES;
    serverPassword.hidden = YES;
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
