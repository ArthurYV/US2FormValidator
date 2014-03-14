//
//  ConditionUnitTests.m
//  US2FormValidatorUnitTests
//
//  Copyright (C) 2012 ustwo™
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  

#import "ConditionUnitTests.h"
#import "US2Condition.h"
#import "US2ConditionCollection.h"
#import "US2ConditionAlphabetic.h"
#import "US2ConditionAlphanumeric.h"
#import "US2ConditionEmail.h"
#import "US2ConditionNumeric.h"
#import "US2ConditionRange.h"
#import "US2ConditionURL.h"
#import "US2ConditionShorthandURL.h"
#import "US2ConditionPostcodeUK.h"
#import "US2ConditionOr.h"
#import "US2ConditionAnd.h"
#import "US2ConditionNot.h"

@implementation ConditionUnitTests


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 Test US2Condition check
 */
- (void)testUS2ConditionShouldAllowViolationDefault
{
    US2Condition *condition = [US2Condition condition];
    XCTAssertTrue(condition.shouldAllowViolation == YES, @"The default value for shouldAllowViolation must be YES", nil);
}

/**
 Test US2ConditionCollection check
 */
- (void)testUS2ConditionCollection
{
    US2ConditionCollection *collection = [[US2ConditionCollection alloc] init];
    
    XCTAssertTrue(collection.count == 0, @"The collection should be empty", nil);
    
    NSObject *someObject = nil;
    XCTAssertThrows([collection addCondition:(US2Condition *)someObject], @"Must not be able to take a nil object", nil);
    XCTAssertTrue(collection.count == 0, @"The collection must be empty", nil);
    
    someObject = [[NSObject alloc] init];
    XCTAssertNoThrow([collection addCondition:(US2Condition *)someObject], @"Must be able to take some other object", nil);
    US2Condition *condition = [collection conditionAtIndex:0];
    XCTAssertFalse([condition isKindOfClass:[US2Condition class]], @"The first item in collection can't be a condition", nil);
    [collection removeConditionAtIndex:0];
    XCTAssertTrue(collection.count == 0, @"The collection must be empty", nil);
    
    US2Condition *condition2 = [[US2Condition alloc] init];
    XCTAssertNoThrow([collection addCondition:condition2], @"Must be able to take a condition", nil);
    XCTAssertTrue(collection.count == 1, @"The collection must have one item", nil);
    [collection removeCondition:condition2];
    XCTAssertTrue(collection.count == 0, @"The collection must be empty", nil);
}

/**
 Test US2ConditionAlphabetic check
 */
- (void)testUS2ConditionAlphabetic
{
    NSString *successTestString1 = @"abcdefgh";
    NSString *successTestString2 = @"abcd efg h";
    NSString *successTestString3 = nil;
    NSString *successTestString4 = @"";
    NSString *failureTestString1 = @"12345678";
    NSString *failureTestString2 = @"a?";
    
    US2ConditionAlphabetic *condition = [[US2ConditionAlphabetic alloc] init];
    
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionAlphabetic should respond with TRUE and not FALSE", nil);
    
    condition.allowWhitespace = YES;
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionAlphabetic should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionAlphabetic should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionAlphabetic should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionAlphabetic should respond with TRUE and not FALSE", nil);
    condition.allowWhitespace = NO;
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionAlphabetic should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString2], @"The US2ConditionAlphabetic should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionAlphanumeric check
 */
