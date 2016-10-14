//
//  SiSCourseDetail.m
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 06.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSCourseDetail.h"
#import "SiSUpcoming.h"

@interface SiSCourseDetail ()

@property (strong, nonatomic) NSMutableArray* upcomings;

@end

@implementation SiSCourseDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.course.title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Avenir Next" size:18.0], NSFontAttributeName, nil]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.upcomings = [NSMutableArray array];
    
    for (SiSUpcoming* obj in self.course.upcoming) {
        
        [self.upcomings addObject:obj];
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.upcomings.count + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"General information:";
            break;
            
        default:
            return [NSString stringWithFormat:@"Upcoming %d:", section];
            break;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 4;
            break;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"Title: %@", self.course.title];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"Url: %@", self.course.url];
                break;
        }
        
    } else if (indexPath.section > 0) {
        
        SiSUpcoming* upc = [self.upcomings objectAtIndex:indexPath.section - 1];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"Instructor: %@", upc.instructor];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"Location: %@", upc.location];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Start date: %@", upc.start_date];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"End date: %@", upc.end_date];
                break;
        }
    }
    
    return cell;
}



@end
