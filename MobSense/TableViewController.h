//
//  TableViewController.h
//  MobSense
//
//  Created by Michael Kabatek on 6/8/16.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TableViewController : UITableViewController

@property (nonatomic, strong) MPVolumeView *volumeView;

@end

