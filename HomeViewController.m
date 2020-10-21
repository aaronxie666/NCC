//
//  HomeViewController.m
//  Nottinghamshire County Council
//
//  Created by Geoff Baker on 18/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "HomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "Reachability.h"
#import "MBProgressHUD.h"
//#import <Parse/Parse.h>
#import "Flurry.h"

@interface HomeViewController ()

@end

@implementation HomeViewController{
    UIView *tmpView;
    UIView *popUpView;
    UIImageView *profilePicture;
    UIImage *selectedProfileImage;
    UIScrollView *sideScroller;
    UIScrollView *pageScroller;
    NSUserDefaults *user;
    UIButton *findParksButton;
    //    CLLocationManager *locationManager;
    int iteration;
    bool refreshView;
    bool userIsOnOverlay;
    bool libraryPicked;
    bool viewHasFinishedLoading;
    bool isFindingNearestParkOn;
    int distanceMovedScroll;
    
    
    IBOutlet UITextField *userTextField;
    
    //Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
    
    UIImageView *activePageView;
    
    //PFObjects
    //    PFObject *selectedMatchObject;
    //    PFObject *selectedOpponent;
    //    PFObject *achievementsObject;
    //    NSMutableArray *locationsObj;
    
    //AnimationImage
    UIImageView *glowImageView;
    
    //NEW
    NSString *URLString;
    UIButton *dailyReward;
    
    int videoCount;
    
    //Graph
    int firstVotes;
    int secondVotes;
    int thirdVotes;
    int forthVotes;
    int fifthVotes;
    
    int x;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    userIsOnOverlay = NO;
    viewHasFinishedLoading = NO;
    // Do any additional setup after loading the view.
    
    
    //Header
    [self.navigationController.navigationBar  setBarTintColor:[UIColor colorWithRed:177/255.0f
                                                                              green:208/255.0f
                                                                               blue:36/255.0f
                                                                              alpha:1.0f]];
    [_sidebarButton setEnabled:NO];
    [_sidebarButton setTintColor: [UIColor clearColor]];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    UIImageView *navigationImage=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 210, 38)];
    navigationImage.image=[UIImage imageNamed:@"ncc_header-logo"];
    
    UIImageView *workaroundImageView = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height >= 812) //iPhone X size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView=workaroundImageView;
    self.navigationItem.titleView.center = self.view.center;
    
    
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"ic_menu"];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 5, 5);
    leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 10);
    [leftBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchDown];
    [leftBarButton setImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //    BackgroundImage
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [background setBackgroundColor:[UIColor whiteColor]];
//    background.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:background];
    //
    [self loadParseContent];
    
    
}


-(void)loadParseContent{
    // Create the UI Scroll View
    
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = @"Loading";
    
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
    
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    
    // Add stuff to view here
    Hud.customView = activityImageView;

    user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user stringForKey:@"userEmail"];
    NSString *password = [user stringForKey:@"userPassword"];

    if(username == nil){
        [self showLoginView];
    }else{
        [self loadUser];
        [Hud removeFromSuperview];
    }
    
}


-(void)showLoginView{
    SWRevealViewController *LoginControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"InitialLogin"];
    
    [self.navigationController pushViewController:LoginControl animated:NO];
}

-(void)showLoading
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = NSLocalizedString(@"Loading", nil);
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    Hud.customView = activityImageView;
}


