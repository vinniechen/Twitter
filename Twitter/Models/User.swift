//
//  User.swift
//  Twitter
//
//  Created by Vinnie Chen on 10/27/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileURL: URL?
    var desc: String?
    
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    //initializer - deserialization
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? NSString as! String
        desc = dictionary["description"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL =  URL(string: profileURLString)
        }
    }
    
    static var _currentUser: User? // hidden
    
    // Computer property
    class var currentUser: User? {
        // Get current user saved in UserDefaults
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        // Set current user
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let  user = user {
                // Convert to JSON
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            
            defaults.synchronize()
        }
    }
}
