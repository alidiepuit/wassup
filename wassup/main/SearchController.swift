//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

var insideView:UIView?
var city = "Hồ Chí Minh"

class SearchController: UIViewController {
    
    var btnFilter: UIBarButtonItem!
    @IBOutlet weak var content: UIView!
    
    var listProvince = [CellDropdown]()
    var selProvince:BTNavigationDropdownMenu?
    var tabPage:TabPageViewController?
    var data:Dictionary<String,AnyObject>!
    var cate:ObjectType!
    var vc1:SearchHotController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selProvince = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Hồ Chí Minh", items: [])
        self.navigationItem.titleView = selProvince
        selProvince!.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            NSNotificationCenter.defaultCenter().postNotificationName("SELECT_PROVINCE", object: nil, userInfo: ["cityId": self!.listProvince[indexPath].id,
                "cityName": self!.listProvince[indexPath].value])
            
            NSNotificationCenter.defaultCenter().postNotificationName("REFRESH_FILTER_AFTER_SELECT_PROVINCE", object: nil, userInfo: ["cityId": self!.listProvince[indexPath].id,
                                "cityName": self!.listProvince[indexPath].value])
        }
        selProvince!.menuTitleColor = UIColor.whiteColor()
        selProvince!.cellTextLabelColor = UIColor.whiteColor()
        
        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc1 = storyboard.instantiateViewControllerWithIdentifier("SearchHotController") as! SearchHotController
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("SearchEventController")
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("SearchHostController")
        let vc4 = storyboard.instantiateViewControllerWithIdentifier("SearchBlogController")
        tabPage!.tabItems = [(vc1, "Hot"), (vc2, Localization("Sự kiện")), (vc3, Localization("Địa điểm")), (vc4, "Blog")]
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 4
        option.tabHeight = 44
        tabPage!.option = option
        tabPage!.pageViewDelegate = self
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.content.frame
        self.content.addSubview(tabPage!.view)
        insideView = content
        
        loadProvince()
        
        Utils.sharedInstance.refreshLocation(self, action: nil, loop: false)
        
        btnFilter = UIBarButtonItem(image: UIImage(named: "ic_more"), style: .Plain, target: self, action: #selector(clickFilter(_:)))
        btnFilter.tintColor = UIColor.whiteColor()
    }
    
    func loadProvince() {
        let md = Filter()
        md.getProvince() {
            (result:AnyObject?) in
            if result != nil {
                if let d = result!["provinces"] as? [Dictionary<String, String>] {
                    self.listProvince = []
                    var a = [String]()
                    for b in d {
                        if let name = b["name"] {
                            a.append(name)
                            self.listProvince.append(CellDropdown(id: b["id"]!, value: name))
                        }
                    }
                    self.selProvince?.updateItems(a)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickFilter(sender: AnyObject) {
        if CONVERT_BOOL(selProvince?.isShown) {
            selProvince?.toggle()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_FILTER", object: nil)
        }
    }
    
    @IBAction func clickSearch(sender: AnyObject) {
        if CONVERT_BOOL(selProvince?.isShown) {
            selProvince?.toggle()
        }
        performSegueWithIdentifier("SearchKeyword", sender: nil)
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

extension SearchController: TabPageViewDelegate {
    func didTabPage(vc: UIViewController) {
        if vc == vc1 {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = btnFilter
        }
    }
    
    func didFinishScroll() {
        if tabPage?.currentIndex == 0 {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = btnFilter
        }
    }
}
