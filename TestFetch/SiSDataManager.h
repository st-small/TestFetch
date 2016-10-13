//
//  SiSDataManager.h
//  TestFetch
//
//  Created by Stanly Shiyanovskiy on 12.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SiSManagerProtocol.h"
#import "SiSCourse.h"

@interface SiSDataManager : NSObject <SiSManagerProtocol>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


+ (SiSDataManager*) sharedManager;


- (SiSCourse*) addCourseWithTitle:(NSString*)title andURL:(NSString*)URL;
- (void) printAllObjects;
- (void) deleteAllObjects;
- (NSUInteger) isCoreDataForEmpty;

@end
