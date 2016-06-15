//
//  CustomDisplayCell.m
//  WizardTemplate
//
//  Created by Michael Kabatek on 10/11/15.
//  Copyright © 2015 stream^N Inc. All rights reserved.
//


#import "CustomDisplayCell.h"

@implementation CustomDisplayCell

@synthesize titleLabel = _titleLabel;
@synthesize captionLabel = _captionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 288, 32)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:20.0f];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, 288, 48)];
        self.captionLabel.textColor = [UIColor grayColor];
        self.captionLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];

        
        [self addSubview:self.titleLabel];
        [self addSubview:self.captionLabel];
    }
    return self;
}

@end
