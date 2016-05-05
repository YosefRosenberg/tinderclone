//
//  SignUpViewController.swift
//  FacebookLogin
//
//  Created by Yosef Rosenberg on 5/2/16.
//  Copyright © 2016 Yosef Rosenberg. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignUpViewController: UIViewController {

    @IBAction func signUp(sender: AnyObject) {
        
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        
        PFUser.currentUser()?.saveInBackground()
        
    }
    @IBOutlet var interestedInWomen: UISwitch!
    @IBOutlet var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlArray = ["http://images-cdn.moviepilot.com/images/c_scale,h_493,w_876/t_mp_quality/r3jovocapveehzkgdswq/doctor-her-5-actresses-who-could-play-a-female-regeneration-of-the-doctor-709622.jpg",
                        "http://ia.media-imdb.com/images/M/MV5BMTM5Nzk4NzIzMl5BMl5BanBnXkFtZTcwNzI1NDYwOQ@@._V1._SX412_CR0,0,412,412_.jpg",
                        "https://s-media-cache-ak0.pinimg.com/736x/fd/0c/2e/fd0c2e3634a1f4a106132133fd613c82.jpg",
                        "http://top10for.com/wp-content/uploads/2015/02/Youngest-Actresses-in-the-World6.jpg",
                        "https://s-media-cache-ak0.pinimg.com/236x/55/7a/0b/557a0b859df7063740d68a90efa2cd82.jpg",
                        "http://a.abcnews.go.com/images/Entertainment/GTY_melissa_mccarthy_ml_141028_16x9_992.jpg"]
        
        var counter = 1
        
        for url in urlArray {
            
            let nsUrl = NSURL(string: url)!
            
            if let data = NSData(contentsOfURL: nsUrl) {
                
                self.userImage.image = UIImage(data: data)
                
                let imageFile: PFFile = PFFile(data: data)
                
                let user:PFUser = PFUser()
                
                let username = "user\(counter)"
                
                user.username = username
                
                user.password = "pass"
                
                user["image"] = imageFile
                
                user["interestedInWomen"] = false
                
                user["gender"] = "female"
                
                counter += 1
                
                
            }
        }
        
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            
            if error != nil {
            
                print(error)

            } else if let result = result {
            
                PFUser.currentUser()?["gender"] = result["gender"]!
                PFUser.currentUser()?["name"] = result["name"]!
                PFUser.currentUser()?["id"] = result["id"]!
                
                PFUser.currentUser()?.saveInBackground()
                
                let userId = result["id"]! as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {

                    if let data = NSData(contentsOfURL: fbpicUrl) {
                
                        self.userImage.image = UIImage(data: data)

                        let imageFile: PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        
                        PFUser.currentUser()?.saveInBackground()
                        
                    }
                }
            }

        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
