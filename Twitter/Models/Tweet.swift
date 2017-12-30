//
//  Tweet.swift
//  Twitter
//
//  Created by Vinnie Chen on 10/27/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var name: String?
    var screenname: String?
    var text: String?
    var timestamp: Date?
    var retweet_count: Int = 0
    var retweeted: Bool?
    var favorites_count: Int = 0
    var favorited: Bool?
    var profileImageUrl: URL?
    var id: String?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        
        retweeted = dictionary["retweeted"] as? Bool
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        
        favorited = dictionary["favorited"] as? Bool
        favorites_count = (dictionary["favorite_count"] as? Int) ?? 0
        

        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        let userInfo = dictionary["user"] as? NSDictionary
        name = userInfo?["name"] as! String
        screenname = userInfo?["screen_name"] as! String
        screenname = "@\(screenname!)"
        
        let profileUrlString = userInfo?["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileImageUrl = URL(string: profileUrlString)
        }
        
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
        id = dictionary["id_str"] as? String
        
    }
    
    
    class func tweetswithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
