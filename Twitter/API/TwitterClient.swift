//
//  TwitterClient.swift
//  Twitter
//
//  Created by Vinnie Chen on 10/28/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    // Create twitter client
    static let sharedInstance  = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "aMTSZofD7a5F8yQyrXvRmBKUU", consumerSecret: "vlfoBAiOxknjlqGErYlCCmZIKT2zrluDtxLrjXQuLXkMIyUNbh")
    
    // Create closures to handle when login process is finished in AppDelegate
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    // Log in
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        // Store paths for later
        loginSuccess = success
        loginFailure = failure
        
        let requestPath = "oauth/request_token"
        // Log out
        deauthorize()
        // Fetch request token, get permission to send user to authorize URL
        fetchRequestToken(withPath: requestPath, method: "GET", callbackURL: URL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("Successfully fetched request token")
            
            // Open given url
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                
            })
            
        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    // Handle URL
    func handleOpenUrl(url: URL) {
        let token = BDBOAuth1Credential(queryString: url.query)
        
        // Fetch access token to person's twitter account
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: token, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            print("Successfully fetched access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user // saves current user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error!) in
            print ("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    // Get user credentials
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil,
           success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
        }, failure: { (URLSessionDataTask, error: Error!) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    // Logout
    func logout() {
        User.currentUser = nil
        deauthorize()
        // Notify logout
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    // Get timeline tweets, used as a closure
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as? [NSDictionary]
            
            // Convert dictionary to array of tweets
            let tweets = Tweet.tweetswithArray(dictionaries: dictionary!)
            success(tweets)
            
        }, failure: { (URLSessionDataTask, error: Error!) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    // Retweet a tweet
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()) {
        let urlString = "1.1/statuses/retweet/" + tweet.id! + ".json"
        post(urlString, parameters: ["id": tweet.id], progress: nil, success: { (task: URLSessionTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }) { (task: URLSessionTask?, error: Error) in
            failure(error)
        }
    }

    
    // Favorite a Tweet
    func favorite(_ tweet: Tweet, completion: @escaping (Tweet?, Error?) -> ()) {
        let urlString = "https://api.twitter.com/1.1/favorites/create.json"
        let parameters = ["id": tweet.id]
        post(urlString, parameters: parameters, progress: { (progress: Progress) in
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("response: \(response)")
        }, failure: { (URLSessionDataTask, error: Error!) in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
    // Compose a tweet
    func compose(_ tweet: String, completion: @escaping (() -> ())) {
        let urlString = "https://api.twitter.com/1.1/statuses/update.json"
        var parameters = [String: AnyObject]()
        parameters["status"] = tweet as AnyObject?
        
        post(urlString, parameters: parameters, progress: { (progress: Progress) in
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("response: \(response)")
        }, failure: { (URLSessionDataTask, error: Error!) in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
}
