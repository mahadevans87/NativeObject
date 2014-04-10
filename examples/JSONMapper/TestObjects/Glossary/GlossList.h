//
//  GlossList.h
//  JSONTest
//
//  Created by mahadevan on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GlossEntry.h"

@interface GlossList : NSObject
{
    GlossEntry * GlossEntry;
    NSString * title;
    
}

@property(nonatomic, retain) GlossEntry * GlossEntry;
@property(nonatomic, retain) NSString * title;

@end
