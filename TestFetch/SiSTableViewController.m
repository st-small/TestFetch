//
//  ViewController.m
//  MyApp
//
//  Created by Stanly Shiyanovskiy on 13.08.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSTableViewController.h"
#import "SiSComplexManager.h"
#import "SiSDataManager.h"
#import "SiSCourse.h"
#import "SiSCourseDetail.h"

@interface SiSTableViewController ()

@property (assign, nonatomic) BOOL loadingData;

@end

@implementation SiSTableViewController

static NSInteger RowsInRequest = 5;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.jsonArray = [NSMutableArray array];
    self.loadingData = YES;
    self.navigationItem.title = @"Список курсов:";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    
    [self getRowsFromServer];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Загрузочка..."];
    [self.tableView addSubview:refreshControl];
}

#pragma mark - API

- (void) getRowsFromServer {
    
    [[SiSComplexManager sharedManager]
     getRowsWithOffset:self.jsonArray.count
     andCount:RowsInRequest
     onSuccess:^(NSArray *productsArray) {
         
         [self.jsonArray addObjectsFromArray:productsArray];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         for (NSUInteger i = [self.jsonArray count] - [productsArray count]; i < [self.jsonArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths
                               withRowAnimation:UITableViewRowAnimationTop];

         [self.tableView endUpdates];
         
         self.loadingData = NO;
         
     }
     onFailure:^(NSError *error) {
         
         NSLog(@"error = %@", [error localizedDescription]);
     }];
    
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.jsonArray count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    for (SiSCourse* obj in self.jsonArray) {
//        NSLog(@"\nпечтаю массив: %@", obj.title);
//    }
    
    NSLog(@"\nколичество в массиве: %d", self.jsonArray.count);
    
    SiSCourse* course = [self.jsonArray objectAtIndex:indexPath.row];
    cell.textLabel.text = course.title;
    
    NSLog(@"%d %@", indexPath.row, cell.textLabel.text);
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SiSCourseDetail"]) {
       
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForCell:sender];
        SiSCourseDetail* vc = [segue destinationViewController];
        vc.course = [self.jsonArray objectAtIndex:selectedIndexPath.row];
        
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    self.loadingData = NO;
    [refreshControl endRefreshing];
}

@end
