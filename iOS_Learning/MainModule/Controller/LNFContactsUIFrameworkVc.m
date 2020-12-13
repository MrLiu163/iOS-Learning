//
//  LNFContactsUIFrameworkVc.m
//  iOS_Learning
//
//  Created by mrliu on 2020/12/13.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFContactsUIFrameworkVc.h"
#import <ContactsUI/ContactsUI.h>

@interface LNFContactsUIFrameworkVc () <CNContactPickerDelegate>

@end

@implementation LNFContactsUIFrameworkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    kLNFWeakSelf;
    [self addRightItemWithTitle:@"选择" tapAction:^(UIBarButtonItem *item) {
        CNContactPickerViewController *contactPickerVc = [[CNContactPickerViewController alloc] init];
        contactPickerVc.delegate = weakSelf;
        [weakSelf presentViewController:contactPickerVc animated:YES completion:^{
            
        }];
    }];
}

#pragma mark - CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    
}

/*!
* @abstract    Singular delegate methods.
* @discussion  These delegate methods will be invoked when the user selects a single contact or property.
*/
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    
}

@end
