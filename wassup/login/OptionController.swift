//
//  OptionController.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class OptionController: UIViewController {

    @IBOutlet weak var regEmail: UIButton!
    @IBOutlet weak var regFb: UIButton!
    @IBOutlet weak var alreadyLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        regEmail.corner(20, border: 0, colorBorder: 0x000000)
        regFb.corner(20, border: 0, colorBorder: 0x000000)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if User.sharedInstance.isLogined {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("RecommandtionTags") 
            self.presentViewController(vc, animated: true) {
                () in
                self.removeFromParentViewController()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnRegEmail(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("RegisterView") 
        self.presentViewController(vc, animated: true) {
            () in
            self.removeFromParentViewController()
        }
    }

    @IBAction func btnRegFB(sender: AnyObject) {
        Utils.lock()
        let model = User()
        model.facebook() {
            (result:AnyObject?) in
            Utils.unlock()
            let dict:Dictionary<String, AnyObject> = result as! Dictionary<String, AnyObject>
            let status = Int(dict["status"] as! NSNumber)
            if status == 1 {
                model.isFirstTimeOpen = true
                model.userId = dict["user_id"] as! String
                model.token = dict["etoken"] as! String
                model.login_style = String(2)
                
                let hasRecommandation = CONVERT_INT(dict["flag"]) == 1
                
                if hasRecommandation {
                    self.performSegueWithIdentifier("afterRecommendation", sender: nil)
                } else {
                    self.performSegueWithIdentifier("Recommendation", sender: nil)
                }
            }
        }
    }
    
    @IBAction func btnAlreadyLogin(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginView") 
        self.presentViewController(vc, animated: true) {
            () in
            self.removeFromParentViewController()
        }
    }
}
