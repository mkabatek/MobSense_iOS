//
//  ViewController.m
//  MobSense
//
//  Created by Michael Kabatek on 6/8/16.
//  Copyright (c) 2016 stream^N Inc. All rights reserved.
//

#import "ViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define BBOX(x) [NSNumber numberWithBool:x]
#define FBOX(x) [NSNumber numberWithFloat:x]

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController
@synthesize motionManager;

double alpha = 0.8;
double gx = 0.0;
double gy = 0.0;
double gz = 0.0;
double ax = 0.0;
double ay = 0.0;
double az = 0.0;
bool mSwap = YES;
id<GAITracker> tracker;
NSDateFormatter *dateFormatter;

extern bool enabled = NO;
extern NSUserDefaults *defaults;

+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
        }
    }
    return _locationManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"ViewController viewDidLoad Method Called");
    
    //Get the share model and also initialize myLocationArray
    self.shareModel = [LocationShareModel sharedModel];
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    settings = [GlobalVariables singleObj];
    self.shareModel.settings = settings;
    
    //First run statment check and run tutorial
    BOOL isRunMoreThanOnce = [defaults boolForKey:@"isRunMoreThanOnce"];
    if(!isRunMoreThanOnce){

        
        //run tutorial here
        WizardController * wizard = [[WizardController alloc] init];
        [self presentViewController:wizard animated:YES completion:nil];

        //set run more than once to true
        [defaults setBool:YES forKey:@"isRunMoreThanOnce"];
        [defaults synchronize];
        
    }
    
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];

    self.navigationItem.leftBarButtonItem  = button;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .05;
    
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];


    //Use for gyro data
    /*
    self.motionManager.gyroUpdateInterval = 1;
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                    [self outputRotationData:gyroData.rotationRate];
                                    }];
    */
    
    
    //Check to what notification functions supported
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        //register for notifications
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    }
    

    
    self.localNotification = [[UILocalNotification alloc] init];
    self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.localNotification.alertBody = @"Collecting Data.";
    self.localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    //If main UI enabled start collecting data
    if(enabled && settings.collect){
        
        gx = alpha * gx + (1- alpha) * acceleration.x;
        gy = alpha * gy + (1- alpha) * acceleration.y;
        gz = alpha * gz + (1- alpha) * acceleration.z;
        
        ax = acceleration.x - gx;
        ay = acceleration.y - gy;
        az = acceleration.z - gz;
        
        
        NSString *data = [NSString stringWithFormat:@"t=%@&ax=%f&ay=%f&az=%f", [dateFormatter stringFromDate:[NSDate date]], ax, ay, az];
        [NSThread detachNewThreadSelector:@selector(collectData:) toTarget:self withObject:data];
        
    }
    
}

//Use this method to get gyro data
/*
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    //self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    //self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    //self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    
    
}
*/



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //Location manager keep alive in background
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                                    userInfo:nil
                                                                     repeats:NO];
    
    
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    //Location manager error handler
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Services" message:@"You have to enable Location Services to use MobSense. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
        break;
    }
}



- (IBAction)OnOff:(id)sender {
    
    
    settings.locationManager = [[CLLocationManager alloc] init];
    [settings.locationManager setDelegate:self];
    [settings.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if (enabled) {
        
        NSLog(@"stopping data collection");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        mSwap = YES;
        [settings.locationManager stopUpdatingLocation];
        [self.shareModel.bgTask endAllBackgroundTasks];

        
    }
    else {
        
        NSLog(@"starting data collection");
        
        //Check if location services are enabled
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
            
        }
        
        
        //Logic for handling different version of iOS
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
            [settings.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            
            [settings.locationManager requestAlwaysAuthorization];
            [settings.locationManager startUpdatingLocation];
            
        } else {
            
            [settings.locationManager startUpdatingLocation];
            
        }
        
        
        
    }
    //Toggle master enable bool
    enabled = !enabled;
    self.shareModel.settings.enabled = enabled;
    NSLog(@"Current state %d", enabled);
    

    
    
}


-(void)collectData:(NSObject* )dataArray{
    
    
    //print data to console
    NSLog(@"data: %@", dataArray);
    
    //Compose post request data
    NSString *post = [NSString stringWithFormat:dataArray];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //Get cookies from authentication and write them to the http header
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                  [cookieJar cookies]];
    
    //Compose the http request
    [request setAllHTTPHeaderFields:headers];
    //TODO: use the setting to compose the host
    //send to the /data route on the specified server
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@/data", settings.host]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    //Start the post request
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
    }] resume];
    
    
}


-(void)applicationEnterBackground{
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
        NSLog(@"authorizationStatus failed");
    }
    else{
        
        if(enabled){
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
            
            CLLocationManager *locationManager = [ViewController sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
                [settings.locationManager setAllowsBackgroundLocationUpdates:YES];
                [locationManager setAllowsBackgroundLocationUpdates:YES];
            }
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                
                [settings.locationManager requestAlwaysAuthorization];
                [settings.locationManager startUpdatingLocation];
                
                [locationManager requestAlwaysAuthorization];
                [locationManager startUpdatingLocation];
                
                
            } else {
                
                [settings.locationManager startUpdatingLocation];
                [locationManager startUpdatingLocation];
                
            }
            
            //Use the BackgroundTaskManager to manage all the background Task
            self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
            [self.shareModel.bgTask beginNewBackgroundTask];
        }
        
    }
    

    
}

- (void) restartLocationUpdates
{
    
    //If master enable this should be running to keep the process from being killed in background
    if(enabled){
    
        NSLog(@"restartLocationUpdates");
        
        if (self.shareModel.timer) {
            [self.shareModel.timer invalidate];
            self.shareModel.timer = nil;
        }
        
        CLLocationManager *locationManager = [ViewController sharedLocationManager];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
            [settings.locationManager setAllowsBackgroundLocationUpdates:YES];
            [locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            
            [settings.locationManager requestAlwaysAuthorization];
            [settings.locationManager startUpdatingLocation];
            
            [locationManager requestAlwaysAuthorization];
            [locationManager startUpdatingLocation];
            
            
        } else {
            
            [settings.locationManager startUpdatingLocation];
            [locationManager startUpdatingLocation];
            
        }
        
    }
}

- (void)startLocationTracking {
    NSLog(@"startLocationTracking");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    } else {
        
        
        if(enabled){
            CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
            
            if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
                NSLog(@"authorizationStatus failed");
            } else {
                NSLog(@"authorizationStatus authorized");
                
                CLLocationManager *locationManager = [ViewController sharedLocationManager];
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                locationManager.distanceFilter = kCLDistanceFilterNone;
                
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
                    [settings.locationManager setAllowsBackgroundLocationUpdates:YES];
                    [locationManager setAllowsBackgroundLocationUpdates:YES];
                }
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    
                    [settings.locationManager requestAlwaysAuthorization];
                    [settings.locationManager startUpdatingLocation];
                    
                    [locationManager requestAlwaysAuthorization];
                    [locationManager startUpdatingLocation];
                    
                    
                } else {
                    
                    [settings.locationManager startUpdatingLocation];
                    [locationManager startUpdatingLocation];
                    
                }
            }
        
        }
        
    }
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [ViewController sharedLocationManager];
    [locationManager stopUpdatingLocation];
}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [ViewController sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    NSLog(@"locationManager stop Updating after 10 seconds");
}


// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSLog(@"%@", data);
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"%@", connection);
}


@end
