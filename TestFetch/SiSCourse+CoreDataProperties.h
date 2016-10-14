//
//  SiSCourse+CoreDataProperties.h
//  TestFetch
//
//  Created by Stanly Shiyanovskiy on 14.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SiSCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiSCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSSet<SiSUpcoming *> *upcoming;

@end

@interface SiSCourse (CoreDataGeneratedAccessors)

- (void)addUpcomingObject:(SiSUpcoming *)value;
- (void)removeUpcomingObject:(SiSUpcoming *)value;
- (void)addUpcoming:(NSSet<SiSUpcoming *> *)values;
- (void)removeUpcoming:(NSSet<SiSUpcoming *> *)values;

@end

NS_ASSUME_NONNULL_END
