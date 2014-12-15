/*
 * AQTrie.m
 * HTMLHyphenator
 * 
 * Created by Jim Dovey on 22/7/2010.
 * 
 * Copyright (c) 2010 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "AQTrie.h"

@interface AQTrie ()
- (void) buildMembersWithPrefix: (NSString *) prefix inArray: (NSMutableArray *) builder;
- (void) buildValuesWithPrefix: (NSString *) prefix inDictionary: (NSMutableDictionary *) builder;
@end

#define KeyValue(ch) ((const void *)((const ptrdiff_t)ch))

#ifdef isdigit
# undef isdigit
#endif
#define isdigit(ch) ((ch >= (int)'0') && (ch <= (int)'9'))

@interface _AQTrieEncodeContext : NSObject
@property (nonatomic, strong) NSMutableData * charData;
@property (nonatomic, strong) NSMutableArray * values;
@end

@implementation _AQTrieEncodeContext
@synthesize charData, values;
@end

@implementation AQTrie

+ (AQTrie *) trie
{
	return ( [[self alloc] init] );
}

- (id) init
{
	self = [super init];
	if ( self == nil )
		return ( nil );
	
	_children = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
	
	return ( self );
}

- (id) initWithCoder: (NSCoder *) aDecoder
{
	self = [super init];
	if ( self == nil )
		return ( nil );
	
	NSData * charData = [aDecoder decodeObjectForKey: @"chars"];
	NSArray * children = [aDecoder decodeObjectForKey: @"children"];
	NSAssert(([charData length]/sizeof(int)) == [children count], @"-[AQTrie initWithCoder:] Expected character count to match child count.");
	
	_leaf = [aDecoder decodeBoolForKey: @"leaf"];
	_value = [aDecoder decodeObjectForKey: @"value"];
	if ( [_value conformsToProtocol: @protocol(NSCopying)] )
		_value = [_value copy];
	
	_children = (__bridge CFMutableDictionaryRef)CFBridgingRelease(CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks));
	
	// pack the dictionary
	const int * chars = [charData bytes];
	[children enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		CFDictionaryAddValue(_children, (const void *)(intptr_t)(chars[idx]), (__bridge const void *)(obj));
	}];
	
	return ( self );
}

- (void) dealloc
{
	if ( _children != NULL )
		CFRelease(_children);
}

static void _EncodeApplier(const void *key, const void *value, void *context)
{
	_AQTrieEncodeContext * ctx = (__bridge _AQTrieEncodeContext *)context;
	int ch = (int)(ptrdiff_t)key;
	id child = (__bridge id)value;
	
	[ctx.charData appendBytes: &ch length: sizeof(int)];
	[ctx.values addObject: child];
}

- (void) encodeWithCoder: (NSCoder *) aCoder
{
	[aCoder encodeBool: _leaf forKey: @"leaf"];
	[aCoder encodeObject: _value forKey: @"value"];
	
	NSMutableData * data = [NSMutableData new];
	NSMutableArray * array = [NSMutableArray new];
	
	_AQTrieEncodeContext * ctx = [_AQTrieEncodeContext new];
	ctx.charData = data;
	ctx.values = array;
	
	CFDictionaryApplyFunction(_children, _EncodeApplier, (__bridge void *)ctx);
	
	[aCoder encodeObject: data forKey: @"chars"];
	[aCoder encodeObject: array forKey: @"children"];
}

- (void) setValue: (id) value
{
	if ( [value conformsToProtocol: @protocol(NSCopying)] )
		value = [value copy];
	
	_value = value;
}

static void _SizeApplier(const void *key __unused, const void *value, void *context)
{
	NSUInteger *pVal = (NSUInteger *)context;
	AQTrie * child = (__bridge AQTrie *)value;
	*pVal += [child count];
}

- (NSUInteger) count
{
	NSUInteger result = CFDictionaryGetCount(_children);
	CFDictionaryApplyFunction(_children, _SizeApplier, &result);
	return ( result );
}

- (AQTrie *) addRunesFromString: (NSString *) str index: (NSUInteger) idx
{
	if ( idx >= [str length] )
	{
		_leaf = YES;
		return ( self );
	}
	
	int ch = tolower((int)[str characterAtIndex: idx]);
	AQTrie * child = (AQTrie *)CFDictionaryGetValue(_children, KeyValue(ch));
	if ( child == nil )
	{
		child = [AQTrie trie];
		CFDictionarySetValue(_children, KeyValue(ch), (__bridge const void *)(child));
	}
	
	return ( [child addRunesFromString: str index: ++idx] );
}

- (void) addString: (NSString *) str
{
	if ( [str length] == 0 )
		return;
	
	[self addRunesFromString: str index: 0];
}

- (void) addString: (NSString *) str withValue: (id) value
{
	if ( [str length] == 0 )
		return;
	
	AQTrie * leaf = [self addRunesFromString: str index: 0];
	[leaf setValue: value];
}

- (BOOL) removeRunesFromString: (NSString *) str index: (NSUInteger) idx
{
	if ( idx >= [str length] )
	{
		_value = nil;
		_leaf = NO;
		return ( CFDictionaryGetCount(_children) == 0 );
	}
	
	int ch = tolower((int)[str characterAtIndex: idx]);
	AQTrie * child = (AQTrie *)CFDictionaryGetValue(_children, KeyValue(ch));
	if ( (child != nil) && ([child removeRunesFromString: str index: ++idx]) )
	{
		// child has no other children, so we can prune it from here
		CFDictionaryRemoveValue(_children, KeyValue(ch));
	}
	
	return ( CFDictionaryGetCount(_children) == 0 );
}

- (BOOL) removeString: (NSString *) str
{
	if ( [str length] == 0 )
		return ( CFDictionaryGetCount(_children) == 0 );
	
	return ( [self removeRunesFromString: str index: 0] );
}

- (AQTrie *) includesString: (NSString *) str index: (NSUInteger) idx
{
	if ( idx >= [str length] )
	{
		if ( _leaf )
			return ( self );
		return ( nil );
	}
	
	int ch = tolower((int)[str characterAtIndex: idx]);
	AQTrie * child = (AQTrie *)CFDictionaryGetValue(_children, KeyValue(ch));
	if ( child == nil )
		return ( nil );
	
	return ( [child includesString: str index: ++idx] );
}

- (BOOL) containsString: (NSString *) str
{
	if ( [str length] == 0 )
		return ( NO );
	
	return ( [self includesString: str index: 0] != nil );
}

- (id) valueForString: (NSString *) str
{
	if ( [str length] == 0 )
		return ( nil );
	
	AQTrie * leaf = [self includesString: str index: 0];
	if ( leaf == nil )
		return ( nil );
	
	return ( leaf->_value );
}

- (void)_applySelector:(SEL)selector toDictionary:(CFDictionaryRef)dictionaryRef withPrefix:(NSString *)prefix andBuilder:(id)builder {
    NSDictionary *dictionary = (__bridge NSDictionary *)dictionaryRef;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        int ch = (int)(ptrdiff_t)key;
        AQTrie * child = (AQTrie *)obj;
        
        NSString *fullPrefix = [prefix stringByAppendingFormat: @"%C", (unichar)ch];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [child performSelector: selector withObject: fullPrefix withObject: builder];
#pragma clang diagnostic pop
    }];
}

- (void) buildMembersWithPrefix: (NSString *) prefix inArray: (NSMutableArray *) builder
{
	if ( _leaf )
		[builder addObject: prefix];
	
	// for each child, go grab all suffixes
    [self _applySelector:_cmd toDictionary:_children withPrefix:prefix andBuilder:builder];
}

- (void) buildValuesWithPrefix: (NSString *) prefix inDictionary: (NSMutableDictionary *) builder
{
	if ( _leaf )
	{
		id v = _value;
		if ( v == nil )
			v = [NSNull null];
		[builder setObject: v forKey: prefix];
	}
	
    [self _applySelector:_cmd toDictionary:_children withPrefix:prefix andBuilder:builder];
}

- (NSArray *) allStrings
{
	NSMutableArray * builder = [[NSMutableArray alloc] initWithCapacity: 512];
	[self buildMembersWithPrefix: @"" inArray: builder];
	[builder sortUsingSelector: @selector(caseInsensitiveCompare:)];
	return ( builder );
}

- (NSDictionary *) allStringsAndValues
{
	NSMutableDictionary * builder = [[NSMutableDictionary alloc] initWithCapacity: 512];
	[self buildValuesWithPrefix: @"" inDictionary: builder];
	return ( builder );
}

- (NSArray *) allSubstringsOfString: (NSString *) string
{
	NSMutableArray * builder = [[NSMutableArray alloc] init];
	NSUInteger i, count = [string length];
	AQTrie * trie = self;
	
	for ( i = 0; i < count; i++ )
	{
		int ch = tolower((int)[string characterAtIndex: i]);
		AQTrie * child = (AQTrie *)CFDictionaryGetValue(trie->_children, KeyValue(ch));
		if ( child == nil )
			break;		// no further substrings in the trie
		
		if ( child->_leaf )
		{
			// this child is the end of a stored string, so it's a valid substring
			[builder addObject: [string substringToIndex: i+1]];
		}
		
		trie = child;
	}
	
	return ( builder );
}

- (NSDictionary *) allSubstringsAndValuesOfString: (NSString *) string
{
	NSMutableDictionary * builder = [[NSMutableDictionary alloc] init];
	NSUInteger i, count = [string length];
	AQTrie * trie = self;
	
	for ( i = 0; i < count; i++ )
	{
		int ch = tolower((int)[string characterAtIndex: i]);
		AQTrie * child = (AQTrie *)CFDictionaryGetValue(trie->_children, KeyValue(ch));
		if ( child == nil )
			break;		// no further substrings in the trie
		
		if ( child->_leaf )
		{
			// this child is the end of a stored string, so it's a valid substring
			id v = child->_value;
			if ( v == nil )
				v = [NSNull null];
			[builder setObject: v forKey: [string substringToIndex: i+1]];
		}
		
		trie = child;
	}
	
	return ( builder );
}

- (AQTrie *) includesString: (NSString *) str index: (NSUInteger) idx returnLeavesOnly: (BOOL) returnLeavesOnly
{
	if ( idx >= [str length] )
	{
		if ( (_leaf) || (returnLeavesOnly == NO) )
			return ( self );
		return ( nil );
	}
	
	int ch = tolower((int)[str characterAtIndex: idx]);
	AQTrie * child = (AQTrie *)CFDictionaryGetValue(_children, (void *)(intptr_t)ch);
	if ( child == nil )
		return ( nil );
	
	return ( [child includesString: str index: ++idx returnLeavesOnly: returnLeavesOnly] );
}

- (NSString *) findFirstMemberWithPrefix: (NSString *) prefix
{
	if ( _leaf )
		return ( prefix );
	
	__block NSString * str = nil;
	
	// for each child, go grab all suffixes
	[((__bridge NSDictionary *)_children) enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
		str = [obj findFirstMemberWithPrefix: [prefix stringByAppendingFormat:@"%C", (unichar)(uintptr_t)key]];
		if ( str != nil )
			*stop = YES;
	}];
	
	return ( str );
}

- (NSString *) firstCompletionForString: (NSString *) str
{
	AQTrie * subtrie = [self includesString: str index: 0 returnLeavesOnly: NO];
	if ( subtrie == nil )
		return ( nil );
	
	return ( [subtrie findFirstMemberWithPrefix: str] );
}

- (NSArray *) allCompletionsForString: (NSString *) str
{
	AQTrie * subtrie = [self includesString: str index: 0 returnLeavesOnly: NO];
	NSArray * completions = [subtrie allStrings];
	
	NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity: [completions count]];
	if ( subtrie->_leaf )
		[result addObject: str];
	
	NSMutableString * full = [[NSMutableString alloc] init];
	for ( NSString * completion in completions )
	{
		[full setString: str];
		[full appendString: completion];
		
		NSString * newStr = [full copy];
		[result addObject: newStr];
	}
	
	return ( result );
}

- (NSDictionary *) allCompletionsAndValuesForString: (NSString *) str
{
	AQTrie * subtrie = [self includesString: str index: 0 returnLeavesOnly: NO];
	
	NSDictionary * completions = [subtrie allStringsAndValues];
	
	NSMutableDictionary * result = [[NSMutableDictionary alloc] initWithCapacity: [completions count]];
	if ( subtrie->_leaf )
		[result setObject: subtrie->_value forKey: str];
	NSMutableString * full = [NSMutableString new];
	
	if ( [completions respondsToSelector: @selector(enumerateKeysAndObjectsUsingBlock:)] )
	{
		[completions enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
			[full setString: str];
			[full appendString: key];
			
			NSString * newStr = [full copy];
			[result setObject: obj forKey: newStr];
		}];
	}
	else
	{
		for ( NSString * completion in completions )
		{
			[full setString: str];
			[full appendString: completion];
			
			NSString * newStr = [full copy];
			[result setObject: [completions objectForKey: completion] forKey: newStr];
		}
	}
	
	return ( result );
}

@end

@implementation AQTrie (TeXHyphenationPatternSupport)

#define UCNumber(x) (x - (int)'0')

- (void) addTeXPatternString: (NSString *) pattern
{
	NSMutableArray * builder = [[NSMutableArray alloc] init];
	NSMutableString * str = [[NSMutableString alloc] init];
	CFIndex len = (CFIndex)[pattern length];
	NSNumber * zeroNum = [NSNumber numberWithInt: 0];
	
	CFStringInlineBuffer buf;
	CFStringInitInlineBuffer((CFStringRef)pattern, &buf, CFRangeMake(0, len));
	
	for ( int i = 0; i < len; i++ )
	{
		int ch = tolower((int)CFStringGetCharacterFromInlineBuffer(&buf, i));
		if ( isdigit(ch) )
		{
			if ( i == 0 )
			{
				// prefix number
				[builder addObject: [NSNumber numberWithInt: UCNumber(ch)]];
			}
			
			// numbers other than the prefix get handled when reading non-digit characters
			continue;
		}
		
		// append the non-digit character to the output
		[str appendFormat: @"%C", (unichar)tolower(ch)];
		
		if ( i < len-1 )
		{
			// look ahead to see if it's followed by a number
			int next = tolower((int)CFStringGetCharacterFromInlineBuffer(&buf, i+1));
			if ( isdigit(next) )
			{
				[builder addObject: [NSNumber numberWithInt: UCNumber(next)]];
			}
			else
			{
				// no number following a letter means the letter gets an implied zero
				[builder addObject: zeroNum];
			}
		}
		else
		{
			// last character in the string gets an implied zero
			[builder addObject: zeroNum];
		}
	}
	
	AQTrie * leaf = [self addRunesFromString: str index: 0];
	[leaf setValue: builder];
}

@end
