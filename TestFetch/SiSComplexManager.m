//
//  SiSComplexManager.m
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 07.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSComplexManager.h"
#import "SiSDataBaseManager.h"
#import "SiSServerManager.h"

@interface SiSComplexManager ()

@property (strong, nonatomic) SiSDataBaseManager* dbManager;
@property (strong, nonatomic) SiSServerManager* serverManager;

@end

@implementation SiSComplexManager

+ (SiSComplexManager*) sharedManager {
    
    SiSComplexManager* manager = [[SiSComplexManager alloc] init];

    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.dbManager = [SiSDataBaseManager new];
        self.serverManager = [SiSServerManager new];
    }
    
    return self;
}

- (void) getRowsWithOffset:(NSInteger)offset
                  andCount:(NSInteger)count
                 onSuccess:(void (^)(NSArray *))success
                 onFailure:(void (^)(NSError *))failure {
    
    [self.dbManager getRowsWithOffset:offset
                             andCount:count
                            onSuccess:^(NSArray* data) {
                                
                                success(data);
                                
                            } onFailure:^(NSError* error) {
                                
                                NSLog(@"Database is empty! Will get data from ServerManager!");
                                
                                [self.serverManager getRowsWithOffset:offset
                                                             andCount:count
                                                            onSuccess:^(NSArray* productsArray) {
                                                                
                                                                success(productsArray);
                                                                
                                                                //+ Сохраняем данные в DatabaseManager
                                                                
                                                                
                                                                
                                                            }
                                                            onFailure:^(NSError* error) {
                                                                
                                                                failure(error);
                                                                
                                                            }];
                            }];
    
}

@end
