//
//  Person.h
//  DataEncrption(5.14)
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSNumber *age;
@end
