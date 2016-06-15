//
//  ViewController.h
//  MobSense
//
//  Created by Michael Kabatek on 1/8/16.
//  Copyright (c) 2016 stream^N Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

#import "LocationShareModel.h"
#import "SettingsTableViewController.h"
#import "WizardController.h"
#import "View.h"



double magnitude;

@class GADBannerView;

@interface ViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, NSURLConnectionDelegate> {
    
    CMMotionManager *motionManager;
    GlobalVariables *settings;
    
    
}
@property(strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet UIButton *OnOff;

@property (strong, nonatomic) IBOutlet UIImageView *Image;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *toggleMode;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *help;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property UILocalNotification * localNotification;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;

@end


