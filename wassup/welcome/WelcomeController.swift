//
//  WelcomeController.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate {

    var pageVC = UIPageViewController()
    var arr:Array<Screen1Controller> = [Screen1Controller(nibName: "Screen1Controller", bundle: nil),
        Screen2Controller(nibName: "Screen2Controller", bundle: nil),
        Screen3Controller(),]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageVC = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.view.frame = self.view.frame
        
        arr[0].index = 0
        arr[1].index = 1
        arr[2].index = 2
        
        let a = [arr[0]]
        pageVC.setViewControllers(a, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        let subViews = pageVC.view.subviews
        for view in subViews {
            if view.isKindOfClass(UIScrollView) {
                scrollView = view as? UIScrollView
            }
            else if view.isKindOfClass(UIPageControl) {
                pageControl = view as? UIPageControl
            }
        }
        
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
        
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMoveToParentViewController(self)
        pageVC.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! Screen1Controller
        if vc.index == 0 {
            return nil
        }
        return arr[vc.index-1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! Screen1Controller
        if vc.index == arr.count-1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("OptionLogin")
            self.presentViewController(vc, animated: true) {
                () in
                self.removeFromParentViewController()
            }
            return nil
        }
        return arr[vc.index+1]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return arr.count-1
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let vc = pendingViewControllers[0] as! Screen1Controller
        if vc.index == arr.count - 1 {
            
        }
    }
}
