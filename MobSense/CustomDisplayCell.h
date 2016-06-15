//
//  CustomDisplayCell.h
//  WizardTemplate
//
//  Created by Michael Kabatek on 10/11/15.
//  Copyright © 2015 stream^N Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

// extends UITableViewCell
@interface CustomDisplayCell : UITableViewCell

// now only showing one label
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *captionLabel;

@end
