//
//  SwitchTableViewCell.h
//  Mobsense
//
//  Created by Michael Kabatek on 1/9/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface SwitchTableViewCell : UITableViewCell{

            GlobalVariables *settings;


}

@property (strong, nonatomic) IBOutlet UILabel *SwitchLabel;

@property (strong, nonatomic) IBOutlet UILabel *SwitchDescription;

@property (strong, nonatomic) IBOutlet UISwitch *Switch;

@property (nonatomic)UITableView * tableView;


@end
