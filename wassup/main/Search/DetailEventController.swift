//
//  DetailEventController.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class DetailEventController: UIViewController {

    @IBOutlet weak var content: UIView!
    var data:Dictionary<String,AnyObject>?
    var cate = ObjectType.Event
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("AboutDetailEventController") as! AboutDetailEventController
        vc1.id = CONVERT_STRING(data!["id"])
        vc1.cate = cate
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("FollowerController") as! FollowerController
        vc2.eventId = CONVERT_STRING(data!["id"])
        vc2.cate = cate
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("ListCheckInController") as! ListCheckInController
        vc3.eventId = CONVERT_STRING(data!["id"])
        vc3.cate = cate
        tabPage.tabItems = [(vc1, "About"), (vc2, "Quan Tâm"), (vc3, "Check in")]
        
        var option = TabPageOption()
        option.currentColor = UIColor.blackColor()
        option.tabCurrentBackgroundColor = UIColor.whiteColor()
        option.tabBackgroundColor = UIColor.fromRgbHex(0x31ACF9)
        option.defaultColor = UIColor.blackColor()
        option.tabEqualizeWidth = true
        option.numberOfItem = 3
        option.style = 1
        option.showBarView = false
        option.tabHeight = 45
        tabPage.option = option
        
        self.addChildViewController(tabPage)
        tabPage.view.frame = self.view.frame
        self.view.addSubview(tabPage.view)
        
        self.title = CONVERT_STRING(data!["name"])

        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
