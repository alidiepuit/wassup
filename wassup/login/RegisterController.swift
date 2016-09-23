//
//  RegisterController.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var btnReg: UIButton!
    @IBOutlet weak var refresh: UIButton!
    @IBOutlet weak var captcha: UITextField!
    @IBOutlet weak var imgCaptcha: UILabel!
    @IBOutlet weak var fullname: UITextField!
    let cap = Captcha()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullname.corner(20, border: 2, colorBorder: 0xFFFFFF)
        email.corner(20, border: 2, colorBorder: 0xFFFFFF)
        password.corner(20, border: 2, colorBorder: 0xFFFFFF)
        rePassword.corner(20, border: 2, colorBorder: 0xFFFFFF)
        captcha.corner(20, border: 2, colorBorder: 0xFFFFFF)
        btnReg.corner(20, border: 0, colorBorder: 0x000000)
        
        refreshCaptcha()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func clickRefresh(sender: AnyObject) {
        refreshCaptcha()
    }
    
    func refreshCaptcha() {
        cap.reload_captcha()
        imgCaptcha.text = cap.getCaptcha()
    }
    
    @IBAction func clickRegister(sender: AnyObject) {
        let alert = UIAlertView(title: Localization("Thông báo"), message: "", delegate: nil, cancelButtonTitle: "OK")
        if fullname.text!.trim() == "" || email.text!.trim() == "" || password.text!.trim() == "" || rePassword.text!.trim() == "" || captcha.text!.trim() == "" {
            alert.message = Localization("Không được để trống thông tin đăng ký")
            alert.show()
            return
        }
        if fullname.text!.trim() == "" {
            alert.message = Localization("Họ tên không hợp lệ")
            alert.show()
            return
        }
        if !email.text!.validEmail() && !email.text!.validPhoneNumber() {
            alert.message = Localization("Email hoặc Phone không hợp lệ")
            alert.show()
            return
        }
        if password.text != rePassword.text {
            alert.message = Localization("Mật khẩu không khớp")
            alert.show()
            return
        }
        if !cap.check(captcha.text) {
            alert.message = Localization("Captcha không đúng")
            alert.show()
            return
        }
        let md = User()
        md.register(email.text!.trim(), fullname: fullname.text!.trim(), passwd: password.text!.trim()) {
            (result:AnyObject?) in
            if let dict = result as? Dictionary<String, AnyObject> {
                let status = Int(dict["status"] as! NSNumber)
                if status == 1 {
                    md.isFirstTimeOpen = true
                    md.login_style = String(1)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("LoginView")
                    self.presentViewController(vc, animated: true) {
                        () in
                        self.removeFromParentViewController()
                    }
                }
                alert.message = dict["message"] as? String
                alert.show()
            }
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("OptionLogin") 
        self.presentViewController(vc, animated: true) {
            () in
            self.removeFromParentViewController()
        }
    }
}
