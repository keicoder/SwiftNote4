//
//  AddEditViewController.m
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import "AddEditViewController.h"
#import "AppDelegate.h" //AppDelegate의 saveContext 메소드 호출
#import "Note.h"
#import "Image.h"

@interface AddEditViewController () <UITextViewDelegate>
//바 버튼 아이템
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
//텍스트 뷰
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;


//코어 데이터
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; //AppDelegate의 컨텍스트 참조



@end


@implementation AddEditViewController
{
    CGSize _keyboardSize;
}

#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewDidLoad];
    
    self.noteTextView.alwaysBounceVertical = YES; //텍스트 뷰 Vertical 바운스
    self.noteTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive; //텍스트 뷰 키보드 Dismiss Mode Interactive
    [self.noteTextView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]]; //텍스트 뷰 백그라운드 컬러
    [[self.noteTextView layer] setCornerRadius:10]; //텍스트 뷰 코너 곡선 적용
    [self.noteTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)]; //텍스트 뷰 인셋 iOS 7
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]; //텍스트 뷰 폰트
    
    [self registerForKeyboardNotifications];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewWillAppear:animated];
    
    if ([self.noteTextView.text length] == 0) {
        
        //Delay 이후 키보드 보이기
        double kDelayInSeconds = 0.55;
        dispatch_time_t kPopTime = dispatch_time(DISPATCH_TIME_NOW, kDelayInSeconds * NSEC_PER_SEC);
        dispatch_after(kPopTime, dispatch_get_main_queue(), ^(void){
            
            [self.noteTextView becomeFirstResponder];
            
        });
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
//    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //키보드 옵저버 해제
}


#pragma mark - Keyboard Notifications

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    //키보드 팝업 옵저버 (키보드 팝업 시 텍스트 뷰 사이즈 조절)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
}


- (void)updateNoteTextViewSize {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? _keyboardSize.width : _keyboardSize.height;
    self.noteTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
}


#pragma mark - 키보드 옵저버


- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    _keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //노트필드 사이즈 조정
    double uDelayInSeconds = 0.4;
    dispatch_time_t uPopTime = dispatch_time(DISPATCH_TIME_NOW, uDelayInSeconds * NSEC_PER_SEC);
    dispatch_after(uPopTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.1 animations:^{
            [self updateNoteTextViewSize];
        }];
    });
}


- (void)keyboardWillHide:(NSNotification*)aNotification
{
    _keyboardSize = CGSizeMake(0.0, 0.0);
    
    [self updateNoteTextViewSize];
    
    self.noteTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //텍스트 뷰 컨텐츠 인 셋 (top, left, bottom, right)
    self.noteTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //텍스트 뷰 스크롤 인디케이터 인 셋
}


#pragma mark - noteTextView(스크롤 뷰)의 오토 스크롤링 막기

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated //prevent autoscrolling
{
	//Keep blank to prevent autoscrolling.
}


#pragma mark - UITextView 델리게이트 메소드

//tells the delegate that the text or attributes in the specified text view were changed by the user
- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.noteTextView.text.length == 0) {
        self.saveButton.enabled = NO;
    } else {
        self.saveButton.enabled = YES;
    }
//    NSLog(@"textViewDidChange: %@", textView.text);
}


//tells the delegate that the text selection changed in the specified text view
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
//    NSString *selectedText = [self.noteTextView textInRange:self.noteTextView.selectedTextRange];
//    NSLog(@"textViewDidChangeSelection: %@", selectedText);
}


//tells the delegate that editing of the specified text view has ended
- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSLog(@"textViewDidEndEditing: %@", textView.text);
}



#pragma mark - noteTextView이외 영역 터치시 키보드 내리기

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.noteTextView isFirstResponder] && [touch view] != self.noteTextView) {
        [self.noteTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}



#pragma mark - 바 버튼 액션 메소드

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self dismissViewControllerAnimated:YES completion:^{
        //block code here
    }];
}


- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    
    NSString *noteText = self.noteTextView.text; //최초 문자 앞에 위치한 공백/새줄 제거할 전체 텍스트
    NSLog (@"noteText: %@", noteText);
    
    NSString *trimmedWholeText = [noteText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //전체 텍스트에서 최초 문자 앞에 위치한 공백/새줄 제거
    NSLog (@"trimmedWholeText: %@", trimmedWholeText);
    
    __block NSString *firstLineText = nil;
    [trimmedWholeText enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        firstLineText = line; //첫 라인 텍스트
        *stop = YES;
    }];
    NSLog (@"firstLineText: %@", firstLineText);
    
    //타이틀 텍스트의 첫 문자로 섹션 키워드 만들기
    NSString *sectionText = [[firstLineText substringToIndex:1] uppercaseString]; //첫번째 캐릭터만 가져옴
    NSLog (@"sectionText: %@", sectionText);
    

    NSDate *today = [NSDate date];
    self.aNewNote.createdDate = today; //생성일
    self.aNewNote.modifiedDate = today; //수정일
    self.aNewNote.noteTitle = firstLineText;
    self.aNewNote.note = noteText;
    self.currentNote.section = sectionText; //섹션 텍스트
    
    AppDelegate *myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate]; //앱 델리게이트 컨텍스트 저장
    [myApp saveContext]; //컨텍스트 저장
    
    NSLog(@"A new note was created");
    
    [self dismissViewControllerAnimated:YES completion:^{
        //block code here
    }];
}


#pragma mark - 메모리 경고

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end