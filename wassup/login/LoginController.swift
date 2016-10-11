//
//  LoginController.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPass: UIButton!
    @IBOutlet weak var loginFB: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.corner(20, border: 2, colorBorder: 0xFFFFFF)
        password.corner(20, border: 2, colorBorder: 0xFFFFFF)
        btnLogin.corner(20, border: 0, colorBorder: 0x000000)
        loginFB.corner(20, border: 0, colorBorder: 0x000000)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickLogin(sender: AnyObject) {
        let email = self.email.text
        let pass = self.password.text
        
        
        let model = User()
        model.login(email!, passwd: pass!) {
            (result:AnyObject?) in
            let dict = result as! Dictionary<String, AnyObject>
            let status = Int(dict["status"]! as! NSNumber)
            if status == 1 {
                model.isFirstTimeOpen = true
                model.userId = dict["user_id"] as! String
                model.token = dict["etoken"] as! String
                model.login_style = String(1)
                let hasRecommandation = CONVERT_INT(dict["flag"]) == 1
                
                if hasRecommandation {
                    self.performSegueWithIdentifier("afterRecommendation", sender: nil)
                } else {
                    self.performSegueWithIdentifier("Recommendation", sender: nil)
                }
            } else {
                let msg = CONVERT_STRING(dict["message"])
                let alert = UIAlertView(title: Localization("Thông báo"), message: msg, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    @IBAction func clickLoginFB(sender: AnyObject) {
        let model = User()
        Utils.lock()
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
    
    @IBAction func clickForgotPassword(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ForgotView") 
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
    }
    
    @IBAction func clickRegister(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("RegisterView") 
        self.presentViewController(vc, animated: true) {
            () in
            self.removeFromParentViewController()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
    }
}
