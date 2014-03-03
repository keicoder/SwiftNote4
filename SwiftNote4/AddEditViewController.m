//
//  AddEditViewController.m
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import "AddEditViewController.h"

@interface AddEditViewController () <UITextViewDelegate>
//바 버튼 아이템
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
//텍스트 뷰
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;


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
    
    [[self.noteTextView layer] setCornerRadius:10]; //텍스트 뷰 코너 곡선 적용
    
    [self.noteTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)]; //텍스트 뷰 인셋 iOS 7
    
    self.noteTextView.alwaysBounceVertical = YES; //텍스트 뷰 Vertical 바운스
    self.noteTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive; //텍스트 뷰 키보드 Dismiss Mode Interactive
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]; //텍스트 뷰 폰트
    [self.noteTextView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]]; //텍스트 뷰 백그라운드 컬러
    
    [self registerForKeyboardNotifications];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewWillAppear:animated];
    
    if ([self.noteTextView.text length] == 0) {
//        [self.noteTextView becomeFirstResponder]; //뷰가 나타날 때 키보드 팝 업
//        self.saveButton.enabled = NO; //save 버튼 비활성
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
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


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    _keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //노트필드 사이즈 조정
    double uDelayInSeconds = 0.4;
    dispatch_time_t uPopTime = dispatch_time(DISPATCH_TIME_NOW, uDelayInSeconds * NSEC_PER_SEC);
    dispatch_after(uPopTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self updateNoteTextViewSize];
        }];
    });
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    _keyboardSize = CGSizeMake(0.0, 0.0);
    
    self.noteTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //노트필드 컨텐츠 인 셋 (top, left, bottom, right)
    self.noteTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //노트필드 스크롤 인디케이터 인 셋
    
    [UIView animateWithDuration:0.3 animations:^{
        [self updateNoteTextViewSize];
    }];
}


#pragma mark - UITextView 델리게이트 메소드

//tells the delegate that the text or attributes in the specified text view were changed by the user
- (void)textViewDidChange:(UITextView *)textView {

//    textView.backgroundColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.85 alpha:1];
//    NSLog(@"textViewDidChange: %@", textView.text);
}


//tells the delegate that the text selection changed in the specified text view
- (void)textViewDidChangeSelection:(UITextView *)textView {
//    NSLog(@"textViewDidChangeSelection: %@", textView.text);
    
}


//tells the delegate that editing of the specified text view has ended
- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSLog(@"textViewDidEndEditing: %@", textView.text);
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