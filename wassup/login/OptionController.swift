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
            self.removeFromParentViewController()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("RecommandtionTags") 
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnRegEmail(sender: AnyObject) {
        self.removeFromParentViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("RegisterView") 
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func btnRegFB(sender: AnyObject) {
        let model = User()
        model.facebook() {
            (result:AnyObject?) in
            let dict:Dictionary<String, AnyObject> = result as! Dictionary<String, AnyObject>
            let status = Int(dict["status"] as! NSNumber)
            if status == 1 {
                model.isFirstTimeOpen = true
                model.userId = dict["user_id"] as! String
                model.token = dict["etoken"] as! String
                model.login_style = String(2)
                
                let alert = UIAlertView(title: Localization("Thong bao"), message: dict["message"] as? String, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
                self.removeFromParentViewController()
                self.performSegueWithIdentifier("afterOption", sender: nil)
            }
        }
    }
    
    @IBAction func btnAlreadyLogin(sender: AnyObject) {
        self.removeFromParentViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginView") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
