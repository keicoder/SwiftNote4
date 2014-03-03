//
//  AddEditViewController.m
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import "AddEditViewController.h"
//#import <QuartzCore/QuartzCore.h>

@interface AddEditViewController () <UITextViewDelegate>
//바 버튼 아이템
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
//텍스트 뷰
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;


@end

@implementation AddEditViewController


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.noteTextView.returnKeyType = UIReturnKeyDone;
//    self.noteTextView.backgroundColor = [UIColor lightGrayColor];
//    
//    self.noteTextView.delegate = self; //텍스트 뷰 델리게이트
//    
//    //CALayer 클래스 이용 텍스트 뷰 커스터마이징, 레이어 프로퍼티 사용을 위해 <QuartzCore/QuartzCore.h> 임포트 할 것.
//    [[self.noteTextView layer] setBorderColor:[[UIColor grayColor] CGColor]]; //border color
//    [[self.noteTextView layer] setBackgroundColor:[[UIColor whiteColor] CGColor]]; //background color
//    [[self.noteTextView layer] setBorderWidth:1.5]; // border width
//    [[self.noteTextView layer] setCornerRadius:5]; // radius of rounded corners
//    [self.noteTextView setClipsToBounds: YES]; //clip text within the bounds
    

    [[self.noteTextView layer] setCornerRadius:10]; //텍스트 뷰 코너 곡선 적용
    
    [self.noteTextView setTextContainerInset:UIEdgeInsetsMake(10, 20, 10, 20)]; //텍스트 뷰 인셋 iOS 7
    
    self.noteTextView.alwaysBounceVertical = YES; //텍스트 뷰 Vertical 바운스
    self.noteTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive; //텍스트 뷰 키보드 Dismiss Mode Interactive
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]; //텍스트 뷰 폰트
    [self.noteTextView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]]; //텍스트 뷰 백그라운드 컬러
    
    
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


#pragma mark - 메모리 경고

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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



#pragma mark - UITextView 델리게이트 메소드

//tells the delegate that the text or attributes in the specified text view were changed by the user
- (void)textViewDidChange:(UITextView *)textView {

    textView.backgroundColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.85 alpha:1];
//    NSLog(@"textViewDidChange: %@", textView.text);
}


//tells the delegate that the text selection changed in the specified text view
- (void)textViewDidChangeSelection:(UITextView *)textView {
//    NSLog(@"textViewDidChangeSelection: %@", textView.text);
    
}


@end