//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Vinnie Chen on 12/29/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweetTextView.becomeFirstResponder()
        userImage.setImageWith((User._currentUser?.profileURL)!)
        userImage.clipsToBounds = true;
        userImage.layer.cornerRadius = userImage.frame.height/2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    @IBAction func onTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.compose(tweetTextView.text, completion: {
            self.dismiss(animated: true, completion: {
                
            })
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
