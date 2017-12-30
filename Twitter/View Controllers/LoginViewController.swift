//
//  LoginViewController.swift
//  Twitter
//
//  Created by Vinnie Chen on 10/27/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // Login Button Action
    @IBAction func onLoginButton(_ sender: Any) {
        
        // Create twitter client
        let twitterClient = TwitterClient.sharedInstance
        
        // Log in - call to TwitterClient
        twitterClient?.login(success: {
            print("Logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
