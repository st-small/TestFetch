//
//  SiSCourseDetail.h
//  07_Lesson_GeekBrains_DZ
//
//  Created by Stanly Shiyanovskiy on 06.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiSProduct.h"

@interface SiSCourseDetail : UITableViewController

@property (strong, nonatomic) SiSProduct* product;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end
