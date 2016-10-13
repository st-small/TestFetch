//
//  SiSUpcoming+CoreDataProperties.h
//  TestFetch
//
//  Created by Stanly Shiyanovskiy on 13.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SiSUpcoming.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiSUpcoming (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *start_date;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSString *instructor;
@property (nullable, nonatomic, retain) NSString *location;

@end

NS_ASSUME_NONNULL_END