-(void)loadUser{
    //Profile Group View
    UIView *headerContainer = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        headerContainer.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        headerContainer.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headerContainer.frame = CGRectMake(0, 60, self.view.frame.size.width, 150);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headerContainer.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headerContainer.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    } else {
        headerContainer.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }
    [self.view addSubview:headerContainer];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headImg.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }
    headImg.image = [UIImage imageNamed:@"background"];
    [headerContainer addSubview:headImg];
    
    
    UIButton *ReportPotholeBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        ReportPotholeBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        ReportPotholeBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        ReportPotholeBtn.frame = CGRectMake((self.view.frame.size.width-220)/2, (150-120)/2, 220, 120);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        ReportPotholeBtn.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        ReportPotholeBtn.frame = CGRectMake(100, 20, 50, 50);
    } else {
        ReportPotholeBtn.frame = CGRectMake(100, 20, 50, 50);
    }
    [ReportPotholeBtn setBackgroundImage:[UIImage imageNamed:@"btn_report"] forState:UIControlStateNormal];
    [ReportPotholeBtn addTarget:self action:@selector(tapReportPotholeBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerContainer addSubview:ReportPotholeBtn];
    
    
    UIView *ButtonsContainer = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        ButtonsContainer.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        ButtonsContainer.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        ButtonsContainer.frame = CGRectMake(0, 215, self.view.frame.size.width, 120);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        ButtonsContainer.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        ButtonsContainer.frame = CGRectMake(100, 20, 50, 50);
    } else {
        ButtonsContainer.frame = CGRectMake(100, 20, 50, 50);
    }
    
    [self.view addSubview:ButtonsContainer];
    
    
    UIButton *NewsBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        NewsBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        NewsBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        NewsBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        NewsBtn.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        NewsBtn.frame = CGRectMake(100, 20, 50, 50);
    } else {
        NewsBtn.frame = CGRectMake(100, 20, 50, 50);
    }
    [NewsBtn setBackgroundImage:[UIImage imageNamed:@"btn_news"] forState:UIControlStateNormal];
    [ButtonsContainer addSubview:NewsBtn];
    
    UIButton *MyRoutesBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        MyRoutesBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        MyRoutesBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        MyRoutesBtn.frame = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        MyRoutesBtn.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        MyRoutesBtn.frame = CGRectMake(100, 20, 50, 50);
    } else {
        MyRoutesBtn.frame = CGRectMake(100, 20, 50, 50);
    }
    [MyRoutesBtn setBackgroundImage:[UIImage imageNamed:@"btn_routes"] forState:UIControlStateNormal];
    [MyRoutesBtn addTarget:self action:@selector(tapMyRoutesBtn) forControlEvents:UIControlEventTouchUpInside];
    [ButtonsContainer addSubview:MyRoutesBtn];
    
    UIButton *SettingBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        SettingBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        SettingBtn.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        SettingBtn.frame = CGRectMake((self.view.frame.size.width/3)*2, 0, self.view.frame.size.width/3, self.view.frame.size.width/3);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        SettingBtn.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        SettingBtn.frame = CGRectMake(100, 20, 50, 50);
    } else {
        SettingBtn.frame = CGRectMake(100, 20, 50, 50);
    }
    [SettingBtn setBackgroundImage:[UIImage imageNamed:@"btn_settings"] forState:UIControlStateNormal];
    [ButtonsContainer addSubview:SettingBtn];
    
    
    UIView *LatestUpdatesContainer = [[UIView alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LatestUpdatesContainer.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LatestUpdatesContainer.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LatestUpdatesContainer.frame = CGRectMake(0, 340, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LatestUpdatesContainer.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LatestUpdatesContainer.frame = CGRectMake(100, 20, 50, 50);
    } else {
        LatestUpdatesContainer.frame = CGRectMake(100, 20, 50, 50);
    }
    [self.view addSubview:LatestUpdatesContainer];
    
    UILabel *LatestUpdates = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LatestUpdates.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LatestUpdates.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LatestUpdates.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LatestUpdates.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LatestUpdates.frame = CGRectMake(100, 20, 50, 50);
    } else {
        LatestUpdates.frame = CGRectMake(100, 20, 50, 50);
    }
    LatestUpdates.text = @"Latest Updates";
    LatestUpdates.textAlignment = NSTextAlignmentCenter;
    [LatestUpdates setFont:[UIFont boldSystemFontOfSize:25]];
    LatestUpdates.textColor = [UIColor darkGrayColor];
    [LatestUpdatesContainer addSubview:LatestUpdates];
    
    
    UIScrollView *LatestUpdatesScroll = [[UIScrollView alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LatestUpdatesScroll.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LatestUpdatesScroll.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LatestUpdatesScroll.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
        LatestUpdatesScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LatestUpdatesScroll.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LatestUpdatesScroll.frame = CGRectMake(100, 20, 50, 50);
    } else {
        LatestUpdatesScroll.frame = CGRectMake(100, 20, 50, 50);
    }
    
    [LatestUpdatesContainer addSubview:LatestUpdatesScroll];
    
    
    
    
//    UIButton *LatestList1 = [[UIButton alloc]init];
//    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
//    {
//        LatestList1.frame = CGRectMake(70, 20, 50, 50);
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
//    {
//        LatestList1.frame = CGRectMake(70, 20, 50, 50);
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
//    {
//        LatestList1.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 130);
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
//    {
//        LatestList1.frame = CGRectMake(70, 20, 50, 50);
//    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
//    {
//        LatestList1.frame = CGRectMake(70, 20, 50, 50);
//    } else {
//        LatestList1.frame = CGRectMake(70, 20, 50, 50);
//    }
////    [LatestList1 setBackgroundImage:[UIImage imageNamed:@"list1"] forState:UIControlStateNormal];
//    [LatestList1.layer setBorderWidth:1.0];
//    [LatestList1.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    LatestList1.layer.shadowColor =  [[UIColor blackColor] CGColor];
//    LatestList1.layer.shadowOffset = CGSizeMake(0, 0);
//    LatestList1.layer.shadowOpacity = 0.5f;
//    LatestList1.layer.cornerRadius = 4.0f;
////    LatestList1.layer.shadowRadius = 0.0f;
////    LatestList1.layer.masksToBounds = NO;
//    [LatestList1 addTarget:self action:@selector(tapReportPotholeBtn) forControlEvents:UIControlEventTouchUpInside];
//    [LatestUpdatesScroll addSubview:LatestList1];
    
    
    
    UIView *LatestList1View = [[UIView alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LatestList1View.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LatestList1View.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LatestList1View.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 130);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LatestList1View.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LatestList1View.frame = CGRectMake(100, 20, 50, 50);
    } else {
        LatestList1View.frame = CGRectMake(100, 20, 50, 50);
    }
    [LatestList1View setBackgroundColor:[UIColor whiteColor]];
    [LatestList1View.layer setBorderWidth:1.0];
    [LatestList1View.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    LatestList1View.layer. shadowColor =  [[UIColor blackColor] CGColor];
    LatestList1View.layer.shadowOffset = CGSizeMake(0, 0);
    LatestList1View.layer.shadowOpacity = 0.5f;
    LatestList1View.layer.cornerRadius = 4.0f;
    [LatestUpdatesScroll addSubview:LatestList1View];
    
    UILabel *Title1 = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        Title1.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        Title1.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        Title1.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        Title1.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        Title1.frame = CGRectMake(100, 20, 50, 50);
    } else {
        Title1.frame = CGRectMake(100, 20, 50, 50);
    }
    Title1.numberOfLines = 2;
    [Title1 setText:@"7 potholes have just been filled in the West Bridgeford area!"];
    [LatestList1View addSubview:Title1];
    
    
    
    
    
    
    
    UIButton *LatestList2 = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LatestList2.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LatestList2.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LatestList2.frame = CGRectMake(0, 130, self.view.frame.size.width, 130);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LatestList2.frame = CGRectMake(70, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LatestList2.frame = CGRectMake(70, 20, 50, 50);
    } else {
        LatestList2.frame = CGRectMake(70, 20, 50, 50);
    }
//    [LatestList2 setBackgroundImage:[UIImage imageNamed:@"List2"] forState:UIControlStateNormal];
    [LatestList2 addTarget:self action:@selector(tapReportPotholeBtn) forControlEvents:UIControlEventTouchUpInside];
    [LatestUpdatesScroll addSubview:LatestList2];
    
    
    
    
}

-(void) tapReportPotholeBtn{
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ReportPothole"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}


-(void) tapMyRoutesBtn{
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyRoutes"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
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
