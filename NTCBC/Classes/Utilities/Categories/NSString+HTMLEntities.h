//
//  NSString+HTMLEntities.h
//  AldoMCEv1
//
//  Created by Michael Chung-Ching Lan on 2014-06-23.
//  Copyright (c) 2014 Kineticcafe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLEntities)

- (NSString *)stringByRemovingHTMLtags;
//- (NSString *)stringByReplacingHTMLentities;

@end
