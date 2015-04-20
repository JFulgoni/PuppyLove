//
//  Plist.h
//  PuppyLove
//
//  Created by John Fulgoni on 12/5/13.
//  Copyright (c) 2013 John Fulgoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plist : NSObject

//Convert Object(Dictionary,Array) to Plist(NSData)
+(NSData *) objToPlistAsData:(id)obj;

//Convert Object(Dictionary,Array) to Plist(NSString)
+(NSString *) objToPlistAsString:(id)obj;

//Convert Plist(NSData) to Object(Array,Dictionary)
+(id) plistToObjectFromData:(NSData *)data;

//Convert Plist(NSString) to Object(Array,Dictionary)
+(id) plistToObjectFromString:(NSString*)str;

@end