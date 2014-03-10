//
//  NoteListsTableViewController.h
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteListsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *notes;

// AppDelegate의 Core Data 참조
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
