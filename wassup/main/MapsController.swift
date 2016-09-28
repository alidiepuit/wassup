//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsController: UIViewController {
    
    var tabPage:TabPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("MapsEventHostController") as! MapsEventHostController
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("MapsEventHostController") as! MapsEventHostController
        vc2.cate = ObjectType.Host
        tabPage!.tabItems = [(vc1, "Sự kiện"), (vc2, "Địa điểm")]
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 2
        option.tabHeight = 44
        tabPage!.option = option
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.view.frame
        self.view.addSubview(tabPage!.view)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSearchTag(sender: AnyObject) {
        performSegueWithIdentifier("SearchTag", sender: nil)
    }
}
