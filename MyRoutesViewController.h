//
//  MyRoutesViewController.h
//  Nottinghamshire County Council
//
//  Created by Geoff Baker on 20/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MyRoutesViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

