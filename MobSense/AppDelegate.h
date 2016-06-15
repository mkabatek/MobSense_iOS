//
//  AppDelegate.h
//  MobSense
//
//  Created by Michael Kabatek on 6/6/16.
//  Copyright (c) 2016 stream^N Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

#import "GlobalVariables.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate>{

    GlobalVariables *settings;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *parametersDictionaryFromQueryString;

@end

