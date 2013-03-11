//
//  ABViewController.m
//  AutoBears
//
//  Created by Cameron Ehrlich on 2/6/13.
//  Copyright (c) 2013 Cameron Ehrlich. All rights reserved.
//

#import "ABViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation ABViewController{
    NSString *calnetid;
    NSString *password;
    NSArray *SSIDs;
}

@synthesize AutoBearsEnabled;
@synthesize CalNetID;
@synthesize Password;
@synthesize webView;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    calnetid = [[NSUserDefaults standardUserDefaults] objectForKey:@"calnetid"];
    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    [CalNetID setText:calnetid];
    [Password setText:password];
    
    [self login:nil];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"ended editing field and stored: %@", textField.text);
    if (textField.tag == 0) {
        calnetid = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:calnetid forKey:@"calnetid"];

    }else if (textField.tag){
        password = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)login:(id)sender{
    
    if ([AutoBearsEnabled isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoBearsEnabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [AutoBearsEnabled setOn:YES animated:YES];
        SSIDs = @[@"AirBears"];
        CNSetSupportedSSIDs((__bridge CFArrayRef) SSIDs);
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoBearsEnabled"];
        [AutoBearsEnabled setOn:NO animated:YES];
        SSIDs = @[@""];
        CNSetSupportedSSIDs((__bridge CFArrayRef) SSIDs);
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    
    
//    if (![self checkIfConnectedToAirBears]) {
//        [UpdateLabel setText:@"Connect to AirBears, and choose Auto Join"];
//        return;
//    }else{
//        [UpdateLabel setText:@""];
//    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wlan.berkeley.edu/cgi-bin/login/cookie.cgi"]];
    [webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
    NSString *javascriptString = [NSString stringWithFormat:@"document.getElementById('username').value='%@';document.getElementById('password').value='%@';document.forms['loginForm'].submit();", calnetid, password];
    [self.webView stringByEvaluatingJavaScriptFromString:javascriptString];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activityIndicator stopAnimating];
    NSLog(@"Webview did fail with error %@", [error description]);
}

-(BOOL)checkIfConnectedToAirBears{
    if ([[self fetchSSIDNames] containsObject:@"AirBears"]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (NSArray*)fetchSSIDNames {
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    NSArray *ifs = (__bridge_transfer id) CNCopySupportedInterfaces();    
    for (NSString *ifnam in ifs) {
        CFDictionaryRef networkDict = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSDictionary *dict = (__bridge NSDictionary*) networkDict;
        NSString* ssid = [dict objectForKey:@"SSID"];
        if (ssid) {
            [output addObject:ssid];
        }
    }
    return output;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
