//
//  ViewController.m
//  Nottinghamshire County Council
//
//  Created by Geoff Baker on 18/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "InitialLoginViewController.h"
//#import <Parse/Parse.h>
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "Flurry.h"

#import "SWRevealViewController.h"
//#import "ImprintDatabase.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "Reachability.h"
#import "MBProgressHUD.h"

@interface InitialLoginViewController ()

@end

@implementation InitialLoginViewController{
    UIView *mainView;
    UIView *buttonView;
    UIScrollView *theScrollView;
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    UIAlertController *alert;                                    //--changed UIAlertView to UIAlertController
    UIAlertAction *defaultAction;
    NSString *emailString;
    NSString *passwordString;
    
    // Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
}

-(void)showLoading
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = NSLocalizedString(@"Loading", nil);
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [mainView addSubview:activityImageView];
    Hud.customView = activityImageView;
}

- (void)viewDidLoad {
    
    [Flurry logEvent:@"User Opened Login Page" timed:YES];
    
    //Log out from all accounts and delete cookies.
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    //    [FBSDKAccessToken setCurrentAccessToken:nil];
    //    [[FBSDKLoginManager new] logOut];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"userId"];
    //    [[PFInstallation currentInstallation] saveInBackground];
    //    [PFUser logOut];
    theScrollView = [[UIScrollView alloc] init];
    theScrollView.bounces = NO;
    theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height); //Position of the button
    theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    //    //Reachability (Checking Internet Connection)
    //    //Delete local notifications
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"userId"];
    //    [[PFInstallation currentInstallation] saveInBackground];
    //    [PFUser logOut];
    [_sidebarButton setEnabled:NO];
    self.navigationController.navigationBarHidden = YES;
    
    //    UIImageView *bg = [[UIImageView alloc] init];
    //    bg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 100);
    //    bg.image = [UIImage imageNamed:@"proBG-01"];
    //    bg.contentMode = UIViewContentModeScaleAspectFill;
    //    [theScrollView addSubview:bg];
    //
    
    
    mainView = [[UIView alloc] init];
    mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:mainView];
    
    //Background Image
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    background.image = [UIImage imageNamed:@"bg"];
    [mainView addSubview:background];
    
    
    //Loading Animation UIImageView
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"load_anim000"];
    activityImageView = [[UIImageView alloc]
                         initWithImage:statusImage];
    
    //Add more images which will be used for the animation
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"load_anim000"],
                                         [UIImage imageNamed:@"load_anim001"],
                                         [UIImage imageNamed:@"load_anim002"],
                                         [UIImage imageNamed:@"load_anim003"],
                                         [UIImage imageNamed:@"load_anim004"],
                                         [UIImage imageNamed:@"load_anim005"],
                                         [UIImage imageNamed:@"load_anim006"],
                                         [UIImage imageNamed:@"load_anim007"],
                                         [UIImage imageNamed:@"load_anim008"],
                                         [UIImage imageNamed:@"load_anim009"],
                                         nil];
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 0.5;
    activityImageView.animationRepeatCount = 0;
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -25,
                                         self.view.frame.size.height/2
                                         -25,
                                         50,
                                         50);
    
    //Load Inital View
    [self loadMain];
    
    //reset user detail
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    
    
}

-(void)loadMain {
    //Logo
    UIImageView *logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake(((self.view.frame.size.width-220)/2), 130, 220, 220);
    logo.image = [UIImage imageNamed:@"logo"];
    [mainView addSubview:logo];
    
    //buttonView
    buttonView = [[UIView alloc] init];
    buttonView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    [mainView addSubview:buttonView];
    
    //FacebookButton
    UIButton *FacebookLoginBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        FacebookLoginBtn.frame = CGRectMake(40, 30, self.view.frame.size.width - 80, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        FacebookLoginBtn.frame = CGRectMake((self.view.frame.size.width-250)/2, 30, 250, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        FacebookLoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        FacebookLoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else {
        FacebookLoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }
    [FacebookLoginBtn setBackgroundImage:[UIImage imageNamed:@"btn_facebook"] forState:UIControlStateNormal];
    [buttonView addSubview:FacebookLoginBtn];
    
    //Login Button
    UIButton *LoginBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LoginBtn.frame = CGRectMake(40, 30, self.view.frame.size.width - 80, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LoginBtn.frame = CGRectMake((self.view.frame.size.width-250)/2, 80, 250, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else {
        LoginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }
    [LoginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [LoginBtn addTarget:self action:@selector(tapEmailLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:LoginBtn];
    
    
    
    //Register Button
    UIButton *RegisterBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        RegisterBtn.frame = CGRectMake(40, 30, self.view.frame.size.width - 80, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        RegisterBtn.frame = CGRectMake((self.view.frame.size.width-250)/2, 130, 250, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        RegisterBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        RegisterBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else {
        RegisterBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }
    [RegisterBtn setBackgroundImage:[UIImage imageNamed:@"btn_register"] forState:UIControlStateNormal];
    [buttonView addSubview:RegisterBtn];
    
    [UIView animateWithDuration:0.5f animations:^{
        buttonView.frame = CGRectMake(0, self.view.frame.size.height - 320, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            buttonView.frame = CGRectMake(0, self.view.frame.size.height - 315, self.view.frame.size.width, 180);
        }];
    }];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self autoLogin];
    
}


-(void)autoLogin {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
    
    NSString *keyChainStr = [NSString stringWithFormat:@"%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]];
    
    if([keyChainStr isEqualToString:@""]) {
        
    } else {
        email.text = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        
        //because label uses NSString and password is NSData object, conversion necessary
        NSData *pwdData = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        NSString *passwordStr = [[NSString alloc] initWithData:pwdData encoding:NSUTF8StringEncoding];
        password.text = passwordStr;
        
//        [self CheckDetails];
    }
    
}

-(IBAction)tapEmailLoginButton:(id)sender
{
    SWRevealViewController *registerControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"LoginEmail"];
    
    [self.navigationController pushViewController:registerControl animated:YES];
}





@end
