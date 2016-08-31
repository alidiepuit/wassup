//
//  FollowController.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class FollowController: UIViewController {

    var eventId = ""
    
    @IBOutlet weak var content: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("FollowerController") as! FollowerController
        vc1.eventId = eventId
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("FollowingController")
        tabPage.tabItems = [(vc1, "Follower"), (vc2, "Following")]
        
        var option = TabPageOption()
        option.currentColor = UIColor.blackColor()
        option.tabBackgroundColor = UIColor.fromRgbHex(0xECECEC)
        option.defaultColor = UIColor.blackColor()
        option.tabEqualizeWidth = true
        option.numberOfItem = 2
        option.style = 0
        option.tabHeight = 40
        tabPage.option = option
        
        self.addChildViewController(tabPage)
        tabPage.view.frame = self.content.frame
        self.content.addSubview(tabPage.view)
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