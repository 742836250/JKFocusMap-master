//
//  JKTestData.m
//
//  Created by 锐锋 王 on 16/1/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "JKTestData.h"


NSString *const kJKTestDataInfor = @"infor";
NSString *const kJKTestDataId = @"id";
NSString *const kJKTestDataImageURL = @"imageURL";
NSString *const kJKTestDataInofr = @"inofr";
NSString *const kJKTestDataSkipURL = @"skipURL";


@interface JKTestData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JKTestData

@synthesize infor = _infor;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize imageURL = _imageURL;
@synthesize inofr = _inofr;
@synthesize skipURL = _skipURL;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.infor = [self objectOrNilForKey:kJKTestDataInfor fromDictionary:dict];
            self.dataIdentifier = [[self objectOrNilForKey:kJKTestDataId fromDictionary:dict] doubleValue];
            self.imageURL = [self objectOrNilForKey:kJKTestDataImageURL fromDictionary:dict];
            self.inofr = [self objectOrNilForKey:kJKTestDataInofr fromDictionary:dict];
            self.skipURL = [self objectOrNilForKey:kJKTestDataSkipURL fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.infor forKey:kJKTestDataInfor];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kJKTestDataId];
    [mutableDict setValue:self.imageURL forKey:kJKTestDataImageURL];
    [mutableDict setValue:self.inofr forKey:kJKTestDataInofr];
    [mutableDict setValue:self.skipURL forKey:kJKTestDataSkipURL];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.infor = [aDecoder decodeObjectForKey:kJKTestDataInfor];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kJKTestDataId];
    self.imageURL = [aDecoder decodeObjectForKey:kJKTestDataImageURL];
    self.inofr = [aDecoder decodeObjectForKey:kJKTestDataInofr];
    self.skipURL = [aDecoder decodeObjectForKey:kJKTestDataSkipURL];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_infor forKey:kJKTestDataInfor];
    [aCoder encodeDouble:_dataIdentifier forKey:kJKTestDataId];
    [aCoder encodeObject:_imageURL forKey:kJKTestDataImageURL];
    [aCoder encodeObject:_inofr forKey:kJKTestDataInofr];
    [aCoder encodeObject:_skipURL forKey:kJKTestDataSkipURL];
}

- (id)copyWithZone:(NSZone *)zone
{
    JKTestData *copy = [[JKTestData alloc] init];
    
    if (copy) {

        copy.infor = [self.infor copyWithZone:zone];
        copy.dataIdentifier = self.dataIdentifier;
        copy.imageURL = [self.imageURL copyWithZone:zone];
        copy.inofr = [self.inofr copyWithZone:zone];
        copy.skipURL = [self.skipURL copyWithZone:zone];
    }
    
    return copy;
}


@end
