//
//  LoginEmailViewController.m
//  Nottinghamshire County Council
//
//  Created by Geoff Baker on 19/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "LoginEmailViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "HomeViewController.h"
//#import <Parse/Parse.h>
#import "Flurry.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface LoginEmailViewController ()
//Reachability
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@end

@implementation LoginEmailViewController{
    MBProgressHUD *HUD;//Loading Screen Implementation
    UIImageView *activityImageView;
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    UIAlertController *alert;
    UIScrollView *theScrollView;
    NSString *emailString;
    NSString *passwordString;
    UIView *mainView;
    UIView *buttonView;
    UIAlertAction *defaultAction;
    
    // Loading Animation
    MBProgressHUD *Hud;
    UIActivityIndicatorView *activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Flurry logEvent:@"User Opened Login Email Page" timed:YES];
    NSLog(@"LOGIN EMAIL VC");
    theScrollView = [[UIScrollView alloc] init];
    theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height); //Position of the button
    theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    //Reachability (Checking Internet Connection)
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    //    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    [self updateInterfaceWithReachability:self.hostReachability];
    
//    self.internetReachability = [Reachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
//    [self updateInterfaceWithReachability:self.internetReachability];
    
//    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
//    [self.wifiReachability startNotifier];
//    [self updateInterfaceWithReachability:self.wifiReachability];
    
    //BackgroundImage
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    background.image = [UIImage imageNamed:@"bg"];
    NSLog(@"OPEN???????");
    [theScrollView addSubview:background];
    
    //Implements custom back button
    UIButton *backToLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        backToLoginButton.frame = CGRectMake(10, 10, 80, 30); //Position of the button
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        backToLoginButton.frame = CGRectMake(10, 20, 80, 30);//Position of the button
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        backToLoginButton.frame = CGRectMake(0, 50, 60, 50);//Position of the button
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        backToLoginButton.frame = CGRectMake(10, 40, 100, 40);//Position of the button
    }
    [backToLoginButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backToLoginButton addTarget:self action:@selector(tapBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    [theScrollView addSubview:backToLoginButton];
    
    //forgot password
    
//    UIButton *resetEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
//    {
//        resetEmailButton.frame = CGRectMake(25, self.view.frame.size.height-60, 120, 30); //Position of the button
//
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
//    {
//        resetEmailButton.frame = CGRectMake(25, self.view.frame.size.height-80, 120, 30);//Position of the button
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
//    {
//        resetEmailButton.frame = CGRectMake(28, self.view.frame.size.height-100, 160, 40);//Position of the button
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
//    {
//        resetEmailButton.frame = CGRectMake(30, self.view.frame.size.height-100, 160, 40);//Position of the button
//    }
//
//    resetEmailButton.tag = 2;
//    [resetEmailButton setBackgroundImage:[UIImage imageNamed:@"forgotPasswordButton"] forState:UIControlStateNormal];
//    [resetEmailButton addTarget:self action:@selector(tapButtonLoginEmail:) forControlEvents:UIControlEventTouchUpInside];
//
//    [theScrollView addSubview:resetEmailButton];
    
    //Submit Button
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        submitButton.frame = CGRectMake(40, self.view.frame.size.height-60, self.view.frame.size.width-80, 30); //Position of the button
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        submitButton.frame = CGRectMake(40, self.view.frame.size.height-50, self.view.frame.size.width-80, 30);//Position of the button
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        submitButton.frame = CGRectMake((self.view.frame.size.width-250)/2, self.view.frame.size.height-220, 250, 50);//Position of the button
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        submitButton.frame = CGRectMake(70, self.view.frame.size.height-80, self.view.frame.size.width-140, 40);//Position of the button
    }
    submitButton.tag = 1;
    [submitButton setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(tapButtonLoginEmail) forControlEvents:UIControlEventTouchUpInside];
    
    [theScrollView addSubview:submitButton];
    
    //Icon Background
    
    UIImageView *iconBackground = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        iconBackground.frame = CGRectMake(30, 5, self.view.frame.size.width-60, 220);//Position of the button
        
    } else if ([[UIScreen mainScreen] bounds].size.height == 568)//iPhone 5 size
    {
        iconBackground.frame = CGRectMake(30, 25, self.view.frame.size.width-60, 300);//Position of the button
    } else if ([[UIScreen mainScreen] bounds].size.height == 667)//iPhone 6 size
    {
        iconBackground.frame = CGRectMake((self.view.frame.size.width-150)/2, 10, 150, 150);//Position of the button
    } else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        iconBackground.frame = CGRectMake(30, 50, self.view.frame.size.width-60, 300);//Position of the button
    }
    iconBackground.image = [UIImage imageNamed:@"logo"];
    iconBackground.contentMode = UIViewContentModeScaleAspectFit;
    iconBackground.clipsToBounds = YES;
    [theScrollView addSubview:iconBackground];
    
    
    //Email
    UIColor *color = [UIColor whiteColor];
    email = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        email.frame = CGRectMake(40, 245, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        email.frame = CGRectMake(40, 265, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        email.frame = CGRectMake(70, 355, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    } else {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    email.textAlignment = NSTextAlignmentLeft;
    email.textColor = [UIColor blackColor];
    email.backgroundColor = [UIColor clearColor];
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, email.frame.size.height - borderWidthEmail, email.frame.size.width, email.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [email.layer addSublayer:borderEmail];
    email.layer.masksToBounds = YES;
    email.placeholder = @"Username...";
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    email.returnKeyType = UIReturnKeyDone;
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.keyboardType = UIKeyboardAppearanceDark;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.clipsToBounds = YES;
    email.returnKeyType = UIReturnKeyDone;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    [email setDelegate:self];
    email.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [theScrollView addSubview:email];
    
    
    //Password
    
    password = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        password.frame = CGRectMake(40, 280, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        password.frame = CGRectMake(40, 300, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        password.frame = CGRectMake(70, 400, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    } else {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    password.textAlignment = NSTextAlignmentLeft;
    password.textColor = [UIColor blackColor];
    password.backgroundColor = [UIColor clearColor];
    CALayer *borderPassword = [CALayer layer];
    CGFloat borderWidthPassword = 1;
    borderPassword.borderColor = [UIColor darkGrayColor].CGColor;
    borderPassword.frame = CGRectMake(0, password.frame.size.height - borderWidthPassword, password.frame.size.width, password.frame.size.height);
    borderPassword.borderWidth = borderWidthPassword;
    [password.layer addSublayer:borderPassword];
    password.layer.masksToBounds = YES;
    password.placeholder = @"Password...";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.returnKeyType = UIReturnKeyDone;
    password.keyboardType = UIKeyboardAppearanceDark;
    password.clipsToBounds = YES;
    password.secureTextEntry = YES;
    [password setDelegate:self];
    [password addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    password.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [theScrollView addSubview:password];
    
    [self.view addSubview:theScrollView];
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [password resignFirstResponder];
    if([email isFirstResponder]) {
        [email resignFirstResponder];
        [password becomeFirstResponder];
    } else {
        //[self tappedLogin];
    }
    return YES;
}

-(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

-(void)tapButtonLoginEmail {
    BOOL wrongEmail = [self validateEmail:email.text];
    
    //     Checks if all fields have been completed
    if ([email.text isEqualToString:@""]) {
        [self alertEmptyFields];
    }else {
        
        //     if (wrongEmail == false) {  //Checks if the emails don't match
        //     [self alertWrongEmail];
        //     }
        
        //     if ([password.text isEqualToString: @""]) {
        //     [self alertEmptyFields];
        //     } else{
        //     emailString = email.text;
        //     passwordString = password.text;
        //
        //     emailString = [emailString lowercaseString];
        //     email.text = emailString;
        //
        //     [self CheckDetails];
        //     }
    }
    
    [self CheckDetails];
}


-(void)CheckDetails{
    NSLog(@"Logged In!");
    [Flurry logEvent:@"User logged in" timed:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email.text forKey:@"userEmail"];
    [defaults setObject:password.text forKey:@"userPassword"];
    
    //because keychain saves password as NSData object
    NSData *pwdData = [passwordString dataUsingEncoding:NSUTF8StringEncoding];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
    [keychainItem setObject:pwdData forKey:(__bridge id)(kSecValueData)];
    [keychainItem setObject:emailString forKey:(__bridge id)(kSecAttrAccount)];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.alpha = 1;
        self.navigationController.navigationBar.hidden = NO;
        
        SWRevealViewController *offersControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [self.navigationController pushViewController:offersControl animated:NO];
    });
}












- (void) alertEmptyFields{

    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Username must be completed!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
