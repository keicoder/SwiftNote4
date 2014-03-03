//
//  Note.h
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * annotate;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteContents;
@property (nonatomic, retain) NSNumber * noteUid;
@property (nonatomic, retain) NSNumber * star;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSSet *toImages;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addToImagesObject:(Image *)value;
- (void)removeToImagesObject:(Image *)value;
- (void)addToImages:(NSSet *)values;
- (void)removeToImages:(NSSet *)values;

@end
