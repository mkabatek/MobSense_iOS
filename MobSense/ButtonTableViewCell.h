//
//  ButtonTableViewCell.h
//  Mobsense
//
//  Created by Michael Kabatek on 1/31/15.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ButtonTableViewCell : UITableViewCell{

    
}


@property (strong, nonatomic) IBOutlet UILabel *ButtonLabel;

@property (strong, nonatomic) IBOutlet UILabel *ButtonTextLabel;

@property (strong, nonatomic) IBOutlet UIView *ButtonClick;

@property (nonatomic)UITableView * tableView;

@end
