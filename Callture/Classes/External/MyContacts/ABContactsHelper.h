//
//  ABContactsHelper.h
//  Callture
//
//  Created by Manish on 17/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABContact.h"
#import "ABGroup.h"

@interface ABContactsHelper : NSObject

// Address Book
+ (ABAddressBookRef) addressBook;

// Address Book Contacts and Groups
+ (NSArray *) contacts; // people
+ (NSArray *) groups; // groups

+(void)clearAllContacts;

// Counting
+ (int) contactsCount;
+ (int) contactsWithImageCount;
+ (int) contactsWithoutImageCount;
+ (int) numberOfGroups;

// Sorting
+ (BOOL) firstNameSorting;

// Add contacts and groups
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error;
+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error;

// Find contacts
+ (NSArray *) contactsMatchingName: (NSString *) fname;
+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname;
+ (NSArray *) contactsMatchingPhone: (NSString *) number;

// Find groups
+ (NSArray *) groupsMatchingName: (NSString *) fname;
+(BOOL)isPermissionToGetContacts:(ABAddressBookRef)addressBook;
@end

// For the simple utility of it. Feel free to comment out if desired
@interface NSString (cstring)
@property (readonly) char *UTF8String;
@end