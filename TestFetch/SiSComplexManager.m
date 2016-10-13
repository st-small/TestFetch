//
//  SiSComplexManager.m
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 07.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSComplexManager.h"
#import "SiSDataManager.h"
#import "SiSServerManager.h"
#import "SiSCourse.h"

@interface SiSComplexManager ()

@property (strong, nonatomic) SiSDataManager* dbManager;
@property (strong, nonatomic) SiSServerManager* serverManager;

@end

@implementation SiSComplexManager

+ (SiSComplexManager*) sharedManager {
    
    static SiSComplexManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SiSComplexManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.dbManager = [SiSDataManager new];
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
                                
                                NSLog(@"Will get DATA from CORE DATA!!!");
                                
                                success(data);
                                
                            } onFailure:^(NSError* error) {
                                
                                NSLog(@"Database is empty! Will get data from ServerManager!");
                                
                                [self.serverManager getRowsWithOffset:offset
                                                             andCount:count
                                                            onSuccess:^(NSArray* productsArray) {
                                                                
                                                                NSLog(@"productsArray.count %d", productsArray.count);
                                                                
                                                                success(productsArray);
                                                                    
                                                                //+ Сохраняем данные в DatabaseManager
                                                                
                                                                for (SiSCourse* obj in productsArray) {
                                                                    
                                                                    [[SiSDataManager sharedManager] addCourseWithTitle:obj.title                                                                                                                andURL:obj.url];
                                                                    
                                                                    //NSLog(@"\n%d", [[SiSDataManager sharedManager] isCoreDataForEmpty]);
                                                                }
                                                                
                                                            } onFailure:^(NSError* error) {
                                                                
                                                                failure(error);
                                                                
                                                            }];
                            }];
    
}

@end
