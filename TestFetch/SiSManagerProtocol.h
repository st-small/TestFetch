//
//  SiSManagerProtocol.h
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 07.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SiSManagerProtocol

+ (instancetype)sharedManager;

- (void) getRowsWithOffset: (NSInteger) offset
                  andCount: (NSInteger) count
                 onSuccess: (void(^)(NSArray* productsArray)) success
                 onFailure: (void(^)(NSError* error)) failure;

@end