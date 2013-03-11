//
//  ABViewController.h
//  AutoBears
//
//  Created by Cameron Ehrlich on 2/6/13.
//  Copyright (c) 2013 Cameron Ehrlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *AutoBearsEnabled;
@property (strong, nonatomic) IBOutlet UITextField *CalNetID;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)login:(id)sender;

@end
