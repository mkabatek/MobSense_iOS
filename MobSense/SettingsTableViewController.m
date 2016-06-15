//
//  SettingsTableViewController.m
//  MobSense
//
//  Created by Michael Kabatek on 6/9/16.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import "SettingsTableViewController.h"

#define BBOX(x) [NSNumber numberWithBool:x]
#define FBOX(x) [NSNumber numberWithFloat:x]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface SettingsTableViewController (){

    NSArray *LabelArray;
    NSArray *DescriptionArray;
    NSArray *ValueArray;
    NSArray *TypeArray;
    NSArray *ModeArray;
    
}

@end

@implementation SettingsTableViewController



@synthesize SettingsTableView;
@synthesize tblTable;




extern NSUserDefaults * defaults;
extern id<GAITracker> tracker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshTable" object:nil];
    

    defaults = [NSUserDefaults standardUserDefaults];
    settings = [GlobalVariables singleObj];
    
    self.SettingsTableView.dataSource = self;
    self.SettingsTableView.delegate = self;


    LabelArray = [[NSArray alloc]initWithObjects:   @"Collect Sensor Data",
                                                    @"Hostname",
                                                    @"Port",
                                                    @"Facebook",
                                                    @"Twitter",
                                                    @"Google",
                                                    @"Clear all Authentication", nil];
    
    
    DescriptionArray = [[NSArray alloc]initWithObjects: @"Collect Sensor Data",
                                                        [NSString stringWithFormat: @"%@", settings.host],
                                                        [NSString stringWithFormat: @"%@", settings.port],
                                                        @"Sign with Facebook",
                                                        @"Sign with Twitter",
                                                        @"Sign with Google",
                                                        @"Clear all Authentication", nil];
    
    
    ValueArray = [[NSArray alloc]initWithObjects:     BBOX(settings.collect),
                                                      [NSString stringWithFormat: @"%@", settings.host],
                                                      [NSString stringWithFormat: @"%@", settings.port],
                                                      @"Authenticate with Facebook",
                                                      @"Authenticate with Twitter",
                                                      @"Authenticate with Google",
                                                      @"Clear all Authentication", nil];
    
    TypeArray =  [[NSArray alloc]initWithObjects:   @"switch",
                                                    @"button",
                                                    @"button",
                                                    @"button",
                                                    @"button",
                                                    @"button",
                                                    @"button", nil];
    
    ModeArray =  [[NSArray alloc]initWithObjects:   @"global",
                                                    @"global",
                                                    @"global",
                                                    @"global",
                                                    @"global",
                                                    @"global",
                                                    @"global", nil];
    
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    self.navigationItem.leftBarButtonItem  = button;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.topItem.title = @"Settings";
    [self addHeaderAndFooter];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Settings"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    
}

