//
//  TableViewController.m
//  MobSense
//
//  Created by Michael Kabatek on 6/8/16.
//  Copyright (c) 2015 stream^N Inc. All rights reserved.
//

#import "TableViewController.h"


@interface TableViewController ()

@end

//TODO: update to use MobSense for server
NSString *adURL = @"https://mobsense.net";
CGFloat height;
CGFloat width;
CGFloat aspect;
CGFloat cellWidth;

@implementation TableViewController
@synthesize volumeView = _volumeView;


- (NSArray *) testModel{
    return @[@"", @"Home",@"Settings",@"Share"];
}

- (NSArray *) iconModel{
    return @[@"", @"home.png",@"settings.png",@"share.png"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSIndexPath* selectedCellIndexPath0= [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedCellIndexPath0 animated:true scrollPosition:UITableViewScrollPositionTop];
    NSIndexPath* selectedCellIndexPath1= [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedCellIndexPath1 animated:true scrollPosition:UITableViewScrollPositionTop];
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self testModel] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.row == 0){
        
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        cellRect = CGRectOffset(cellRect, -tableView.contentOffset.x, -tableView.contentOffset.y);
        cellWidth = cellRect.size.width;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.frame = cellRect;
        cell.backgroundView = imgView;
        
        
        //Async load json from server via http
        //TODO migrate this to MobSense server
        NSURL *jsonUrl = [NSURL URLWithString:@"https://mobsense.net/resources/free.json"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:jsonUrl];
        [request setTimeoutInterval: 2.0]; // Will timeout after 2 seconds
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (data != nil && error == nil)
                                   {
                                       NSLog(@"async json successful");
                                       // It worked, your source HTML is in sourceHTML
                                       //Success getting JSON! trying to get image
                                       NSLog(@"JSON Data has loaded successfully.");
                                       NSError* jsonError;
                                       NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions
                                                                                                      error:&jsonError];
                                       if (jsonError) {
                                           
                                           //Error converting JSON! load the default image
                                           NSLog(@"%@", [error localizedDescription]);
                                           UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
                                           [imgView setContentMode:UIViewContentModeScaleAspectFill];
                                           imgView.frame = cellRect;
                                           cell.backgroundView = imgView;
                                           
                                           
                                           
                                       } else {
                                           
                                           
                                           //Success parsing JSON!
                                           NSLog(@"JSON Data has parsed successfully.");
                                           
                                           NSString *url = jsonResponse[@"url"];
                                           NSString *image = jsonResponse[@"image"];
                                           
                                           NSLog(@"URL: %@", url);
                                           NSLog(@"IMAGE: %@", image);
                                           
                                           NSURL *imageUrl = [NSURL URLWithString:image];
                                           adURL = url;
                                           
                                           
                                           NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
                                           [request setTimeoutInterval: 2.0]; // Will timeout after 2 seconds
                                           [NSURLConnection sendAsynchronousRequest:request
                                                                              queue:[NSOperationQueue currentQueue]
                                                                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                                      
                                                                      if (data != nil && error == nil)
                                                                      {
                                                                          
                                                                          //Success loading image!
                                                                          NSLog(@"Image has loaded successfully.");
                                                                          UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
                                                                          [imgView setContentMode:UIViewContentModeScaleAspectFill];
                                                                          imgView.frame = cellRect;
                                                                          cell.backgroundView = imgView;
                                                                          
                                                                      }
                                                                      else
                                                                      {
                                                                          //Error loading image! load the default image
                                                                          NSLog(@"%@", [error localizedDescription]);
                                                                          UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
                                                                          [imgView setContentMode:UIViewContentModeScaleAspectFill];
                                                                          imgView.frame = cellRect;
                                                                          cell.backgroundView = imgView;
                                                                          
                                                                      }
                                                                      
                                                                  }];
                                           
                                           
                                           
                                           
                                           
                                           
                                           
                                       }
                                       
                                   }
                                   else
                                   {
                                       NSLog(@"async error");
                                       //Error loading image! load the default image
                                       NSLog(@"%@", [error localizedDescription]);
                                       UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
                                       [imgView setContentMode:UIViewContentModeScaleAspectFill];
                                       imgView.frame = cellRect;
                                       cell.backgroundView = imgView;
                                       
                                       
                                   }
                                   
                               }];
        
        
    }
    else{
        cell.textLabel.text = [self testModel][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[self iconModel][indexPath.row]];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.transform = CGAffineTransformMakeScale(0.69, 0.69);
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    UIViewController *settings =  [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    
    switch (index) {
        case 0:{
            //Banner ad menu image
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adURL]];
            
            break;
        }
        case 1:{
            //NavDrawer Home button - load home vc
            self.mm_drawerController.centerViewController = home;
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                //run this when drawer closed finished
                
            }];

            break;
        }
        case 2:{
            //NavDrawer Settings button - load settings vc
            self.mm_drawerController.centerViewController = settings;
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {

                //run this when drawer closed finished
                
            }];

            break;
        }
        case 3:{
            //Nav Drawer Share button
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
                //run this when drawer closed finished
                
                NSLog(@"shareButton pressed");
                NSURL *url = [NSURL URLWithString:@"https://mobsense.net"];
                NSString *text = @"@MobSense is a data collection and visualization framework for mobile devices.\n";
                //UIImage *image = [UIImage imageNamed:@"noisapp_media_onepage_oneline_iphone.png"];
                NSArray *activityItems = @[text, url];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                [activityVC setValue:@"@MobSense is a data collection and visualization framework for mobile devices." forKey:@"subject"];
                activityVC.excludedActivityTypes = @[UIActivityTypePrint,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypePostToVimeo
                                                     ];
                [self presentViewController:activityVC animated:TRUE completion:nil];
                
            }];
            
            break;
        }
            
            
        default:
            break;
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //sizes of cells in NavDrawer cell zero is larger because image otherwize navbutton
    if(indexPath.row == 0){
        
        return 180;
        
    }
    else{
        
        return 50;
    }
    
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end

