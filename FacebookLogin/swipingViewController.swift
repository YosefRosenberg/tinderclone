//
//  swipingViewController.swift
//  FacebookLogin
//
//  Created by Yosef Rosenberg on 5/2/16.
//  Copyright © 2016 Yosef Rosenberg. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class swipingViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    
    var displayedUserId = ""
    
    // The function for gesture recognition added to the image
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        // Allows the label to be at 1 in teh center but get smaller as it moves from center, the min and 1 limit it from being bigger than 1.
        let scale = min(100 / abs(xFromCenter), 1)
        
        // 1 corresponds to about 60 degrees
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        // 1 corresponds to origional size so this is just slightly smaller
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        
        //This piece of code allows the label to return to center when you release your finger
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" {
            
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey: acceptedOrRejected)
                
                PFUser.currentUser()?.saveInBackground()
            
            }
            
            //Sets our label to how it was originally
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
        
    }
    // Creating a function called updateImage to be called elsewhere
    func updateImage() {
        var interestedIn = "male"
        
        if (PFUser.currentUser()?["interestedInWomen"])! as! Bool == true {
            
            interestedIn = "female"
            
        }
        
        var isFemale = true
        
        if (PFUser.currentUser()!["gender"])! as! String == "male" {
            
            isFemale = false
        }
        // Setting the query
        var query = PFUser.query()
        
        query!.whereKey("gender", equalTo: interestedIn)
        query!.whereKey("interestedInWomen", equalTo: isFemale)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query!.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query!.limit = 1
        
        query!.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let objects = objects as! [PFObject]? {
                
                for object in objects {
                    
                    self.displayedUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            
                            
                        } else {
                            
                            if let data = imageData {
                                
                                self.userImage.image = UIImage(data: data)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        
        userImage.addGestureRecognizer(gesture)
        
        userImage.userInteractionEnabled = true
        
        updateImage()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "logOut" {
            
            PFUser.logOut()
            
        }
        
    }

}
