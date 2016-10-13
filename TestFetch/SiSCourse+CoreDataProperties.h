//
//  SiSCourse+CoreDataProperties.h
//  TestFetch
//
//  Created by Stanly Shiyanovskiy on 12.10.16.
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

@end

NS_ASSUME_NONNULL_END
