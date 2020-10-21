//
//  LoginEmailViewController.h
//  Nottinghamshire County Council
//
//  Created by Geoff Baker on 19/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "DBManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>


@interface LoginEmailViewController : UIViewController<MFMessageComposeViewControllerDelegate>
// Properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

