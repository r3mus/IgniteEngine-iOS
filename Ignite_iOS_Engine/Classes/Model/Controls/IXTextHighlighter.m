//
//  IXImageControl.m
//  Ignite iOS Engine (IX)
//
//  Created by Robert Walsh on 10/15/13.
//  Copyright (c) 2013 Apigee, Inc. All rights reserved.
//

#import "IXBaseControl.h"
#import "IXTextHighlighter.h"
#import "TTTAttributedLabel.h"

static NSString* lastHashTagTouched = nil;
static NSString* lastAccountTouched = nil;
static NSString* lastEmailTouched = nil;
static NSString* lastLinkTouched = nil;
static NSString* lastDateTouched = nil;
static NSString* lastPhoneTouched = nil;

@interface IXTextHighlighter () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel* attributedLabel;

@end

@implementation IXTextHighlighter

@synthesize attributedLabel = _attributedLabel;

-(void)dealloc
{
    [_attributedLabel setDelegate:nil];
}

-(void)buildView
{
    [super buildView];
    
    _attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [_attributedLabel setDelegate:self];
    [_attributedLabel setDataDetectorTypes:UIDataDetectorTypeAll];
    [_attributedLabel setTextColor:[UIColor colorWithRed:0.286 green:0.286 blue:0.286 alpha:1.0]];
    [_attributedLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_attributedLabel setNumberOfLines:0];
    [_attributedLabel setHighlightedTextColor:[UIColor whiteColor]];
    [_attributedLabel setShadowColor:[UIColor colorWithWhite:0.87f alpha:0.0f]];
    [_attributedLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [_attributedLabel setVerticalAlignment:TTTAttributedLabelVerticalAlignmentTop];
    
    [[self contentView] addSubview:_attributedLabel];
}

-(void)layoutControlContentsInRect:(CGRect)rect
{
    [_attributedLabel setFrame:rect];
}

-(CGSize)preferredSizeForSuggestedSize:(CGSize)size
{
    return [_attributedLabel sizeThatFits:size];
}

-(void)applySettings
{
    [super applySettings];
    
    NSString* text = [[self propertyContainer] getStringPropertyValue:@"text" defaultValue:@""];
    UIColor* textColor = [[self propertyContainer] getColorPropertyValue:@"text_color" defaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]];
    
    [[self attributedLabel] setTextColor:textColor];
    [[self attributedLabel] setText:text];
    
    // LINK
    NSMutableDictionary *mutableLinkAttributes = [[NSMutableDictionary alloc] init];
    
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getColorPropertyValue:@"link_color" defaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getFontPropertyValue:@"font" defaultValue:[UIFont fontWithName:@"HelveticaNeue" size:13]] forKey:(NSString *)kCTFontAttributeName];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [[self attributedLabel] setLinkAttributes:mutableLinkAttributes];
    
    // @ACCOUNT
    mutableLinkAttributes = [[NSMutableDictionary alloc] init];
    
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getColorPropertyValue:@"account_color" defaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [[self attributedLabel] setAccountAttributes:mutableLinkAttributes];
    [[self attributedLabel] setHashtagAttributes:mutableLinkAttributes];
    [[self attributedLabel] setDateAttributes:mutableLinkAttributes];
    [[self attributedLabel] setPhoneNumberAttributes:mutableLinkAttributes];
    [[self attributedLabel] setAddressAttributes:mutableLinkAttributes];
    [[self attributedLabel] setEmailAttributes:mutableLinkAttributes];
    
    //HASHTAG
    mutableLinkAttributes = [[NSMutableDictionary alloc] init];
    
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getFontPropertyValue:@"font" defaultValue:[UIFont fontWithName:@"HelveticaNeue" size:13]] forKey:(NSString *)kCTFontAttributeName];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    [[self attributedLabel] setHashtagAttributes:mutableLinkAttributes];
    
    mutableLinkAttributes = [[NSMutableDictionary alloc] init];
    
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getColorPropertyValue:@"hashtag_color" defaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableLinkAttributes setValue:(id)[[self propertyContainer] getFontPropertyValue:@"font" defaultValue:[UIFont fontWithName:@"HelveticaNeue" size:13]] forKey:(NSString *)kCTFontAttributeName];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableLinkAttributes setValue:(id)[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableLinkAttributes setValue:(id)[NSNumber numberWithFloat:2.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    
    [[self attributedLabel] setActiveLinkAttributes:mutableLinkAttributes];
    
    //UIColor* linkColor = [self.settings getColorSetting:@"link-color" orDefaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]];
    
    //    UIColor* textColor = [self.settings getColorSetting:@"text-color" orDefaultValue:[UIColor whiteColor]];
    
    //
    //    UIColor* emailColor = [self.settings getColorSetting:@"email-color" orDefaultValue:[UIColor colorWithRed:129.0f/255.0f green:171.0f/255.0f blue:193.0f/255.0f alpha:1.0f]];
    //    [_attributedLabel setColorEmail:emailColor];
    //
    //    UIColor* accountColor = [self.settings getColorSetting:@"account-color" orDefaultValue:[UIColor colorWithWhite:100.0f/255.0f alpha:1.0f]];
    //    [_attributedLabel setColorAccount:accountColor];
    //
    //    UIColor* hashTagColor = [self.settings getColorSetting:@"hashtag-color" orDefaultValue:[UIColor colorWithWhite:170.0f/255.0f alpha:1.0f]];
    //    [_attributedLabel setColorHashtag:hashTagColor];
    //
    //    if([self.settings getBoolSetting:@"enable-shadow" orDefaultValue:NO])
    //    {
    //        UIColor* shadowColor = [_settings getColorSetting:@"shadow-color" orDefaultValue:[UIColor blackColor]];
    //
    //        _attributedLabel.shadowColor = shadowColor;
    //        _attributedLabel.shadowOffset = CGSizeMake([_settings getFloatSetting:@"shadow-offset-right" orDefaultValue:2.0], [_settings getFloatSetting:@"shadow-offset-down" orDefaultValue:2.0]);
    //    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectHashtagOrMentionWithURL:(NSURL *)url
{
    //[self.settings setSetting:@"last-account-touched" value:[url absoluteString]];
    //[self processActionsOn:@"account-touched"];
    //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hashtag or mention selected:", nil) message:[url absoluteString] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectHashtagWithURL:(NSURL *)url
{
    //    NSLog(@"#hashtag: %d",url);
    lastHashTagTouched = nil;
    
    lastHashTagTouched = [[url absoluteString] copy];
    
    //    [self.settings setSetting:@"last-hashtag-touched" value:[url absoluteString]];
    
    [[self actionContainer] executeActionsForEventNamed:@"hashtag_touched"];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectMentionWithURL:(NSURL *)url
{
    
    //    NSLog(@"@account: %d",url);
    lastAccountTouched = nil;
    
    lastAccountTouched = [[url absoluteString] copy];
    //    [self.settings setSetting:@"last-account-touched" value:[url absoluteString]];
    [[self actionContainer] executeActionsForEventNamed:@"account_touched"];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label
  didSelectEmailWithURL:(NSString *)emailAddress
{
    //    NSLog(@"mail: %d",emailAddress);
    
    lastEmailTouched = nil;
    
    lastEmailTouched = [emailAddress copy];
    
    //    [self.settings setSetting:@"last-email-touched" value:emailAddress];
    [[self actionContainer] executeActionsForEventNamed:@"email_touched"];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    //    NSLog(@"Link: %d",url);
    
    lastLinkTouched = nil;
    
    lastLinkTouched = [[url absoluteString] copy];
    
    //    [self.settings setSetting:@"last-link-touched" value:[url absoluteString]];
    [[self actionContainer] executeActionsForEventNamed:@"link_touched"];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
  didSelectLinkWithDate:(NSDate *)date
{
    //    NSLog(@"mail: %d",date.description);
    
    lastDateTouched = nil;
    
    lastDateTouched = [[date description] copy];
    
    //    [self.settings setSetting:@"last-date-touched" value:date.description];
    [[self actionContainer] executeActionsForEventNamed:@"date_touched"];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    //    NSLog(@"Phone: %d",phoneNumber);
    
    lastPhoneTouched = nil;
    
    lastPhoneTouched = [phoneNumber copy];
    
    //    [self.settings setSetting:@"last-phone-touched" value:phoneNumber];
    [[self actionContainer] executeActionsForEventNamed:@"phone_touched"];
}

//-(NSString*)getControlSpecificReadonlyPropertyValue:(NSString *)propertyName
//{
//    if( [propertyName isEqualToString:@"last-hashtag-touched"] )
//    {
//        return lastHashTagTouched;
//    }
//    else if( [propertyName isEqualToString:@"last-account-touched"] )
//    {
//        return lastAccountTouched;
//    }
//    else if( [propertyName isEqualToString:@"last-email-touched"] )
//    {
//        return lastEmailTouched;
//    }
//    else if( [propertyName isEqualToString:@"last-link-touched"] )
//    {
//        return lastLinkTouched;
//    }
//    else if( [propertyName isEqualToString:@"last-date-touched"] )
//    {
//        return lastDateTouched;
//    }
//    else if( [propertyName isEqualToString:@"last-phone-touched"] )
//    {
//        return lastPhoneTouched;
//    }
//}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
//    [[self propertyContainer] getStringPropertyValue:@"image" defaultValue:@""]
//    [self.settings setSetting:@"last-street-touched" value:[addressComponents objectForKey:@"Street"]];
//    [self.settings setSetting:@"last-city-touched" value:[addressComponents objectForKey:@"City"]];
//    [self.settings setSetting:@"last-state-touched" value:[addressComponents objectForKey:@"State"]];
//    [self.settings setSetting:@"last-zip-touched" value:[addressComponents objectForKey:@"ZIP"]];
//    [self.settings setSetting:@"last-country-touched" value:[addressComponents objectForKey:@"Country"]];
//    [self processActionsOn:@"address-touched"];
}


@end
