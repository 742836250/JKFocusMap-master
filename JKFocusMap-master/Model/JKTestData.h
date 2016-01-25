//
//  JKTestData.h
//
//  Created by 锐锋 王 on 16/1/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JKTestData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *infor;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *inofr;
@property (nonatomic, strong) NSString *skipURL;

@property (nonatomic, assign) BOOL netImageNoError;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