- (void)testUS2ConditionAlphanumeric
{
    NSString *successTestString1 = @"abcdefgh1234567890";
    NSString *successTestString2 = nil;
    NSString *successTestString3 = @"";
    NSString *failureTestString1 = @"a?1";
    
    US2ConditionAlphanumeric *condition = [[US2ConditionAlphanumeric alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionAlphanumeric should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionAlphanumeric should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionAlphanumeric should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionAlphanumeric should respond with FALSE and not TRUE", nil);
}

/**
 Test Condition with custom regex check
 */
- (void)testUS2ConditionRegexString
{
    NSString *successTestString1 = @"hello world";
    NSString *failureTestString1 = @"a?1";
    NSString *failureTestString2 = nil;
    NSString *failureTestString3 = @"";
    
    US2Condition *condition = [[US2Condition alloc] initWithRegexString:@"hello world"];
    XCTAssertTrue([condition check:successTestString1], @"The US2Condition should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2Condition should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString2], @"The US2Condition should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString3], @"The US2Condition should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionEmail check
 */
- (void)testUS2ConditionEmail
{
    NSString *successTestString1 = @"example@example.ex";
    NSString *successTestString2 = @"e_x.a+m-p_l.e@example.ex.am";
    NSString *successTestString3 = @"e_x.a+m-p_l.e@ex.example-example.ex.am";
    NSString *successTestString4 = @"example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_example_@example.ex";
    NSString *successTestString5 = nil;
    NSString *successTestString6 = @"";
    
    NSString *failureTestString1 = @"example";
    NSString *failureTestString2 = @"example@";
    NSString *failureTestString3 = @"example@example";
    NSString *failureTestString4 = @"example@example.";
    NSString *failureTestString5 = @"example@example.ex.";
    NSString *failureTestString6 = @"e xample@example.ex.";
    NSString *failureTestString7 = @"e/xample@example.ex.";
    NSString *failureTestString8 = @"example@example.ex example@example.ex";
    
    US2ConditionEmail *condition = [[US2ConditionEmail alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString5], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString6], @"The US2ConditionEmail should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString2], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString4], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString5], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString6], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString7], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString8], @"The US2ConditionEmail should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionURL check
 */
- (void)testUS2ConditionURL
{
    NSString *successTestString1 = @"http://www.example.com";
    NSString *successTestString2 = @"https://www.example.com";
    NSString *successTestString3 = @"http://www.example.com/path";
    NSString *successTestString4 = @"http://www.example.com/?id=12345&param=value";
    NSString *successTestString5 = nil;
    NSString *successTestString6 = @"";
    
    NSString *failureTestString3 = @"example";
    NSString *failureTestString4 = @"example.com";
    NSString *failureTestString5 = @"www.example.com";
    NSString *failureTestString6 = @"http://example";
    NSString *failureTestString7 = @"http://";
    NSString *failureTestString8 = @"ftp://www.example.com";
    NSString *failureTestString9 = @"mailto://www.example.com";
    
    US2ConditionURL* condition = [[US2ConditionURL alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString5], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString6], @"The US2ConditionURL should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString4], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString5], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString6], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString7], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString8], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString9], @"The US2ConditionURL should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionShorthandURL check
 */
- (void)testUS2ConditionShorthandURL
{
    NSString *successTestString1 = @"http://www.example.com";
    NSString *successTestString2 = @"https://www.example.com";
    NSString *successTestString3 = @"http://www.example.com/path";
    NSString *successTestString4 = @"http://www.example.com/path";
    NSString *successTestString5 = @"http://www.example.com/?id=12345&param=value";
    NSString *successTestString6 = @"example.com";
    NSString *successTestString7 = @"www.example.com";
    NSString *successTestString8 = @"www.example.com/path";
    NSString *successTestString9 = nil;
    NSString *successTestString10 = @"";
    
    NSString *failureTestString3 = @"example";
    NSString *failureTestString4 = @"http://example";
    NSString *failureTestString5 = @"http://";
    NSString *failureTestString6 = @"ftp://www.example.com";
    NSString *failureTestString7 = @"mailto://www.example.com";
    
    US2ConditionShorthandURL* condition = [[US2ConditionShorthandURL alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString5], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString6], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString7], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString8], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString9], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString10], @"The US2ConditionShorthandURL should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionShorthandURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString4], @"The US2ConditionShorthandURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString5], @"The US2ConditionShorthandURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString6], @"The US2ConditionShorthandURL should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString7], @"The US2ConditionShorthandURL should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionNumeric check
