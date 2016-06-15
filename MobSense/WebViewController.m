//
//  WebViewController.m
//  MobSense
//
//  Created by Michael Kabatek on 6/7/16.
//  Copyright © 2016 stream^N Inc. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController



NSString *token;
NSString *tokenSecret;
NSString *userId;
NSString *oauth_token;
NSString *oauth_verifier;
NSMutableDictionary *queryStringDictionary;
NSMutableDictionary *queryTokens;
NSURLRequest *rq1;
NSURLRequest *rq2;
UIWebView *webView;

int requestNumber = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    requestNumber = 0;
    // Do any additional setup after loading the view, typically from a nib.
    settings = [GlobalVariables singleObj];
    
    //create header webview and button
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    headerView.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];

    queryStringDictionary = [[NSMutableDictionary alloc] init];
    queryTokens  = [[NSMutableDictionary alloc] init];
    webView.delegate = self;
    
    //create and custimzie the cancel button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(8, 8, 64, 64);
    
    
    //add subviews to the viewcontroller
    [self.view addSubview:headerView];
    [self.view addSubview:webView];
    [headerView addSubview:button];
    
    if([_provider isEqualToString:@"Twitter"] ){

        NSURL *url = [NSURL URLWithString:@"https://mobsense.net/auth/twitter"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    
    }
    else{
    
        NSURL *url = [NSURL URLWithString:_loadUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
    }
    
    
    

    

    
}


- (BOOL)webView:(UIWebView *)wV shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (!webView.isLoading) {
        
        NSString *currentURL = webView.request.URL.absoluteString;
        NSLog(@"Current URL %@\n", currentURL);
        
        NSString *currentHost = [[[NSURL alloc] initWithString:currentURL] host];
        NSLog(@"Current HOST %@\n", currentHost);
        NSLog(@"Settings HOST %@\n", settings.host);


        if([settings.host isEqualToString:currentHost]){
            
            //Save cookies in NSUSerDefaults for later use
            NSLog(@"Authenticated!");
            
            //Manually save cookies for later recall
            NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
            for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                [cookieArray addObject:cookie.name];
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
                [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
                [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
                [cookieProperties setObject:[NSNumber numberWithInt:cookie.version] forKey:NSHTTPCookieVersion];
                
                [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
                
                [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //compose and show alert for succesful authentication
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Authenticated."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [webView setDelegate:nil];
            [super.self dismissViewControllerAnimated:YES completion:nil];
        
        }
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)cancel{
    
    [super.self dismissViewControllerAnimated:YES completion:nil];
    

}


@end
