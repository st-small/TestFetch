//
//  SiSCourseDetail.m
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 06.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSCourseDetail.h"

@interface SiSCourseDetail ()

@end

@implementation SiSCourseDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.product.title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    
    self.startLabel.text = self.product.startDate;
    self.endLabel.text = self.product.endDate;
    self.instructorLabel.text = self.product.instructor;    
    self.urlLabel.text = self.product.URL;
    
}





@end
