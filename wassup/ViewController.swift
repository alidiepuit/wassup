//
//  ViewController.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wcView = WelcomeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wcView = WelcomeController(nibName: "WelcomeController", bundle: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let user = User()
        if user.isFirstTimeOpen {
            self.addChildViewController(wcView)
            wcView.view.frame = self.view.bounds
            self.view.addSubview(wcView.view)
            wcView.didMoveToParentViewController(self)
        } else {
            if User.sharedInstance.isLogined {
                self.performSegueWithIdentifier("mainView", sender: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("OptionLogin") 
                self.parentViewController!.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

