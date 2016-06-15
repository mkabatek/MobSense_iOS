//
//  ViewController.m
//  ScrollView
//
//  Created by Michael Kabatek on 10/11/15.
//  Copyright © 2015 stream^N Inc. All rights reserved.
//

#import "WizardController.h"
#import "CustomDisplayCell.h"

@interface WizardController ()

@end

@implementation WizardController

int pages = 8; //number of pages in the wizard
int marginX = 0;
int marginY = 0;
float screenScale = 1.25;
UITableView *tableView;
NSMutableArray *headerArray;
NSMutableArray *captionArray;
NSMutableArray *settingsArray;
NSMutableArray *settingsTitleArray;
NSMutableArray *settingsCaptionArray;
NSMutableAttributedString *string;
UIButton *button;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    headerArray = [NSMutableArray array];
    [headerArray addObject:@"Welcome"];
    [headerArray addObject:@"Get Ready"];
    [headerArray addObject:@"MobSense Disabled"];
    [headerArray addObject:@"Allow Location"];
    [headerArray addObject:@"MobSense Enabled"];
    [headerArray addObject:@"Menu"];
    [headerArray addObject:@"Settings"];
    [headerArray addObject:@"Settings Overview"];
    
    
    captionArray = [NSMutableArray array];
    [captionArray addObject:@"This tutorial will guide you through the steps of using MobSense."];
    [captionArray addObject:@"Make sure you're signed up at mobsense.net, and have connected at least one social account."];
    [captionArray addObject:@"Click the large red MobSense icon to enable MobSense."];
    [captionArray addObject:@"The first time you enable MobSense, you must allow location services."];
    [captionArray addObject:@"When MobSense is enabled, data collection is active, and sent to your mobsense.net account."];
    [captionArray addObject:@"Use the navigation menu to switch between the Home and Settings screens."];
    [captionArray addObject:@"Use the settings to connect your account to mobsense.net."];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Approximate Distance: 120m away"];
    NSRange selectedRange = NSMakeRange(22, 4); // 4 characters, starting at index 22
    
    [string beginEditing];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                   range:selectedRange];
    
    [string endEditing];

    
    settingsArray = [NSMutableArray array];
    [settingsArray addObject:@"Collect Sensor Data: Enable/Disable data to your host"];
    [settingsArray addObject:@"Host: Host where data is sent."];
    [settingsArray addObject:@"Port: Port where data is sent."];
    [settingsArray addObject:@"Facebook: Autheticate with Facebook."];
    [settingsArray addObject:@"Twitter: Autheticate with Twitter."];
    [settingsArray addObject:@"Google: Autheticate with Google."];
    [settingsArray addObject:@"Clear all Authentication: Clear all authenticated accounts."];
    
    
    //Breaking these out for custom cell
    settingsTitleArray = [NSMutableArray array];
    [settingsTitleArray addObject:@"Collect Sensor Data:"];
    [settingsTitleArray addObject:@"Host:"];
    [settingsTitleArray addObject:@"Port:"];
    [settingsTitleArray addObject:@"Facebook:"];
    [settingsTitleArray addObject:@"Twitter:"];
    [settingsTitleArray addObject:@"Google:"];
    [settingsTitleArray addObject:@"Clear all Authentication:"];
    
    settingsCaptionArray = [NSMutableArray array];
    [settingsCaptionArray addObject:@"Enable/Disable data to your host."];
    [settingsCaptionArray addObject:@"Host where data is sent."];
    [settingsCaptionArray addObject:@"Port where data is sent."];
    [settingsCaptionArray addObject:@"Autheticate with Facebook."];
    [settingsCaptionArray addObject:@"Autheticate with Twitter."];
    [settingsCaptionArray addObject:@"Autheticate with Google."];
    [settingsCaptionArray addObject:@"Clear all authenticated accounts."];
    
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    NSLog(@"Frame width %f", scrollview.frame.size.width);
    NSLog(@"Frame height %f", scrollview.frame.size.height);
    NSLog(@"Screen width %f", screenWidth);
    NSLog(@"Screen height %f", screenHeight);
    marginY = screenWidth/4;


    
    // Adjust scroll view content size, set background colour and turn on paging
    
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * pages, scrollview.frame.size.height);
    scrollview.pagingEnabled=YES;
    scrollview.backgroundColor = [UIColor whiteColor];
    
    // Generate content for our scroll view using the frame height and width as the reference point
    
    
    int headerLocation = -screenHeight/2 + 48;
    int captionLocation = -screenHeight/2 + 104;
    int textPadding = 16;
    int buttonHeight = 64;
    
    int i = 0;
    while (i <= pages - 1) {
        

        if (i == pages - 1) {
            
            
            //Code for final page here
            
            NSString *header = [headerArray objectAtIndex:i];
            //Add normal view
            UIView *page =[[UIImageView alloc] initWithFrame:CGRectMake(((scrollview.frame.size.width)*i), marginY, screenWidth, screenHeight*screenScale)];
            [scrollview addSubview:page];
            
            
            
            //Add header to view
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(((scrollview.frame.size.width)*i) + textPadding, headerLocation, screenWidth - textPadding*2, screenHeight)];
            headerLabel.text = header; //here you set the text you want...
            headerLabel.font = [UIFont fontWithName:@"Arial" size:32];
            headerLabel.textColor = [UIColor colorWithRed:0/255.f green:161/255.f blue:227/255.f alpha:1.0];
            [scrollview addSubview:headerLabel];
            
            //Add settings overview here
            //Table location properties
            CGFloat x = ((scrollview.frame.size.width)*i);
            CGFloat y = marginY;
            CGFloat width = screenWidth - textPadding;
            CGFloat height = screenHeight - buttonHeight - marginY;
            CGRect tableFrame = CGRectMake(x, y, width, height);
            
            tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
            
            tableView.rowHeight = 80;
            tableView.sectionFooterHeight = 16;
            tableView.sectionHeaderHeight = 16;
            tableView.scrollEnabled = YES;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.userInteractionEnabled = YES;
            tableView.allowsSelection = NO;
            tableView.bounces = YES;

            tableView.delegate = self;
            tableView.dataSource = self;


            [scrollview addSubview:tableView];
            
            //Add button to buttom of table view
            
            
            //Table location properties
            CGFloat bx = ((scrollview.frame.size.width)*i);
            CGFloat by = screenHeight - buttonHeight;
            CGFloat bWidth = screenWidth;
            CGFloat bHeight = buttonHeight;
            CGRect buttonFrame = CGRectMake(bx, by, bWidth, bHeight);
            button = [[UIButton alloc] initWithFrame: buttonFrame];
            [button setTitle: @"Get Started" forState: UIControlStateNormal];
            [button addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor: [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1.0] forState: UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.0];
            [scrollview addSubview:button];
            i++;
            
        }
        else{
            //Code from normal pages here
            NSString *header = [headerArray objectAtIndex:i];
            NSString *caption = [captionArray objectAtIndex:i];
            
            //add image pages
            UIImageView *page =[[UIImageView alloc] initWithFrame:CGRectMake(((scrollview.frame.size.width)*i), marginY, screenWidth, screenHeight*screenScale)];
            
            page.contentMode = UIViewContentModeScaleAspectFit;
            CGRect pageBound = page.bounds;
            CGSize pageSize = pageBound.size;
            CGFloat pageWidth = pageSize.width;
            CGFloat pageHeight = pageSize.height;
//            NSLog(@"Page width %f", pageWidth);
//            NSLog(@"Page height %f", pageHeight);
            
            NSString * imageString = [NSString stringWithFormat:@"%@%d%@", @"guide", i, @".png"];
            page.image=[UIImage imageNamed:imageString];
            [scrollview addSubview:page];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(((scrollview.frame.size.width)*i) + textPadding, headerLocation, screenWidth - textPadding*2, screenHeight)];
            headerLabel.text = header; //here you set the text you want...
            headerLabel.font = [UIFont fontWithName:@"Arial" size:32];
            headerLabel.textColor = [UIColor colorWithRed:0/255.f green:161/255.f blue:227/255.f alpha:1.0];
            [scrollview addSubview:headerLabel];
            
            UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(((scrollview.frame.size.width)*i) + textPadding, captionLocation, screenWidth - textPadding*2, screenHeight)];
            captionLabel.text = caption; //here you set the text you want...
            captionLabel.font = [UIFont fontWithName:@"Arial" size:18];
            captionLabel.textColor = [UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1.0];
            captionLabel.numberOfLines = 0;
            captionLabel.textAlignment = NSTextAlignmentLeft;
            [scrollview addSubview:captionLabel];
            i++;
        
        }
        
            

        


    }
    
    
    [self.view addSubview:scrollview];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-  (void)btnSelected:(id)sender{
    
    NSLog(@"Button Clicked");
    if(button.enabled)
    {
        button.enabled=NO;
        button.backgroundColor=[UIColor whiteColor];
        [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(delayedFunction:) userInfo:nil repeats:NO];

        
        
    }



}

- (void)delayedFunction:(id)sender{

    button.enabled=YES;
    button.backgroundColor = [UIColor colorWithRed:0/255.f green:153/255.f blue:51/255.f alpha:1.0];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [settingsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tmpTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier         =   @"MainCell";
    CustomDisplayCell *cell               =   [tmpTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell    =   [[CustomDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.textLabel sizeToFit];
    
    cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titleLabel.numberOfLines = 0;
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.captionLabel.numberOfLines = 0;
    cell.captionLabel.textAlignment = NSTextAlignmentLeft;

 
    cell.textLabel.text = @"";
    cell.titleLabel.text = [settingsTitleArray objectAtIndex:indexPath.row];
    cell.captionLabel.text = [settingsCaptionArray objectAtIndex:indexPath.row];
    
    return cell;
}






@end