// Add this method just beneath viewDidLoad:
- (void)refreshTableWithNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return LabelArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * currentType = [TypeArray objectAtIndex:indexPath.row];
    NSString * currentLabel = [LabelArray objectAtIndex:indexPath.row];
    
    
    
    if ([currentType isEqualToString:@"slider"]) {
        
    }
    else if([currentType isEqualToString:@"switch"]){
        
    }
    else if ([currentType isEqualToString:@"button"]){
        
        
        
        if ([currentLabel isEqualToString:@"Hostname"]) {
            
            //User chooses Hostname
            NSLog(@"User selected Hostname");
            
            if ([UIAlertController class])
            {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hostname" message:@"Hostname (mobsense.net)." preferredStyle:UIAlertControllerStyleAlert]; // 7
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    //User updates Hostname
                    NSString *text = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                    
                    //update values here
                    settings._host[0] = text;
                    settings.host = settings._host[0];
                    [defaults setObject:settings._host forKey:@"_host"];
                    
                    [self.tableView reloadData];
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    NSLog(@"User pressed Cancel");
                    
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                
                
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    //populate hostname here
                    textField.text = settings._host[0];
                    textField.placeholder = @"mobsense.net";
                }];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hostname" message:@"Hostname (mobsense.net)." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                //get Hostname here
                [[alert textFieldAtIndex:0] setText:settings.host];
                alert.tag = 1;
                [alert show];
                
            }
            
            
            
        }
        else if ([currentLabel isEqualToString:@"Port"]){
            

            //User chooses Port
            NSLog(@"User selected Port");
            
            if ([UIAlertController class])
            {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Port" message:@"Port (80)." preferredStyle:UIAlertControllerStyleAlert]; // 7
                
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    
                    
                    //User updates Hostname
                    NSString *text = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                    
                    //update values here
                    settings._port[0] = text;
                    settings.port = settings._port[0];
                    [defaults setObject:settings._port forKey:@"_port"];
                    
                    [self.tableView reloadData];
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    NSLog(@"User pressed Cancel");
                    
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                
                
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    //populate port here
                    textField.text = settings._port[0];
                    textField.placeholder = @"80";
                    
                }];
                [[alert.textFields objectAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Port" message:@"Port (80)." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                //get port here
                [[alert textFieldAtIndex:0]  setText:settings.port ];
                [[alert textFieldAtIndex:0]  setKeyboardType:UIKeyboardTypeNumberPad ];
                
                alert.tag = 1;
                [alert show];
                
            }
            
            
        }
        else if ([currentLabel isEqualToString:@"Facebook"]){
            
            NSLog(@"Authenticate with Facebook");
            
            [[NXOAuth2AccountStore sharedStore] setClientID:@"XXXXXXXXXXX" // your App ID Facebook
                                                     secret:@"XXXXXXXXXXX" // your App secret Facebook
                                           authorizationURL:[NSURL URLWithString:@"https://www.facebook.com/dialog/oauth"]
                                                   tokenURL:[NSURL URLWithString:@"https://graph.facebook.com/oauth/access_token"]
                                                redirectURL:[NSURL URLWithString:@"https://mobsense.net/auth/facebook/callback"]
                                             forAccountType:@"Facebook"];
            
            
            [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Facebook"
                                           withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                               // Open a web view or similar
                                               
                                               NSString *loadUrl = [preparedURL absoluteString];
                                               WebViewController * webView = [[WebViewController alloc] init];
                                               webView.provider = @"Facebook";
                                               webView.loadUrl = loadUrl;
                                               [self presentViewController:webView animated:YES completion:nil];
                                               
                                           }];
            
            
        }
        else if ([currentLabel isEqualToString:@"Twitter"]){
            
            NSLog(@"Authenticate with Twitter");
            
            NSString *CALL_BACK_URL = @"http://mobsense.net/auth/twitter/callback";
            NSString *TWITTER_OAUTH_KEY = @"XXXXXXXXXXX"; // your App ID Twitter
            NSString *TWITTER_OAUTH_SECRET = @"XXXXXXXXXXX"; // your App secret Twitter
            
            //NSString *loadUrl = [preparedURL absoluteString];
            WebViewController * webView = [[WebViewController alloc] init];
            webView.provider = @"Twitter";
            webView.CALL_BACK_URL = CALL_BACK_URL;
            webView.TWITTER_OAUTH_KEY = TWITTER_OAUTH_KEY;
            webView.TWITTER_OAUTH_SECRET = TWITTER_OAUTH_SECRET;
            [self presentViewController:webView animated:YES completion:nil];
            
            
            

            
            

        }
        else if ([currentLabel isEqualToString:@"Google"]){
            
            NSLog(@"Authenticate with Google");
            
            
            [[NXOAuth2AccountStore sharedStore] setClientID:@"XXXXXXXXXXX" // your App ID Google
                                                     secret:@"XXXXXXXXXXX" // your App secret Google
                                           authorizationURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/plus.me"]
                                                   tokenURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"]
                                                redirectURL:[NSURL URLWithString:@"https://mobsense.net/auth/google/callback"]
                                             forAccountType:@"Google"];
            
            


            [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Google"
                                           withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                               // Open a web view or similar
                                               
                                               NSString *loadUrl = [preparedURL absoluteString];
                                               WebViewController * webView = [[WebViewController alloc] init];
                                               webView.provider = @"Google";
                                               webView.loadUrl = loadUrl;
                                               [self presentViewController:webView animated:YES completion:nil];
                                               
                                           }];
            
        }
        else if ([currentLabel isEqualToString:@"Clear all Authentication"]){
            
            NSLog(@"Clear all Authentication");
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done"
                                                            message:@"Authentication Cleared."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
        else{
        
        }

        

    
    }
    
    
}

