//
//  AppDelegate.m
//  MobSense
//
//  Created by Michael Kabatek on 1/8/16.
//  Copyright (c) 2016 stream^N Inc. All rights reserved.
//

#define BBOX(x) [NSNumber numberWithBool:x]
#define FBOX(x) [NSNumber numberWithFloat:x]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#import "AppDelegate.h"


@implementation AppDelegate


extern NSUserDefaults *defaults;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
    [drawerController setMaximumLeftDrawerWidth:250.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    defaults = [NSUserDefaults standardUserDefaults];
    settings = [GlobalVariables singleObj];
    
    //First run statment set defaults
    BOOL isRunMoreThanOnce = [defaults boolForKey:@"isRunMoreThanOnce"];
    //Get version number in order to reset data if updated
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    float version = [appVersionString floatValue];
    float previousVersion = [defaults floatForKey:@"appVersion"];
    
    
    //Check if app has been run more than once
    //Check if previous and this verison number are different
    if(!isRunMoreThanOnce || version != previousVersion){
        // Show the alert view
        // Then set the first run flag
        //[defaults setBool:YES forKey:@"isRunMoreThanOnce"];
        NSLog(@"Version %@", [NSString stringWithFormat: @"%f", version]);
        NSLog(@"Previous Version %@", [NSString stringWithFormat: @"%f", previousVersion]);
        
        [defaults setFloat:version forKey:@"appVersion"];
        
        NSArray *_collect = @[BBOX(YES)];
        NSArray *_host = @[@"mobsense.net"];
        NSArray *_port = @[@"80"];
        NSArray *_facebook = @[@""];
        NSArray *_twitter = @[@""];
        NSArray *_google = @[@""];
        
        [defaults setBool:YES forKey:@"collect"];
        [defaults setObject:@"mobsense.net" forKey:@"host"];
        [defaults setObject:@"80" forKey:@"port"];
        [defaults setObject:@"facebook" forKey:@""];
        [defaults setObject:@"twitter" forKey:@""];
        [defaults setObject:@"google" forKey:@""];
        
        [defaults setObject:_collect forKey:@"_collect"];
        [defaults setObject:_host forKey:@"_host"];
        [defaults setObject:_port forKey:@"_port"];
        [defaults setObject:_facebook forKey:@"_facebook"];
        [defaults setObject:_twitter forKey:@"_twitter"];
        [defaults setObject:_google forKey:@"_google"];
        
        [defaults synchronize];
        
        
        
        
    }
    
    settings.collect     = [defaults boolForKey:@"collect"];
    settings.host        = [defaults valueForKey:@"host"];
    settings.port        = [defaults valueForKey:@"port"];
    settings.facebook    = [defaults valueForKey:@"facebook"];
    settings.twitter     = [defaults valueForKey:@"twitter"];
    settings.google      = [defaults valueForKey:@"google"];

    
    settings._collect     = [[defaults objectForKey:@"_collect"] mutableCopy];
    settings._host       = [[defaults objectForKey:@"_host"] mutableCopy];
    settings._port       = [[defaults objectForKey:@"_port"] mutableCopy];
    settings._facebook   = [[defaults objectForKey:@"_facebook"] mutableCopy];
    settings._twitter    = [[defaults objectForKey:@"_twitter"] mutableCopy];
    settings._google     = [[defaults objectForKey:@"_google"] mutableCopy];
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // Override point for customization after application launch.
        [[UIApplication sharedApplication]
         setMinimumBackgroundFetchInterval:
         UIApplicationBackgroundFetchIntervalMinimum];
        
    } else {
        
        
        
    }
    
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    //GAI *gai = [GAI sharedInstance];
    //gai.trackUncaughtExceptions = YES; // report uncaught exceptions
    //gai.logger.logLevel = kGAILogLevelError; // remove before app release
    
    //reload authetication cookies ]
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    NSLog(@"cookie dictionary found is %@",cookieDictionary);
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        
        
        NSLog(@"cookie found is %@",[cookieDictionary objectAtIndex:i]);
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [defaults setBool:NO forKey:@"enabled"];
    
    [defaults setBool:settings.collect forKey:@"collect"];
    [defaults setObject:settings.host forKey:@"host"];
    [defaults setObject:settings.port forKey:@"port"];
    [defaults setObject:settings.facebook forKey:@"facebook"];
    [defaults setObject:settings.twitter forKey:@"twitter"];
    [defaults setObject:settings.google forKey:@"google"];
    
    [defaults setObject:settings._collect forKey:@"_collect"];
    [defaults setObject:settings._host forKey:@"_host"];
    [defaults setObject:settings._port forKey:@"_port"];
    [defaults setObject:settings._facebook forKey:@"_facebook"];
    [defaults setObject:settings._twitter forKey:@"_twitter"];
    [defaults setObject:settings._google forKey:@"_google"];

    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}


@end
