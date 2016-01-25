//
//  JKTestModel.h
//
//  Created by 锐锋 王 on 16/1/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JKTestModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) double errorCode;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
