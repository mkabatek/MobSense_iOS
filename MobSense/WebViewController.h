//
//  WebViewController.h
//  MobSense
//
//  Created by Michael Kabatek on 6/7/16.
//  Copyright © 2016 stream^N Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>{

    GlobalVariables *settings;

}


@property (strong, nonatomic) NSString *loadUrl;
@property (strong, nonatomic) NSString *provider;

@property (strong, nonatomic) NSString *CALL_BACK_URL;
@property (strong, nonatomic) NSString *TWITTER_OAUTH_KEY;
@property (strong, nonatomic) NSString *TWITTER_OAUTH_SECRET;



@end
