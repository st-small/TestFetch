//
//  SiSDataManager.m
//  TestFetch
//
//  Created by Stanly Shiyanovskiy on 12.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSDataManager.h"

#import <UIKit/UIKit.h>

@implementation SiSDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (SiSDataManager*) sharedManager {
    
    static SiSDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SiSDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Private Methods

- (SiSCourse*) addCourseWithTitle:(NSString*)title andURL:(NSString*)URL {
    
    SiSCourse* course =
    [NSEntityDescription insertNewObjectForEntityForName:@"SiSCourse"
                                  inManagedObjectContext:self.managedObjectContext];
    
    course.title = title;
    course.url = URL;
    
    NSError* error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSLog(@"THERE ARE %d ELEMENTS IN COREDATA! ADDING %@ %@", [self isCoreDataForEmpty], course.title, course.url);
    
    return course;
}

- (NSArray*) allObjectsByEntity:(NSString*)entity {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description =
    [NSEntityDescription entityForName:entity
                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray =
    [self.managedObjectContext executeFetchRequest:request
                                             error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) printArray:(NSArray*) array {
    
    for (id object in array) {
        
        if ([object isKindOfClass:[SiSCourse class]]) {
            SiSCourse* course = (SiSCourse*) object;
            NSLog(@"COURSE: %@, URL: %@, UPCOMINGS: %u", course.title, course.url, course.upcoming.count);
            
        } else if ([object isKindOfClass:[SiSUpcoming class]]) {
            
            SiSUpcoming* upcoming = (SiSUpcoming*) object;
            NSLog(@"UPCOMING: START: %@, END: %@, INSTRUCTOR: %@, LOCATION: %@, COURSE: %@", upcoming.start_date, upcoming.end_date, upcoming.instructor, upcoming.location, upcoming.course.title);
            
        }
        
    }
    
}

- (void) printAllObjects {
    
    NSArray* allObjects = [self allObjectsByEntity:@"SiSObject"];
    
    [self printArray:allObjects];
}

- (void) deleteAllObjects {
    
    NSArray* allObjects = [self allObjectsByEntity:@"SiSObject"];
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    
    [self.managedObjectContext save:nil];
}

- (NSUInteger) isCoreDataForEmpty {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"SiSCourse"
                                    inManagedObjectContext: self.managedObjectContext]];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: request
                                                                 error: &error];
    return count;
}

#pragma mark - Manager Protocol

- (void) getRowsWithOffset: (NSInteger) offset
                  andCount: (NSInteger) count
                 onSuccess: (void(^)(NSArray* productsArray)) success
                 onFailure: (void(^)(NSError* error)) failure {
    
    //Запрос к базе
    
    NSError* requestError = nil;
    NSArray* resultArray = [self allObjectsByEntity:@"SiSCourse"];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    if ([self isCoreDataForEmpty] > 1) {
        
        NSLog(@"%@", ([self isCoreDataForEmpty] < 1) ? @"YES -> EMPTY" : @"NO -> NO EMPTY");
        success(resultArray);
        
    } else {
        
        failure(requestError);
    }
    
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SiS.TestFetch" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestFetch" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestFetch.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL
                                                  error:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
