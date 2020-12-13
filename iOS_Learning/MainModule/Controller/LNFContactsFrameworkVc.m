//
//  LNFContactsFrameworkVc.m
//  iOS_Learning
//
//  Created by mrliu on 2020/12/12.
//  Copyright © 2020 interstellar. All rights reserved.
//

#import "LNFContactsFrameworkVc.h"
#import <Contacts/Contacts.h>

API_AVAILABLE(ios(9.0))
@interface LNFContactsFrameworkVc ()

@property (nonatomic, strong) CNContactStore *contactStore;

@end

@implementation LNFContactsFrameworkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    if (@available(iOS 9.0, *)) {
        self.contactStore = [[CNContactStore alloc] init];
        // 获取联系人访问权限
        CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (CNAuthorizationStatusNotDetermined == cnAuthStatus) { // 还未设置
            // 请求联系人访问权限
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) { // 点击了允许访问
                    
                } else { // 点击拒绝
                    
                }
            }];
        } else if (CNAuthorizationStatusRestricted == cnAuthStatus) { // 访问受限
            
        } else if (CNAuthorizationStatusDenied == cnAuthStatus) { // 拒绝访问
            
        } else if (CNAuthorizationStatusAuthorized == cnAuthStatus) { // 允许访问
            NSError *error;
            // Thread 1: "A property was not requested when contact was fetched."
            NSMutableArray *fetchKeyList = [NSMutableArray array];
            [fetchKeyList addObject:CNContactNamePrefixKey];
            [fetchKeyList addObject:CNContactGivenNameKey];
            [fetchKeyList addObject:CNContactMiddleNameKey];
            [fetchKeyList addObject:CNContactFamilyNameKey];
            [fetchKeyList addObject:CNContactPreviousFamilyNameKey];
            [fetchKeyList addObject:CNContactNameSuffixKey];
            [fetchKeyList addObject:CNContactNicknameKey];
            [fetchKeyList addObject:CNContactOrganizationNameKey];
            [fetchKeyList addObject:CNContactDepartmentNameKey];
            [fetchKeyList addObject:CNContactJobTitleKey];
            [fetchKeyList addObject:CNContactPhoneticGivenNameKey];
            [fetchKeyList addObject:CNContactPhoneticMiddleNameKey];
            [fetchKeyList addObject:CNContactPhoneticFamilyNameKey];
            [fetchKeyList addObject:CNContactBirthdayKey];
            [fetchKeyList addObject:CNContactNonGregorianBirthdayKey];
            [fetchKeyList addObject:CNContactImageDataKey];
            [fetchKeyList addObject:CNContactThumbnailImageDataKey];
            [fetchKeyList addObject:CNContactImageDataAvailableKey];
            [fetchKeyList addObject:CNContactTypeKey];
            [fetchKeyList addObject:CNContactPhoneNumbersKey];
            [fetchKeyList addObject:CNContactEmailAddressesKey];
            [fetchKeyList addObject:CNContactPostalAddressesKey];
            [fetchKeyList addObject:CNContactDatesKey];
            [fetchKeyList addObject:CNContactUrlAddressesKey];
            [fetchKeyList addObject:CNContactRelationsKey];
            [fetchKeyList addObject:CNContactSocialProfilesKey];
            [fetchKeyList addObject:CNContactInstantMessageAddressesKey];
            CNContactFetchRequest *contactFetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeyList.copy];
            // 遍历获取联系人模型 block在主线程
            [self.contactStore enumerateContactsWithFetchRequest:contactFetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                // 姓名、昵称等
                NSString *namePrefix = contact.namePrefix;
                NSString *givenName = contact.givenName;
                NSString *middleName = contact.middleName;
                NSString *familyName = contact.familyName;
                NSString *previousFamilyName = contact.previousFamilyName; //
                NSString *nameSuffix = contact.nameSuffix;
                NSString *nickName = contact.nickname;
//                NSString *organizationName = contact.organizationName;
                NSString *departmentName = contact.departmentName; //
                NSString *jobTitle = contact.jobTitle; //
                // 音标名称
                NSString *phoneticGivenName = contact.phoneticGivenName;
                NSString *phoneticMiddleName = contact.phoneticMiddleName;
                NSString *phoneticFamilyName = contact.phoneticFamilyName;
                // 音标组织名称
                NSString *phoneticOrganizationName = @"";
                if (@available(iOS 10.0, *)) {
//                    phoneticOrganizationName = contact.phoneticOrganizationName;
                } else {
                    // Fallback on earlier versions
                }
                // 头像、头像缩略图
                NSData *imageData = contact.imageData;
                NSData *thumbnailImageData = contact.thumbnailImageData;
                // 电话号码
                NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = contact.phoneNumbers;
                if (phoneNumbers.count && [givenName isEqualToString:@"Trump"]) {
                    for (int i = 0; i < phoneNumbers.count; i++) {
                        // CNLabelPhoneNumberiPhone
                        // CNLabelPhoneNumberMobile
                        // CNLabelPhoneNumberMain
                        // CNLabelPhoneNumberHomeFax
                        // CNLabelPhoneNumberWorkFax
                        // CNLabelPhoneNumberOtherFax
                        // CNLabelPhoneNumberPager
                        CNLabeledValue *labelValue = phoneNumbers[i];
                        NSString *label = labelValue.label;
                        CNPhoneNumber *value = labelValue.value;
                        NSString *phoneNumber = value.stringValue;
                        if ([label isEqualToString:CNLabelPhoneNumberiPhone]) {
                            
                        } else if ([label isEqualToString:CNLabelPhoneNumberMobile]) {
                            
                        } else if ([label isEqualToString:CNLabelPhoneNumberMain]) {
                            
                        }
                    }
                }
                // 邮箱地址
                NSArray<CNLabeledValue<NSString*>*> *emailAddresses = contact.emailAddresses;
                // 邮政地址
                NSArray<CNLabeledValue<CNPostalAddress*>*> *postalAddresses = contact.postalAddresses;
                // 网址地址
                NSArray<CNLabeledValue<NSString*>*> *urlAddresses = contact.urlAddresses;
                // 联系人关系
                NSArray<CNLabeledValue<CNContactRelation*>*> *contactRelations = contact.contactRelations;
                // 社交主页地址(Facebook、Twitter、Sina等)
                NSArray<CNLabeledValue<CNSocialProfile*>*> *socialProfiles = contact.socialProfiles;
                // 即时通讯地址(Yahoo、Skype、QQ等)
                NSArray<CNLabeledValue<CNInstantMessageAddress*>*> *instantMessageAddresses = contact.instantMessageAddresses;
                // 阳历生日
                NSDateComponents *birthday = contact.birthday;
                // 阴历生日
                NSDateComponents *nonGregorianBirthday = contact.nonGregorianBirthday;
                // 其他阳历日期
                NSArray<CNLabeledValue<NSDateComponents*>*> *dates = contact.dates;
            }];
            if (error) {
                NSLog(@"---->>>>%@", error);
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

@end