*/
- (void)testUS2ConditionNumeric
{
    NSString *successTestString1 = @"1234567890";
    NSMutableString *successTestString2 = [NSMutableString string];
    for (NSUInteger i = 0; i < 10; i++)
    {
        [successTestString2 appendString:successTestString1];
    }
    NSString *successTestString3 = nil;
    NSString *successTestString4 = @"";
    
    NSString *failureTestString1 = @"a";
    NSString *failureTestString3 = @"1234abc";
    
    US2ConditionNumeric *condition = [[US2ConditionNumeric alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionNumeric should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionNumeric should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionNumeric should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionNumeric should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionNumeric should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionNumeric should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionRange check
*/
- (void)testUS2ConditionRange
{
    NSString *successTestString1 = @"1A2B3D4C5D";
    NSString *successTestString2 = @"1A2";
    
    NSString *failureTestString1 = @"1A2B3D4C5D6E";
    NSString *failureTestString2 = @"1A";
    NSString *failureTestString3 = nil;
    NSString *failureTestString4 = @"";
    
    US2ConditionRange *condition = [[US2ConditionRange alloc] init];
    condition.range = US2TextRangeMake(3, 10);
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString2], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString4], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionRange check
 */
- (void)testUS2ConditionRange2
{
    NSString *successTestString1 = @"";
    NSString *successTestString2 = @"1";
    NSString *successTestString3 = @"1A";
    NSString *successTestString4 = @"1A2";
    
    NSString *failureTestString1 = @"1A234";
    
    US2ConditionRange *condition = [[US2ConditionRange alloc] init];
    condition.range = US2TextRangeMake(0, 4);
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
}

/**
 Test US2ConditionPostcodeUK check
 */
- (void)testUS2ConditionPostcodeUK
{
    NSString *successTestString1 = @"M1 1BA";
    NSString *successTestString2 = @"N12 1UD";
    NSString *successTestString3 = @"EH9 4UA";
    NSString *successTestString4 = @"RG6 1WG";
    NSString *successTestString5 = @"W1A 1NA";
    NSString *successTestString6 = @"SW1A 1HQ";
    NSString *successTestString7 = @"FIQQ 1ZZ"; // Falkland Islands
    NSString *successTestString8 = nil;
    NSString *successTestString9 = @"";
    
    NSString *failureTestString1 = @"M1AA 1BA";
    NSString *failureTestString2 = @"M1 1BAA";
    NSString *failureTestString3 = @"M1 1BA1";
    
    US2ConditionPostcodeUK *condition = [[US2ConditionPostcodeUK alloc] init];
    XCTAssertTrue([condition check:successTestString1], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString2], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString3], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString4], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString5], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString6], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString7], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString8], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([condition check:successTestString9], @"The US2ConditionPostcodeUK should respond with TRUE and not FALSE", nil);
    
    XCTAssertFalse([condition check:failureTestString1], @"The US2ConditionPostcodeUK should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString2], @"The US2ConditionPostcodeUK should respond with FALSE and not TRUE", nil);
    XCTAssertFalse([condition check:failureTestString3], @"The US2ConditionPostcodeUK should respond with FALSE and not TRUE", nil);
}

/**
 Test US2Condition createLocalizedViolationString and localizedViolationString customization.
 */
- (void)testUS2ConditionCustomLocalizedViolationString
{
    NSString *customLocalizedViolationString = @"Enter a valid UK postal code.";
    US2ConditionPostcodeUK *condition = [[US2ConditionPostcodeUK alloc] init];
    condition.localizedViolationString = customLocalizedViolationString;
    
    XCTAssertEqualObjects([condition localizedViolationString], customLocalizedViolationString, @"Condition must return custom/overriden localized violation string.");
}

/**
 Test US2ConditionOr
 */
