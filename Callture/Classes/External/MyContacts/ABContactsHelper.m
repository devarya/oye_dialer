//
//  ABContactsHelper.m
//  Callture
//
//  Created by Manish on 17/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. Ltd. All rights reserved.
//

#import "ABContactsHelper.h"
#import "GlobalData.h"
#import <AddressBookUI/AddressBookUI.h>
#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
static NSMutableArray *contacts;
@implementation ABContactsHelper

/*
 Note: You cannot CFRelease the addressbook after CFAutorelease(ABAddressBookCreate());
 */
+ (ABAddressBookRef) addressBook
{
	return CFAutorelease(ABAddressBookCreate());
}

+ (NSArray *) contacts
{
    if (contacts == nil ) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                    NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
                    contacts = [[NSMutableArray arrayWithCapacity:thePeople.count] retain];
                    for (id person in thePeople){
                        [contacts addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
                    }
                    [thePeople release];
                    //contacts = [GlobalData sortArray:contacts withKey:@"contactName"];
                    NSSortDescriptor *lastDescriptor =
                    
                    [[[NSSortDescriptor alloc] initWithKey:@"contactName"
                                                 ascending:YES
                                                  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
                    
                    
                    
                    NSArray *descriptors = [NSArray arrayWithObject:lastDescriptor];
                    
                    contacts = [[contacts sortedArrayUsingDescriptors:descriptors] mutableCopy];
                });
            }
            else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                // The user has previously given access, add the contact
                NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
                contacts = [[NSMutableArray arrayWithCapacity:thePeople.count] retain];
                for (id person in thePeople){
                    [contacts addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
                }
                [thePeople release];
                //contacts = [GlobalData sortArray:contacts withKey:@"contactName"];
                NSSortDescriptor *lastDescriptor =
                
                [[[NSSortDescriptor alloc] initWithKey:@"contactName"
                                             ascending:YES
                                              selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
                
                
                
                NSArray *descriptors = [NSArray arrayWithObject:lastDescriptor];
                
                contacts = [[contacts sortedArrayUsingDescriptors:descriptors] mutableCopy];
            }
            else {
                // The user has previously denied access
                // Send an alert telling user to change privacy setting in settings app
            }
        }else
        {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            contacts = [[NSMutableArray arrayWithCapacity:thePeople.count] retain];
            for (id person in thePeople){
                [contacts addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
            }
            [thePeople release];
            //contacts = [GlobalData sortArray:contacts withKey:@"contactName"];
            NSSortDescriptor *lastDescriptor =
            
            [[[NSSortDescriptor alloc] initWithKey:@"contactName"
                                         ascending:YES
                                          selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
            
            
            
            NSArray *descriptors = [NSArray arrayWithObject:lastDescriptor];
            
            contacts = [[contacts sortedArrayUsingDescriptors:descriptors] mutableCopy];
        }
        // Request authorization to Address Book
        
    }
	return contacts;
}

+(void)clearAllContacts
{
    contacts = nil;
}

+ (int) contactsCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	return ABAddressBookGetPersonCount(addressBook);
}

+ (int) contactsWithImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

+ (int) contactsWithoutImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (!ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

// Groups
+ (int) numberOfGroups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	int ncount = groups.count;
	[groups release];
	return ncount;
}

+ (NSArray *) groups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
	for (id group in groups)
		[array addObject:[ABGroup groupWithRecord:(ABRecordRef)group]];
	[groups release];
	return array;
}

// Sorting
+ (BOOL) firstNameSorting
{
	return (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst);
}


#pragma mark Contact Management

// Thanks to Eridius for suggestions re: error
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aContact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aGroup.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (NSArray *) contactsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@ OR organization contains[cd] %@", fname, fname, fname, fname, fname];
    if([[contacts filteredArrayUsingPredicate:pred] count]>0)
        return [contacts filteredArrayUsingPredicate:pred];
    else
        return nil;
}

+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@ OR organization contains[cd] %@", fname, fname, fname, fname,fname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@ OR organization contains[cd] %@", lname, lname, lname, lname,lname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	if([[contacts filteredArrayUsingPredicate:pred] count]>0)
        return contacts;
    else
        return nil;
}

+ (NSArray *) contactsMatchingPhone: (NSString *) number
{
	NSPredicate *pred;
	//NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"phonenumbers contains[cd] %@", number];
    if([[[ABContactsHelper contacts] filteredArrayUsingPredicate:pred] count]>0)
        return [[ABContactsHelper contacts] filteredArrayUsingPredicate:pred];
    else
        return nil;
}

+ (NSArray *) groupsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *groups = [ABContactsHelper groups];
	pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@ ", fname];
	return [groups filteredArrayUsingPredicate:pred];
}
@end