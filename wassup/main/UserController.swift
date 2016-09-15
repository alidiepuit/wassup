//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class UserController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var menu: UITableView!
    
    var data:Dictionary<String,AnyObject>!
    
    let titleMenu = [Localization("Profile"),
                     Localization("Đăng xuất"),
                     Localization("Giới thiệu"),
                     Localization("Liên hệ"),
                     Localization("Quy chế hoạt động"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatar.corner(30, border: 0, colorBorder: 0x000000)
    }
    
    override func viewWillAppear(animated: Bool) {
         getProfile()
    }
    
    func getProfile() {
        let md = User()
        md.getMyProfile() {
            (result:AnyObject?) in
            self.data = result!["user"] as! Dictionary<String,AnyObject>
            LazyImage.showForImageView(self.avatar, url: CONVERT_STRING(self.data["image"]))
            self.name.text = CONVERT_STRING(self.data["fullname"])
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.selectionStyle = .None
        cell.textLabel?.text = titleMenu[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("DetailProfile", sender: nil)
        case 1:
            User.sharedInstance.logout()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginView")
            self.presentViewController(vc, animated: true) {
                () in
                self.removeFromParentViewController()
            }
        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Logout" {
            User.sharedInstance.logout()
        }
        
        if segue.identifier == "DetailProfile" {
            let navi = segue.destinationViewController as! UINavigationController
            let vc = navi.topViewController as! ProfileController
            vc.data = self.data
        }
    }
}
