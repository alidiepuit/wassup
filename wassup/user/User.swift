//
//  User.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class User: ModelBase {
    
    static let sharedInstance = User()
    var callback: ServiceResponse?
    
    var userId:String {
        get {
            guard let id = NSUserDefaults.standardUserDefaults().stringForKey("user_id") else {
                return ""
            }
            return id
        }
        set(id) {
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "user_id")
        }
    }
    
    var token:String {
        get {
            let id = NSUserDefaults.standardUserDefaults().stringForKey("user_token")
            return id != nil ? id! : ""
        }
        set(id) {
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "user_token")
        }
    }
    
    var login_style:String {
        get {
            guard let id = NSUserDefaults.standardUserDefaults().stringForKey("user_login_style") else {
                return ""
            }
            return id
        }
        set(id) {
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "user_login_style")
        }
    }
    
    var language:String {
        get {
            guard let id = NSUserDefaults.standardUserDefaults().stringForKey("user_language") else {
                return "vi"
            }
            return id
        }
        set(id) {
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "user_language")
        }
    }
    
    var isLogined:Bool {
        get {
            return self.userId != ""
        }
    }
    
    func login(username: String, passwd: String, callback: ServiceResponse) {
        let model = "user/login"
        let dict = ["email":username,
                    "password": passwd]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func logout() {
        userId = ""
        token = ""
    }
    
    func facebook(callback: ServiceResponse) {
        self.callback = callback
        let fbManager = FBSDKLoginManager()
        fbManager.logInWithReadPermissions(["email"], handler:  {
            (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if (fbloginresult.grantedPermissions.contains("email") as? Bool) != nil {
                    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: fbloginresult.token.tokenString, version: nil, HTTPMethod: "GET")
                    req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                        if(error == nil) {
                            self.getFBUserData(result["email"] as! String, fullname: result["name"] as! String, token:fbloginresult.token.tokenString)
                        }
                        else
                        {
                            print("error \(error)", terminator: "")
                        }
                    })
                }
            }
        })
    }
    
    func getFBUserData(email: String, fullname: String, token: String){
        self.loginFB(email, fullname: fullname, token: token) {
            (result) in
            if self.callback != nil {
                self.callback!(result)
            }
            
        }
    }
    
    func loginFB(email: String, fullname: String, token: String, callback: ServiceResponse) {
        let model = "user/loginFacebook"
        let dict = ["email":email,
                    "fullname": fullname,
                    "etoken": token]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func register(username: String, passwd: String, callback: ServiceResponse) {
        let model = "user/registerUser"
        let dict = ["email":username,
            "password": passwd]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func forgotPass(username: String, callback: ServiceResponse) {
        let model = "user/sendEmailResetPassword"
        let dict = ["email":username,]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    var isFirstTimeOpen:Bool {
        get {
            return !NSUserDefaults.standardUserDefaults().boolForKey("IS_FIRST_TIME_OPEN")
        }
        set(val) {
            return NSUserDefaults.standardUserDefaults().setBool(val, forKey: "IS_FIRST_TIME_OPEN")
        }
    }
    
    var hasRecommandation:Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("USER_HAS_RECOMMANDATION")
        }
        set(val) {
            return NSUserDefaults.standardUserDefaults().setBool(val, forKey: "USER_HAS_RECOMMANDATION")
        }
    }
    
    
    func registEvent(eventId: String) {
        let model = "u_user/registEvent"
        let dict = ["event_id": eventId,
                    "user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func followHost(hostId: String) {
        let model = "u_user/follow"
        let dict = ["host_id": hostId,
                    "user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func followUser(userId: String) {
        let model = "u_user/follow"
        let dict = ["user_id": userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func bookmarkBlog(collectionId: String, collectionName: String, objectId: String, objectType: String) {
        let model = "u_user/bookmark"
        let dict = ["collection_id": collectionId,
                    "collection_name": collectionName,
                    "object_id": objectId,
                    "object_type": objectType,
                    "user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func likeBlog(blogId: String) {
        let model = "u_user/likeArticle"
        let dict = ["article_id": blogId,
                    "user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func likeFeed(feedId: String) {
        let model = "u_user/likeFeed"
        let dict = ["id": feedId,
                    "user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: nil)
    }
    
    func getMyProfile(callback: ServiceResponse) {
        let model = "u_user/getProfile"
        let dict = ["user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func getUserProfile(userId: String, callback: ServiceResponse) {
        let model = "user/getProfile"
        let dict = ["user_id": userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func updateProfile(fullname: String, email: String, address: String, avatar: NSData, cover: NSData, callback: ServiceResponse) {
        let model = "u_user/updateProfile"
        let dict = ["fullname": fullname,
                    "email": email,
                    "address": address,
                    "image": avatar,
                    "banner": cover,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI(model, params: dict, callback: callback)
    }
}
