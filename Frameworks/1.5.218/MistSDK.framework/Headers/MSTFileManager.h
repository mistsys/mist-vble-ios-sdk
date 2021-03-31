//
//  MSTFileManager.h
//  SWANDOLPHIN
//
//  Created by Cuong Ta on 1/10/18.
//  Copyright © 2018 Mist Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTFileManager : NSObject

// Utility

+(NSDateFormatter *)getDataFormat;

// Init

-(id)initWithDirPath:(NSString *)path;

-(id)initWithDirPath:(NSString *)path withBufferedLines:(NSInteger)lines;

-(instancetype)init;

// Writing data into the directory

-(void)writeText:(NSString *)text;

-(void)writeTextWithTimestamp:(NSString *)text;

-(void)writeText:(NSString *)text onceEvery:(NSTimeInterval)sec;

-(void)writeData:(NSData *)data;

// Getting the data from the directory

-(NSString *)getDirPath;

-(NSArray *)getFilesInPath;

-(NSMutableDictionary *)getDataInPath;

// Clearing

-(void)clearDataInPath;

-(void)clearDataInPathMoreThanDays:(int)days;

@end
