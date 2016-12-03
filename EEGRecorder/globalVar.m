//
//  globalVar.m
//  EEGRecorder
//
//  Created by Valdery Moura Junior on 8/15/14.
//  Copyright (c) 2014 Massachusetts General Hospital. All rights reserved.
//

#import "globalVar.h"

@implementation globalVar
@synthesize EEGplot_global;
//@synthesize packet_counter;


static globalVar *instance = nil;

+(globalVar *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [globalVar new];
        }
    }
    return instance;
}



@end
