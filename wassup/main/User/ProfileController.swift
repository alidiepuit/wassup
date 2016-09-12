//
//  ProfileController.swift
//  wassup
//
//  Created by MAC on 9/9/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    var data:Dictionary<String,AnyObject>!
    
    var tabPage:TabPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("ProfileMain") as! ProfileMainController
        vc1.detailUser = data
        
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("ProfileActivity")
        
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("FollowController") as! FollowController
        vc3.data = data
        vc3.cate = ObjectType.Users
        
        let vc4 = storyboard.instantiateViewControllerWithIdentifier("ProfileCollection")
        tabPage!.tabItems = [(vc1, "Main"), (vc2, "Hoạt động"), (vc3, "Followers"), (vc4, "Collection")]
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 4
        option.tabHeight = 45
        tabPage!.option = option
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.view.frame
        self.view.addSubview(tabPage!.view)
        
        title = CONVERT_STRING(data["fullname"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
