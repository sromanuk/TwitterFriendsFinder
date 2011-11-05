//
//  TwitterInformationResaiver.m
//  TwitterFriendsFinder
//
//  Created by Slavik Romanuk on 11/5/11.
//  Copyright (c) 2011 romanuk.org.ua. All rights reserved.
//

#import "TwitterInformationResaiver.h"


@interface TwitterInformationReceiver (Private)

twitCurl * initTwitterCurl(std::string  username, std::string password);

@end


@implementation TwitterInformationReceiver

twitCurl * initTwitterCurl(std::string  username, std::string password) {

    twitCurl * twitterObj = new twitCurl();
    std::string tmpStr;
    std::string replyMsg;
    char tmpBuf[1024];
    int tmpVar = 0;
    
    /* Set twitter username and password */
    twitterObj->setTwitterUsername( username );
    twitterObj->setTwitterPassword( password );
    
    /* OAuth flow begins */
    /* Step 0: Set OAuth related params. These are got by registering your app at twitter.com */
    twitterObj->getOAuth().setConsumerKey( TWITTER_CONSUMER_KEY );
    twitterObj->getOAuth().setConsumerSecret( TWIITER_CONSUMER_SECRET_KEY );
    
    /* Step 1: Check if we alredy have OAuth access token from a previous run */
    std::string myOAuthAccessTokenKey("");
    std::string myOAuthAccessTokenSecret("");
    std::ifstream oAuthTokenKeyIn;
    std::ifstream oAuthTokenSecretIn;
    
    oAuthTokenKeyIn.open( "twitterClient_token_key.txt" );
    oAuthTokenSecretIn.open( "twitterClient_token_secret.txt" );
    
    memset( tmpBuf, 0, 1024 );
    oAuthTokenKeyIn >> tmpBuf;
    myOAuthAccessTokenKey = tmpBuf;
    
    memset( tmpBuf, 0, 1024 );
    oAuthTokenSecretIn >> tmpBuf;
    myOAuthAccessTokenSecret = tmpBuf;
    
    oAuthTokenKeyIn.close();
    oAuthTokenSecretIn.close();
    
    if( myOAuthAccessTokenKey.size() && myOAuthAccessTokenSecret.size() )
    {
        /* If we already have these keys, then no need to go through auth again */
        printf( "\nUsing:\nKey: %s\nSecret: %s\n\n", myOAuthAccessTokenKey.c_str(), myOAuthAccessTokenSecret.c_str() );
        
        twitterObj->getOAuth().setOAuthTokenKey( myOAuthAccessTokenKey );
        twitterObj->getOAuth().setOAuthTokenSecret( myOAuthAccessTokenSecret );
    }
    else
    {
        /* Step 2: Get request token key and secret */
        twitterObj->oAuthRequestToken( tmpStr );
        
        /* Step 3: Get PIN  */
        memset( tmpBuf, 0, 1024 );
        printf( "\nDo you want to visit twitter.com for PIN (0 for no; 1 for yes): " );
        gets( tmpBuf );
        tmpVar = atoi( tmpBuf );
        
        if( tmpVar > 0 )
        {
            /* Ask user to visit twitter.com page and get PIN */
            memset( tmpBuf, 0, 1024 );
            printf( "\nPlease visit this link in web browser and authorize this application:\n%s", tmpStr.c_str() );
            printf( "\nEnter the PIN provided by twitter: " );
            gets( tmpBuf );
            tmpStr = tmpBuf;
            twitterObj->getOAuth().setOAuthPin( tmpStr );
        }
        else
        {
            /* Else, get it via twitcurl PIN handling */
            twitterObj->oAuthHandlePIN( tmpStr );
        }
        
        /* Step 4: Exchange request token with access token */
        twitterObj->oAuthAccessToken();
        
        /* Step 5: Now, save this access token key and secret for future use without PIN */
        twitterObj->getOAuth().getOAuthTokenKey( myOAuthAccessTokenKey );
        twitterObj->getOAuth().getOAuthTokenSecret( myOAuthAccessTokenSecret );
        
        /* Step 6: Save these keys in a file or wherever */
        std::ofstream oAuthTokenKeyOut;
        std::ofstream oAuthTokenSecretOut;
        
        oAuthTokenKeyOut.open( "twitterClient_token_key.txt" );
        oAuthTokenSecretOut.open( "twitterClient_token_secret.txt" );
        
        oAuthTokenKeyOut.clear();
        oAuthTokenSecretOut.clear();
        
        oAuthTokenKeyOut << myOAuthAccessTokenKey.c_str();
        oAuthTokenSecretOut << myOAuthAccessTokenSecret.c_str();
        
        oAuthTokenKeyOut.close();
        oAuthTokenSecretOut.close();
    }
    /* OAuth flow ends */
    
    return twitterObj;
}

- (id) initWithUserName: (NSString *) username password: (NSString *) password
{
    if (self = [super init]) {
        std::string usernameString([username cStringUsingEncoding:NSUTF8StringEncoding]);
        std::string passwordString([password cStringUsingEncoding:NSUTF8StringEncoding]);
        
        initTwitterCurl(usernameString, passwordString);
    }
    
    return self;
}

@end
