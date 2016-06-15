//
//  SwitchTableViewCell.m
//  Mobsense
//
//  Created by Michael Kabatek on 1/9/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import "SwitchTableViewCell.h"

#define BBOX(x) [NSNumber numberWithBool:x]
#define FBOX(x) [NSNumber numberWithFloat:x]

@implementation SwitchTableViewCell{

    NSUserDefaults *defaults;

}

- (void)awakeFromNib {
    // Initialization code
    settings = [GlobalVariables singleObj];
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchToggle:(id)sender {
    
    NSLog(@"%@ %d", self.SwitchLabel.text, self.Switch.isOn);
    
    if([self.SwitchLabel.text  isEqual: @"Collect Sensor Data"]){
        
        [defaults setFloat:self.Switch.isOn forKey:@"collect"];
        settings.collect = self.Switch.isOn;
        
        settings._collect[0] = BBOX(self.Switch.isOn);
        [defaults setObject:settings._collect forKey:@"_collect"];
        [defaults synchronize];
        [_tableView reloadData];

        
    }
    else{
        
    }
    
    
}

@end