- (void)testUS2ConditionOr
{
    NSString *successTestString1 = @"";    
    NSString *failureTestString1 = @"1A234";
    
    US2ConditionRange *conditionRange = [[US2ConditionRange alloc] init];
    conditionRange.range = US2TextRangeMake(0, 4);
    
    US2ConditionAlphanumeric *conditionAlphanumeric = [[US2ConditionAlphanumeric alloc] init];
    
    US2ConditionOr *conditionOr = [[US2ConditionOr alloc] initWithConditionOne: conditionRange two: conditionAlphanumeric];
    NSString *expectedLocalizedViolationString = @"Min 0 Max 4 or must only contain alphanumeric";
    conditionOr.localizedViolationString = expectedLocalizedViolationString;
    
    // Test initial conditions
    XCTAssertTrue([conditionRange check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);    
    XCTAssertFalse([conditionRange check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertEqualObjects([conditionRange localizedViolationString], @"US2KeyConditionViolationRange", @"Localized violation desription must match.");
    
    // Test or condition
    XCTAssertTrue([conditionOr check: failureTestString1], @"The US2ConditionOr should be true for alpha or range.", nil);
    XCTAssertEqualObjects([conditionOr localizedViolationString], expectedLocalizedViolationString, @"Localized violation desription must match.");
}

/**
 Test US2ConditionAnd
 */
- (void)testUS2ConditionAnd
{
    NSString *successTestString1 = @"";
    NSString *successTestString2 = @"1A23";
    NSString *failureTestString1 = @"1A234";
    
    US2ConditionRange *conditionRange = [[US2ConditionRange alloc] init];
    conditionRange.range = US2TextRangeMake(0, 4);
    
    US2ConditionAlphanumeric *conditionAlphanumeric = [[US2ConditionAlphanumeric alloc] init];
    
    US2ConditionAnd *conditionAnd = [[US2ConditionAnd alloc] initWithConditionOne: conditionRange two: conditionAlphanumeric];
    NSString *expectedLocalizedViolationString = @"US2KeyConditionViolationRange";
    conditionAnd.localizedViolationString = expectedLocalizedViolationString;
    
    // Test initial conditions
    XCTAssertTrue([conditionRange check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertFalse([conditionRange check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertEqualObjects([conditionRange localizedViolationString], @"US2KeyConditionViolationRange", @"Localized violation desription must match.");
    
    // Test or condition
    XCTAssertTrue([conditionAnd check: successTestString1], @"The US2ConditionAnd should be true for alpha or range.", nil);
    XCTAssertTrue([conditionAnd check: successTestString2], @"The US2ConditionAnd should be true for alpha or range.", nil);
    XCTAssertFalse([conditionAnd check: failureTestString1], @"The US2ConditionAnd should be true for alpha or range.", nil);
    XCTAssertEqualObjects([conditionAnd localizedViolationString], expectedLocalizedViolationString, @"Localized violation desription must match.");
}

/**
 Test US2ConditionNot
 */
- (void)testUS2ConditionNot
{
    NSString *successTestString1 = @"";
    NSString *failureTestString1 = @"1A234";
    
    US2ConditionRange *conditionRange = [[US2ConditionRange alloc] init];
    conditionRange.range = US2TextRangeMake(0, 4);
    
    US2ConditionNot *conditionNot = [[US2ConditionNot alloc] initWithCondition: conditionRange];
    NSString *expectedLocalizedViolationString = @"Must not be between 0 through 4.";
    conditionNot.localizedViolationString = expectedLocalizedViolationString;
    
    // Test initial conditions
    XCTAssertTrue([conditionRange check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertFalse([conditionRange check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertEqualObjects([conditionRange localizedViolationString], @"US2KeyConditionViolationRange", @"Localized violation desription must match.");
    
    // Test not condition
    XCTAssertFalse([conditionNot check:successTestString1], @"The US2ConditionRange should respond with TRUE and not FALSE", nil);
    XCTAssertTrue([conditionNot check:failureTestString1], @"The US2ConditionRange should respond with FALSE and not TRUE", nil);
    XCTAssertEqualObjects([conditionNot localizedViolationString], expectedLocalizedViolationString, @"Localized violation desription must match.");
    
}

/**
 Test US2Condition condition
 */
- (void)testUS2ConditionStatic
{
    US2Condition *conditionRange = [US2ConditionRange condition];
    XCTAssertNotNil(conditionRange, @"Condition must not be nil.");
    XCTAssertTrue([conditionRange isKindOfClass: [US2ConditionRange class]], @"Must be correct class.", nil);
}

@end
