//
//  ABGroup.h
//  Callture
//
//  Created by Manish on 17/02/12.
//  Copyright (c) 2012 Aryavrat Infotech Pvt. Ltd. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABContact.h"

@interface ABGroup : NSObject 
{
	ABRecordRef record;
}

+ (id) group;
+ (id) groupWithRecord: (ABRecordRef) record;
+ (id) groupWithRecordID: (ABRecordID) recordID;
- (BOOL) removeSelfFromAddressBook: (NSError **) error;

@property (nonatomic, readonly) ABRecordRef record;
@property (nonatomic, readonly) ABRecordID recordID;
@property (nonatomic, readonly) ABRecordType recordType;
@property (nonatomic, readonly) BOOL isPerson;

- (NSArray *) membersWithSorting: (ABPersonSortOrdering) ordering;
- (BOOL) addMember: (ABContact *) contact withError: (NSError **) error;
- (BOOL) removeMember: (ABContact *) contact withError: (NSError **) error;

@property (nonatomic, assign) NSString *name;
@property (nonatomic, readonly) NSArray *members; 

@end
