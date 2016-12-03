//
//  globalVar.h
//  EEGRecorder
//
//  Created by Valdery Moura Junior on 8/15/14.
//  Copyright (c) 2014 Massachusetts General Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globalVar : NSObject {
    
    NSMutableArray  *EEGplot_global;
    NSInteger *packet_counter;
}

@property (nonatomic, retain) NSMutableArray *EEGplot_global;
+(globalVar*)getInstance;

//@property (nonatomic, assign) UInt8 *packet_counter;


@end
