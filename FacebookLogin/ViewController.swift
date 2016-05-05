//
//  ViewController.swift
//  FacebookLogin
//
//  Created by Yosef Rosenberg on 4/28/16.
//  Copyright © 2016 Yosef Rosenberg. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("fbsignin", sender: self)
            
            }
        }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        var permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
           
            print("User: \(user)")
            print("Error: \(error)")
            
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    
                    self.performSegueWithIdentifier("fbsignin", sender: self)
                    
                } else {
                    
                    if let currentUser = PFUser.currentUser() {
                        
                        if let interestedInWomen = user["interestedInWomen"] {
                            
                            self.performSegueWithIdentifier("logUserIn", sender: self)
                            
                        } else {
                            
                            self.performSegueWithIdentifier("fbsignin", sender: self)

                        }
                        
                    }
                    
                    
                }
                
            } else {
                
                print("Uh oh. The user cancelled the Facebook login.")
                
                print("User cancelled")
                
            }
            
            
        }
    }
}
