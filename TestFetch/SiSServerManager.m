//
//  SiSServerManager.m
//  MyApp
//
//  Created by Stanly Shiyanovskiy on 31.08.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSServerManager.h"
#import "SiSDataManager.h"
#import "AFNetworking.h"
#import "SiSCourse.h"

static NSString* originLink = @"http://bookapi.bignerdranch.com/courses.json";

@interface SiSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) NSURL* tempUrl;

@end

@implementation SiSServerManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"http://bookapi.bignerdranch.com/courses.json"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    return self;
}

+ (SiSServerManager*) sharedManager {
    
    SiSServerManager* manager = [[SiSServerManager alloc] init];
    
    return manager;
}

- (void) getRowsWithOffset:(NSInteger)offset
                  andCount:(NSInteger)count
                 onSuccess:(void (^)(NSArray *))success
                 onFailure:(void (^)(NSError *))failure {
    
    [self.sessionManager GET:originLink
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionTask * task, id  responseObject) {
                         
                         NSArray* rowsArray = [responseObject objectForKey:@"courses"];
                         
                         //NSLog(@"%@", rowsArray);
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSUInteger i = 0; i < rowsArray.count; i++) {
                             
                             NSDictionary* singleProduct = rowsArray[i];
                                                          
                             if (singleProduct.count > 0) {
                                 
                                 NSDictionary* titleDict = singleProduct[@"title"];
                                 NSString* URL = [NSString stringWithFormat:@"%@", singleProduct[@"url"]];
                                 
                                 SiSCourse* course =
                                 [NSEntityDescription insertNewObjectForEntityForName:@"SiSCourse"
                                                               inManagedObjectContext:[[SiSDataManager sharedManager] managedObjectContext]];
                                 course.title = [NSString stringWithFormat:@"%@", titleDict];
                                 course.url = URL;
                                 
                                 [objectsArray addObject:course];
                                 
                                 //NSLog(@"The course is: %@ and %@", course.title, course.url);
                             }
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                         
                     } failure:^(NSURLSessionTask* operation, NSError* error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(error);
                         }
                     }];
    
}

@end
