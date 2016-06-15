//
//  SettingsTableViewController.h
//  MobSense
//
//  Created by Michael Kabatek on 6/9/16.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/sysctl.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Google/Analytics.h>

#import "UIViewController+MMDrawerController.h"

#import "SwitchTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "MMDrawerBarButtonItem.h"
#import "WizardController.h"
#import "WebViewController.h"
#import "NXOAuth2.h"





@interface SettingsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{

    GlobalVariables *settings;

}

@property (strong, nonatomic) IBOutlet UITableView *SettingsTableView;

@property(nonatomic, retain) UITableView *tblTable;

@property (strong, nonatomic) MPVolumeView *volumeView;

@property (strong, nonatomic) IBOutlet UIButton *defaults;

@property (nonatomic, strong) NSArray *statuses;

@property (nonatomic, weak) IBOutlet UITextField *consumerKeyTextField;
@property (nonatomic, weak) IBOutlet UITextField *consumerSecretTextField;
@property (nonatomic, weak) IBOutlet UILabel *loginStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *getTimelineStatusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISwitch *openSafariSwitch;

- (IBAction)loginWithiOSAction:(id)sender;
- (IBAction)loginOnTheWebAction:(id)sender;
- (IBAction)reverseAuthAction:(id)sender;
- (IBAction)getTimelineAction:(id)sender;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;



@end


