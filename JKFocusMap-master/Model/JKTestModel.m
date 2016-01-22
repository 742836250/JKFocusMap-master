//
//  JKTestModel.m
//
//  Created by 锐锋 王 on 16/1/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "JKTestModel.h"
#import "JKTestData.h"


NSString *const kJKTestModelData = @"data";
NSString *const kJKTestModelErrorCode = @"errorCode";


@interface JKTestModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JKTestModel

@synthesize data = _data;
@synthesize errorCode = _errorCode;


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
    NSObject *receivedJKTestData = [dict objectForKey:kJKTestModelData];
    NSMutableArray *parsedJKTestData = [NSMutableArray array];
    if ([receivedJKTestData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedJKTestData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedJKTestData addObject:[JKTestData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedJKTestData isKindOfClass:[NSDictionary class]]) {
       [parsedJKTestData addObject:[JKTestData modelObjectWithDictionary:(NSDictionary *)receivedJKTestData]];
    }

    self.data = [NSArray arrayWithArray:parsedJKTestData];
            self.errorCode = [[self objectOrNilForKey:kJKTestModelErrorCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kJKTestModelData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.errorCode] forKey:kJKTestModelErrorCode];

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

    self.data = [aDecoder decodeObjectForKey:kJKTestModelData];
    self.errorCode = [aDecoder decodeDoubleForKey:kJKTestModelErrorCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kJKTestModelData];
    [aCoder encodeDouble:_errorCode forKey:kJKTestModelErrorCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    JKTestModel *copy = [[JKTestModel alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
        copy.errorCode = self.errorCode;
    }
    
    return copy;
}


@end
