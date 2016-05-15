//
//  Person.m
//  DataEncrption(5.14)
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "Person.h"

@implementation Person
//实现编码方法,一旦进行归档,会立马执行
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.age forKey:@"age"];
}

//实现反编码方法,一旦进行解档(读取数组)会立马调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
    }
    return self;
}
@end
