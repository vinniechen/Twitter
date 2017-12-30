//
//  TweetCell.swift
//  Twitter
//
//  Created by Vinnie Chen on 10/29/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    var favorited: Bool?
    var retweeted: Bool?
    
    var user: User?
    
    var tweet: Tweet! {
        didSet {
            nameLabel.setTitle(tweet.name, for: .normal)
            usernameLabel.text = tweet.screenname
            dateLabel.text = "2hr"
            tweetLabel.text = tweet.text
            retweetCountLabel.text = "\(tweet.retweet_count)"
            favoriteCount.text = "\(tweet.favorites_count)"
            favorited = tweet.favorited
            retweeted = tweet.retweeted
            
            userImage.setImageWith(tweet.profileImageUrl!)
            userImage.layer.cornerRadius = userImage.frame.height/2
            userImage.clipsToBounds = true
            
            if tweet.favorited! {
                favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            }
            if tweet.retweeted! {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            }
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onUser(_ sender: Any) {
    
    }
    
    @IBAction func onUserImage(_ sender: Any) {
    
    }
    
    func getProfile(user: User) {
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if retweeted! {
            tweet.retweeted = false
            tweet.retweet_count -= 1
        } else {
            tweet.retweeted = true
            tweet.retweet_count += 1
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            TwitterClient.sharedInstance?.retweet(tweet: tweet, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if favorited! {
            tweet.favorited = false
            tweet.favorites_count -= 1
        } else {
            tweet.favorited = true
            tweet.favorites_count += 1
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            TwitterClient.sharedInstance?.favorite(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if error != nil {
                    
                } else {
                    print("error: \(error!.localizedDescription)")
                }
            })
        }
        
    }
    

}
