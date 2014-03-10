//
//  AddEditViewController.h
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

#pragma mark - AddEditViewControllerDelegate : 컨텍스트의 저장/취소/모달 뷰 해제를 위한 델리게이트

@protocol AddEditViewControllerDelegate

- (void) addEditViewControllerDidSave;
- (void) addEditViewControllerDidCancel:(Note *)noteToDelete;

@end

@interface AddEditViewController : UIViewController

@property (nonatomic, strong) Note *currentNote; //선택된 현재 노트
@property (nonatomic, strong) Note *aNewNote; //새 노트

@end


