//
//  GlobalVariables.h
//  MobSense
//
//  Created by Michael Kabatek on 1/11/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreLocation/CoreLocation.h>

@interface GlobalVariables : NSObject {


    bool enabled;
    bool collect;
    NSString *host;
    NSString *port;
    NSString *facebook;
    NSString *twitter;
    NSString *google;

    
    NSMutableArray *_collect;
    NSMutableArray *_host;
    NSMutableArray *_port;
    NSMutableArray *_facebook;
    NSMutableArray *_twitter;
    NSMutableArray *_google;
    
    CLLocationManager *locationManager;
    

}


@property(nonatomic) bool enabled;
@property(nonatomic) bool collect;
@property(nonatomic) NSString *host;
@property(nonatomic) NSString *port;
@property(nonatomic) NSString *facebook;
@property(nonatomic) NSString *twitter;
@property(nonatomic) NSString *google;



@property(nonatomic) NSMutableArray *_collect;
@property(nonatomic) NSMutableArray *_host;
@property(nonatomic) NSMutableArray *_port;
@property(nonatomic) NSMutableArray *_facebook;
@property(nonatomic) NSMutableArray *_twitter;
@property(nonatomic) NSMutableArray *_google;

@property(nonatomic) CLLocationManager *locationManager;

+(GlobalVariables *) singleObj;

@end
