//
//  Image.h
//  SwiftNote4
//
//  Created by jun on 2014. 3. 3..
//  Copyright (c) 2014년 jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * geoTag;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * imageUid;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSSet *toNotes;
@end

@interface Image (CoreDataGeneratedAccessors)

- (void)addToNotesObject:(Note *)value;
- (void)removeToNotesObject:(Note *)value;
- (void)addToNotes:(NSSet *)values;
- (void)removeToNotes:(NSSet *)values;

@end
