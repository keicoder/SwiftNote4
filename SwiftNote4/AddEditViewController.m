//
//  AddEditViewController.m
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import "AddEditViewController.h"

@interface AddEditViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddEditViewController


#pragma mark - 뷰 라이프 사이클

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - 메모리 경고

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
