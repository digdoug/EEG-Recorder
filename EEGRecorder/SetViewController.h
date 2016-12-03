//
//
//  SetViewController.h
//  EEGRecorder
//
//  Created by Lucas Pinto on 7/22/15.
//  Copyright (c) 2015 Massachusetts General Hospital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"

@interface SetViewController : UIViewController<TIBLECBKeyfobDelegate>{

    TIBLECBKeyfob *z;
    NSString *currPassword;
    
}
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UILabel *currServPasswordBttn;
@property (weak, nonatomic) IBOutlet UITextField *serverPassword;




@end

