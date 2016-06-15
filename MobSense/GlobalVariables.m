//
//  GlobalVariables.m
//  MobSense
//
//  Created by Michael Kabatek on 1/11/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables{

    GlobalVariables * anotherSingle;

}


@synthesize enabled;
@synthesize collect;
@synthesize host;
@synthesize port;
@synthesize facebook;
@synthesize twitter;
@synthesize google;


@synthesize _collect;
@synthesize _host;
@synthesize _port;
@synthesize _facebook;
@synthesize _twitter;
@synthesize _google;


@synthesize locationManager;


+(GlobalVariables *)singleObj{

    
    static GlobalVariables * single = nil;
    
    @synchronized(self){
    
        if(!single){
        
            single = [[GlobalVariables alloc] init];
        }
        
    }
    return single;
    

}

@end


