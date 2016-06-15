//
//  ButtonTableViewCell.m
//  Mobsense
//
//  Created by Michael Kabatek on 1/31/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)touchUp:(id)sender {
    NSLog(@"Done tapping, presisting settings");
    //[defaults synchronize];
}


@end