//Alert method for pre iOS7 and lower
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 0){
        
        //Case where select preset is clicked
        switch (buttonIndex)
        {
            case 0:

                break;
            default:

                
                [self.tableView reloadData];
                break;
        }

    
    }
    else if (alertView.tag == 1){
        
        //Case where rename preset is clicked
        if (buttonIndex == 0) {
            // cancel button response
            
        }
        else if(buttonIndex == 1){
            NSString *text = [alertView textFieldAtIndex:0].text;
            [self.tableView reloadData];
            
        }
    
    
    }
    

    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    //This code generates the cells to be shown on screen. It runs each time a cell is moved off screen
    //values arrays need to be refreshed here.
    
    DescriptionArray = [[NSArray alloc]initWithObjects: @"Collect Sensor Data",
                        [NSString stringWithFormat: @"%@", settings.host],
                        [NSString stringWithFormat: @"%@", settings.port],
                        @"Facebook",
                        @"Twitter",
                        @"Google",
                        @"Clear all Authentication", nil];
    
    
    ValueArray = [[NSArray alloc]initWithObjects:     BBOX(settings.collect),
                  [NSString stringWithFormat: @"%@", settings.host],
                  [NSString stringWithFormat: @"%@", settings.port],
                  @"Authenticate with Facebook",
                  @"Authenticate with Twitter",
                  @"Authenticate with Google",
                  @"Clear all Authentication", nil];
    

    static NSString *CellIdentifier;
    NSString * currentType = [TypeArray objectAtIndex:indexPath.row];
    UITableViewCell *returnCell;
    
    if ([currentType isEqualToString:@"slider"]) {
        
        //Populate custom slider cells
        
    }
    else if([currentType isEqualToString:@"button"]){
        
        
        //Populate custom button cells
        CellIdentifier = @"ButtonCell";
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if(!cell){
            
            
            cell = [[ButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.ButtonLabel.text = [LabelArray objectAtIndex:indexPath.row];
        cell.ButtonTextLabel.text = [ValueArray objectAtIndex:indexPath.row];
        cell.ButtonTextLabel.numberOfLines = 0;
        cell.ButtonTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tableView= tableView;
        returnCell = cell;
        
    }
    else if([currentType isEqualToString:@"switch"]){
        
        //Populate custom switch cells
        CellIdentifier = @"SwitchCell";
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            
            
            cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.SwitchLabel.text = [LabelArray objectAtIndex:indexPath.row];
        cell.SwitchDescription.text = [DescriptionArray objectAtIndex:indexPath.row];
        [cell.Switch setOn:[[ValueArray objectAtIndex:indexPath.row] boolValue] animated:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tableView= tableView;
        returnCell = cell;
        
    
    }
    else{
        
        //Poopulate place holders
        CellIdentifier = @"EmptyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        returnCell = cell;
    }
    
    return returnCell;
    
}


- (IBAction)restoreDefaults:(id)sender {
    
    
    //Restore default settings
    self.mm_drawerController.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    NSArray *_collect = @[BBOX(YES)];
    NSArray *_host = @[@"mobsense.net"];
    NSArray *_port = @[@"80"];
    NSArray *_facebook = @[@""];
    NSArray *_twitter = @[@""];
    NSArray *_google = @[@""];
    
    [defaults setObject:_collect forKey:@"_collect"];
    [defaults setObject:_host forKey:@"_host"];
    [defaults setObject:_port forKey:@"_port"];
    [defaults setObject:_facebook forKey:@"_facebook"];
    [defaults setObject:_twitter forKey:@"_twitter"];
    [defaults setObject:_google forKey:@"_google"];
    
    [defaults setBool:NO forKey:@"collect"];
    [defaults setObject:@"mobsense.net" forKey:@"host"];
    [defaults setObject:@"80" forKey:@"port"];
    [defaults setObject:@"facebook" forKey:@"Facebook"];
    [defaults setObject:@"twitter" forKey:@"Twitter"];
    [defaults setObject:@"google" forKey:@"Google"];
    
    settings.collect     = [defaults boolForKey:@"collect"];
    settings.host        = [defaults valueForKey:@"host"];
    settings.port        = [defaults valueForKey:@"port"];
    settings.facebook    = [defaults valueForKey:@"facebook"];
    settings.twitter     = [defaults valueForKey:@"twitter"];
    settings.google      = [defaults valueForKey:@"google"];
    
    
}




-(NSArray *)get_memory_array
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
    }
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    
    NSString *free = [NSString stringWithFormat:@"%u", mem_free];
    NSString *used = [NSString stringWithFormat:@"%u", mem_used];
    NSString *total = [NSString stringWithFormat:@"%u", mem_total];
    
    NSArray * MemArray =  [[NSArray alloc]initWithObjects:free, used, total, nil];
    return MemArray;
    
    
}


//Get platform details
- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

- (void) addHeaderAndFooter
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:v];
    [self.tableView setTableFooterView:v];

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


//Unused methods
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
