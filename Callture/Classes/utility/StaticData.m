//
//  StaticData.m
//  Callture
//
//  Created by Manish on 24/12/11.
//  Copyright (c) 2011 Aryavrat infotech. All rights reserved.
//

#import "StaticData.h"
static NSMutableArray *one = nil;
static NSMutableArray *two = nil;
static NSMutableArray *three = nil;
static NSMutableArray *four = nil;
static NSMutableArray *five = nil;
static NSMutableArray *six = nil;
static NSMutableArray *seven = nil;
static NSMutableArray *eight = nil;
static NSMutableArray *nine = nil;
static NSString *apiuser = @"callture_mobi";
static NSString *apipwd = @"m0b1l3a9p";
static NSString *apikey = @"F65C5A0A-758F-4CAF-8823-E2D94D5D29F1";
@implementation StaticData

+(NSString *)APIKEY
{
    return apikey;
}

+(NSString *)APIUSR
{
    return apiuser;
}

+(NSString *)APIPWD
{
    return apipwd;
}

+(NSMutableArray *)ONE
{
    if(one==nil)
        one = [[NSMutableArray alloc]initWithObjects:@" ", nil];
    return one;
}

+(NSMutableArray *)TWO
{
    if(two==nil)
        two = [[NSMutableArray alloc]initWithObjects:@"a",@"b",@"c", nil];
    return two;
}
+(NSMutableArray *)THREE
{
    if(three==nil)
        three = [[NSMutableArray alloc]initWithObjects:@"d",@"e",@"f", nil];
    return three;
}
+(NSMutableArray *)FOUR
{
    if(four==nil)
        four = [[NSMutableArray alloc]initWithObjects:@"g",@"h",@"i", nil];
    return four;
}
+(NSMutableArray *)FIVE
{
    if(five==nil)
        five = [[NSMutableArray alloc]initWithObjects:@"j",@"k",@"l", nil];
    return five;
}
+(NSMutableArray *)SIX
{
    if(six==nil)
        six = [[NSMutableArray alloc]initWithObjects:@"m",@"n",@"o", nil];
    return six;
}
+(NSMutableArray *)SEVEN
{
    if(seven==nil)
        seven = [[NSMutableArray alloc]initWithObjects:@"p",@"q",@"r",@"s", nil];
    return seven;
}
+(NSMutableArray *)EIGHT
{
    if(eight==nil)
        eight = [[NSMutableArray alloc]initWithObjects:@"t",@"u",@"v", nil];
    return eight;
}
+(NSMutableArray *)NINE
{
    if(nine==nil)
        nine = [[NSMutableArray alloc]initWithObjects:@"w",@"x",@"y",@"z", nil];
    return nine;
}

+(NSMutableArray *)GetKeyValues:(char)val
{
    switch (val) {
        case '2':
            return [StaticData TWO];
            break;
        case '3':
            return [StaticData THREE];
            break;
        case '4':
            return [StaticData FOUR];
            break;
        case '5':
            return [StaticData FIVE];
            break;
        case '6':
            return [StaticData SIX];
            break;
        case '7':
            return [StaticData SEVEN];
            break;
        case '8':
            return [StaticData EIGHT];
            break;
        case '9':
            return [StaticData NINE];
            break;
        default:
            return [StaticData ONE];
            break;
    }
    return nil;
}

@end
