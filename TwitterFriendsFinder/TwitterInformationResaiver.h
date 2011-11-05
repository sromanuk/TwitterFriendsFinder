//
//  TwitterInformationResaiver.h
//  TwitterFriendsFinder
//
//  Created by Slavik Romanuk on 11/5/11.
//  Copyright (c) 2011 romanuk.org.ua. All rights reserved.
//


#import "twitcurl.h"

@interface TwitterInformationReceiver : NSObject {
    twitCurl * m_twitterObject;
}

- (id) initWithUserName: (NSString *) username password: (NSString *) password;

@end
