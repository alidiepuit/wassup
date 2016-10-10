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
    var vc1:AboutDetailEventController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc1 = storyboard.instantiateViewControllerWithIdentifier("AboutDetailEventController") as! AboutDetailEventController
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

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkinFromDetail(_:)), name: "CHECKIN_FROM_DETAIL", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(commentFromDetail(_:)), name: "COMMENT_FROM_DETAIL", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkinFromDetail(noti:NSNotification) {
        performSegueWithIdentifier("Checkin", sender: nil)
    }
    
    func commentFromDetail(noti:NSNotification) {
        performSegueWithIdentifier("Comment", sender: nil)
    }
    
    @IBAction func saveComment(sender: UIStoryboardSegue) {
        if let vc = sender.sourceViewController as? CommentController, data = vc.saveData {
            let arrImage = data["arrImage"] as! [UIImage]
            let description = CONVERT_STRING(data["description"])
            let md = User()
            if vc.cateView == ObjectType.Comment {
                md.comment(cate, id: CONVERT_STRING(data["id"]), description: description, images: arrImage) {
                    (result:AnyObject?) in
                    self.vc1.reloadDataWhenAppear()
                }
            } else {
                md.checkin(cate, id: CONVERT_STRING(data["id"]), description: description, images: arrImage) {
                    (result:AnyObject?) in
                    self.vc1.reloadDataWhenAppear()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "Comment" || segue.identifier == "Checkin")
            && data != nil && data!.count > 0 {
            let navi = segue.destinationViewController as! UINavigationController
            let vc = navi.topViewController as! CommentController
            vc.data = data
            vc.cate = cate
            vc.cateView = segue.identifier == "Comment" ? ObjectType.Comment : ObjectType.Checkin
        }
    }
}
