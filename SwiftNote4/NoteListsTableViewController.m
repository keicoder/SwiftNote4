//
//  NoteListsTableViewController.m
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import "NoteListsTableViewController.h"
#import "AppDelegate.h" //Core Data 참조
#import "Note.h"
#import "Image.h"
#import "AddEditViewController.h" //prepareForSegue

@interface NoteListsTableViewController () <NSFetchedResultsControllerDelegate>
{
    NSArray *allMyNoteData;   // array to store all Notes
}

@end

@implementation NoteListsTableViewController

//notes (mutableArray) getter 메소드
//- (NSMutableArray *)notes
//{
//    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
//    if (!_notes) _notes = [[NSMutableArray alloc] init];
//    return _notes;
//}


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [super viewDidLoad];
    
    self.navigationItem.title = @""; //내비게이션 백 버튼 타이틀 제거
    
    //관리객체 컨텍스트 참조
    if (_managedObjectContext == nil) {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    //가져오기 수행
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [super viewWillAppear:animated];
    
    allMyNoteData = [_fetchedResultsController fetchedObjects]; //array to store all Notes (모든 노트 인스턴스 배열)
    
    //애드 뷰 블랭크 노트 삭제
    if ([allMyNoteData count] == 0) {
        [self.tableView reloadData]; //테이블 뷰에 데이터가 없을 때 에러를 막기 위한 if문
    }
    
    [self.tableView reloadData]; //테이블 뷰 컨트롤러가 나타나려는 시점마다 데이터 리로드
    
}


#pragma mark - fetchedResultsController (지연된 로딩)

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    //배치 사이즈 (메모리 관리)
    [fetchRequest setFetchBatchSize:20];
    
    //sortDescriptor
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modifiedDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //fetchedResultsController 엑세서 메소드
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"section" cacheName:nil];
    //위 코드까지가 fetchedResultsController 생성 코드임.
    
    //fetchedResultsController 델리게이트
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    cell.textLabel.text = note.noteTitle;

    return cell;
}


#pragma mark - Table view 개별 행 높이

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 44;
    } else {
        /*
         static UILabel* label;
         if (!label) {
         label = [[UILabel alloc]
         initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
         label.text = @"test";
         }
         //label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
         [label sizeToFit];
         return label.frame.size.height * 3.3;
         */
        return 50;
    }
}





#pragma mark - Navigation: prepareForSegue

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNote"]) {
        
        AddEditViewController *aevc = segue.destinationViewController;
        
        Note *newNote = (Note *) [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[self managedObjectContext]];
        
        aevc.aNewNote = newNote; //뉴 노트 생성
        aevc.aNewNote.note = @""; //새 노트의 경우 텍스트가 없으면 에러 발생함
        aevc.title = @"Add Note"; //뷰의 타이틀 설정
    }
}




#pragma mark - AddEditViewController Delegate 메소드

- (void) addEditViewControllerDidCancel:(Note *)noteToDelete
{
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:noteToDelete];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        //block code here
//    }];
}


- (void) addEditViewControllerDidSave
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        //block code here
//    }];
}








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/







#pragma mark - 메모리 경고

- (void)didReceiveMemoryWarning
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [super didReceiveMemoryWarning];
}





@end
